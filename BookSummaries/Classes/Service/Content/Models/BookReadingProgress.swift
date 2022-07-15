//
//  BookReadingProgress.swift
//  BookSummaries
//
//  Created by Андрей Чернышев on 15.07.2022.
//

struct BookReadingProgress: Codable, Hashable {
    let book: Book
    let currentChapterIndex: Int
}
