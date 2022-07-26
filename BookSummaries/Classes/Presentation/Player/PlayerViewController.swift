//
//  PlayerViewController.swift
//  BookSummaries
//
//  Created by Андрей Чернышев on 26.07.2022.
//

import UIKit
import RxSwift

final class PlayerViewController: UIViewController {
    lazy var mainView = PlayerView()
    
    private lazy var disposeBag = DisposeBag()
    
    private let book: BookCover
    private let audioPlayer: AudioPlayer
    
    private init(book: BookCover, audioUrl: URL) {
        self.book = book
        self.audioPlayer = AudioPlayerManager.shared.makePlayerIfNeeded(audioUrl: audioUrl)
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView.closeButton.rx.tap
            .bind(to: Binder(self) { base, void in
                base.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
        
        mainView.slider.rx.controlEvent(.valueChanged)
            .bind(to: Binder(self) { base, event in
                let value = base.mainView.slider.value
                base.audioPlayer.seek(to: value)
            })
            .disposed(by: disposeBag)
        
        mainView.playPauseButton.rx.tap
            .bind(to: Binder(self) { base, void in
                switch base.mainView.playPauseButton.stateCode {
                case .play:
                    base.audioPlayer.pause()
                case .pause:
                    base.showPreloaderIfNeeded()
                    base.audioPlayer.play()
                }
                
                self.mainView.playPauseButton.invertedState()
            })
            .disposed(by: disposeBag)
        
        mainView.playerBackButton.rx.tap
            .bind(to: Binder(self) { base, void in
                base.audioPlayer.back()
            })
            .disposed(by: disposeBag)
        
        mainView.playerForwardButton.rx.tap
            .bind(to: Binder(self) { base, void in
                base.audioPlayer.forward()
            })
            .disposed(by: disposeBag)
        
        audioPlayer.delegate = self
        mainView.fill(book: book)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        PlayerViewControllerMediator.shared.notifyAboutAppear(with: book)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        PlayerViewControllerMediator.shared.notifyAboutDisappear()
    }
}

// MARK: Make
extension PlayerViewController {
    static func make(book: BookCover, audioUrl: URL) -> PlayerViewController {
        let vc = PlayerViewController(book: book, audioUrl: audioUrl)
        vc.modalPresentationStyle = .fullScreen
        return vc
    }
}

// MARK: AudioPlayerDelegate
extension PlayerViewController: AudioPlayerDelegate {
    func audioPlayer(totalDuration: Float64) {
        mainView.setup(totalDuration: totalDuration)
    }
    
    func audioPlayer(currentTime: Float64) {
        mainView.setup(currentTime: currentTime)
        
        if currentTime > 0 && audioPlayer.isPlaying() == true {
            mainView.playPauseButton.stateCode = .play
        }
    }
    
    func audioPlayerFinished() {
        mainView.playPauseButton.stateCode = .pause
    }
    
    func audioPlayerDidStartPlay() {
        audio(isDownloading: false)
    }
}

// MARK: Private
private extension PlayerViewController {
    func showPreloaderIfNeeded() {
        let isDownloading = !audioPlayer.isPlaying() && (audioPlayer.currentSeconds() == 0)
        
        audio(isDownloading: isDownloading)
    }
    
    func audio(isDownloading: Bool) {
        mainView.playPauseButton.isHidden = isDownloading
        isDownloading ? mainView.preloaderView.start() : mainView.preloaderView.stop()
    }
}
