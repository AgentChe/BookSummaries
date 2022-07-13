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
    
    lazy var didTappSeeAll = PublishRelay<Void>()
    lazy var didTapMark = PublishRelay<Bool>()
    
    lazy var shareLink = makeShareLink()
    lazy var isSavedBook = makeIsSavedBook()
    lazy var elements = makeElements()
    lazy var activity = RxActivityIndicator()
    
    private lazy var isShowingAll = makeIsShowingAll()
    private lazy var categories = makeCategories()
    private lazy var bookKit = makeBookKit()
    
    private lazy var contentManager = ContentManagerMock() // TODO
    
    private lazy var observableRetrySingle = ObservableRetrySingle()
    
    private let bookId: BehaviorRelay<Int>
    
    init(bookId: Int) {
        self.bookId = BehaviorRelay(value: bookId)
    }
}

// MARK: Private
private extension BookViewModel {
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
                        ? self.contentManager.removeSaved(bookId: book.id)
                        : self.contentManager.save(bookId: book.id)

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
            .combineLatest(categories, bookKit, isShowingAll)
            .map { categories, bookKit, isShowingAll -> [BookTableElement] in
                var result = [BookTableElement]()
                
                let book = bookKit.book
                
                result.append(.bookImage(book.imageUrl))
                
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
        didTappSeeAll
            .map { true }
            .startWith(false)
            .asDriver(onErrorDriveWith: .never())
    }
    
    func makeCategories() -> Driver<[Category]> {
        contentManager
            .obtainCategories(forceUpdate: false)
            .asDriver(onErrorJustReturn: [])
    }
    
    func makeBookKit() -> Driver<BookKit> {
        bookId
            .flatMapLatest { [weak self] bookId -> Observable<BookKit> in
                guard let self = self else {
                    return .never()
                }
                
                func source() -> Single<BookKit> {
                    self.contentManager
                        .obtainBookKit(bookId: bookId)
                        .flatMap { kit -> Single<BookKit> in
                            guard let kit = kit else {
                                return .error(ContentError(.notContent))
                            }
                            
                            return .just(kit)
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
}
