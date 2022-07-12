//
//  ForYouViewModel.swift
//  BookSummaries
//
//  Created by Андрей Чернышев on 07.07.2022.
//

import RxSwift
import RxCocoa

final class ForYouViewModel {
    var tryAgain: ((Error) -> (Observable<Void>))?
    
    lazy var elements = makeElements()
    lazy var activity = RxActivityIndicator()
    
    private lazy var observableRetrySingle = ObservableRetrySingle()
}

// MARK: Private
private extension ForYouViewModel {
    func makeElements() -> Driver<[ForYouTableElement]> {
        .never()
    }
}
