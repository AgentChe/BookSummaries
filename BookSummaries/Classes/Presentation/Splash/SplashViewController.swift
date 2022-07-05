//
//  SplashViewController.swift
//  BookSummaries
//
//  Created by Андрей Чернышев on 05.07.2022.
//

import UIKit
import RxSwift

final class SplashViewController: UIViewController {
    lazy var mainView = SplashView()
    
    private lazy var disposeBag = DisposeBag()
    
    override func loadView() {
        view = mainView
    }
}

// MARK: Make
extension SplashViewController {
    static func make() -> SplashViewController {
        SplashViewController()
    }
}
