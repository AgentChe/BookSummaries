//
//  ExploreCollectionBookCell.swift
//  BookSummaries
//
//  Created by Андрей Чернышев on 19.07.2022.
//

import UIKit
import Kingfisher

final class ExploreCollectionBookCell: UICollectionViewCell {
    lazy var bookImageView = makeImageView()
    lazy var nameLabel = makeLabel(numberOfLines: 2)
    lazy var authorLabel = makeLabel(numberOfLines: 1)
    
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
extension ExploreCollectionBookCell {
    func setup(element: BookCover) {
        bookImageView.kf.setImage(with: element.imageUrl)
        
        nameLabel.attributedText = element.name
            .attributed(with: TextAttributes()
                            .textColor(Appearance.black)
                            .font(Fonts.PlusJakartaSans.semiBold(size: 16.scale))
                            .lineHeight(20.8.scale)
                            .letterSpacing(-0.17.scale)
                            .lineBreakMode(.byTruncatingTail))
        
        authorLabel.attributedText = element.author.name
            .attributed(with: TextAttributes()
                            .textColor(Appearance.black.withAlphaComponent(0.5))
                            .font(Fonts.PlusJakartaSans.regular(size: 16.scale))
                            .lineHeight(24.scale)
                            .letterSpacing(-0.17.scale)
                            .lineBreakMode(.byTruncatingTail))
    }
}

// MARK: Private
private extension ExploreCollectionBookCell {
    func initialize() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        let selectedView = UIView()
        selectedView.backgroundColor = UIColor.clear
        selectedBackgroundView = selectedView
    }
}

// MARK: Make constraints
private extension ExploreCollectionBookCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            bookImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            bookImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            bookImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16.scale),
            bookImageView.heightAnchor.constraint(equalToConstant: 197.scale)
        ])
        
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            nameLabel.topAnchor.constraint(equalTo: bookImageView.bottomAnchor, constant: 16.scale)
        ])
        
        NSLayoutConstraint.activate([
            authorLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            authorLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            authorLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 5.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension ExploreCollectionBookCell {
    func makeImageView() -> BookImageView {
        let view = BookImageView(size: .medium)
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeLabel(numberOfLines: Int) -> UILabel {
        let view = UILabel()
        view.numberOfLines = numberOfLines
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
}
