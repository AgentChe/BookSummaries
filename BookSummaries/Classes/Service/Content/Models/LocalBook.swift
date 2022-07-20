//
//  LocalBook.swift
//  BookSummaries
//
//  Created by Андрей Чернышев on 20.07.2022.
//

import Foundation

struct LocalBook: Codable, Hashable {
    let original: Book
    let localAudioURL: URL
}
