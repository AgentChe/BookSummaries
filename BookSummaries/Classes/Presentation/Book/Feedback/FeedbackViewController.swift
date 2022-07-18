//
//  FeedbackViewController.swift
//  BookSummaries
//
//  Created by Андрей Чернышев on 18.07.2022.
//

import UIKit
import RxSwift

final class FeedbackViewController: UIViewController {
    lazy var mainView = FeedbackView()
    
    private lazy var disposeBag = DisposeBag()
    
    private let viewModel: FeedbackViewModel
    
    private init(book: Book) {
        viewModel = FeedbackViewModel(book: book)
        
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
        
        viewModel.elements
            .drive(Binder(mainView.tableView) { base, elements in
                base.setup(elements: elements)
            })
            .disposed(by: disposeBag)
        
        addHideKeyboardAction()
    }
}

// MARK: Make
extension FeedbackViewController {
    static func make(book: Book) -> FeedbackViewController {
        let vc = FeedbackViewController(book: book)
        vc.modalPresentationStyle = .popover
        return vc
    }
}

// MARK: Private
private extension FeedbackViewController {
    func addHideKeyboardAction() {
        let tapGesture = UITapGestureRecognizer()
        mainView.addGestureRecognizer(tapGesture)
        
        tapGesture.rx.event
            .bind(to: Binder(self) { base, event in
                base.mainView.endEditing(true)
            })
            .disposed(by: disposeBag)
    }
}
