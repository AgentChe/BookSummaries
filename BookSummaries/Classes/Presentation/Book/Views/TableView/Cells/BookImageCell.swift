//
//  BookImageCell.swift
//  BookSummaries
//
//  Created by Андрей Чернышев on 11.07.2022.
//

import UIKit
import Kingfisher

final class BookImageCell: UITableViewCell {
    lazy var bookImageView = makeImageView()
    
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
extension BookImageCell {
    func setup(element: URL) {
        bookImageView.kf.setImage(with: element)
    }
}

// MARK: Private
private extension BookImageCell {
    func initialize() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        selectionStyle = .none
    }
}

// MARK: Make constraints
private extension BookImageCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            bookImageView.widthAnchor.constraint(equalToConstant: 221.scale),
            bookImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            bookImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            bookImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension BookImageCell {
    func makeImageView() -> BookImageView {
        let view = BookImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
}
