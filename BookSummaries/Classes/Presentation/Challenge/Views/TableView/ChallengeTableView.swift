//
//  ChallengeTableView.swift
//  BookSummaries
//
//  Created by Андрей Чернышев on 17.08.2022.
//

import UIKit

protocol ChallengeTableDelegate: AnyObject {
    func challengeTableDidTappedListen()
    func challengeTableDidTappedRead()
    func challengeTableDidTapped(element: ChallengeBookElement)
}

final class ChallengeTableView: UITableView {
    weak var mainDelegate: ChallengeTableDelegate?
    
    private lazy var elements = [ChallengeTableElement]()
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension ChallengeTableView {
    func setup(elements: [ChallengeTableElement]) {
        self.elements = elements
        
        reloadData()
    }
}

// MARK: UITableViewDataSource
extension ChallengeTableView: UITableViewDataSource {
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
        case .header(let element):
            let cell = dequeueReusableCell(withIdentifier: String(describing: ChallengeHeaderCell.self)) as! ChallengeHeaderCell
            cell.setup(name: element.name,
                       title: element.title,
                       text: element.text)
            return cell
        case .buttons:
            let cell = dequeueReusableCell(withIdentifier: String(describing: ChallengeButtonsCell.self)) as! ChallengeButtonsCell
            cell.delegate = mainDelegate
            return cell
        case .books(let elements):
            let cell = dequeueReusableCell(withIdentifier: String(describing: ChallengeBooksCell.self)) as! ChallengeBooksCell
            cell.collectionView.mainDelegate = mainDelegate
            cell.setup(elements: elements)
            return cell
        case .badges(let element):
            let cell = dequeueReusableCell(withIdentifier: String(describing: ChallengeBadgesCell.self)) as! ChallengeBadgesCell
            cell.setup(element: element)
            return cell
        }
    }
}

// MARK: UITableViewDelegate
extension ChallengeTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch elements[indexPath.row] {
        case .offset(let offset):
            return offset
        case .buttons:
            return 49.scale
        case .books:
            return 188.scale
        case .badges:
            return 198.scale
        default:
            return UITableView.automaticDimension
        }
    }
}

// MARK: Private
private extension ChallengeTableView {
    func initialize() {
        register(UITableViewCell.self, forCellReuseIdentifier: String(describing: UITableViewCell.self))
        register(ChallengeHeaderCell.self, forCellReuseIdentifier: String(describing: ChallengeHeaderCell.self))
        register(ChallengeButtonsCell.self, forCellReuseIdentifier: String(describing: ChallengeButtonsCell.self))
        register(ChallengeBooksCell.self, forCellReuseIdentifier: String(describing: ChallengeBooksCell.self))
        register(ChallengeBooksCell.self, forCellReuseIdentifier: String(describing: ChallengeBooksCell.self))
        register(ChallengeBadgesCell.self, forCellReuseIdentifier: String(describing: ChallengeBadgesCell.self))
        
        dataSource = self
        delegate = self
    }
}
