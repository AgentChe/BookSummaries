//
//  BookInfoCell.swift
//  BookSummaries
//
//  Created by Андрей Чернышев on 11.07.2022.
//

import UIKit

final class BookInfoCell: UITableViewCell {
    lazy var chaptersIconView = makeIconView(name: "Book.Chapters")
    lazy var chaptersLabel = makeLabel()
    lazy var timeIconView = makeIconView(name: "Book.Time")
    lazy var timeLabel = makeLabel()
    
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
extension BookInfoCell {
    func setup(element: BookInfoElement) {
        let attrs = TextAttributes()
            .textColor(Appearance.black)
            .font(Fonts.PlusJakartaSans.regular(size: 16.scale))
            .lineHeight(24.scale)
            .letterSpacing(-0.17.scale)
        
        let chapters = String(format: "Book.ChaptersCount".localized, element.chaptersCount)
        chaptersLabel.attributedText = chapters.attributed(with: attrs)
        
        let time = String(format: "Book.Min".localized, element.min)
        timeLabel.attributedText = time.attributed(with: attrs)
    }
}

// MARK: Private
private extension BookInfoCell {
    func initialize() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        selectionStyle = .none
    }
}

// MARK: Make constraints
private extension BookInfoCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            chaptersIconView.widthAnchor.constraint(equalToConstant: 24.scale),
            chaptersIconView.heightAnchor.constraint(equalToConstant: 24.scale),
            chaptersIconView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 80.scale),
            chaptersIconView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            chaptersLabel.leadingAnchor.constraint(equalTo: chaptersIconView.trailingAnchor, constant: 5.scale),
            chaptersLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            timeIconView.widthAnchor.constraint(equalToConstant: 24.scale),
            timeIconView.heightAnchor.constraint(equalToConstant: 24.scale),
            timeIconView.leadingAnchor.constraint(equalTo: chaptersLabel.trailingAnchor, constant: 20.scale),
            timeIconView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            timeLabel.leadingAnchor.constraint(equalTo: timeIconView.trailingAnchor, constant: 5.scale),
            timeLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension BookInfoCell {
    func makeIconView(name: String) -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: name)
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
