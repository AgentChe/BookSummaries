//
//  ChaptersViewModel.swift
//  BookSummaries
//
//  Created by Андрей Чернышев on 15.07.2022.
//

import RxSwift
import RxCocoa

final class ChaptersViewModel {
    let selectChapter: BehaviorRelay<BookChapter>
    
    lazy var elements = makeElements()
    
    private let chapters: BehaviorRelay<[BookChapter]>
    
    init(chapters: [BookChapter], selectedChapter: BookChapter) {
        self.chapters = BehaviorRelay(value: chapters)
        self.selectChapter = BehaviorRelay(value: selectedChapter)
    }
}

// MARK: Private
private extension ChaptersViewModel {
    func makeElements() -> Driver<[ChaptersTableElement]> {
        Driver
            .combineLatest(
                chapters.asDriver(),
                selectChapter.asDriver()
            )
            .map { chapters, selectedChapter -> [ChaptersTableElement] in
                var result = [ChaptersTableElement]()
                
                for (index, chapter) in chapters.enumerated() {
                    let isLast = (chapters.count - 1) == index
                    
                    let element = ChapterTableElement(number: String(index + 1),
                                                      chapter: chapter,
                                                      isSelected: chapter == selectedChapter,
                                                      separatorHidden: isLast)
                    result.append(.chapter(element))
                    
                    if !isLast {
                        result.append(.offset)
                    }
                }
                
                return result
            }
    }
}
