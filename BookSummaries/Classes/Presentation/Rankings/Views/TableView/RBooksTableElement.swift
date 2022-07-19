//
//  RBooksTableElement.swift
//  BookSummaries
//
//  Created by Андрей Чернышев on 19.07.2022.
//

import CoreGraphics

enum RBooksTableElement {
    case offset(CGFloat)
    case book(RBooksTableBookElement)
    case separator
}

struct RBooksTableBookElement {
    let number: String
    let book: BookCover
}
