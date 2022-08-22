//
//  ChallengeButtonsCell.swift
//  BookSummaries
//
//  Created by Андрей Чернышев on 17.08.2022.
//

import UIKit

final class ChallengeButtonsCell: UITableViewCell {
    weak var delegate: ChallengeTableDelegate?
    
    lazy var listenButton = makeListenButton()
    lazy var readButton = makeReadButton()
    
    private var element: ChallengeButtonsElement?
    
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
extension ChallengeButtonsCell {
    func setup(element: ChallengeButtonsElement) {
        self.element = element
    }
}

// MARK: Private
private extension ChallengeButtonsCell {
    func initialize() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        selectionStyle = .none
    }
    
    @objc
    func listenTapped() {
        guard let bookId = element?.currentDayBookId else {
            return
        }
        
        delegate?.challengeTableDidTappedListen(bookId: bookId)
    }
    
    
    @objc
    func readTapped() {
        guard let bookId = element?.currentDayBookId else {
            return
        }
        
        delegate?.challengeTableDidTappedRead(bookId: bookId)
    }
}

// MARK: Make constraints
private extension ChallengeButtonsCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            listenButton.widthAnchor.constraint(equalToConstant: 166.scale),
            listenButton.topAnchor.constraint(equalTo: contentView.topAnchor),
            listenButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            listenButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.scale)
        ])
        
        NSLayoutConstraint.activate([
            readButton.widthAnchor.constraint(equalToConstant: 166.scale),
            readButton.topAnchor.constraint(equalTo: contentView.topAnchor),
            readButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            readButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 193.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension ChallengeButtonsCell {
    func makeListenButton() -> ChallengeButton {
        let view = ChallengeButton(icon: "Challenge.ListenIcon",
                                   text: "Challenge.Listen".localized)
        view.backgroundColor = Appearance.secondary2
        view.layer.cornerRadius = 16.scale
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addTarget(self, action: #selector(listenTapped), for: .touchUpInside)
        contentView.addSubview(view)
        return view
    }
    
    func makeReadButton() -> ChallengeButton {
        let view = ChallengeButton(icon: "Challenge.ReadIcon",
                                   text: "Challenge.Read".localized)
        view.backgroundColor = Appearance.secondary2
        view.layer.cornerRadius = 16.scale
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addTarget(self, action: #selector(readTapped), for: .touchUpInside)
        contentView.addSubview(view)
        return view
    }
}
