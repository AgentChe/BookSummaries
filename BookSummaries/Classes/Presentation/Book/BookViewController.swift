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
        
        viewModel.tryAgain = { [weak self] error -> Observable<Void> in
            guard let self = self else {
                return .never()
            }
            
            return self.openError()
        }
        
        viewModel.activity
            .drive(Binder(self) { base, activity in
                base.activity(activity)
            })
            .disposed(by: disposeBag)
        
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
        
        mainView.tableView.mainDelegate = self
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

// MARK: BookTableDelegate
extension BookViewController: BookTableDelegate {
    func bookTableDidTapped(chapter: BookChapter) {
        
    }
    
    func bookTableDidTappedSeeAll() {
        
    }
    
    func bookTableDidTapped(book: BookBrochure) {
        let vc = BookViewController.make(bookId: book.id)
        present(vc, animated: true)
    }
    
    func bookTableDidTapped(category: Category) {
        let vc = CategoryViewController.make(category: category)
        present(vc, animated: true)
    }
}

// MARK: Private
private extension BookViewController {
    func openError() -> Observable<Void> {
        Observable<Void>
            .create { [weak self] observe in
                guard let self = self else {
                    return Disposables.create()
                }
                
                let vc = TryAgainViewController.make {
                    observe.onNext(())
                }
                self.present(vc, animated: true)
                
                return Disposables.create()
            }
    }
    
    func activity(_ activity: Bool) {
        activity ? mainView.preloader.startAnimating() : mainView.preloader.stopAnimating()
    }
}
