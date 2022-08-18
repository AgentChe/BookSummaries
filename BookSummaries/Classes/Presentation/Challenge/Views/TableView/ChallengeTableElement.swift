//
//  ChallengeTableElement.swift
//  BookSummaries
//
//  Created by Андрей Чернышев on 17.08.2022.
//

import CoreGraphics

enum ChallengeTableElement {
    case offset(CGFloat)
    case header(ChallengeHeaderElement)
    case buttons
    case books([ChallengeBookElement])
    case badges(ChallengeBadgesElement)
}

struct ChallengeHeaderElement {
    let name: String
    let title: String
    let text: String
}

struct ChallengeBookElement {
    let dayNumber: Int
    let book: BookCover
    let completed: Bool
    let current: Bool
}

struct ChallengeBadgesElement {
    let goodStartProgress: Int
    let completeDay3Progress: Int
    let completeChallengeProgress: Int
}
