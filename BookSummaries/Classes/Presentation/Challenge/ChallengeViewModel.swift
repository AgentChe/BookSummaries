//
//  ChallengeViewModel.swift
//  BookSummaries
//
//  Created by Андрей Чернышев on 12.08.2022.
//

import RxSwift
import RxCocoa

final class ChallengeViewModel {
    var tryAgain: ((Error) -> (Observable<Void>))?
    
    lazy var listenTapped = PublishRelay<Int>()
    
    lazy var progress = makeProgress()
    lazy var elements = makeElements()
    lazy var listen = makeListen()
    lazy var activity = RxActivityIndicator()
    
    private lazy var challenge = makeChallenge()
    private lazy var readingBooks = makeReadingBooks()
    private let challengeId: BehaviorRelay<Int>
    
    private lazy var contentManager = ContentManager()
    
    private lazy var observableRetrySingle = ObservableRetrySingle()
    
    init(challengeId: Int) {
        self.challengeId = BehaviorRelay(value: challengeId)
    }
}

// MARK: Private
private extension ChallengeViewModel {
    func makeProgress() -> Driver<Int> {
        Driver
            .combineLatest(
                challenge.map { $0.books },
                readingBooks
            ) { challengeBooks, readingBooks -> Int in
                let readBooksAtChallenge = readingBooks
                    .filter { readingBook -> Bool in
                        challengeBooks.contains(where: { $0.id == readingBook.book.id })
                    }
                    .filter { $0.progress == 1 }
                
                let readBooksCount = Float(readBooksAtChallenge.count)
                let totalBooksCount = Float(challengeBooks.count)
                
                guard totalBooksCount > 0 else {
                    return 0
                }
                
                let progress = readBooksCount / totalBooksCount * 100
                
                return Int(progress)
            }
    }
    
    func makeElements() -> Driver<[ChallengeTableElement]> {
        Driver
            .combineLatest(challenge, readingBooks)
            .map { [weak self] challenge, readingBooks -> [ChallengeTableElement] in
                guard let self = self else {
                    return []
                }
                
                let readingBooksAtChallenge = readingBooks.filter { readingBook -> Bool in
                    challenge.books.contains(where: { $0.id == readingBook.book.id })
                }
                
                var result = [ChallengeTableElement]()
                
                let header = ChallengeHeaderElement(name: challenge.name,
                                                    title: challenge.title,
                                                    text: challenge.text)
                result.append(.header(header))
                
                let isCompleteChallenge = self.isCompleteChallenge(readingBooks: readingBooksAtChallenge,
                                                                   challengeBooksCount: challenge.books.count)
                let readingDayBookId = self.readingDayBookId(readingBooks: readingBooks,
                                                             challengeBooks: challenge.books)
                if !isCompleteChallenge, let readingDayBookId = readingDayBookId {
                    let element = ChallengeButtonsElement(currentDayBookId: readingDayBookId)
                    
                    result.append(contentsOf: [
                        .offset(20.scale),
                        .buttons(element)
                    ])
                }
                
                let books = challenge.books.enumerated().map { index, book -> ChallengeBookElement in
                    let completed = readingBooksAtChallenge.first(where: { $0.book.id == book.id })?.progress == 1
                    
                    return ChallengeBookElement(dayNumber: index + 1,
                                                book: book,
                                                completed: completed,
                                                current: readingDayBookId == book.id)
                }
                result.append(contentsOf: [
                    .offset(30.scale),
                    .books(books)
                ])
                
                let goodStartProgress = self.goodStartProgress(readingBooks: readingBooksAtChallenge)
                let completeDay3Progress = self.completeDay3Progress(readingBooks: readingBooksAtChallenge)
                let completeChallengeProgress = self.completeChallengeProgress(readingBooks: readingBooksAtChallenge,
                                                                               challengeBooksCount: challenge.books.count)
                let badges = ChallengeBadgesElement(goodStartProgress: goodStartProgress,
                                                    completeDay3Progress: completeDay3Progress,
                                                    completeChallengeProgress: completeChallengeProgress)
                result.append(contentsOf: [
                    .offset(30.scale),
                    .badges(badges)
                ])
                
                return result
            }
    }
    
    func makeChallenge() -> Driver<Challenge> {
        challengeId
            .flatMapLatest { [weak self] challengeId -> Observable<Challenge> in
                guard let self = self else {
                    return .never()
                }
                
                func source() -> Single<Challenge> {
                    self.contentManager
                        .obtainChallenge(id: challengeId)
                        .flatMap { challenge -> Single<Challenge> in
                            guard let challenge = challenge else {
                                return .error(ContentError(.notContent))
                            }
                            
                            return .just(challenge)
                        }
                }
                
                func trigger(error: Error) -> Observable<Void> {
                    guard let tryAgain = self.tryAgain?(error) else {
                        return .empty()
                    }
                    
                    return tryAgain
                }

                return self.observableRetrySingle
                    .retry(source: { source() },
                           trigger: { trigger(error: $0) })
                    .trackActivity(self.activity)
            }
            .asDriver(onErrorDriveWith: .never())
    }
    
    func makeReadingBooks() -> Driver<[BookReadingProgress]> {
        let initial = contentManager
            .obtainReadingBooks()
            .asDriver(onErrorJustReturn: [])
        
        let updated = ContentMediator.shared
            .bookReadingProgressUpdated
            .flatMapLatest { [weak self] book -> Driver<[BookReadingProgress]> in
                guard let self = self else {
                    return .never()
                }
                
                return self.contentManager
                    .obtainReadingBooks()
                    .asDriver(onErrorJustReturn: [])
            }
        
        return Driver.merge(initial, updated)
    }
    
    func makeListen() -> Driver<(BookCover, URL)> {
        listenTapped
            .flatMapLatest { [weak self] bookId -> Observable<(BookCover, URL)> in
                guard let self = self else {
                    return .never()
                }
                
                func source() -> Single<(BookCover, URL)> {
                    self.contentManager
                        .obtainBookKit(bookId: bookId)
                        .flatMap { bookKit -> Single<(BookCover, URL)> in
                            guard let bookKit = bookKit else {
                                return .error(ContentError(.notContent))
                            }
                            
                            let book = bookKit.book
                            let bookCover = BookCover(id: book.id,
                                                      name: book.name,
                                                      author: book.author,
                                                      imageUrl: book.imageUrl,
                                                      rankingId: book.rankingId,
                                                      shareLink: book.shareLink,
                                                      paid: false)
                            return .just((bookCover, book.audioUrl))
                        }
                }
                
                func trigger(error: Error) -> Observable<Void> {
                    guard let tryAgain = self.tryAgain?(error) else {
                        return .empty()
                    }
                    
                    return tryAgain
                }

                return self.observableRetrySingle
                    .retry(source: { source() },
                           trigger: { trigger(error: $0) })
            }
            .asDriver(onErrorDriveWith: .never())
    }
}

// MARK: Private (Additional)
private extension ChallengeViewModel {
    func isCompleteChallenge(readingBooks: [BookReadingProgress], challengeBooksCount: Int) -> Bool {
        completeChallengeProgress(readingBooks: readingBooks, challengeBooksCount: challengeBooksCount) == 100
    }
    
    func readingDayBookId(readingBooks: [BookReadingProgress], challengeBooks: [BookCover]) -> Int? {
        guard !readingBooks.isEmpty else {
            return challengeBooks.first?.id
        }
        
        let lastChallengeBookIndex = challengeBooks.lastIndex(where: { book -> Bool in
            readingBooks.contains(where: { $0.book.id == book.id })
        })
        guard let lastChallengeBookIndex = lastChallengeBookIndex else {
            return challengeBooks.first?.id
        }
        
        guard let progress = readingBooks.first(where: { $0.book.id == challengeBooks[lastChallengeBookIndex].id })?.progress else {
            return challengeBooks.first?.id
        }
        
        if progress < 1 {
            return challengeBooks[lastChallengeBookIndex].id
        } else {
            let nextIndex = lastChallengeBookIndex + 1
            if challengeBooks.indices.contains(nextIndex) {
                return challengeBooks[nextIndex].id
            }
        }
        
        return nil
    }
    
    func goodStartProgress(readingBooks: [BookReadingProgress]) -> Int {
        guard readingBooks.count > 0 else {
            return 0
        }
        
        let progress = readingBooksToProgress(readingBooks)
        return progress.max() ?? 0
    }
    
    func completeDay3Progress(readingBooks: [BookReadingProgress]) -> Int {
        guard readingBooks.count > 0 else {
            return 0
        }
        
        let progress = readingBooksToProgress(readingBooks)
        
        let totalProgress = progress
            .sorted(by: { $0 > $1 })
            .prefix(3)
            .reduce(0) { $0 + $1 }
        let totalPercent = Float(300)
        
        let percent = Float(totalProgress) / totalPercent * 100
        
        return Int(percent)
    }
    
    func completeChallengeProgress(readingBooks: [BookReadingProgress], challengeBooksCount: Int) -> Int {
        guard readingBooks.count > 0 else {
            return 0
        }
        
        let progress = readingBooksToProgress(readingBooks)
        
        let totalProgress = progress
            .sorted(by: { $0 > $1 })
            .reduce(0) { $0 + $1 }
        let totalPercent = Float(challengeBooksCount * 100)
        
        guard totalPercent > 0 else {
            return 0
        }
        
        let percent = Float(totalProgress) / totalPercent * 100
        
        return Int(percent)
    }
    
    func readingBooksToProgress(_ readingBooks: [BookReadingProgress]) -> [Int] {
        readingBooks.map { book -> Int in
            let readChaptersCount = Float(book.currentChapterIndex + 1)
            let totalChaptersCount = Float(book.book.chapters.count)
            let percent = readChaptersCount / totalChaptersCount * 100
            return Int(percent)
        }
    }
}
