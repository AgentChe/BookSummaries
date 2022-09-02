//
//  LibraryViewModel.swift
//  BookSummaries
//
//  Created by Андрей Чернышев on 22.07.2022.
//

import RxSwift
import RxCocoa

final class LibraryViewModel {
    var tryAgain: ((Error) -> (Observable<Void>))?
    
    lazy var filter = PublishRelay<LibraryFilterView.Filter>()
    lazy var didTapRemove = PublishRelay<BookCover>()
    
    lazy var elements = makeElements()
    lazy var emptyState = makeEmptyState()
    lazy var activity = RxActivityIndicator()
    
    private lazy var booksElements = makeBooksElements()
    private lazy var savedBooksElements = makeSavedBooksElements()
    private lazy var historyBooksElements = makeHistoryBooksElements()
    private lazy var downloadedBooksElements = makeDownloadedBooksElements()
    private lazy var readingBooks = makeReadingBooks()
    
    private lazy var contentManager = ContentManager()
    
    private lazy var observableRetrySingle = ObservableRetrySingle()
}

// MARK: Private
private extension LibraryViewModel {
    func makeEmptyState() -> Driver<LibraryEmptyView.State?> {
        elements
            .withLatestFrom(filter.asDriver(onErrorDriveWith: .never())) { ($0, $1) }
            .map { elements, filter -> LibraryEmptyView.State? in
                guard elements.isEmpty else {
                    return nil
                }
                
                switch filter {
                case .saved:
                    return .saved
                case .history:
                    return .history
                case .downloaded:
                    return .downloaded
                }
            }
            .startWith(nil)
    }
    
    func makeElements() -> Driver<[LibraryTableElement]> {
        booksElements
            .map { booksElements -> [LibraryTableElement] in
                var result = [LibraryTableElement]()
                
                booksElements.enumerated().forEach { index, bookElement in
                    result.append(.book(bookElement))
                    
                    if (booksElements.count - 1) != index {
                        result.append(contentsOf: [
                            .offset(16.scale),
                            .separator,
                            .offset(16.scale)
                        ])
                    }
                }
                
                return result
            }
    }
    
    func makeBooksElements() -> Driver<[LibraryTableBookElement]> {
        filter.asDriver(onErrorDriveWith: .never())
            .flatMapLatest { [weak self] filter -> Driver<[LibraryTableBookElement]> in
                guard let self = self else {
                    return .never()
                }
                
                switch filter {
                case .saved:
                    return self.savedBooksElements
                case .history:
                    return self.historyBooksElements
                case .downloaded:
                    return self.downloadedBooksElements
                }
            }
    }
    
    func makeSavedBooksElements() -> Driver<[LibraryTableBookElement]> {
        let savedBooks = downloadSavedBooks()
            .flatMapLatest { [weak self] books -> Driver<[BookCover]> in
                guard let self = self else {
                    return .never()
                }
                
                let saved = ContentMediator.shared
                    .bookDidSaved
                    .map { (1, $0) }
                    .asDriver(onErrorDriveWith: .never())
                
                let removed = ContentMediator.shared
                    .bookDidRemoveFromSaved
                    .map { (2, $0) }
                    .asDriver(onErrorDriveWith: .never())
                
                let libraryDelete = self.didTapRemove
                    .flatMapLatest { book -> Single<(Int, BookCover)> in
                        self.contentManager
                            .removeSaved(book: book)
                            .map { success in (2, book) }
                    }
                    .asDriver(onErrorDriveWith: .never())
                
                return Driver
                    .merge(saved, removed, libraryDelete)
                    .scan(books) { books, args -> [BookCover] in
                        let (action, book) = args
                        
                        var copy = books
                        
                        if action == 1 {
                            if let index = copy.firstIndex(where: { $0.id == book.id }) {
                                copy[index] = book
                            } else {
                                copy.append(book)
                            }
                        } else if action == 2 {
                            if let index = copy.firstIndex(where: { $0.id == book.id }) {
                                copy.remove(at: index)
                            }
                        }
                        
                        return copy
                    }
                    .startWith(books)
            }
        
        return Driver
            .combineLatest(savedBooks, readingBooks)
            .map { savedBooks, readingBooks -> [LibraryTableBookElement] in
                Self.combine(booksCovers: savedBooks, readingBooks: readingBooks)
            }
    }
    
    func makeHistoryBooksElements() -> Driver<[LibraryTableBookElement]> {
        readingBooks
            .map { readingBooks -> [LibraryTableBookElement] in
                readingBooks.map { readingBook -> LibraryTableBookElement in
                    LibraryTableBookElement(book: BookCover(book: readingBook.book),
                                            progress: readingBook.progress)
                }
            }
    }
    
    func makeDownloadedBooksElements() -> Driver<[LibraryTableBookElement]> {
        let downloadedBooks = contentManager
            .obtainDownloadBooks()
            .asDriver(onErrorJustReturn: [])
            .map { downloadedBooks -> [Book] in
                downloadedBooks.map { $0.combine() }
            }
            .flatMapLatest { [weak self] downloadedBooks -> Driver<[Book]> in
                guard let self = self else {
                    return .never()
                }
                
                let download = ContentMediator.shared
                    .bookDownloaded
                    .map { (1, $0.original) }
                    .asDriver(onErrorDriveWith: .never())
                
                let libraryDelete = self.didTapRemove
                    .flatMapLatest { book -> Single<(Int, Book)> in
                        self.contentManager
                            .removeDownload(bookId: book.id)
                            .map { success in (2, Book(id: book.id)) }
                    }
                    .asDriver(onErrorDriveWith: .never())
                
                return Driver
                    .merge(download, libraryDelete)
                    .scan(downloadedBooks) { books, args -> [Book] in
                        let (action, book) = args
                        
                        var copy = books
                        
                        if action == 1 {
                            if let index = copy.firstIndex(where: { $0.id == book.id }) {
                                copy[index] = book
                            } else {
                                copy.append(book)
                            }
                        } else if action == 2 {
                            if let index = copy.firstIndex(where: { $0.id == book.id }) {
                                copy.remove(at: index)
                            }
                        }
                        
                        return copy
                    }
                    .startWith(downloadedBooks)
            }
        
        return Driver
            .combineLatest(downloadedBooks, readingBooks)
            .map { downloadedBooks, readingBooks -> [LibraryTableBookElement] in
                let covers = downloadedBooks.map { BookCover(book: $0) }
                return Self.combine(booksCovers: covers, readingBooks: readingBooks)
            }
    }
    
    func makeReadingBooks() -> Driver<[BookReadingProgress]> {
        contentManager
            .obtainReadingBooks()
            .asDriver(onErrorJustReturn: [])
            .flatMapLatest { [weak self] readingBooks -> Driver<[BookReadingProgress]> in
                guard let self = self else {
                    return .never()
                }
                
                let updated = ContentMediator.shared
                    .bookReadingProgressUpdated
                    .map { (1, $0) }
                    .asDriver(onErrorDriveWith: .never())
                
                let libraryDelete = self.didTapRemove
                    .flatMapLatest { book -> Single<(Int, BookReadingProgress)> in
                        self.contentManager
                            .removeBookProgress(bookId: book.id)
                            .map { (2, BookReadingProgress(book: Book(id: book.id), currentChapterIndex: 0)) }
                    }
                    .asDriver(onErrorDriveWith: .never())
                
                return Driver
                    .merge(updated, libraryDelete)
                    .scan(readingBooks) { books, args -> [BookReadingProgress] in
                        let (action, readingBook) = args
                        
                        var copy = books
                        
                        if action == 1 {
                            if let index = copy.firstIndex(where: { $0.book.id == readingBook.book.id }) {
                                copy[index] = readingBook
                            } else {
                                copy.append(readingBook)
                            }
                        } else if action == 2 {
                            if let index = copy.firstIndex(where: { $0.book.id == readingBook.book.id }) {
                                copy.remove(at: index)
                            }
                        }
                        
                        return copy
                    }
                    .startWith(readingBooks)
            }
    }
    
    func downloadSavedBooks() -> Driver<[BookCover]> {
        func source() -> Single<[BookCover]> {
            contentManager
                .obtainSavedBooksCover()
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
            .trackActivity(activity)
            .asDriver(onErrorJustReturn: [])
    }
}

// MARK: Utils
private extension LibraryViewModel {
    static func combine(booksCovers: [BookCover], readingBooks: [BookReadingProgress]) -> [LibraryTableBookElement] {
        booksCovers.map { book -> LibraryTableBookElement in
            let readingBook = readingBooks.first(where: { $0.book.id == book.id })

            return LibraryTableBookElement(book: book,
                                           progress: readingBook?.progress)
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
        paid = false
    }
}

// MARK: Additional (Book)
private extension Book {
    init(id: Int) {
        self.id = id
        name = ""
        imageUrl = URL(string: "www.google.com")!
        author = Author(name: "", photoUrl: URL(string: "www.google.com")!)
        rankingId = 0
        time = 0
        audioUrl = URL(string: "www.google.com")!
        shareLink = URL(string: "www.google.com")!
        isSaved = false
        introduction = nil
        chapters = []
        whatAbout = ""
    }
}
