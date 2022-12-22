//
//  AudioPlayer.swift
//  BookSummaries
//
//  Created by Андрей Чернышев on 26.07.2022.
//

import UIKit
import AVFoundation

protocol AudioPlayerDelegate: AnyObject {
    func audioPlayer(totalDuration: Float64)
    func audioPlayer(currentTime: Float64)
    func audioPlayerFinished()
    func audioPlayerDidStartPlay()
}

final class AudioPlayer: NSObject {
    weak var delegate: AudioPlayerDelegate? {
        didSet {
            let duration = item.asset.duration
            let totalSeconds = CMTimeGetSeconds(duration)
            
            let currentSeconds = CMTimeGetSeconds(player.currentTime())
            
            delegate?.audioPlayer(totalDuration: totalSeconds)
            delegate?.audioPlayer(currentTime: currentSeconds)
        }
    }
    
    var speed: Float = 1 {
        didSet {
            player.rate = speed
        }
    }
    
    let audioUrl: URL
    
    private lazy var item = AVPlayerItem(url: audioUrl)
    private lazy var player = AVPlayer(playerItem: item)
    
    private var playerTimeObserver: Any?
    
    deinit {
        clear()
    }
    
    init(audioUrl: URL) {
        self.audioUrl = audioUrl
        
        super.init()
        
        try? AVAudioSession.sharedInstance().setCategory(.playback)
        
        NotificationCenter.default
            .addObserver(self,
                         selector: #selector(didFinished),
                         name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
                         object: item)
        
        playerTimeObserver = player.addPeriodicTimeObserver(forInterval: CMTimeMakeWithSeconds(1, preferredTimescale: 1), queue: DispatchQueue.main) { [weak self] time in
            guard let self = self else {
                return
            }
            
            guard self.item.status == .readyToPlay else {
                return
            }
            
            let currentSeconds = CMTimeGetSeconds(self.player.currentTime())
            
            self.delegate?.audioPlayer(currentTime: currentSeconds)
        }
        
        player.addBoundaryTimeObserver(forTimes: [NSValue(time: CMTime(seconds: 1, preferredTimescale: 1000))], queue: DispatchQueue.main) { [weak self] in
            
            self?.delegate?.audioPlayerDidStartPlay()
        }
    }
}

// MARK: Public
extension AudioPlayer {
    func currentSeconds() -> Float64 {
        CMTimeGetSeconds(player.currentTime())
    }
    
    func isPlaying() -> Bool {
        player.timeControlStatus == .playing
    }
    
    func play() {
        player.play()
        player.rate = speed
    }
    
    func pause() {
        player.pause()
    }
    
    func back() {
        player.pause()
        
        let currentSeconds = CMTimeGetSeconds(player.currentTime())
        
        var newTime = currentSeconds - 15
        
        if newTime < 0 {
            newTime = 0
        }
        
        let selectedTime = CMTimeMake(value: Int64(newTime * 1000 as Float64), timescale: 1000)
        
        player.seek(to: selectedTime) { [weak self] success in
            self?.play()
        }
    }
    
    func forward() {
        player.pause()
        
        let duration = item.asset.duration
        let totalSeconds = CMTimeGetSeconds(duration)
        
        let currentSeconds = CMTimeGetSeconds(player.currentTime())
        
        var newTime = currentSeconds + 15
        
        if newTime > totalSeconds {
            newTime = totalSeconds
        }
        
        let selectedTime = CMTimeMake(value: Int64(newTime * 1000 as Float64), timescale: 1000)
        
        player.seek(to: selectedTime) { [weak self] success in
            self?.play()
        }
    }
    
    func seek(to value: Float) {
        let seconds = TimeInterval(value)
        let targetTime = CMTime(seconds: seconds, preferredTimescale: 1)
        
        player.seek(to: targetTime) { [weak self] success in
            self?.play()
        }
    }
    
    func clear() {
        player.pause()
        
        if let observer = playerTimeObserver {
            player.removeTimeObserver(observer)
            playerTimeObserver = nil
        }
        
        NotificationCenter.default.removeObserver(self)
    }
}

// MARK: Private
private extension AudioPlayer {
    @objc
    func didFinished() {
        player.pause()
        
        delegate?.audioPlayerFinished()
    }
}
