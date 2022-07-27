//
//  TabPlayerView.swift
//  BookSummaries
//
//  Created by Андрей Чернышев on 27.07.2022.
//

import UIKit
import RxSwift

protocol TabPlayerViewDelegate: AnyObject {
    func tabPlayerDidCloseTapped()
}

final class TabPlayerView: UIButton {
    weak var delegate: TabPlayerViewDelegate?
    
    lazy var iconView = makeImageView()
    lazy var nameLabel = makeLabel()
    lazy var authorLabel = makeLabel()
    lazy var playPauseButton = makePlayPauseView()
    lazy var separator = makeSeparator()
    
    private var audioPlayer: AudioPlayer?
    
    private lazy var disposeBag = DisposeBag()
    
    private var book: BookCover?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension TabPlayerView {
    func fill(book: BookCover) {
        self.book = book
        
        iconView.kf.cancelDownloadTask()
        iconView.image = nil
        iconView.kf.setImage(with: book.imageUrl)
        
        nameLabel.attributedText = book.name
            .attributed(with: TextAttributes()
                            .textColor(Appearance.black)
                            .font(Fonts.PlusJakartaSans.bold(size: 14.scale))
                            .lineHeight(16.8.scale)
                            .letterSpacing(-0.17.scale))
        
        authorLabel.attributedText = book.author.name
            .attributed(with: TextAttributes()
                            .textColor(Appearance.black.withAlphaComponent(0.5))
                            .font(Fonts.PlusJakartaSans.regular(size: 14.scale))
                            .lineHeight(19.6.scale)
                            .letterSpacing(-0.17.scale))
    }
    
    func becomeControlOnPlayer() {
        audioPlayer = AudioPlayerManager.shared.player
        audioPlayer?.delegate = self
    }
    
    func resignControlOnPlayer() {
        audioPlayer = nil
        book = nil
        
        playPauseButton.stateCode = .pause
    }
}

// MARK: AudioPlayerDelegate
extension TabPlayerView: AudioPlayerDelegate {
    func audioPlayer(totalDuration: Float64) {}
    func audioPlayerDidStartPlay() {}
    
    func audioPlayer(currentTime: Float64) {
        if currentTime > 0 && audioPlayer?.isPlaying() == true {
            playPauseButton.stateCode = .play
        }
    }
    
    func audioPlayerFinished() {
        playPauseButton.stateCode = .pause
    }
}

// MARK: Private
private extension TabPlayerView {
    func initialize() {
        playPauseButton.rx.tap
            .bind(to: Binder(self) { base, void in
                switch base.playPauseButton.stateCode {
                case .play:
                    base.audioPlayer?.pause()
                case .pause:
                    base.audioPlayer?.play()
                }
                
                base.playPauseButton.invertedState()
            })
            .disposed(by: disposeBag)
        
        rx.tap
            .bind(to: Binder(self) { base, void in
                guard let book = base.book, let audioUrl = base.audioPlayer?.audioUrl else {
                    return
                }
            
                let vc = PlayerViewController.make(book: book, audioUrl: audioUrl)
                UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.rootViewController?.present(vc, animated: true)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: Make constraints
private extension TabPlayerView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            iconView.widthAnchor.constraint(equalToConstant: 37.scale),
            iconView.heightAnchor.constraint(equalToConstant: 44.scale),
            iconView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            iconView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 63.scale),
            nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -75.scale),
            nameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 14.5.scale)
        ])
        
        NSLayoutConstraint.activate([
            authorLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 63.scale),
            authorLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -75.scale),
            authorLabel.topAnchor.constraint(equalTo: topAnchor, constant: 34.5.scale)
        ])
        
        NSLayoutConstraint.activate([
            playPauseButton.widthAnchor.constraint(equalToConstant: 40.scale),
            playPauseButton.heightAnchor.constraint(equalToConstant: 40.scale),
            playPauseButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            playPauseButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -14.scale)
        ])
        
        NSLayoutConstraint.activate([
            separator.leadingAnchor.constraint(equalTo: leadingAnchor),
            separator.trailingAnchor.constraint(equalTo: trailingAnchor),
            separator.bottomAnchor.constraint(equalTo: bottomAnchor),
            separator.heightAnchor.constraint(equalToConstant: 1.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension TabPlayerView {
    func makeImageView() -> BookImageView {
        let view = BookImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeLabel() -> UILabel {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makePlayPauseView() -> TabPlayerPlayPauseView {
        let view = TabPlayerPlayPauseView()
        view.stateCode = .pause
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeSeparator() -> UIView {
        let view = UIView()
        view.backgroundColor = Appearance.secondary5
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
