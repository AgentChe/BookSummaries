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
    
    private lazy var viewModel = BookViewModel(bookId: bookId, isFree: isFree)
    
    private let bookId: Int
    private let isFree: Bool
    
    private init(bookId: Int, isFree: Bool) {
        self.bookId = bookId
        self.isFree = isFree
        
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
        
        AmplitudeManager.shared
            .logEvent(name: "Book Screen")
        
        viewModel.tryAgain = { [weak self] error -> Observable<Void> in
            guard let self = self else {
                return .never()
            }
            
            return self.open(error: error)
        }
        
        viewModel.activity
            .drive(Binder(self) { base, activity in
                base.activity(activity)
            })
            .disposed(by: disposeBag)
        
        mainView.closeButton.rx.tap
            .bind(to: Binder(self) { base, void in
                AmplitudeManager.shared
                    .logEvent(name: "Book Tap", parameters: ["what": "back"])
                
                base.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
        
        mainView.listenButton.rx.tap
            .bind(to: viewModel.didTapListen)
            .disposed(by: disposeBag)
        
        viewModel.listen
            .drive(Binder(self) { base, args in
                let (book, url) = args
                
                AmplitudeManager.shared
                    .logEvent(name: "Book Tap", parameters: ["what": "listen"])
                
                let vc = PlayerViewController.make(book: book, audioUrl: url)
                base.present(vc, animated: true)
            })
            .disposed(by: disposeBag)
        
        viewModel.bookIsDownloading
            .drive(Binder(mainView) { base, isDownloading in
                base.update(bookIsDownloading: isDownloading)
            })
            .disposed(by: disposeBag)
        
        viewModel.downloadState
            .drive(Binder(mainView.downloadView) { base, state in
                base.state = state
            })
            .disposed(by: disposeBag)
        
        mainView.readButton.rx.tap
            .bind(to: viewModel.didTapRead)
            .disposed(by: disposeBag)
        
        viewModel.reader
            .drive(Binder(self) { base, reader in
                AmplitudeManager.shared
                    .logEvent(name: "Book Tap", parameters: ["what": "read"])
                
                let vc = ReaderViewController.make(book: reader.0, chapter: reader.1)
                base.present(vc, animated: true)
            })
            .disposed(by: disposeBag)
        
        mainView.shareButton.rx.tap
            .withLatestFrom(viewModel.shareLink)
            .bind(to: Binder(self) { base, url in
                AmplitudeManager.shared
                    .logEvent(name: "Book Tap", parameters: ["what": "share"])
                
                base.share(url: url)
            })
            .disposed(by: disposeBag)
        
        mainView.favoriteButton.rx.tap
            .withLatestFrom(viewModel.isSavedBook)
            .do(onNext: { saved in
                AmplitudeManager.shared
                    .logEvent(name: "Book Tap", parameters: ["what": "bookmark"])
            })
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
    static func make(bookId: Int, isFree: Bool) -> BookViewController {
        let vc = BookViewController(bookId: bookId, isFree: isFree)
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
        let vc: UIViewController
        
        let needPayment = !SessionManager().hasActiveSubscriptions()
        if needPayment && book.paid {
            vc = PaygateViewController.make()
        } else {
            vc = BookViewController.make(bookId: book.id, isFree: false)
        }
        
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
        AmplitudeManager.shared
            .logEvent(name: "Book Tap", parameters: ["what": "download"])
        
        viewModel.didTapStartDownload.accept(Void())
    }
    
    func bookDownloadViewDidStopTapped() {
        viewModel.didTapStopDownload.accept(Void())
    }
}

// MARK: Private
private extension BookViewController {
    func update(favorite: Bool) {
        let image = UIImage(named: favorite ? "Book.Mark.Check" : "Book.Mark.Uncheck")
        mainView.favoriteButton.iconView.image = image
    }
    
    func open(error: Error) -> Observable<Void> {
        Observable<Void>
            .create { [weak self] observe in
                guard let self = self else {
                    return Disposables.create()
                }
                
                let vc = TryAgainViewController.make(error: error) {
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
