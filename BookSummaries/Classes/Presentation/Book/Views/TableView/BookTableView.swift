//
//  BookTableView.swift
//  BookSummaries
//
//  Created by Андрей Чернышев on 11.07.2022.
//

import UIKit

protocol BookTableDelegate: AnyObject {
    func bookTableDidTapped(chapter: BookChapter)
    func bookTableDidTappedSeeAll()
    func bookTableDidTapped(book: BookBrochure)
    func bookTableDidTapped(category: Category)
}

final class BookTableView: UITableView {
    weak var mainDelegate: BookTableDelegate?
    
    private lazy var elements = [BookTableElement]()
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Pubic
extension BookTableView {
    func setup(elements: [BookTableElement]) {
        self.elements = elements
        
        reloadData()
    }
}

// MARK: UITableViewDataSource
extension BookTableView: UITableViewDataSource {
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
        case .bookImage(let element):
            let cell = dequeueReusableCell(withIdentifier: String(describing: BookImageCell.self)) as! BookImageCell
            cell.setup(element: element)
            return cell
        case .progress(let element):
            let cell = dequeueReusableCell(withIdentifier: String(describing: BookProgressCell.self)) as! BookProgressCell
            cell.setup(element: element)
            return cell
        case .bookName(let element):
            let cell = dequeueReusableCell(withIdentifier: String(describing: BookNameCell.self)) as! BookNameCell
            cell.setup(element: element)
            return cell
        case .authorName(let element):
            let cell = dequeueReusableCell(withIdentifier: String(describing: BookAuthorNameCell.self)) as! BookAuthorNameCell
            cell.setup(element: element)
            return cell
        case .info(let element):
            let cell = dequeueReusableCell(withIdentifier: String(describing: BookInfoCell.self)) as! BookInfoCell
            cell.setup(element: element)
            return cell
        case .title(let element):
            let cell = dequeueReusableCell(withIdentifier: String(describing: BookTitleCell.self)) as! BookTitleCell
            cell.setup(element: element)
            return cell
        case .introduction:
            return dequeueReusableCell(withIdentifier: String(describing: BookIntroductionCell.self))!
        case .chapter(let element):
            let cell = dequeueReusableCell(withIdentifier: String(describing: BookChapterCell.self)) as! BookChapterCell
            cell.setup(element: element)
            return cell
        case .separator:
            return dequeueReusableCell(withIdentifier: String(describing: BookSeparatorCell.self))!
        case .seeAll:
            return dequeueReusableCell(withIdentifier: String(describing: BookSeeAllCell.self))!
        case .whatAbout(let element):
            let cell = dequeueReusableCell(withIdentifier: String(describing: BookWhatAboutCell.self)) as! BookWhatAboutCell
            cell.setup(element: element)
            return cell
        case .author(let element):
            let cell = dequeueReusableCell(withIdentifier: String(describing: BookAuthorCell.self)) as! BookAuthorCell
            cell.setup(element: element)
            return cell
        case .books(let elements):
            let cell = dequeueReusableCell(withIdentifier: String(describing: ForYouBooksCell.self)) as! ForYouBooksCell
            cell.setup(elements: elements, tapped: { [weak self] book in
                self?.mainDelegate?.bookTableDidTapped(book: book)
            })
            return cell
        case .categories(let elements):
            let cell = dequeueReusableCell(withIdentifier: String(describing: ForYouCategoriesCell.self)) as! ForYouCategoriesCell
            cell.setup(elements: elements, tapped: { [weak self] category in
                self?.mainDelegate?.bookTableDidTapped(category: category)
            })
            return cell
        }
    }
}

// MARK: UITableViewDelegate
extension BookTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch elements[indexPath.row] {
        case .offset(let offset):
            return offset
        case .bookImage:
            return 267.scale
        case .progress:
            return 16.scale
        case .info, .introduction:
            return 24.scale
        case .chapter:
            return 60.scale
        case .separator:
            return 1.scale
        case .seeAll:
            return 53.scale
        case .author:
            return 40.scale
        case .books:
            return 245.scale
        case .categories:
            return 56.scale
        default:
            return UITableView.automaticDimension
        }
    }
}

// MARK: Private
private extension BookTableView {
    func initialize() {
        register(UITableViewCell.self, forCellReuseIdentifier: String(describing: UITableViewCell.self))
        register(BookImageCell.self, forCellReuseIdentifier: String(describing: BookImageCell.self))
        register(BookProgressCell.self, forCellReuseIdentifier: String(describing: BookProgressCell.self))
        register(BookNameCell.self, forCellReuseIdentifier: String(describing: BookNameCell.self))
        register(BookAuthorNameCell.self, forCellReuseIdentifier: String(describing: BookAuthorNameCell.self))
        register(BookInfoCell.self, forCellReuseIdentifier: String(describing: BookInfoCell.self))
        register(BookTitleCell.self, forCellReuseIdentifier: String(describing: BookTitleCell.self))
        register(BookIntroductionCell.self, forCellReuseIdentifier: String(describing: BookIntroductionCell.self))
        register(BookChapterCell.self, forCellReuseIdentifier: String(describing: BookChapterCell.self))
        register(BookSeparatorCell.self, forCellReuseIdentifier: String(describing: BookSeparatorCell.self))
        register(BookSeeAllCell.self, forCellReuseIdentifier: String(describing: BookSeeAllCell.self))
        register(BookWhatAboutCell.self, forCellReuseIdentifier: String(describing: BookWhatAboutCell.self))
        register(BookAuthorCell.self, forCellReuseIdentifier: String(describing: BookAuthorCell.self))
        register(ForYouBooksCell.self, forCellReuseIdentifier: String(describing: ForYouBooksCell.self))
        register(ForYouCategoriesCell.self, forCellReuseIdentifier: String(describing: ForYouCategoriesCell.self))
        
        dataSource = self
        delegate = self
    }
}
