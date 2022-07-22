//
//  LibraryTableElement.swift
//  BookSummaries
//
//  Created by Андрей Чернышев on 22.07.2022.
//

import CoreGraphics

enum LibraryTableElement {
    case offset(CGFloat)
    case book(LibraryTableBookElement)
    case separator
}

struct LibraryTableBookElement {
    let book: BookCover
    let progress: Float?
}
