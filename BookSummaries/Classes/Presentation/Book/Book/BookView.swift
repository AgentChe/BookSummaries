//
//  BookView.swift
//  BookSummaries
//
//  Created by Андрей Чернышев on 11.07.2022.
//

import UIKit

final class BookView: UIView {
    lazy var closeButton = makeCloseButton()
    lazy var downloadButton = makeDownloadButton()
    lazy var shareButton = makeShareButton()
    lazy var favoriteButton = makeFavoriteButton()
    lazy var tableView = makeTableView()
    lazy var bottomView = makeBottomView()
    lazy var listenButton = makeListenButton()
    lazy var readButton = makeReadButton()
    lazy var preloader = makePreloader()
    
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
private extension BookView {
    func initialize() {
        backgroundColor = Appearance.background
    }
}

// MARK: Make constraints
private extension BookView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            closeButton.widthAnchor.constraint(equalToConstant: 24.scale),
            closeButton.heightAnchor.constraint(equalToConstant: 24.scale),
            closeButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            closeButton.topAnchor.constraint(equalTo: topAnchor, constant: ScreenSize.isIphoneXFamily ? 60.scale : 30.scale)
        ])
        
        NSLayoutConstraint.activate([
            downloadButton.widthAnchor.constraint(equalToConstant: 41.scale),
            downloadButton.heightAnchor.constraint(equalToConstant: 41.scale),
            downloadButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 212.scale),
            downloadButton.centerYAnchor.constraint(equalTo: closeButton.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            shareButton.widthAnchor.constraint(equalToConstant: 41.scale),
            shareButton.heightAnchor.constraint(equalToConstant: 41.scale),
            shareButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 265.scale),
            shareButton.centerYAnchor.constraint(equalTo: closeButton.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            favoriteButton.widthAnchor.constraint(equalToConstant: 41.scale),
            favoriteButton.heightAnchor.constraint(equalToConstant: 41.scale),
            favoriteButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 318.scale),
            favoriteButton.centerYAnchor.constraint(equalTo: closeButton.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.topAnchor.constraint(equalTo: downloadButton.bottomAnchor, constant: 2.scale),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            bottomView.leadingAnchor.constraint(equalTo: leadingAnchor),
            bottomView.trailingAnchor.constraint(equalTo: trailingAnchor),
            bottomView.bottomAnchor.constraint(equalTo: bottomAnchor),
            bottomView.heightAnchor.constraint(equalToConstant: ScreenSize.isIphoneXFamily ? 139.scale : 109.scale)
        ])
        
        NSLayoutConstraint.activate([
            listenButton.widthAnchor.constraint(equalToConstant: 166.scale),
            listenButton.heightAnchor.constraint(equalToConstant: 49.scale),
            listenButton.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor, constant: 16.scale),
            listenButton.topAnchor.constraint(equalTo: bottomView.topAnchor, constant: 30.scale)
        ])
        
        NSLayoutConstraint.activate([
            readButton.widthAnchor.constraint(equalToConstant: 166.scale),
            readButton.heightAnchor.constraint(equalToConstant: 49.scale),
            readButton.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor, constant: 193.scale),
            readButton.topAnchor.constraint(equalTo: bottomView.topAnchor, constant: 30.scale)
        ])
        
        NSLayoutConstraint.activate([
            preloader.centerXAnchor.constraint(equalTo: tableView.centerXAnchor),
            preloader.centerYAnchor.constraint(equalTo: tableView.centerYAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension BookView {
    func makeCloseButton() -> TapAreaButton {
        let view = TapAreaButton()
        view.setImage(UIImage(named: "Book.Close"), for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeDownloadButton() -> BookNavButton {
        let view = BookNavButton()
        view.backgroundColor = Appearance.secondary5
        view.iconView.image = UIImage(named: "Book.Download")
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeShareButton() -> BookNavButton {
        let view = BookNavButton()
        view.backgroundColor = Appearance.secondary5
        view.iconView.image = UIImage(named: "Book.Share")
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeFavoriteButton() -> BookNavButton {
        let view = BookNavButton()
        view.backgroundColor = Appearance.secondary5
        view.iconView.image = UIImage(named: "Book.Mark.Uncheck")
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeTableView() -> BookTableView {
        let view = BookTableView()
        view.contentInset = UIEdgeInsets(top: 27.scale, left: 0, bottom: ScreenSize.isIphoneXFamily ? 200.scale : 170.scale, right: 0)
        view.separatorStyle = .none
        view.showsVerticalScrollIndicator = false
        view.contentInsetAdjustmentBehavior = .never
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeBottomView() -> UIView {
        let view = UIView()
        view.backgroundColor = UIColor(integralRed: 249, green: 248, blue: 240)
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.06
        view.layer.shadowOffset = .zero
        view.layer.shadowRadius = 10.scale
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeListenButton() -> BookActionButton {
        let view = BookActionButton()
        view.backgroundColor = Appearance.primaryGreen
        view.layer.cornerRadius = 16.scale
        view.iconView.image = UIImage(named: "Book.Listen")
        view.text = "Book.Listen".localized
        view.translatesAutoresizingMaskIntoConstraints = false
        bottomView.addSubview(view)
        return view
    }
    
    func makeReadButton() -> BookActionButton {
        let view = BookActionButton()
        view.backgroundColor = Appearance.primaryGreen
        view.layer.cornerRadius = 16.scale
        view.iconView.image = UIImage(named: "Book.Read")
        view.text = "Book.Read".localized
        view.translatesAutoresizingMaskIntoConstraints = false
        bottomView.addSubview(view)
        return view
    }
    
    func makePreloader() -> Spinner {
        let view = Spinner(size: CGSize(width: 45.scale, height: 45.scale))
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
