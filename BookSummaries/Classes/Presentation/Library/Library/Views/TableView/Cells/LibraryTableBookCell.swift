//
//  LibraryTableBookCell.swift
//  BookSummaries
//
//  Created by Андрей Чернышев on 22.07.2022.
//

import UIKit

final class LibraryTableBookCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension LibraryTableBookCell {
    func setup(element: LibraryTableBookElement,
               bookTapped: @escaping ((BookCover) -> Void),
               menuTapped: @escaping ((BookCover) -> Void)) {
        
    }
}

// MARK: Private
private extension LibraryTableBookCell {
    func initialize() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        selectionStyle = .none
    }
}

// MARK: Make constraints
private extension LibraryTableBookCell {
    func makeConstraints() {
        
    }
}

// MARK: Lazy initialization
private extension LibraryTableBookCell {
    
}
