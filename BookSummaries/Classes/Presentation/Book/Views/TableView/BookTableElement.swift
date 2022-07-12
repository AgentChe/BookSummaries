//
//  BookTableElement.swift
//  BookSummaries
//
//  Created by Андрей Чернышев on 11.07.2022.
//

import CoreGraphics
import Foundation

enum BookTableElement {
    case offset(CGFloat)
    case bookImage(URL)
    case progress(Float)
    case bookName(String)
    case authorName(String)
    case info(BookInfoElement)
    case title(String)
    case introduction
    case chapter(BookChapterElement)
    case separator
    case seeAll
    case whatAbout(String)
    case author(BookAuthorElement)
    case books([BookCover])
    case categories([Category])
}

struct BookInfoElement {
    let chaptersCount: Int
    let min: Int
}

struct BookChapterElement {
    let chapter: BookChapter
    let number: String
}

struct BookAuthorElement {
    let image: URL
    let name: String
}
