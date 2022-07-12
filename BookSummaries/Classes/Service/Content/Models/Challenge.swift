//
//  Challenge.swift
//  BookSummaries
//
//  Created by Андрей Чернышев on 07.07.2022.
//

import Foundation

struct Challenge: Codable, Hashable {
    let id: Int
    let name: String
    let title: String
    let imageUrl: URL
}
