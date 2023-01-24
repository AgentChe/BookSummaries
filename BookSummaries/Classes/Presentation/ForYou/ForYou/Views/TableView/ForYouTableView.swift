//
//  ForYouTableView.swift
//  BookSummaries
//
//  Created by Андрей Чернышев on 07.07.2022.
//

import UIKit

protocol ForYouTableDelegate: AnyObject {
    func forYouTableDidTapped(freeBook: BookCover)
    func forYouTableDidTapped(book: BookCover)
    func forYouTableDidTapped(challenge: ChallengeCover)
    func forYouTableDidTapped(ranking: Ranking)
    func forYouTableDidTapped(category: Category)
}

final class ForYouTableView: UITableView {
    weak var mainDelegate: ForYouTableDelegate?
    
    private lazy var elements = [ForYouTableElement]()
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension ForYouTableView {
    func setup(elements: [ForYouTableElement]) {
        self.elements = elements
        
        reloadData()
    }
}

// MARK: UITableViewDataSource
extension ForYouTableView: UITableViewDataSource {
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
        case .freeBook(let element):
            let cell = dequeueReusableCell(withIdentifier: String(describing: ForYouFreeBookCell.self)) as! ForYouFreeBookCell
            cell.setup(element: element)
            return cell
        case .title(let element):
            let cell = dequeueReusableCell(withIdentifier: String(describing: ForYouTitleCell.self)) as! ForYouTitleCell
            cell.setup(title: element, seeAllHidden: true)
            return cell
        case .books(let elements):
            let cell = dequeueReusableCell(withIdentifier: String(describing: ForYouBooksCell.self)) as! ForYouBooksCell
            cell.setup(elements: elements, tapped: { [weak self] book in
                self?.mainDelegate?.forYouTableDidTapped(book: book)
            })
            return cell
        case .challenges(let elements):
            let cell = dequeueReusableCell(withIdentifier: String(describing: ForYouChallengesCell.self)) as! ForYouChallengesCell
            cell.setup(elements: elements, tapped: { [weak self] challenge in
                self?.mainDelegate?.forYouTableDidTapped(challenge: challenge)
            })
            return cell
        case .rankingTitle(let element):
            let cell = dequeueReusableCell(withIdentifier: String(describing: ForYouTitleCell.self)) as! ForYouTitleCell
            cell.setup(title: element.name, seeAllHidden: false)
            return cell
        case .rankingBook(let element):
            let cell = dequeueReusableCell(withIdentifier: String(describing: ForYouRankingCell.self)) as! ForYouRankingCell
            cell.setup(element: element)
            return cell
        case .separator:
            return dequeueReusableCell(withIdentifier: String(describing: ForYouSeparatorCell.self))!
        case .categories(let elements):
            let cell = dequeueReusableCell(withIdentifier: String(describing: ForYouCategoriesCell.self)) as! ForYouCategoriesCell
            cell.setup(elements: elements, tapped: { [weak self] category in
                self?.mainDelegate?.forYouTableDidTapped(category: category)
            })
            return cell
        }
    }
}

// MARK: UITableViewDelegate
extension ForYouTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch elements[indexPath.row] {
        case .offset(let offset):
            return offset
        case .freeBook:
            return 340.scale
        case .title, .rankingTitle:
            return 24.scale
        case .books:
            return 245.scale
        case .challenges:
            return 284.scale
        case .rankingBook:
            return 78.scale
        case .separator:
            return 1.scale
        case .categories:
            return 56.scale
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch elements[indexPath.row] {
        case .freeBook(let element):
            mainDelegate?.forYouTableDidTapped(freeBook: element)
        case .rankingBook(let element):
            mainDelegate?.forYouTableDidTapped(book: element.book)
        case .rankingTitle(let element):
            mainDelegate?.forYouTableDidTapped(ranking: element)
        default:
            break
        }
    }
}

// MARK: Private
private extension ForYouTableView {
    func initialize() {
        register(UITableViewCell.self, forCellReuseIdentifier: String(describing: UITableViewCell.self))
        register(ForYouFreeBookCell.self, forCellReuseIdentifier: String(describing: ForYouFreeBookCell.self))
        register(ForYouTitleCell.self, forCellReuseIdentifier: String(describing: ForYouTitleCell.self))
        register(ForYouBooksCell.self, forCellReuseIdentifier: String(describing: ForYouBooksCell.self))
        register(ForYouChallengesCell.self, forCellReuseIdentifier: String(describing: ForYouChallengesCell.self))
        register(ForYouRankingCell.self, forCellReuseIdentifier: String(describing: ForYouRankingCell.self))
        register(ForYouSeparatorCell.self, forCellReuseIdentifier: String(describing: ForYouSeparatorCell.self))
        register(ForYouCategoriesCell.self, forCellReuseIdentifier: String(describing: ForYouCategoriesCell.self))
        
        dataSource = self
        delegate = self
    }
}
