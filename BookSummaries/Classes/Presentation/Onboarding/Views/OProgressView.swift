//
//  OProgressView.swift
//  BookSummaries
//
//  Created by Андрей Чернышев on 26.08.2022.
//

import UIKit

final class OProgressView: OSlideView {
    lazy var titleLabel = makeLabel()
    lazy var progressView = makeProgressView()
    lazy var bottomView = makeBottomView()
    
    private lazy var titleAttrs = makeTitleAttrs()
    
    private var timer: Timer?
    
    override init(step: OnboardingView.Step) {
        super.init(step: step)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func moveToThis() {
        super.moveToThis()
        
        calculatePercent()
    }
}

// MARK: Private
private extension OProgressView {
    func initialize() {
        backgroundColor = Appearance.primaryGreen
    }
    
    func calculatePercent() {
        let duration = Double(7.5)
        var seconds = Double(0)
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] timer in
            guard let self = self else {
                return
            }
            
            seconds += 0.1
            
            var percent = Int(seconds / duration * 100)
            if percent > 100 {
                percent = 100
            }
            
            self.progressView.setup(percent: percent)
            self.updateTitle(percent: percent)
            self.bottomView.setup(percent: percent)
            
            if seconds >= duration {
                timer.invalidate()
                
                self.finish()
            }
        }
    }
    
    func updateTitle(percent: Int) {
        let string: String
        if percent <= 33 {
            string = "Onboarding.Progress.Title1".localized
        } else if percent <= 66 {
            string = "Onboarding.Progress.Title2".localized
        } else {
            string = "Onboarding.Progress.Title3".localized
        }
        titleLabel.attributedText = string.attributed(with: titleAttrs)
    }
    
    func finish() {
        timer = nil
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) { [weak self] in
            self?.onNext()
        }
    }
}

// MARK: Make constraints
private extension OProgressView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: ScreenSize.isIphoneXFamily ? 168.scale : 80.scale)
        ])
        
        NSLayoutConstraint.activate([
            progressView.centerXAnchor.constraint(equalTo: centerXAnchor),
            progressView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 78.scale)
        ])
        
        NSLayoutConstraint.activate([
            bottomView.leadingAnchor.constraint(equalTo: leadingAnchor),
            bottomView.trailingAnchor.constraint(equalTo: trailingAnchor),
            bottomView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -44.scale),
            bottomView.heightAnchor.constraint(equalToConstant: 77.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension OProgressView {
    func makeLabel() -> UILabel {
        let view = UILabel()
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeProgressView() -> OCircleProgressView {
        let view = OCircleProgressView()
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeBottomView() -> OBottomProgressView {
        let view = OBottomProgressView()
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeTitleAttrs() -> TextAttributes {
        TextAttributes()
            .textColor(Appearance.secondary5)
            .font(Fonts.PlusJakartaSans.bold(size: 28.scale))
            .lineHeight(36.4.scale)
            .letterSpacing(-0.37.scale)
            .textAlignment(.center)
    }
}
