//
//  LibraryTableBookCell.swift
//  BookSummaries
//
//  Created by Андрей Чернышев on 22.07.2022.
//

import UIKit
import Kingfisher

final class LibraryTableBookCell: UITableViewCell {
    lazy var bookImageView = makeImageView()
    lazy var nameLabel = makeLabel()
    lazy var authorLabel = makeLabel()
    lazy var progressView = makeProgressView()
    lazy var menuButton = makeMenuButton()
    
    private lazy var nameLabelTopConstraint = NSLayoutConstraint()
    private lazy var authorLabelTopConstraint = NSLayoutConstraint()
    
    private var menuTapped: (() -> Void)?
    
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
extension LibraryTableBookCell {
    func setup(element: LibraryTableBookElement, menuTapped: @escaping () -> Void) {
        self.menuTapped = menuTapped
        
        bookImageView.kf.setImage(with: element.book.imageUrl)
        
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
        
        progressView.isHidden = element.progress == nil
        if let progress = element.progress {
            progressView.progress = progress
        }
        
        nameLabelTopConstraint.isActive = false
        authorLabelTopConstraint.isActive = false
        
        nameLabelTopConstraint.constant = element.progress == nil ? 14.scale : 4.scale
        authorLabelTopConstraint.constant = element.progress == nil ? 40.scale : 30.scale
        
        nameLabelTopConstraint.isActive = true
        authorLabelTopConstraint.isActive = true
        
        contentView.layoutIfNeeded()
    }
}

// MARK: Private
private extension LibraryTableBookCell {
    func initialize() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        selectionStyle = .none
    }
    
    @objc
    func didTappedMenu() {
        menuTapped?()
    }
}

// MARK: Make constraints
private extension LibraryTableBookCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            bookImageView.widthAnchor.constraint(equalToConstant: 65.scale),
            bookImageView.heightAnchor.constraint(equalToConstant: 78.scale),
            bookImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.scale),
            bookImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
        
        nameLabelTopConstraint = nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4.scale)
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 91.scale),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -47.scale),
            nameLabelTopConstraint
        ])
        
        authorLabelTopConstraint = authorLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 30.scale)
        NSLayoutConstraint.activate([
            authorLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 91.scale),
            authorLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -47.scale),
            authorLabelTopConstraint
        ])
        
        NSLayoutConstraint.activate([
            progressView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 91.scale),
            progressView.widthAnchor.constraint(equalToConstant: 140.scale),
            progressView.heightAnchor.constraint(equalToConstant: 6.scale),
            progressView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 68.scale)
        ])
        
        NSLayoutConstraint.activate([
            menuButton.widthAnchor.constraint(equalToConstant: 24.scale),
            menuButton.heightAnchor.constraint(equalToConstant: 24.scale),
            menuButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            menuButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension LibraryTableBookCell {
    func makeImageView() -> BookImageView {
        let view = BookImageView()
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
    
    func makeProgressView() -> UIProgressView {
        let view = UIProgressView()
        view.layer.cornerRadius = 3.scale
        view.layer.masksToBounds = true
        view.trackTintColor = Appearance.secondary5
        view.progressTintColor = Appearance.primaryGreen
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeMenuButton() -> TapAreaButton {
        let view = TapAreaButton()
        view.setImage(UIImage(named: "Library.Menu"), for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addTarget(self, action: #selector(didTappedMenu), for: .touchUpInside)
        contentView.addSubview(view)
        return view
    }
}
