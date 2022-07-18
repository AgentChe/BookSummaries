//
//  FeedbackViewModel.swift
//  BookSummaries
//
//  Created by Андрей Чернышев on 18.07.2022.
//

import RxSwift
import RxCocoa

final class FeedbackViewModel {
    let book: BehaviorRelay<Book>
    lazy var elements = makeElements()
    
    init(book: Book) {
        self.book = BehaviorRelay(value: book)
    }
}

// MARK: Private
private extension FeedbackViewModel {
    func makeElements() -> Driver<[FeedbackTableElement]> {
        book.asDriver()
            .map { book -> [FeedbackTableElement] in
                var result = [FeedbackTableElement]()
                
                let title = String(format: "Feedback.Title".localized, book.name)
                result.append(.book(title))
                
                let rating = FeedbackRatingElement(rating: 0)
                result.append(contentsOf: [
                    .offset(16.scale),
                    .rating(rating)
                ])
                
                let improves = FeedbackImprovesElement(improves: [])
                result.append(contentsOf: [
                    .offset(30.scale),
                    .improves(improves)
                ])
                
                let whatBetter = FeedbackWhatBetterElement()
                result.append(contentsOf: [
                    .offset(30.scale),
                    .whatBetter(whatBetter)
                ])
                
                let whatLearn = FeedbackWhatLearnElement()
                result.append(contentsOf: [
                    .offset(30.scale),
                    .whatLearn(whatLearn)
                ])
                
                return result
            }
    }
}
