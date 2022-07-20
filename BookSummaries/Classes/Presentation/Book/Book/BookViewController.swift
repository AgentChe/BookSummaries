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
    
    private lazy var viewModel = BookViewModel(bookId: bookId)
    
    private let bookId: Int
    
    private init(bookId: Int) {
        self.bookId = bookId
        
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
        
        mainView.readButton.rx.tap
            .bind(to: viewModel.didTapRead)
            .disposed(by: disposeBag)
        
        viewModel.reader
            .drive(Binder(self) { base, reader in
                let vc = ReaderViewController.make(book: reader.0, chapter: reader.1)
                base.present(vc, animated: true)
            })
            .disposed(by: disposeBag)
        
        mainView.shareButton.rx.tap
            .withLatestFrom(viewModel.shareLink)
            .bind(to: Binder(self) { base, url in
                base.share(url: url)
            })
            .disposed(by: disposeBag)
        
        mainView.favoriteButton.rx.tap
            .withLatestFrom(viewModel.isSavedBook)
            .bind(to: viewModel.didTapMark)
            .disposed(by: disposeBag)
        
        viewModel.isSavedBook
            .drive(Binder(self) { base, isSaved in
                base.update(favorite: isSaved)
            })
            .disposed(by: disposeBag)
        
        viewModel.elements
            .drive(Binder(mainView.tableView) { base, elements in
                base.setup(elements: elements)
            })
            .disposed(by: disposeBag)
        
        mainView.tableView.mainDelegate = self
        mainView.downloadView.delegate = self
    }
}

// MARK: Make
extension BookViewController {
    static func make(bookId: Int) -> BookViewController {
        let vc = BookViewController(bookId: bookId)
        vc.modalPresentationStyle = .fullScreen
        return vc
    }
}

// MARK: BookTableDelegate
extension BookViewController: BookTableDelegate {
    func bookTableDidTapped(chapter: BookChapter) {
        viewModel.didTapChapter.accept(chapter)
    }
    
    func bookTableDidTappedSeeAll() {
        viewModel.didTapSeeAll.accept(Void())
    }
    
    func bookTableDidTapped(book: BookCover) {
        let vc = BookViewController.make(bookId: book.id)
        present(vc, animated: true)
    }
    
    func bookTableDidTapped(category: Category) {
        let vc = CategoryViewController.make(category: category)
        present(vc, animated: true)
    }
}

// MARK: BookDownloadViewDelegate
extension BookViewController: BookDownloadViewDelegate {
    func bookDownloadViewDidDownloadTapped() {
        
    }
    
    func bookDownloadViewDidStopTapped() {
        
    }
}

// MARK: Private
private extension BookViewController {
    func update(favorite: Bool) {
        let image = UIImage(named: favorite ? "Book.Mark.Check" : "Book.Mark.Uncheck")
        mainView.favoriteButton.setImage(image, for: .normal)
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
        activity ? mainView.preloader.startAnimating() : mainView.preloader.stopAnimating()
    }
    
    func share(url: URL) {
        let vc = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        present(vc, animated: true)
    }
}
