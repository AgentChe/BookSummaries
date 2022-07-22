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
    
    lazy var elements = makeElements()
    lazy var emptyState = makeEmptyState()
    lazy var activity = RxActivityIndicator()
    
    private lazy var contentManager = ContentManagerMock() // TODO
    
    private lazy var observableRetrySingle = ObservableRetrySingle()
}

// MARK: Private
private extension LibraryViewModel {
    func makeElements() -> Driver<[LibraryTableElement]> {
        contentManager
            .obtainCategoryBooksCover(categoryId: 1)
            .map { books -> [LibraryTableElement] in
                var result = [LibraryTableElement]()
                
                let all = (books + books + books)
                let a = (all + all + all)
                
                a.enumerated().forEach { index, book in
                    let element = LibraryTableBookElement(book: book,
                                                          progress: ((index == 2 || index == 7)) ? nil : Float.random(in: 1...100))
                    result.append(.book(element))
                    
                    if (a.count - 1) != index {
                        result.append(contentsOf: [
                            .offset(16.scale),
                            .separator,
                            .offset(16.scale)
                        ])
                    }
                }
                
                return result
            }
            .asDriver(onErrorJustReturn: [])
    }
    
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
    
    func makeSavedBooks() -> Driver<[BookCover]> {
        .never()
    }
    
    func makeHistoryBooks() -> Driver<[BookCover]> {
        .never()
    }
    
    func makeDownloadBooks() -> Driver<[BookCover]> {
        .never()
    }
}
