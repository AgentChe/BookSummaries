//
//  MainView.swift
//  BookSummaries
//
//  Created by Андрей Чернышев on 07.07.2022.
//

import UIKit

final class MainView: UIView {
    lazy var container = makeContainer()
    lazy var tabView = makeTabView()
    lazy var playerView = makePlayerView()
    
    private lazy var playerLeadingConstraint = NSLayoutConstraint()
    private lazy var playerTrailingConstraint = NSLayoutConstraint()
    private lazy var playerBottomConstraint = NSLayoutConstraint()
    private lazy var playerHeightConstraint = NSLayoutConstraint()
    private lazy var containerBottomConstraint = NSLayoutConstraint()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension MainView {
    func showPlayer(show: Bool) {
        playerView.isHidden = !show
        
        NSLayoutConstraint.deactivate([
            playerLeadingConstraint,
            playerTrailingConstraint,
            playerBottomConstraint,
            playerHeightConstraint,
            containerBottomConstraint
        ])
        
        if show {
            playerLeadingConstraint = playerView.leadingAnchor.constraint(equalTo: leadingAnchor)
            playerTrailingConstraint = playerView.trailingAnchor.constraint(equalTo: trailingAnchor)
            playerBottomConstraint = playerView.bottomAnchor.constraint(equalTo: tabView.topAnchor)
            playerHeightConstraint = playerView.heightAnchor.constraint(equalToConstant: 64.scale)
            containerBottomConstraint = container.bottomAnchor.constraint(equalTo: playerView.topAnchor)
            
            NSLayoutConstraint.activate([
                playerLeadingConstraint,
                playerTrailingConstraint,
                playerBottomConstraint,
                playerHeightConstraint,
                containerBottomConstraint
            ])
        } else {
            containerBottomConstraint = container.bottomAnchor.constraint(equalTo: tabView.topAnchor)
            containerBottomConstraint.isActive = true
        }
        
        layoutIfNeeded()
    }
}


// MARK: Make constraints
private extension MainView {
    func makeConstraints() {
        containerBottomConstraint = container.bottomAnchor.constraint(equalTo: tabView.topAnchor)
        NSLayoutConstraint.activate([
            container.leadingAnchor.constraint(equalTo: leadingAnchor),
            container.trailingAnchor.constraint(equalTo: trailingAnchor),
            container.topAnchor.constraint(equalTo: topAnchor),
            containerBottomConstraint
        ])
        
        playerLeadingConstraint = playerView.leadingAnchor.constraint(equalTo: leadingAnchor)
        playerTrailingConstraint = playerView.trailingAnchor.constraint(equalTo: trailingAnchor)
        playerBottomConstraint = playerView.bottomAnchor.constraint(equalTo: tabView.topAnchor)
        playerHeightConstraint = playerView.heightAnchor.constraint(equalToConstant: 64.scale)
        
        NSLayoutConstraint.activate([
            tabView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tabView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tabView.bottomAnchor.constraint(equalTo: bottomAnchor),
            tabView.heightAnchor.constraint(equalToConstant: ScreenSize.isIphoneXFamily ? 83.scale : 60.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension MainView {
    func makeContainer() -> UIView {
        let view = UIView()
        view.backgroundColor = Appearance.background
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeTabView() -> TabView {
        let view = TabView()
        view.backgroundColor = Appearance.background
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makePlayerView() -> TabPlayerView {
        let view = TabPlayerView()
        view.backgroundColor = Appearance.background
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
