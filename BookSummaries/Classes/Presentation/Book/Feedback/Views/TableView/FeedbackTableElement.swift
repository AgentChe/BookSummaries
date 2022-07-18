//
//  FeedbackTableElement.swift
//  BookSummaries
//
//  Created by Андрей Чернышев on 18.07.2022.
//

import CoreGraphics

enum FeedbackTableElement {
    case offset(CGFloat)
    case book(String)
    case rating(FeedbackRatingElement)
    case improves(FeedbackImprovesElement)
    case whatBetter(FeedbackWhatBetterElement)
    case whatLearn(FeedbackWhatLearnElement)
}

final class FeedbackRatingElement {
    var rating: Int
    
    init(rating: Int) {
        self.rating = rating
    }
}

final class FeedbackImprovesElement {
    var improves: [Int]
    
    init(improves: [Int]) {
        self.improves = improves
    }
}

final class FeedbackWhatBetterElement {
    var text: String?
}

final class FeedbackWhatLearnElement {
    var text: String?
}
