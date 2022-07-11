//
//  TryAgainView.swift
//  BookSummaries
//
//  Created by Андрей Чернышев on 05.07.2022.
//

import UIKit

final class TryAgainView: UIView {
    lazy var imageView = makeImageView()
    lazy var titleLabel = makeTitleLabel()
    lazy var subTitleLabel = makeSubTitleLabel()
    lazy var tryAgainButton = makeButton()
    lazy var contactButton = makeContactButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension TryAgainView {
    func initialize() {
        backgroundColor = Appearance.background
    }
}

// MARK: Make constraints
private extension TryAgainView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 263.scale),
            imageView.heightAnchor.constraint(equalToConstant: 284.scale),
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.topAnchor.constraint(equalTo: topAnchor, constant: ScreenSize.isIphoneXFamily ? 40.scale : 0)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: ScreenSize.isIphoneXFamily ? 23.scale : 15.scale)
        ])
        
        NSLayoutConstraint.activate([
            subTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            subTitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            subTitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12.scale)
        ])
        
        NSLayoutConstraint.activate([
            tryAgainButton.widthAnchor.constraint(equalToConstant: 328.scale),
            tryAgainButton.heightAnchor.constraint(equalToConstant: 60.scale),
            tryAgainButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            tryAgainButton.bottomAnchor.constraint(equalTo: contactButton.topAnchor, constant: -15.scale)
        ])
        
        NSLayoutConstraint.activate([
            contactButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            contactButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            contactButton.heightAnchor.constraint(equalToConstant: 24.scale),
            contactButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: ScreenSize.isIphoneXFamily ? -44.scale : -25.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension TryAgainView {
    func makeImageView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: "TryAgain.Image")
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.black)
            .font(Fonts.PlusJakartaSans.semiBold(size: ScreenSize.isIphoneXFamily ? 24.scale : 20.scale))
            .lineHeight(ScreenSize.isIphoneXFamily ? 28.8.scale : 24.8.scale)
            .letterSpacing(-0.44.scale)
            .textAlignment(.center)
        
        let view = UILabel()
        view.numberOfLines = 0
        view.attributedText = "TryAgain.Title".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeSubTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.black.withAlphaComponent(0.5))
            .font(Fonts.PlusJakartaSans.semiBold(size: ScreenSize.isIphoneXFamily ? 19.scale : 17.scale))
            .lineHeight(ScreenSize.isIphoneXFamily ? 26.6.scale : 23.6.scale)
            .textAlignment(.center)
        
        let view = UILabel()
        view.numberOfLines = 0
        view.attributedText = "TryAgain.SubTitle".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeButton() -> UIButton {
        let attrs = TextAttributes()
            .textColor(Appearance.white)
            .font(Fonts.PlusJakartaSans.semiBold(size: 20.scale))
        
        let view = UIButton()
        view.setAttributedTitle("TryAgain.Button".localized.attributed(with: attrs), for: .normal)
        view.layer.cornerRadius = 16.scale
        view.backgroundColor = Appearance.primaryGreen
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeContactButton() -> TapAreaButton {
        let attrs = TextAttributes()
            .textColor(Appearance.primaryGreen)
            .font(Fonts.PlusJakartaSans.semiBold(size: ScreenSize.isIphoneXFamily ? 20.scale : 17.scale))
        
        let view = TapAreaButton()
        view.setAttributedTitle("TryAgain.Contact".localized.attributed(with: attrs), for: .normal)
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
