//
//  ForYouTableElement.swift
//  BookSummaries
//
//  Created by Андрей Чернышев on 07.07.2022.
//

import CoreGraphics

enum ForYouTableElement {
    case offset(CGFloat)
    case freeBook(BookCover)
    case title(String)
    case books([BookCover])
    case challenges([Challenge])
    case rankingTitle(Ranking)
    case rankingBook(ForYouRankingBookElement)
    case separator
    case categories([Category])
}

struct ForYouRankingBookElement {
    let number: String
    let book: BookCover
}
