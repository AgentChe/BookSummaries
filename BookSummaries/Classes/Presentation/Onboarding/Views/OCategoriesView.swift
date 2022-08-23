//
//  OCategoriesView.swift
//  BookSummaries
//
//  Created by Андрей Чернышев on 23.08.2022.
//

import UIKit

protocol OCategoriesViewDelegate: AnyObject {
    func categoriesViewDidSelected(elements: [OCategoriesCollectionElement])
}

final class OCategoriesView: OSlideView {
    weak var categoriesDelegate: OCategoriesViewDelegate?
    
    lazy var titleLabel = makeTitleLabel()
    lazy var collectionView = makeCollectionView()
    lazy var backButton = makeBackButton()
    lazy var nextButton = makeNextButton()
    
    private lazy var elements = [
        OCategoriesCollectionElement(title: "Onboarding.Categories.Health".localized),
        OCategoriesCollectionElement(title: "Onboarding.Categories.Learning & Developing".localized),
        OCategoriesCollectionElement(title: "Onboarding.Categories.Welness & Spiritual Growth".localized),
        OCategoriesCollectionElement(title: "Onboarding.Categories.Leadership & Management".localized),
        OCategoriesCollectionElement(title: "Onboarding.Categories.Money & Wealth".localized),
        OCategoriesCollectionElement(title: "Onboarding.Categories.Psychology".localized),
        OCategoriesCollectionElement(title: "Onboarding.Categories.Sales & Marketing".localized),
        OCategoriesCollectionElement(title: "Onboarding.Categories.Finance".localized),
        OCategoriesCollectionElement(title: "Onboarding.Categories.Business & Entrepreneurship".localized),
        OCategoriesCollectionElement(title: "Onboarding.Categories.Business Strategy & Culture".localized),
        OCategoriesCollectionElement(title: "Onboarding.Categories.Economics".localized),
        OCategoriesCollectionElement(title: "Onboarding.Categories.Sociology & General".localized),
        OCategoriesCollectionElement(title: "Onboarding.Categories.Technology & Innovation".localized),
        OCategoriesCollectionElement(title: "Onboarding.Categories.Personal Development & Success".localized),
        OCategoriesCollectionElement(title: "Onboarding.Categories.Problem - Solving & Creativity".localized),
        OCategoriesCollectionElement(title: "Onboarding.Categories.Parenting & Relationships".localized)
    ]
    
    override init(step: OnboardingView.Step) {
        super.init(step: step)
        
        makeConstraints()
        initialize()
        checkEnabled()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension OCategoriesView {
    func initialize() {
        backgroundColor = Appearance.background
        
        collectionView.changeSelection = { [weak self] in
            self?.checkEnabled()
        }
        collectionView.setup(elements: elements)
    }
    
    @objc
    func nextTapped() {
        let selected = elements.filter { $0.selected }
        categoriesDelegate?.categoriesViewDidSelected(elements: selected)
        
        onNext()
    }
    
    func checkEnabled() {
        let marked = elements.contains(where: { $0.selected })
        nextButton.isEnabled = marked
        nextButton.alpha = marked ? 1 : 0.4
    }
}

// MARK: Make constraints
private extension OCategoriesView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: ScreenSize.isIphoneXFamily ? 131.scale : 60.scale)
        ])
        
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 2.scale),
            collectionView.bottomAnchor.constraint(equalTo: backButton.topAnchor, constant: -2.scale)
        ])
        
        NSLayoutConstraint.activate([
            backButton.widthAnchor.constraint(equalToConstant: 54.scale),
            backButton.heightAnchor.constraint(equalToConstant: 54.scale),
            backButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24.scale),
            backButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: ScreenSize.isIphoneXFamily ? -60.scale : -20.scale)
        ])
        
        NSLayoutConstraint.activate([
            nextButton.widthAnchor.constraint(equalToConstant: 54.scale),
            nextButton.heightAnchor.constraint(equalToConstant: 54.scale),
            nextButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24.scale),
            nextButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: ScreenSize.isIphoneXFamily ? -60.scale : -20.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension OCategoriesView {
    func makeTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.black)
            .font(Fonts.PlusJakartaSans.bold(size: 28.scale))
            .lineHeight(36.4.scale)
            .letterSpacing(-0.37.scale)
            .textAlignment(.center)
        
        let view = UILabel()
        view.numberOfLines = 0
        view.attributedText = "Onboarding.Categories.Title".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeCollectionView() -> OCategoriesCollectionView {
        let layout = OCategoriesCollectionLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 16.scale
        layout.minimumInteritemSpacing = 12.scale
        layout.sectionInset = UIEdgeInsets(top: 24.scale, left: 24.scale, bottom: 24.scale, right: 24.scale)
        
        let view = OCategoriesCollectionView(frame: .zero, collectionViewLayout: layout)
        view.backgroundColor = UIColor.clear
        view.showsVerticalScrollIndicator = false
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeBackButton() -> TapAreaButton {
        let view = TapAreaButton()
        view.setImage(UIImage(named: "Onboarding.Back"), for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addTarget(self, action: #selector(onBack), for: .touchUpInside)
        addSubview(view)
        return view
    }
    
    func makeNextButton() -> TapAreaButton {
        let view = TapAreaButton()
        view.setImage(UIImage(named: "Onboarding.Next"), for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addTarget(self, action: #selector(nextTapped), for: .touchUpInside)
        addSubview(view)
        return view
    }
}
