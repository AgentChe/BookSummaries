//
//  BookKit.swift
//  BookSummaries
//
//  Created by Андрей Чернышев on 11.07.2022.
//

struct BookKit: Codable, Hashable {
    let book: Book
    let similarBooks: [BookBrochure]
    let exploreCategories: [Category]
}
