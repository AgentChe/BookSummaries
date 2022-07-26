//
//  PlayPauseButton.swift
//  BookSummaries
//
//  Created by Андрей Чернышев on 26.07.2022.
//

import UIKit

final class PlayPauseButton: UIButton {
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
private extension PlayPauseButton {
    func update() {
        switch stateCode {
        case .play:
            setImage(UIImage(named: "Player.Pause"), for: .normal)
        case .pause:
            setImage(UIImage(named: "Player.Play"), for: .normal)
        }
    }
}
