//
//  ForYouFreeBookCell.swift
//  BookSummaries
//
//  Created by Андрей Чернышев on 07.07.2022.
//

import UIKit
import Kingfisher

final class ForYouFreeBookCell: UITableViewCell {
    lazy var placeholder1View = makePlaceholder1View()
    lazy var placeholder2View = makePlaceholder2View()
    lazy var bookImageView = makeImageView()
    lazy var freeLabel = makeFreeLabel()
    lazy var nameLabel = makeLabel(numberOfLines: 2)
    lazy var authorLabel = makeLabel(numberOfLines: 1)
    
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
extension ForYouFreeBookCell {
    func setup(element: BookCover) {
        bookImageView.kf.setImage(with: element.imageUrl)
        
        nameLabel.attributedText = element.name
            .attributed(with: TextAttributes()
                            .textColor(Appearance.black)
                            .font(Fonts.PlusJakartaSans.bold(size: 16.scale))
                            .lineHeight(19.2.scale)
                            .letterSpacing(-0.17.scale)
                            .textAlignment(.center)
                            .lineBreakMode(.byTruncatingTail))
        
        authorLabel.attributedText = element.author.name
            .attributed(with: TextAttributes()
                            .textColor(Appearance.black.withAlphaComponent(0.5))
                            .font(Fonts.PlusJakartaSans.regular(size: 16.scale))
                            .lineHeight(24.scale)
                            .letterSpacing(-0.17.scale)
                            .textAlignment(.center)
                            .lineBreakMode(.byTruncatingTail))
    }
}

// MARK: Private
private extension ForYouFreeBookCell {
    func initialize() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        selectionStyle = .none
    }
}

// MARK: Make constraints
private extension ForYouFreeBookCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            placeholder1View.widthAnchor.constraint(equalToConstant: 294.scale),
            placeholder1View.heightAnchor.constraint(equalToConstant: 309.scale),
            placeholder1View.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            placeholder1View.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            placeholder2View.widthAnchor.constraint(equalToConstant: 295.scale),
            placeholder2View.heightAnchor.constraint(equalToConstant: 309.scale),
            placeholder2View.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            placeholder2View.topAnchor.constraint(equalTo: contentView.topAnchor)
        ])
        
        NSLayoutConstraint.activate([
            bookImageView.widthAnchor.constraint(equalToConstant: 131.scale),
            bookImageView.heightAnchor.constraint(equalToConstant: 158.scale),
            bookImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            bookImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 23.scale)
        ])
        
        NSLayoutConstraint.activate([
            freeLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            freeLabel.topAnchor.constraint(equalTo: bookImageView.bottomAnchor, constant: 20.scale)
        ])
        
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 48.scale),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -48.scale),
            nameLabel.topAnchor.constraint(equalTo: freeLabel.bottomAnchor, constant: 10.scale)
        ])
        
        NSLayoutConstraint.activate([
            authorLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 48.scale),
            authorLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -48.scale),
            authorLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 5.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension ForYouFreeBookCell {
    func makePlaceholder1View() -> UIView {
        let view = UIView()
        view.backgroundColor = UIColor(integralRed: 229, green: 228, blue: 215)
        view.layer.cornerRadius = 30.scale
        view.transform = CGAffineTransform(rotationAngle: (-6.31 * CGFloat.pi / 180))
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makePlaceholder2View() -> UIView {
        let view = UIView()
        view.backgroundColor = UIColor(integralRed: 247, green: 244, blue: 233)
        view.layer.cornerRadius = 30.scale
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeImageView() -> BookImageView {
        let view = BookImageView(size: .small3)
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeFreeLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.primaryGreen)
            .font(Fonts.PlusJakartaSans.extraBold(size: 16.scale))
            .lineHeight(19.2.scale)
            .textAlignment(.center)
        
        let view = UILabel()
        view.attributedText = "ForYou.FreeButton.Free".localized.attributed(with: attrs)
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
