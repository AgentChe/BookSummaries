//
//  LibraryViewController.swift
//  BookSummaries
//
//  Created by Андрей Чернышев on 22.07.2022.
//

import UIKit
import RxSwift

final class LibraryViewController: UIViewController {
    lazy var mainView = LibraryView()
    
    private lazy var viewModel = LibraryViewModel()
    
    private lazy var disposeBag = DisposeBag()
    
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
        
        addFilterActions()
    }
}

// MARK: Make
extension LibraryViewController {
    static func make() -> LibraryViewController {
        let vc = LibraryViewController()
        vc.navigationItem.backButtonTitle = " "
        return vc
    }
}

// MARK: Private
private extension LibraryViewController {
    func addFilterActions() {
        Observable
            .merge(
                mainView.filterView.savedButton.rx.tap
                    .map { LibraryFilterView.Filter.saved },
                
                mainView.filterView.historyButton.rx.tap
                    .map { LibraryFilterView.Filter.history },
                
                mainView.filterView.downloadedButton.rx.tap
                    .map { LibraryFilterView.Filter.downloaded }
            )
            .startWith(.saved)
            .bind(to: Binder(self) { base, filter in
                base.mainView.filterView.filter = filter
                base.viewModel.filter.accept(filter)
            })
            .disposed(by: disposeBag)
    }
    
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
//        mainView.collectionView.isHidden = activity
        activity ? mainView.preloader.startAnimating() : mainView.preloader.stopAnimating()
    }
}
