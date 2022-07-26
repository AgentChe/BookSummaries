//
//  PlayerView.swift
//  BookSummaries
//
//  Created by Андрей Чернышев on 26.07.2022.
//

import UIKit
import Kingfisher
import AVFoundation

final class PlayerView: UIView {
    lazy var closeButton = makeCloseButton()
    lazy var imageView = makeImageView()
    lazy var nameLabel = makeLabel()
    lazy var authorLabel = makeLabel()
    lazy var slider = makeSlider()
    lazy var currentTimeLabel = makeLabel()
    lazy var totalTimeLabel = makeLabel()
    lazy var playPauseButton = makePlayPauseButton()
    lazy var preloaderView = makePreloaderView()
    lazy var playerBackButton = makePlayerBackButton()
    lazy var playerForwardButton = makePlayerForwardButton()
    lazy var speedButton = makeSpeedButton()
    
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
extension PlayerView {
    func fill(book: BookCover) {
        imageView.kf.setImage(with: book.imageUrl)
        
        nameLabel.attributedText = book.name
            .attributed(with: TextAttributes()
                            .textColor(Appearance.black)
                            .font(Fonts.PlusJakartaSans.bold(size: 20.scale))
                            .lineHeight(24.scale)
                            .letterSpacing(-0.17.scale)
                            .textAlignment(.center))
        
        authorLabel.attributedText = book.author.name
            .attributed(with: TextAttributes()
                            .textColor(Appearance.black.withAlphaComponent(0.5))
                            .font(Fonts.PlusJakartaSans.regular(size: 16.scale))
                            .lineHeight(24.scale)
                            .letterSpacing(-0.17.scale)
                            .textAlignment(.center))
    }
    
    func setup(totalDuration: Float64) {
        slider.minimumValue = 0
        slider.maximumValue = Float(totalDuration)
        
        totalTimeLabel.attributedText = string(from: totalDuration)
            .attributed(with: TextAttributes()
                            .textColor(Appearance.black.withAlphaComponent(0.5))
                            .font(Fonts.PlusJakartaSans.semiBold(size: 12.scale))
                            .lineHeight(14.4.scale))
    }
    
    func setup(currentTime: Float64) {
        slider.value = Float(currentTime)
        
        currentTimeLabel.attributedText = string(from: currentTime)
            .attributed(with: TextAttributes()
                            .textColor(Appearance.black.withAlphaComponent(0.5))
                            .font(Fonts.PlusJakartaSans.semiBold(size: 12.scale))
                            .lineHeight(14.4.scale))
    }
    
    func setup(speed: Float) {
        let attrs = TextAttributes()
            .textColor(Appearance.black)
            .font(Fonts.PlusJakartaSans.semiBold(size: 16.scale))
            .letterSpacing(-0.17.scale)
        let string = String(format: "Player.Speed".localized, speed)
        speedButton.setAttributedTitle(string.attributed(with: attrs), for: .normal)
    }
}

// MARK: Private
private extension PlayerView {
    func initialize() {
        backgroundColor = Appearance.background
    }
    
    func string(from interval: TimeInterval) -> String {
        let interval = Int(interval)
        let seconds = interval % 60
        let minutes = (interval / 60) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

// MARK: Make constraints
private extension PlayerView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            closeButton.widthAnchor.constraint(equalToConstant: 24.scale),
            closeButton.heightAnchor.constraint(equalToConstant: 24.scale),
            closeButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 19.scale),
            closeButton.topAnchor.constraint(equalTo: topAnchor, constant: ScreenSize.isIphoneXFamily ? 60.scale : 30.scale)
        ])
        
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 221.scale),
            imageView.heightAnchor.constraint(equalToConstant: 267.scale),
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.topAnchor.constraint(equalTo: closeButton.bottomAnchor, constant: ScreenSize.isIphoneXFamily ? 35.scale : 20.scale)
        ])
        
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: ScreenSize.isIphoneXFamily ? 36.scale : 20.scale)
        ])
        
        NSLayoutConstraint.activate([
            authorLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            authorLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            authorLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 5.scale)
        ])
        
        NSLayoutConstraint.activate([
            slider.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 25.scale),
            slider.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -25.scale),
            slider.heightAnchor.constraint(equalToConstant: 16.scale),
            slider.topAnchor.constraint(equalTo: authorLabel.bottomAnchor, constant: ScreenSize.isIphoneXFamily ? 30.scale : 20.scale)
        ])
        
        NSLayoutConstraint.activate([
            currentTimeLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 25.scale),
            currentTimeLabel.topAnchor.constraint(equalTo: slider.bottomAnchor, constant: 10.scale)
        ])
        
        NSLayoutConstraint.activate([
            totalTimeLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -25.scale),
            totalTimeLabel.topAnchor.constraint(equalTo: slider.bottomAnchor, constant: 10.scale)
        ])
        
        NSLayoutConstraint.activate([
            playPauseButton.widthAnchor.constraint(equalToConstant: 70.scale),
            playPauseButton.heightAnchor.constraint(equalToConstant: 70.scale),
            playPauseButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            playPauseButton.topAnchor.constraint(equalTo: slider.bottomAnchor, constant: ScreenSize.isIphoneXFamily ? 44.scale : 40.scale)
        ])
        
        NSLayoutConstraint.activate([
            preloaderView.widthAnchor.constraint(equalToConstant: 70.scale),
            preloaderView.heightAnchor.constraint(equalToConstant: 70.scale),
            preloaderView.centerXAnchor.constraint(equalTo: playPauseButton.centerXAnchor),
            preloaderView.centerYAnchor.constraint(equalTo: playPauseButton.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            playerBackButton.widthAnchor.constraint(equalToConstant: 40.scale),
            playerBackButton.heightAnchor.constraint(equalToConstant: 40.scale),
            playerBackButton.trailingAnchor.constraint(equalTo: playPauseButton.leadingAnchor, constant: -40.scale),
            playerBackButton.centerYAnchor.constraint(equalTo: playPauseButton.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            playerForwardButton.widthAnchor.constraint(equalToConstant: 40.scale),
            playerForwardButton.heightAnchor.constraint(equalToConstant: 40.scale),
            playerForwardButton.leadingAnchor.constraint(equalTo: playPauseButton.trailingAnchor, constant: 40.scale),
            playerForwardButton.centerYAnchor.constraint(equalTo: playPauseButton.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            speedButton.widthAnchor.constraint(equalToConstant: 101.scale),
            speedButton.heightAnchor.constraint(equalToConstant: 41.scale),
            speedButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            speedButton.topAnchor.constraint(equalTo: playPauseButton.bottomAnchor, constant: ScreenSize.isIphoneXFamily ? 72.scale : 32.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension PlayerView {
    func makeCloseButton() -> TapAreaButton {
        let view = TapAreaButton()
        view.setImage(UIImage(named: "Player.Close"), for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeImageView() -> BookImageView {
        let view = BookImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeLabel() -> UILabel {
        let view = UILabel()
        view.numberOfLines = 2
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeSlider() -> UISlider {
        let view = UISlider()
        view.thumbTintColor = Appearance.primaryGreen
        view.minimumTrackTintColor = Appearance.primaryGreen
        view.maximumTrackTintColor = Appearance.secondary5
        view.isContinuous = true
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makePlayPauseButton() -> PlayPauseButton {
        let view = PlayPauseButton()
        view.stateCode = .pause
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makePreloaderView() -> PlayerPreloaderView {
        let view = PlayerPreloaderView()
        view.backgroundColor = Appearance.primaryGreen
        view.stop()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makePlayerBackButton() -> TapAreaButton {
        let view = TapAreaButton()
        view.setImage(UIImage(named: "Player.Back"), for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makePlayerForwardButton() -> TapAreaButton {
        let view = TapAreaButton()
        view.setImage(UIImage(named: "Player.Forward"), for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeSpeedButton() -> UIButton {
        let view = UIButton()
        view.layer.cornerRadius = 16.scale
        view.backgroundColor = Appearance.secondary5
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
