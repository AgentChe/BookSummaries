//
//  BookViewModel.swift
//  BookSummaries
//
//  Created by Андрей Чернышев on 11.07.2022.
//

import RxSwift
import RxCocoa

final class BookViewModel {
    var tryAgain: ((Error) -> (Observable<Void>))?
    
    lazy var didTapSeeAll = PublishRelay<Void>()
    lazy var didTapMark = PublishRelay<Bool>()
    lazy var didTapChapter = PublishRelay<BookChapter>()
    lazy var didTapRead = PublishRelay<Void>()
    lazy var didTapStartDownload = PublishRelay<Void>()
    lazy var didTapStopDownload = PublishRelay<Void>()
    lazy var didTapListen = PublishRelay<Void>()
    
    lazy var listen = makeListen()
    lazy var bookIsDownloading = makeBookIsDownloading()
    lazy var downloadState = makeDownloadState()
    lazy var reader = makeReader()
    lazy var shareLink = makeShareLink()
    lazy var isSavedBook = makeIsSavedBook()
    lazy var elements = makeElements()
    lazy var activity = RxActivityIndicator()
    
    private lazy var isShowingAll = makeIsShowingAll()
    private lazy var readingProgress = makeReadingProgress()
    private lazy var categories = makeCategories()
    private lazy var bookKit = makeBookKit()
    private lazy var readingBooks = makeReadingBooks()
    private lazy var currentBookFromCache = makeCurrentBookFromCache()
    private lazy var downloadBooks = makeDownloadBooks()
    
    private lazy var contentManager = ContentManagerMock() // TODO
    
    private lazy var bookDownloadObserver = BookDownloadObserver()
    
    private lazy var observableRetrySingle = ObservableRetrySingle()
    
    private let bookId: BehaviorRelay<Int>
    
    init(bookId: Int) {
        self.bookId = BehaviorRelay(value: bookId)
    }
}

// MARK: Private
private extension BookViewModel {
    func makeListen() -> Driver<(BookCover, URL)> {
        didTapListen
            .withLatestFrom(bookKit) { $1.book }
            .withLatestFrom(downloadBooks) { book, downloadBooks -> (BookCover, URL) in
                let cover = BookCover(book: book)
                
                if let downloadBook = downloadBooks.first(where: { $0.original.id == book.id }) {
                    return (cover, downloadBook.combine().audioUrl)
                }
                
                return (cover, book.audioUrl)
            }
            .asDriver(onErrorDriveWith: .never())
    }
    
    func makeBookIsDownloading() -> Driver<Bool> {
        downloadState
            .map { state -> Bool in
                switch state {
                case .download, .downloaded:
                    return false
                case .downloading:
                    return true
                }
            }
    }
    
    func makeDownloadState() -> Driver<BookDownloadView.State> {
        let initial = Observable
            .combineLatest(downloadBooks.asObservable().take(1), bookId)
            .flatMap { [weak self] downloadBooks, bookId -> Observable<BookDownloadView.State> in
                guard let self = self else {
                    return .never()
                }
                
                return Observable<BookDownloadView.State>.create { event in
                    if downloadBooks.contains(where: { $0.original.id == bookId }) {
                        event.onNext(.downloaded)
                    } else if DownloadBooksQueue.shared.containsOperation(with: bookId) {
                        self.bookDownloadObserver.progress = { book, percent in
                            if book.id == bookId {
                                event.onNext(.downloading(percent))
                            }
                        }
                        DownloadBooksQueue.shared.subscribe(book: bookId, on: self.bookDownloadObserver)
                    } else {
                        event.onNext(.download)
                    }
                    
                    return Disposables.create()
                }
            }
            .asDriver(onErrorDriveWith: .never())
        
        let downloaded = ContentMediator.shared.bookDownloaded
            .withLatestFrom(bookId.asSignal(onErrorSignalWith: .never())) { ($0, $1) }
            .flatMap { downloadedBook, bookId -> Driver<BookDownloadView.State> in
                guard downloadedBook.original.id == bookId else {
                    return .never()
                }
                
                return .just(.downloaded)
            }
            .asDriver(onErrorDriveWith: .never())
        
        let startDownload = didTapStartDownload
            .withLatestFrom(bookKit)
            .flatMapLatest { [weak self] bookKit -> Observable<BookDownloadView.State> in
                guard let self = self else {
                    return .never()
                }
                
                return self.contentManager
                    .download(book: bookKit.book, delegate: self.bookDownloadObserver)
                    .asObservable()
                    .flatMapLatest { book -> Observable<BookDownloadView.State> in
                        .never()
                    }
                    .startWith(.downloading(0))
            }
            .asDriver(onErrorDriveWith: .never())
        
        let progressDownload = didTapStartDownload
            .withLatestFrom(bookId)
            .flatMapLatest { [weak self] bookId -> Observable<BookDownloadView.State> in
                guard let self = self else {
                    return .never()
                }
                
                return Observable<BookDownloadView.State>.create { event in
                    self.bookDownloadObserver.progress = { book, percent in
                        if book.id == bookId {
                            event.onNext(.downloading(percent))
                        }
                    }
                    
                    return Disposables.create()
                }
            }
            .asDriver(onErrorDriveWith: .never())
        
        let stopDownload = didTapStopDownload
            .withLatestFrom(bookId)
            .flatMapLatest { bookId -> Single<BookDownloadView.State> in
                DownloadBooksQueue.shared.removeOperation(for: bookId)
                
                return .just(.download)
            }
            .asDriver(onErrorDriveWith: .never())
        
        return Driver.merge(initial, downloaded, startDownload, progressDownload, stopDownload)
    }
    
    func makeReader() -> Driver<(Book, BookChapter)> {
        let chapter = didTapChapter
            .withLatestFrom(bookKit) { ($1.book, $0) }
            .asDriver(onErrorDriveWith: .never())
        
        let read = didTapRead
            .withLatestFrom(bookKit)
            .withLatestFrom(readingBooks) { bookKit, readingBooks -> (Book, BookChapter)? in
                let book = bookKit.book
                let bookChapter: BookChapter?
                
                if let lastReadingChapter = readingBooks.first(where: { $0.book.id == book.id }) {
                    bookChapter = book.chapters[safe: lastReadingChapter.currentChapterIndex] ?? book.chapters.last
                } else {
                    bookChapter = book.chapters.first
                }
                
                guard let bookChapter = bookChapter else {
                    return nil
                }

                return (book, bookChapter)
            }
            .compactMap { $0 }
            .asDriver(onErrorDriveWith: .never())
        
        return Driver.merge(chapter, read)
    }
    
    func makeShareLink() -> Driver<URL> {
        bookKit
            .map { $0.book.shareLink }
    }
    
    func makeIsSavedBook() -> Driver<Bool> {
        let initial = bookKit
            .map { $0.book.isSaved }
        
        let action = didTapMark
            .withLatestFrom(bookKit) { ($0, $1.book) }
            .flatMapFirst { [weak self] isSaved, book -> Observable<Bool> in
                guard let self = self else {
                    return .never()
                }
                
                func source() -> Single<Bool> {
                    let request = isSaved
                    ? self.contentManager.removeSaved(book: BookCover(book: book))
                        : self.contentManager.save(book: BookCover(book: book))

                    return request
                        .map { _ in !isSaved }
                }
                
                func trigger(error: Error) -> Observable<Void> {
                    guard let tryAgain = self.tryAgain?(error) else {
                        return .empty()
                    }
                    
                    return tryAgain
                }

                return self.observableRetrySingle
                    .retry(source: { source() },
                           trigger: { trigger(error: $0) })
            }
            .asDriver(onErrorDriveWith: .never())
        
        return Driver
            .merge(initial, action)
    }
    
    func makeElements() -> Driver<[BookTableElement]> {
        Driver
            .combineLatest(categories, bookKit, isShowingAll, readingProgress)
            .map { categories, bookKit, isShowingAll, readingProgress -> [BookTableElement] in
                var result = [BookTableElement]()
                
                let book = bookKit.book
                
                result.append(.bookImage(book.imageUrl))
                
                if let readingProgress = readingProgress {
                    result.append(contentsOf: [
                        .offset(36.scale),
                        .progress(readingProgress)
                    ])
                }
                
                result.append(contentsOf: [
                    .offset(20.scale),
                    .bookName(book.name),
                    .offset(5.scale),
                    .authorName(book.author.name)
                ])
                
                result.append(contentsOf: [
                    .offset(18.scale),
                    .info(BookInfoElement(chaptersCount: book.chapters.count,
                                          min: book.time))
                ])
                
                result.append(contentsOf: [
                    .offset(30.scale),
                    .title("Book.Chapters".localized)
                ])
                
                if let introduction = book.introduction {
                    result.append(contentsOf: [
                        .offset(34.scale),
                        .introduction(introduction),
                    ])
                }
                
                let chapters = isShowingAll ? book.chapters : Array(book.chapters.prefix(5))
                result.append(.offset(34.scale))
                chapters.enumerated().forEach { index, chapter in
                    let element = BookChapterElement(chapter: chapter, number: String(index + 1))
                    result.append(.chapter(element))
                    
                    if (chapters.count - 1) != index {
                        result.append(contentsOf: [
                            .offset(16.scale),
                            .separator,
                            .offset(16.scale)
                        ])
                    }
                }
                
                let needShowSeeAll = book.chapters.count > 5 && !isShowingAll
                if needShowSeeAll {
                    result.append(contentsOf: [
                        .offset(24.scale),
                        .seeAll
                    ])
                }
                
                result.append(contentsOf: [
                    .offset(30.scale),
                    .title("Book.WhatAbout?".localized),
                    .offset(16.scale),
                    .whatAbout(book.whatAbout)
                ])
                
                result.append(contentsOf: [
                    .offset(30.scale),
                    .title("Book.Author".localized),
                    .offset(16.scale),
                    .author(book.author)
                ])
                
                if !bookKit.similarBooks.isEmpty {
                    result.append(contentsOf: [
                        .offset(46.scale),
                        .title("Book.SimilarBooks".localized),
                        .offset(16.scale),
                        .books(bookKit.similarBooks)
                    ])
                }
                
                if !categories.isEmpty {
                    result.append(contentsOf: [
                        .offset(21.scale),
                        .title("Book.ExploreCategories".localized),
                        .offset(16.scale),
                        .categories(categories)
                    ])
                }
                
                return result
            }
    }
    
    func makeIsShowingAll() -> Driver<Bool> {
        didTapSeeAll
            .map { true }
            .startWith(false)
            .asDriver(onErrorDriveWith: .never())
    }
        
    func makeReadingProgress() -> Driver<Float?> {
        Driver
            .combineLatest(bookKit, readingBooks)
            .map { bookKit, readingBooks -> Float? in
                let book = bookKit.book
                
                guard
                    !book.chapters.isEmpty,
                    let readingBook = readingBooks.first(where: { $0.book.id == book.id })
                else {
                    return nil
                }
                
                return readingBook.progress
            }
    }
    
    func makeCategories() -> Driver<[Category]> {
        contentManager
            .obtainCategories(forceUpdate: false)
            .asDriver(onErrorJustReturn: [])
    }
    
    func makeBookKit() -> Driver<BookKit> {
        Observable
            .combineLatest(bookId, currentBookFromCache.asObservable().take(1))
            .flatMapLatest { [weak self] bookId, currentBookFromCache -> Observable<BookKit> in
                guard let self = self else {
                    return .never()
                }
                
                func source() -> Single<BookKit> {
                    self.contentManager
                        .obtainBookKit(bookId: bookId)
                        .catchAndReturn(nil)
                        .flatMap { kit -> Single<BookKit> in
                            if let kit = kit {
                                return .just(kit)
                            }
                            
                            if let currentBookFromCache = currentBookFromCache {
                                let local = BookKit(book: currentBookFromCache.combine(), similarBooks: [])
                                return .just(local)
                            }
                            
                            return .error(ContentError(.notContent))
                        }
                }
                
                func trigger(error: Error) -> Observable<Void> {
                    guard let tryAgain = self.tryAgain?(error) else {
                        return .empty()
                    }
                    
                    return tryAgain
                }
                
                return self.observableRetrySingle
                    .retry(source: { source() },
                           trigger: { trigger(error: $0) })
                    .trackActivity(self.activity)
            }
            .asDriver(onErrorDriveWith: .never())
    }
    
    func makeReadingBooks() -> Driver<[BookReadingProgress]> {
        let initial = contentManager
            .obtainReadingBooks()
            .asDriver(onErrorJustReturn: [])
        
        let updated = ContentMediator.shared.bookReadingProgressUpdated
            .flatMapLatest { [weak self] _ -> Driver<[BookReadingProgress]> in
                guard let self = self else {
                    return .never()
                }
                
                return self.contentManager
                    .obtainReadingBooks()
                    .asDriver(onErrorJustReturn: [])
            }
        
        return Driver.merge(initial, updated)
    }
    
    func makeCurrentBookFromCache() -> Driver<LocalBook?> {
        Driver
            .combineLatest(downloadBooks, bookId.asDriver())
            .map { downloadBooks, bookId -> LocalBook? in
                downloadBooks.first(where: { $0.original.id == bookId })
            }
    }
    
    func makeDownloadBooks() -> Driver<[LocalBook]> {
        let initial = contentManager
            .obtainDownloadBooks()
            .asDriver(onErrorJustReturn: [])
        
        return initial
            .flatMapLatest { books -> Driver<[LocalBook]> in
                ContentMediator.shared
                    .bookDownloaded
                    .scan(books) { books, book -> [LocalBook] in
                        var copy = books
                        copy.append(book)
                        return copy
                    }
                    .startWith(books)
                    .asDriver(onErrorDriveWith: .never())
            }
    }
}

// MARK: Additional (BookCover)
private extension BookCover {
    init(book: Book) {
        id = book.id
        name = book.name
        author = book.author
        imageUrl = book.imageUrl
        rankingId = book.rankingId
        shareLink = book.shareLink
    }
}
