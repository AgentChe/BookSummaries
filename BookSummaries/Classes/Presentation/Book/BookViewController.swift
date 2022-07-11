//
//  BookViewController.swift
//  BookSummaries
//
//  Created by Андрей Чернышев on 11.07.2022.
//

import UIKit
import RxSwift

final class BookViewController: UIViewController {
    lazy var mainView = BookView()
    
    private lazy var disposeBag = DisposeBag()
    
    private lazy var viewModel = BookViewModel()
    
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
        
        viewModel.elements
            .drive(Binder(mainView.tableView) { base, elements in
                base.setup(elements: elements)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: Make
extension BookViewController {
    static func make(bookId: Int) -> BookViewController {
        let vc = BookViewController()
        vc.modalPresentationStyle = .fullScreen
        return vc
    }
}
