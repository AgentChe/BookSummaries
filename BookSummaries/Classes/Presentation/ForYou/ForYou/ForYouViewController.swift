//
//  ForYouViewController.swift
//  BookSummaries
//
//  Created by Андрей Чернышев on 07.07.2022.
//

import UIKit
import RxSwift

final class ForYouViewController: UIViewController {
    lazy var mainView = ForYouView()
    
    private lazy var disposeBag = DisposeBag()
    
    private lazy var viewModel = ForYouViewModel()
    
    override func loadView() {
        view = mainView
    }
}

// MARK: Make
extension ForYouViewController {
    static func make() -> ForYouViewController {
        ForYouViewController()
    }
}

// MARK: Private
private extension ForYouViewController {
    
}
