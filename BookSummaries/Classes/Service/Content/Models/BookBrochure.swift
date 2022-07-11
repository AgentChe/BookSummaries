//
//  BookBrochure.swift
//  BookSummaries
//
//  Created by Андрей Чернышев on 07.07.2022.
//

import Foundation

struct BookBrochure: Codable, Hashable {
    let id: Int
    let name: String
    let author: String
    let image: URL
}
