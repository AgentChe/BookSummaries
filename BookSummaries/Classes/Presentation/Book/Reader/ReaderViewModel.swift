//
//  ReaderViewModel.swift
//  BookSummaries
//
//  Created by Андрей Чернышев on 15.07.2022.
//

import RxSwift
import RxCocoa

final class ReaderViewModel {
    let book: BehaviorRelay<Book>
    let currentChapter: BehaviorRelay<BookChapter>
    lazy var didTapMinusTextSize = PublishRelay<Void>()
    lazy var didTapPlusTextSize = PublishRelay<Void>()
    
    lazy var textSize = makeTextSize()
    lazy var shareLink = makeShareLink()
    lazy var progress = makeProgress()
    lazy var text = makeText()
    lazy var isLastChapter = makeIsLastChapter()
    
    private lazy var textSizes = makeTextSizes()
    
    private lazy var contentManager = ContentManagerMock() // TODO
    private lazy var profileManager = ProfileManager()
    
    init(book: Book, startChapter: BookChapter) {
        self.book = BehaviorRelay(value: book)
        self.currentChapter = BehaviorRelay(value: startChapter)
    }
}

// MARK: Private
private extension ReaderViewModel {
    func makeTextSize() -> Driver<TextSize> {
        let initial = profileManager
            .obtainTextSize()
            .asDriver(onErrorDriveWith: .never())
        
        let updated = initial.flatMapLatest { [weak self] textSize -> Driver<TextSize> in
            guard let self = self else {
                return .never()
            }
            
            return self.makeActionsTextSizeChanged()
        }
        
        return Driver.merge(initial, updated)
    }
    
    func makeShareLink() -> Driver<URL> {
        book
            .map { $0.shareLink }
            .asDriver(onErrorDriveWith: .never())
    }
    
    func makeProgress() -> Driver<Float> {
        Driver
            .combineLatest(
                book.asDriver(),
                currentChapter.asDriver()
            )
            .flatMapLatest { [weak self] book, chapter -> Driver<BookReadingProgress> in
                guard let self = self else {
                    return .never()
                }
                
                guard let index = book.chapters.firstIndex(of: chapter) else {
                    return .never()
                }
                
                let readingBook = BookReadingProgress(book: book, currentChapterIndex: index)
                
                return self.contentManager
                    .set(bookReadingProgress: readingBook)
                    .map { readingBook }
                    .asDriver(onErrorDriveWith: .never())
            }
            .map { readingBook -> Float in
                let number = readingBook.currentChapterIndex + 1
                let progress = Float(number) / Float(readingBook.book.chapters.count)
                
                return progress
            }
    }
    
    func makeText() -> Driver<NSAttributedString> {
        Driver
            .combineLatest(currentChapter.asDriver(), textSize)
            .map { chapter, textSize -> NSAttributedString in
                let title = chapter.title
                    .attributed(with: TextAttributes()
                                    .textColor(Appearance.black)
                                    .font(Fonts.Merriweather.black(size: 20.scale))
                                    .lineHeight(28.scale)
                                    .letterSpacing(0.37.scale))
                
                let empty = "\n\n"
                    .attributed(with: TextAttributes()
                                    .font(Fonts.Merriweather.black(size: 15.scale))
                                    .lineHeight(15.scale))
                
                let text = chapter.text
                    .attributed(with: TextAttributes()
                                    .textColor(Appearance.black)
                                    .font(Fonts.Merriweather.regular(size: textSize.fontSize))
                                    .lineHeight(textSize.lineHeight)
                                    .letterSpacing(0.37.scale))
                
                let result = NSMutableAttributedString()
                result.append(title)
                result.append(empty)
                result.append(text)
                return result
            }
            .asDriver(onErrorDriveWith: .never())
    }
    
    func makeIsLastChapter() -> Driver<Bool> {
        Driver
            .combineLatest(
                book.asDriver(),
                currentChapter.asDriver()
            )
            .map { book, chapter -> Bool in
                guard let index = book.chapters.firstIndex(of: chapter) else {
                    return true
                }
                
                return (book.chapters.count - 1) == index
            }
    }
    
    func makeActionsTextSizeChanged() -> Driver<TextSize> {
        Observable
            .merge(
                didTapMinusTextSize.map { -1 },
                didTapPlusTextSize.map { 1 }
            )
            .withLatestFrom(textSize) { ($0, $1) }
            .withLatestFrom(textSizes) { ($0.0, $0.1, $1) }
            .compactMap { coef, currentTextSize, textSizes -> TextSize? in
                guard let currentIndex = textSizes.firstIndex(of: currentTextSize) else {
                    return nil
                }
                
                let index = currentIndex + coef
                
                guard textSizes.indices.contains(index) else {
                    return nil
                }
                
                return textSizes[index]
            }
            .flatMapLatest { [weak self] textSize -> Single<TextSize> in
                guard let self = self else {
                    return .never()
                }
                
                return self.profileManager
                    .set(textSize: textSize)
                    .map { textSize }
            }
            .asDriver(onErrorDriveWith: .never())
    }
    
    func makeTextSizes() -> Driver<[TextSize]> {
        .deferred {
            .just([
                TextSize(percent: 80),
                TextSize(percent: 90),
                TextSize(percent: 100),
                TextSize(percent: 110),
                TextSize(percent: 120)
            ])
        }
    }
}
