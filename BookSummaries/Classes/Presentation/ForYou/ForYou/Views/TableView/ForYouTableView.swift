//
//  ForYouTableView.swift
//  BookSummaries
//
//  Created by Андрей Чернышев on 07.07.2022.
//

import UIKit

final class ForYouTableView: UITableView {
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
            cell.setup(elements: elements, tapped: { book in
                
            })
            return cell
        case .challenges(let elements):
            let cell = dequeueReusableCell(withIdentifier: String(describing: ForYouChallengesCell.self)) as! ForYouChallengesCell
            cell.setup(elements: elements, tapped: { challenge in
                
            })
            return cell
        case .rankingTitle(let element), .newReleasesTitle(let element):
            let cell = dequeueReusableCell(withIdentifier: String(describing: ForYouTitleCell.self)) as! ForYouTitleCell
            cell.setup(title: element, seeAllHidden: false)
            return cell
        case .ranking(let element):
            let cell = dequeueReusableCell(withIdentifier: String(describing: ForYouRankingCell.self)) as! ForYouRankingCell
            cell.setup(element: element)
            return cell
        case .separator:
            return dequeueReusableCell(withIdentifier: String(describing: ForYouSeparatorCell.self))!
        case .categories(let elements):
            let cell = dequeueReusableCell(withIdentifier: String(describing: ForYouCategoriesCell.self)) as! ForYouCategoriesCell
            cell.setup(elements: elements, tapped: { challenge in
                
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
        case .title, .rankingTitle, .newReleasesTitle:
            return 24.scale
        case .books:
            return 245.scale
        case .challenges:
            return 284.scale
        case .ranking:
            return 78.scale
        case .separator:
            return 1.scale
        case .categories:
            return 56.scale
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
