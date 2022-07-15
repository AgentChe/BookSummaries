//
//  ChaptersTableElement.swift
//  BookSummaries
//
//  Created by Андрей Чернышев on 15.07.2022.
//

import CoreGraphics

enum ChaptersTableElement {
    case offset
    case chapter(ChapterTableElement)
}

struct ChapterTableElement {
    let number: String
    let chapter: BookChapter
    let isSelected: Bool
    let separatorHidden: Bool
}
