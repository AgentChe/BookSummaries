//
//  AudioPlayerManager.swift
//  BookSummaries
//
//  Created by Андрей Чернышев on 26.07.2022.
//

import Foundation

final class AudioPlayerManager {
    static let shared = AudioPlayerManager()
    
    private(set) var player: AudioPlayer?
    
    private init() {}
}

// MARK: Public
extension AudioPlayerManager {
    func makePlayerIfNeeded(audioUrl: URL) -> AudioPlayer {
        guard player?.audioUrl == audioUrl else {
            player = AudioPlayer(audioUrl: audioUrl)
            return player!
        }
        
        if let player = player {
            return player
        }
        
        player = AudioPlayer(audioUrl: audioUrl)
        
        return player!
    }
    
    func clear() {
        player?.clear()
        player = nil
    }
}
