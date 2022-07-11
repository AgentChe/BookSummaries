//
//  Book.swift
//  BookSummaries
//
//  Created by Андрей Чернышев on 11.07.2022.
//

import Foundation

struct Book: Codable, Hashable {
    let id: Int
    let name: String
    let image: URL
    let author: String
    let authorImage: URL
    let whatAbout: String
    let chapters: [BookChapter]
}
