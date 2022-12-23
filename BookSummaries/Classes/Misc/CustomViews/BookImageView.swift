//
//  BookImageView.swift
//  BookSummaries
//
//  Created by Андрей Чернышев on 07.07.2022.
//

import UIKit

class BookImageView: UIImageView {
    enum Size {
        case small1
        case small2
        case small3
        case medium
        case large
    }
    
    lazy var line1View = makeLine1View()
    lazy var line2View = makeLine2View()
    lazy var line3View = makeLine3View()
    lazy var line4View = makeLine4View()
    
    private let size: Size
    
    init(size: Size) {
        self.size = size
        
        super.init(frame: .zero)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension BookImageView {
    func initialize() {
        clipsToBounds = true
        contentMode = .scaleAspectFill
        layer.cornerRadius = 10.scale
    }
    
    func line1Width() -> CGFloat {
        switch size {
        case .small1:
            return 1.scale
        case .small2:
            return 1.scale
        case .small3:
            return 3.scale
        case .medium:
            return 3.scale
        case .large:
            return 5.06.scale
        }
    }
    
    func line2Width() -> CGFloat {
        switch size {
        case .small1:
            return 1.scale
        case .small2:
            return 1.scale
        case .small3:
            return 2.scale
        case .medium:
            return 2.scale
        case .large:
            return 2.scale
        }
    }
    
    func line3Width() -> CGFloat {
        switch size {
        case .small1:
            return 1.scale
        case .small2:
            return 2.scale
        case .small3:
            return 5.scale
        case .medium:
            return 5.scale
        case .large:
            return 5.scale
        }
    }
    
    func line4Width() -> CGFloat {
        switch size {
        case .small1:
            return 0.56.scale
        case .small2:
            return 0.99.scale
        case .small3:
            return 2.scale
        case .medium:
            return 2.49.scale
        case .large:
            return 3.37.scale
        }
    }
    
    func line2Leading() -> CGFloat {
        switch size {
        case .small1:
            return 1.scale
        case .small2:
            return 3.scale
        case .small3:
            return 5.scale
        case .medium:
            return 5.scale
        case .large:
            return 10.scale
        }
    }
    
    func line3Leading() -> CGFloat {
        switch size {
        case .small1:
            return 2.scale
        case .small2:
            return 4.scale
        case .small3:
            return 7.scale
        case .medium:
            return 7.scale
        case .large:
            return 12.scale
        }
    }
}

// MARK: Make constraints
private extension BookImageView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            line1View.leadingAnchor.constraint(equalTo: leadingAnchor),
            line1View.topAnchor.constraint(equalTo: topAnchor),
            line1View.bottomAnchor.constraint(equalTo: bottomAnchor),
            line1View.widthAnchor.constraint(equalToConstant: line1Width())
        ])
        
        NSLayoutConstraint.activate([
            line2View.leadingAnchor.constraint(equalTo: leadingAnchor, constant: line2Leading()),
            line2View.topAnchor.constraint(equalTo: topAnchor),
            line2View.bottomAnchor.constraint(equalTo: bottomAnchor),
            line2View.widthAnchor.constraint(equalToConstant: line2Width())
        ])
        
        NSLayoutConstraint.activate([
            line3View.leadingAnchor.constraint(equalTo: leadingAnchor, constant: line3Leading()),
            line3View.topAnchor.constraint(equalTo: topAnchor),
            line3View.bottomAnchor.constraint(equalTo: bottomAnchor),
            line3View.widthAnchor.constraint(equalToConstant: line3Width())
        ])
        
        NSLayoutConstraint.activate([
            line4View.trailingAnchor.constraint(equalTo: trailingAnchor),
            line4View.topAnchor.constraint(equalTo: topAnchor),
            line4View.bottomAnchor.constraint(equalTo: bottomAnchor),
            line4View.widthAnchor.constraint(equalToConstant: line4Width())
        ])
    }
}

// MARK: Lazy initialization
private extension BookImageView {
    func makeLine1View() -> GradientView {
        let view = GradientView()
        view.gradientLayer.colors = [
            UIColor.black.withAlphaComponent(0).cgColor,
            UIColor(integralRed: 15, green: 15, blue: 15, alpha: 0.15).cgColor
        ]
        view.gradientLayer.startPoint = CGPoint(x: 1, y: 0.5)
        view.gradientLayer.endPoint = CGPoint(x: 0, y: 0.5)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeLine2View() -> GradientView {
        let view = GradientView()
        view.gradientLayer.colors = [
            UIColor.white.withAlphaComponent(0).cgColor,
            UIColor.white.withAlphaComponent(0.16).cgColor,
            UIColor.white.withAlphaComponent(0.16).cgColor,
            UIColor.white.withAlphaComponent(0).cgColor
        ]
        view.gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        view.gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeLine3View() -> GradientView {
        let view = GradientView()
        view.gradientLayer.colors = [
            UIColor(integralRed: 232, green: 231, blue: 227, alpha: 0).cgColor,
            UIColor(integralRed: 116, green: 116, blue: 116, alpha: 0.15).cgColor,
            UIColor(integralRed: 41, green: 41, blue: 41, alpha: 0.15).cgColor,
            UIColor(integralRed: 234, green: 233, blue: 230, alpha: 0).cgColor
        ]
        view.gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        view.gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeLine4View() -> GradientView {
        let view = GradientView()
        view.gradientLayer.colors = [
            UIColor.black.withAlphaComponent(0).cgColor,
            UIColor(integralRed: 29, green: 29, blue: 29, alpha: 0.05).cgColor
        ]
        view.gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        view.gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
