//
//  BookDownloadView.swift
//  BookSummaries
//
//  Created by Андрей Чернышев on 20.07.2022.
//

import UIKit

protocol BookDownloadViewDelegate: AnyObject {
    func bookDownloadViewDidDownloadTapped()
    func bookDownloadViewDidStopTapped()
}

final class BookDownloadView: UIView {
    enum State {
        case download
        case downloading(Float)
        case downloaded
    }
    
    weak var delegate: BookDownloadViewDelegate?
    
    lazy var state = State.download {
        didSet {
            update()
        }
    }
    
    lazy var imageView = makeImageView()
    lazy var rectView = makeRectView()
    lazy var circleLayer = makeCircleLayer()
    lazy var trackLayer = makeTrackLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
        initialize()
        update()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        CGSize(width: 41.scale, height: 41.scale)
    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        bounds.insetBy(dx: -10.scale, dy: -10.scale).contains(point)
    }
}

// MARK: Private
private extension BookDownloadView {
    func initialize() {
        layer.cornerRadius = intrinsicContentSize.width / 2
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapped))
        isUserInteractionEnabled = true
        addGestureRecognizer(tapGesture)
    }
    
    func update() {
        switch state {
        case .download:
            backgroundColor = Appearance.secondary5
            imageView.image = UIImage(named: "Book.Download")
            rectView.isHidden = true
            circleLayer.isHidden = true
            trackLayer.isHidden = true
            trackLayer.strokeEnd = 0
        case .downloading(let percent):
            backgroundColor = UIColor.clear
            imageView.image = nil
            rectView.isHidden = false
            circleLayer.isHidden = false
            trackLayer.isHidden = false
            trackLayer.strokeEnd = CGFloat(percent / 100)
        case .downloaded:
            backgroundColor = Appearance.secondary5
            imageView.image = UIImage(named: "Book.Download.Completed")
            rectView.isHidden = true
            circleLayer.isHidden = true
            trackLayer.isHidden = true
            trackLayer.strokeEnd = 0
        }
    }
    
    @objc
    func tapped() {
        switch state {
        case .download:
            delegate?.bookDownloadViewDidDownloadTapped()
        case .downloading:
            delegate?.bookDownloadViewDidStopTapped()
        case .downloaded:
            break
        }
    }
}

// MARK: Make constraints
private extension BookDownloadView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 22.scale),
            imageView.heightAnchor.constraint(equalToConstant: 22.scale),
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            rectView.widthAnchor.constraint(equalToConstant: 9.scale),
            rectView.heightAnchor.constraint(equalToConstant: 9.scale),
            rectView.centerXAnchor.constraint(equalTo: centerXAnchor),
            rectView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension BookDownloadView {
    func makeImageView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeRectView() -> UIView {
        let view = UIView()
        view.backgroundColor = Appearance.primaryGreen
        view.layer.cornerRadius = 2.scale
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeCircleLayer() -> CAShapeLayer {
        let center = intrinsicContentSize.width / 2
        let circularPath = UIBezierPath(arcCenter: CGPoint(x: center, y: center),
                                        radius: center - 1.5.scale,
                                        startAngle: -.pi / 2,
                                        endAngle: 1.5 * .pi,
                                        clockwise: true)
        
        let layer = CAShapeLayer()
        layer.path = circularPath.cgPath
        layer.fillColor = UIColor.clear.cgColor
        layer.lineCap = .round
        layer.lineWidth = 3.scale
        layer.strokeColor = Appearance.secondary5.cgColor
        self.layer.addSublayer(layer)
        return layer
    }
    
    func makeTrackLayer() -> CAShapeLayer {
        let center = intrinsicContentSize.width / 2
        let circularPath = UIBezierPath(arcCenter: CGPoint(x: center, y: center),
                                        radius: center - 1.5.scale,
                                        startAngle: -.pi / 2,
                                        endAngle: 1.5 * .pi,
                                        clockwise: true)
        
        let layer = CAShapeLayer()
        layer.path = circularPath.cgPath
        layer.fillColor = UIColor.clear.cgColor
        layer.lineCap = .round
        layer.lineWidth = 3.scale
        layer.strokeColor = Appearance.primaryGreen.cgColor
        layer.strokeStart = 0
        self.layer.addSublayer(layer)
        return layer
    }
}
