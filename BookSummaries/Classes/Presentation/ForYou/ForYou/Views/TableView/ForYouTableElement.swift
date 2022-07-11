//
//  ForYouTableElement.swift
//  BookSummaries
//
//  Created by Андрей Чернышев on 07.07.2022.
//

import CoreGraphics

enum ForYouTableElement {
    case offset(CGFloat)
    case freeBook(BookBrochure)
    case title(String)
    case books([BookBrochure])
    case challenges([Challenge])
    case rankingTitle(String)
    case ranking(ForYouRankingElement)
    case separator
    case categories([Category])
    case newReleasesTitle(String)
}

struct ForYouRankingElement {
    let number: String
    let book: BookBrochure
}
