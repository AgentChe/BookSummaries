//
//  ChallengeBooksCollectionCell.swift
//  BookSummaries
//
//  Created by Андрей Чернышев on 17.08.2022.
//

import UIKit
import Kingfisher

final class ChallengeBooksCollectionCell: UICollectionViewCell {
    lazy var container = makeContainer()
    lazy var checkedView = makeCheckedView()
    lazy var dayNumberLabel = makeLabel()
    lazy var bookNameLabel = makeLabel()
    lazy var authorLabel = makeLabel()
    lazy var bookImageView = makeBookImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        bookImageView.kf.cancelDownloadTask()
        bookImageView.image = nil
    }
}

// MARK: Public
extension ChallengeBooksCollectionCell {
    func setup(element: ChallengeBookElement) {
        let book = element.book
        
        bookImageView.kf.setImage(with: book.imageUrl)
        
        checkedView.image = UIImage(named: element.completed ? "Challenge.Checked" : "Challenge.Unchecked")
        
        container.layer.borderWidth = element.current ? 3.scale : 0
        container.layer.borderColor = element.current ? Appearance.secondary2.withAlphaComponent(0.3).cgColor : UIColor.clear.cgColor
        
        let day = String(format: "Challenge.Day".localized, element.dayNumber)
        dayNumberLabel.attributedText = day
            .attributed(with: TextAttributes()
                            .textColor(Appearance.black)
                            .font(Fonts.PlusJakartaSans.bold(size: 20.scale))
                            .lineHeight(24.scale)
                            .letterSpacing(-0.17.scale))
        
        bookNameLabel.attributedText = book.name
            .attributed(with: TextAttributes()
                            .textColor(Appearance.black)
                            .font(Fonts.PlusJakartaSans.semiBold(size: 16.scale))
                            .lineHeight(20.8.scale)
                            .letterSpacing(-0.17.scale)
                            .lineBreakMode(.byTruncatingTail))
        
        authorLabel.attributedText = book.author.name
            .attributed(with: TextAttributes()
                            .textColor(Appearance.black.withAlphaComponent(0.5))
                            .font(Fonts.PlusJakartaSans.regular(size: 16.scale))
                            .lineHeight(24.scale)
                            .letterSpacing(-0.17.scale)
                            .lineBreakMode(.byTruncatingTail))
    }
}

// MARK: Private
private extension ChallengeBooksCollectionCell {
    func initialize() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        let selectedView = UIView()
        selectedView.backgroundColor = UIColor.clear
        selectedBackgroundView = selectedView
    }
}

// MARK: Make constraints
private extension ChallengeBooksCollectionCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            container.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            container.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            container.topAnchor.constraint(equalTo: contentView.topAnchor),
            container.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            checkedView.widthAnchor.constraint(equalToConstant: 32.scale),
            checkedView.heightAnchor.constraint(equalToConstant: 32.scale),
            checkedView.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 20.scale),
            checkedView.topAnchor.constraint(equalTo: container.topAnchor, constant: 20.scale)
        ])
        
        NSLayoutConstraint.activate([
            dayNumberLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 20.scale),
            dayNumberLabel.topAnchor.constraint(equalTo: container.topAnchor, constant: 59.scale)
        ])
        
        NSLayoutConstraint.activate([
            bookNameLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 20.scale),
            bookNameLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -154.scale),
            bookNameLabel.topAnchor.constraint(equalTo: container.topAnchor, constant: 100.scale)
        ])
        
        NSLayoutConstraint.activate([
            authorLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 20.scale),
            authorLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -154.scale),
            authorLabel.topAnchor.constraint(equalTo: container.topAnchor, constant: 145.scale)
        ])
        
        NSLayoutConstraint.activate([
            bookImageView.widthAnchor.constraint(equalToConstant: 124.scale),
            bookImageView.heightAnchor.constraint(equalToConstant: 150.scale),
            bookImageView.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            bookImageView.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -20.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension ChallengeBooksCollectionCell {
    func makeContainer() -> UIView {
        let view = UIView()
        view.layer.cornerRadius = 20.scale
        view.backgroundColor = Appearance.white
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.03
        view.layer.shadowOffset = .zero
        view.layer.shadowRadius = 6.scale
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeCheckedView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
    
    func makeLabel() -> UILabel {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
    
    func makeBookImageView() -> BookImageView {
        let view = BookImageView(size: .small3)
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
}
