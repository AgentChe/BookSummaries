//
//  PlayerPreloaderView.swift
//  BookSummaries
//
//  Created by Андрей Чернышев on 26.07.2022.
//

import UIKit

final class PlayerPreloaderView: CircleView {
    lazy var preloader = makePreloader()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension PlayerPreloaderView {
    func start() {
        isHidden = false
        preloader.startAnimating()
    }
    
    func stop() {
        isHidden = true
        preloader.stopAnimating()
    }
}

// MARK: Make constraints
private extension PlayerPreloaderView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            preloader.centerXAnchor.constraint(equalTo: centerXAnchor),
            preloader.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension PlayerPreloaderView {
    func makePreloader() -> Spinner {
        let view = Spinner(size: CGSize(width: 24.scale, height: 24.scale), color: .white)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
