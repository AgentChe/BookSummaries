//
//  OQuantityButton.swift
//  BookSummaries
//
//  Created by Андрей Чернышев on 23.08.2022.
//

import UIKit

final class OQuantityButton: UIButton {
    struct Quantity {
        let code: Int
        let title: String
        let subTitle: String
    }
    
    lazy var marked = false {
        didSet {
            update()
        }
    }
    
    lazy var mainLabel = makeTitleLabel()
    lazy var secondLabel = makeSubTitleLabel()
    
    let quantity: Quantity
    
    init(quantity: Quantity) {
        self.quantity = quantity
        
        super.init(frame: .zero)
        
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension OQuantityButton {
    func update() {
        layer.borderWidth = marked ? 2.scale : 0
        layer.borderColor = marked ? Appearance.primaryGreen.cgColor : UIColor.clear.cgColor
    }
}

// MARK: Make constraints
private extension OQuantityButton {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            mainLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            mainLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16.scale)
        ])
        
        NSLayoutConstraint.activate([
            secondLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            secondLabel.topAnchor.constraint(equalTo: topAnchor, constant: 42.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension OQuantityButton {
    func makeTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.black)
            .font(Fonts.PlusJakartaSans.bold(size: 16.scale))
            .lineHeight(22.4.scale)
            .letterSpacing(-0.17.scale)
            .textAlignment(.center)
        
        let view = UILabel()
        view.attributedText = quantity.title.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeSubTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.black)
            .font(Fonts.PlusJakartaSans.regular(size: 16.scale))
            .lineHeight(22.4.scale)
            .letterSpacing(-0.17.scale)
            .textAlignment(.center)
        
        let view = UILabel()
        view.attributedText = quantity.subTitle.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
