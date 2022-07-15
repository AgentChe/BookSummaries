//
//  ReaderViewController.swift
//  BookSummaries
//
//  Created by Андрей Чернышев on 15.07.2022.
//

import UIKit
import RxSwift

final class ReaderViewController: UIViewController {
    lazy var mainView = ReaderView()
    
    private lazy var disposeBag = DisposeBag()
    
    private let viewModel: ReaderViewModel
    
    private init(book: Book, chapter: BookChapter) {
        viewModel = ReaderViewModel(book: book, startChapter: chapter)
        
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
        
        mainView.chaptersButton.rx.tap
            .withLatestFrom(viewModel.book)
            .withLatestFrom(viewModel.currentChapter) { ($0, $1) }
            .bind(to: Binder(self) { base, args in
                base.open(chapters: args.0.chapters, currentChapter: args.1)
            })
            .disposed(by: disposeBag)
        
        mainView.shareButton.rx.tap
            .withLatestFrom(viewModel.shareLink)
            .bind(to: Binder(self) { base, url in
                base.share(url: url)
            })
            .disposed(by: disposeBag)
        
        viewModel.progress
            .drive(Binder(mainView.progressView) { base, progress in
                base.setProgress(progress, animated: true)
            })
            .disposed(by: disposeBag)
        
        viewModel.text
            .drive(Binder(mainView.label) { base, text in
                base.attributedText = text
            })
            .disposed(by: disposeBag)
        
        viewModel.isLastChapter
            .drive(Binder(mainView) { base, isLastChapter in
                base.bottomView(hidden: !isLastChapter)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: Make
extension ReaderViewController {
    static func make(book: Book, chapter: BookChapter) -> ReaderViewController {
        let vc = ReaderViewController(book: book, chapter: chapter)
        vc.modalPresentationStyle = .popover
        return vc
    }
}

// MARK: Private
private extension ReaderViewController {
    func share(url: URL) {
        let vc = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        present(vc, animated: true)
    }
    
    func open(chapters: [BookChapter], currentChapter: BookChapter) {
        let vc = ChaptersViewController.make(chapters: chapters, selectedChapter: currentChapter) { [weak self] chapter in
            self?.viewModel.currentChapter.accept(chapter)
        }
        present(vc, animated: true)
    }
}
