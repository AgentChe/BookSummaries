//
//  RankingsViewController.swift
//  BookSummaries
//
//  Created by Андрей Чернышев on 18.07.2022.
//

import UIKit
import RxSwift

final class RankingsViewController: UIViewController {
    lazy var mainView = RankingsView()
    
    private lazy var disposeBag = DisposeBag()
    
    private let viewModel: RankingsViewModel
    
    private init(start: Ranking?) {
        viewModel = RankingsViewModel(start: start)
        
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
        
        viewModel.rankingsElements
            .drive(Binder(mainView.rankingView) { base, elements in
                base.setup(elements: elements)
            })
            .disposed(by: disposeBag)
        
        viewModel.booksElements
            .drive(Binder(mainView.booksView) { base, elements in
                base.setup(elements: elements)
            })
            .disposed(by: disposeBag)
        
        mainView.rankingView.mainDelegate = self
        mainView.booksView.mainDelegate = self
    }
}

// MARK: Make
extension RankingsViewController {
    static func make(start: Ranking?) -> RankingsViewController {
        let vc = RankingsViewController(start: start)
        vc.modalPresentationStyle = .fullScreen
        return vc
    }
}

// MARK: RankingsCollectionDelegate
extension RankingsViewController: RankingsCollectionDelegate {
    func rankingCollectionDidTapped(element: RankingsCollectionElement) {
        viewModel.selectRanking.accept(element.ranking)
    }
}

// MARK: RBooksTableDelegate
extension RankingsViewController: RBooksTableDelegate {
    func rankingBooksTableDidTapped(book: BookCover) {
        let vc: UIViewController
        
        let needPayment = !SessionManager().hasActiveSubscriptions()
        if needPayment && book.paid {
            vc = PaygateViewController.make()
        } else {
            vc = BookViewController.make(bookId: book.id)
        }
        
        present(vc, animated: true)
    }
}

// MARK: Private
private extension RankingsViewController {
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
        mainView.booksView.isHidden = activity
        activity ? mainView.preloader.startAnimating() : mainView.preloader.stopAnimating()
    }
}
