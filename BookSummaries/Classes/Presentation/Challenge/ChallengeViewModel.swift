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
    
    lazy var progress = makeProgress()
    lazy var elements = makeElements()
    lazy var activity = RxActivityIndicator()
    
    private lazy var challenge = makeChallenge()
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
        .deferred {
            .just(50)
        }
    }
    
    func makeElements() -> Driver<[ChallengeTableElement]> {
        challenge
            .map { challenge -> [ChallengeTableElement] in
                var result = [ChallengeTableElement]()
                
                let header = ChallengeHeaderElement(name: challenge.name,
                                                    title: challenge.title,
                                                    text: challenge.text)
                result.append(.header(header))
                
                result.append(contentsOf: [
                    .offset(20.scale),
                    .buttons
                ])
                
                let books = challenge.books.enumerated().map { index, book -> ChallengeBookElement in
                    ChallengeBookElement(dayNumber: index + 1, book: book, completed: index <= 1, current: index == 2)
                }
                result.append(contentsOf: [
                    .offset(30.scale),
                    .books(books)
                ])
                
                let badges = ChallengeBadgesElement(goodStartProgress: 100,
                                                    completeDay3Progress: 34,
                                                    completeChallengeProgress: 0)
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
}
