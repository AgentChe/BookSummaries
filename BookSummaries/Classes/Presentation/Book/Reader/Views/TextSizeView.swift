//
//  TextSizeView.swift
//  BookSummaries
//
//  Created by Андрей Чернышев on 15.07.2022.
//

import UIKit

final class TextSizeView: UIView {
    lazy var container = makeContainer()
    lazy var label = makeLabel()
    lazy var minusButton = makeMinusButton()
    lazy var plusButton = makePlusButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension TextSizeView {
    func setup(percent: Int) {
        let attrs = TextAttributes()
            .textColor(Appearance.black)
            .font(Fonts.PlusJakartaSans.bold(size: 16.scale))
            .lineHeight(19.2.scale)
            .letterSpacing(-0.17.scale)
        let string = String(format: "Reader.TextSize".localized, percent)
        label.attributedText = string.attributed(with: attrs)
    }
}

// MARK: Make constraints
private extension TextSizeView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            container.leadingAnchor.constraint(equalTo: leadingAnchor),
            container.trailingAnchor.constraint(equalTo: trailingAnchor),
            container.heightAnchor.constraint(equalToConstant: 135.scale),
            container.topAnchor.constraint(equalTo: topAnchor)
        ])
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            label.topAnchor.constraint(equalTo: container.topAnchor, constant: 20.scale)
        ])
        
        NSLayoutConstraint.activate([
            minusButton.widthAnchor.constraint(equalToConstant: 60.scale),
            minusButton.heightAnchor.constraint(equalToConstant: 60.scale),
            minusButton.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 114.scale),
            minusButton.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 16.scale)
        ])
        
        NSLayoutConstraint.activate([
            plusButton.widthAnchor.constraint(equalToConstant: 60.scale),
            plusButton.heightAnchor.constraint(equalToConstant: 60.scale),
            plusButton.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 189.scale),
            plusButton.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 16.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension TextSizeView {
    func makeContainer() -> UIView {
        let view = UIView()
        view.backgroundColor = Appearance.background
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.06
        view.layer.shadowOffset = CGSize(width: 0, height: 3.scale)
        view.layer.shadowRadius = 10.scale
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeLabel() -> UILabel {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
    
    func makeMinusButton() -> UIButton {
        let view = UIButton()
        view.setImage(UIImage(named: "Reader.TextSize.Minus"), for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
    
    func makePlusButton() -> UIButton {
        let view = UIButton()
        view.setImage(UIImage(named: "Reader.TextSize.Plus"), for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
}
