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
    
    lazy var shareLink = makeShareLink()
    lazy var progress = makeProgress()
    lazy var text = makeText()
    lazy var isLastChapter = makeIsLastChapter()
    
    init(book: Book, startChapter: BookChapter) {
        self.book = BehaviorRelay(value: book)
        self.currentChapter = BehaviorRelay(value: startChapter)
    }
}

// MARK: Private
private extension ReaderViewModel {
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
            .map { book, chapter -> Float in
                guard !book.chapters.isEmpty else {
                    return 0
                }
                
                guard let index = book.chapters.firstIndex(of: chapter) else {
                    return 0
                }
                
                let number = index + 1
                
                return Float(number) / Float(book.chapters.count)
            }
    }
    
    func makeText() -> Driver<NSAttributedString> {
        currentChapter
            .map { chapter -> NSAttributedString in
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
                                    .font(Fonts.Merriweather.regular(size: 16.scale))
                                    .lineHeight(25.6.scale)
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
}
