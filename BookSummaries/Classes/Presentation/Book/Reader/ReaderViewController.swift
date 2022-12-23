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
        
        AmplitudeManager.shared
            .logEvent(name: "Read Screen")
        
        mainView.closeButton.rx.tap
            .bind(to: Binder(self) { base, void in
                AmplitudeManager.shared
                    .logEvent(name: "Read Tap", parameters: ["what": "close"])
                
                base.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
        
        mainView.chaptersButton.rx.tap
            .withLatestFrom(viewModel.book)
            .withLatestFrom(viewModel.currentChapter) { ($0, $1) }
            .bind(to: Binder(self) { base, args in
                AmplitudeManager.shared
                    .logEvent(name: "Read Tap", parameters: ["what": "chapters"])
                
                base.open(chapters: args.0.chapters, currentChapter: args.1)
            })
            .disposed(by: disposeBag)
        
        mainView.textSizeView.minusButton.rx.tap
            .bind(to: viewModel.didTapMinusTextSize)
            .disposed(by: disposeBag)
        
        mainView.textSizeView.plusButton.rx.tap
            .bind(to: viewModel.didTapPlusTextSize)
            .disposed(by: disposeBag)
        
        viewModel.textSize
            .drive(Binder(mainView.textSizeView) { base, textSize in
                base.setup(percent: textSize.percent)
            })
            .disposed(by: disposeBag)
        
        mainView.markFinishButton.rx.tap
            .withLatestFrom(viewModel.book)
            .bind(to: Binder(self) { base, book in
                AmplitudeManager.shared
                    .logEvent(name: "Read Tap", parameters: ["what": "mark as finished"])
                
                let vc = FeedbackViewController.make(book: book)
                base.present(vc, animated: true)
            })
            .disposed(by: disposeBag)
        
        mainView.shareButton.rx.tap
            .withLatestFrom(viewModel.shareLink)
            .bind(to: Binder(self) { base, url in
                AmplitudeManager.shared
                    .logEvent(name: "Read Tap", parameters: ["what": "share"])
                
                base.share(url: url)
            })
            .disposed(by: disposeBag)
        
        mainView.textSizeButton.rx.tap
            .scan(true) { hidden, _ -> Bool in
                !hidden
            }
            .startWith(true)
            .bind(to: Binder(self) { base, hidden in
                AmplitudeManager.shared
                    .logEvent(name: "Read Tap", parameters: ["what": "font size"])
                
                base.textSize(hidden: hidden)
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
        
        addSwipeActions()
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
    func addSwipeActions() {
        let leftSwipe = UISwipeGestureRecognizer()
        leftSwipe.direction = .left
        
        let rightSwipe = UISwipeGestureRecognizer()
        rightSwipe.direction = .right
        
        leftSwipe.rx.event
            .withLatestFrom(viewModel.currentChapter)
            .bind(to: viewModel.didSwipeToNextChapter)
            .disposed(by: disposeBag)
        
        rightSwipe.rx.event
            .withLatestFrom(viewModel.currentChapter)
            .bind(to: viewModel.didSwipeToPreviousChapter)
            .disposed(by: disposeBag)
        
        mainView.scrollView.addGestureRecognizer(leftSwipe)
        mainView.scrollView.addGestureRecognizer(rightSwipe)
    }
    
    func share(url: URL) {
        let vc = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        present(vc, animated: true)
    }
    
    func open(chapters: [BookChapter], currentChapter: BookChapter) {
        let vc = ChaptersViewController.make(chapters: chapters, selectedChapter: currentChapter) { [weak self] chapter in
            self?.viewModel.didSelectChapter.accept(chapter)
        }
        present(vc, animated: true)
    }
    
    func textSize(hidden: Bool) {
        mainView.textSizeButton.setImage(UIImage(named: hidden ? "Reader.TextSize.Hidden" : "Reader.TextSize.Open"), for: .normal)
        
        mainView.textSizeView.isHidden = hidden
    }
}
