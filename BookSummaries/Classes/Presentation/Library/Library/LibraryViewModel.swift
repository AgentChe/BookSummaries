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
    lazy var activity = RxActivityIndicator()
    
    private lazy var observableRetrySingle = ObservableRetrySingle()
}

// MARK: Private
private extension LibraryViewModel {
    func makeElements() -> Driver<[LibraryTableElement]> {
        .never()
    }
}
