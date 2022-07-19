//
//  RBooksTableView.swift
//  BookSummaries
//
//  Created by Андрей Чернышев on 19.07.2022.
//

import UIKit

protocol RBooksTableDelegate: AnyObject {
    func rankingBooksTableDidTapped(book: BookCover)
}

final class RBooksTableView: UITableView {
    weak var mainDelegate: RBooksTableDelegate?
    
    private lazy var elements = [RBooksTableElement]()
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension RBooksTableView {
    func setup(elements: [RBooksTableElement]) {
        self.elements = elements
        
        reloadData()
    }
}

// MARK: UITableViewDataSource
extension RBooksTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        elements.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch elements[indexPath.row] {
        case .offset:
            let cell = dequeueReusableCell(withIdentifier: String(describing: UITableViewCell.self))!
            cell.backgroundColor = UIColor.clear
            cell.contentView.backgroundColor = UIColor.clear
            cell.selectionStyle = .none
            return cell
        case .book(let element):
            let cell = dequeueReusableCell(withIdentifier: String(describing: RBooksTableBookCell.self)) as! RBooksTableBookCell
            cell.setup(element: element)
            return cell
        case .separator:
            return dequeueReusableCell(withIdentifier: String(describing: RBooksTableSeparatorCell.self))!
        }
    }
}

// MARK: UITableViewDelegate
extension RBooksTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch elements[indexPath.row] {
        case .offset(let offset):
            return offset
        case .book:
            return 78.scale
        case .separator:
            return 1.scale
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard case let .book(element) = elements[indexPath.row] else {
            return
        }
        
        mainDelegate?.rankingBooksTableDidTapped(book: element.book)
    }
}

// MARK: Private
private extension RBooksTableView {
    func initialize() {
        register(UITableViewCell.self, forCellReuseIdentifier: String(describing: UITableViewCell.self))
        register(RBooksTableBookCell.self, forCellReuseIdentifier: String(describing: RBooksTableBookCell.self))
        register(RBooksTableSeparatorCell.self, forCellReuseIdentifier: String(describing: RBooksTableSeparatorCell.self))
        
        dataSource = self
        delegate = self
    }
}
