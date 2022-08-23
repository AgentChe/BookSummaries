//
//  OCategoriesCollectionElement.swift
//  BookSummaries
//
//  Created by Андрей Чернышев on 23.08.2022.
//

final class OCategoriesCollectionElement {
    let title: String
    var selected: Bool
    
    init(title: String) {
        self.title = title
        self.selected = false
    }
}
