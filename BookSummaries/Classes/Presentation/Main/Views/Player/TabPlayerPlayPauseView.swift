//
//  TabPlayerPlayPauseView.swift
//  BookSummaries
//
//  Created by Андрей Чернышев on 27.07.2022.
//

import UIKit

final class TabPlayerPlayPauseView: UIButton {
    enum State {
        case play, pause
    }
    
    var stateCode = State.pause {
        didSet {
            update()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        update()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func invertedState() {
        switch stateCode {
        case .play:
            stateCode = .pause
        case .pause:
            stateCode = .play
        }
    }
}

// MARK: Private
private extension TabPlayerPlayPauseView {
    func update() {
        switch stateCode {
        case .play:
            setImage(UIImage(named: "Main.Player.Pause"), for: .normal)
        case .pause:
            setImage(UIImage(named: "Main.Player.Play"), for: .normal)
        }
    }
}
