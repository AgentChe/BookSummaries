//
//  RBooksTableBookCell.swift
//  BookSummaries
//
//  Created by Андрей Чернышев on 19.07.2022.
//

import UIKit
import Kingfisher

final class RBooksTableBookCell: UITableViewCell {
    lazy var numberLabel = makeLabel()
    lazy var bookImageView = makeImageView()
    lazy var nameLabel = makeLabel()
    lazy var authorLabel = makeLabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
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
extension RBooksTableBookCell {
    func setup(element: RBooksTableBookElement) {
        bookImageView.kf.setImage(with: element.book.imageUrl)
        
        numberLabel.attributedText = element.number
            .attributed(with: TextAttributes()
                            .textColor(Appearance.black)
                            .font(Fonts.PlusJakartaSans.bold(size: 20.scale))
                            .lineHeight(24.scale)
                            .letterSpacing(-0.17.scale))
        
        nameLabel.attributedText = element.book.name
            .attributed(with: TextAttributes()
                            .textColor(Appearance.black)
                            .font(Fonts.PlusJakartaSans.semiBold(size: 16.scale))
                            .lineHeight(20.8.scale)
                            .letterSpacing(-0.17.scale)
                            .lineBreakMode(.byTruncatingTail))
        
        authorLabel.attributedText = element.book.author.name
            .attributed(with: TextAttributes()
                            .textColor(Appearance.black.withAlphaComponent(0.5))
                            .font(Fonts.PlusJakartaSans.regular(size: 16.scale))
                            .lineHeight(24.scale)
                            .letterSpacing(-0.17.scale)
                            .lineBreakMode(.byTruncatingTail))
    }
}

// MARK: Private
private extension RBooksTableBookCell {
    func initialize() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        selectionStyle = .none
    }
}

// MARK: Make constraints
private extension RBooksTableBookCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            numberLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24.scale),
            numberLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            bookImageView.widthAnchor.constraint(equalToConstant: 65.scale),
            bookImageView.heightAnchor.constraint(equalToConstant: 78.scale),
            bookImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 53.scale),
            bookImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 128.scale),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.scale),
            nameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -43.scale)
        ])
        
        NSLayoutConstraint.activate([
            authorLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 128.scale),
            authorLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.scale),
            authorLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 40.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension RBooksTableBookCell {
    func makeImageView() -> BookImageView {
        let view = BookImageView(size: .small2)
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeLabel() -> UILabel {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
}
