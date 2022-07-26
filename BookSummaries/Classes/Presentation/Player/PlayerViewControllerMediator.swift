//
//  PlayerViewControllerMediator.swift
//  BookSummaries
//
//  Created by Андрей Чернышев on 26.07.2022.
//

protocol PlayerViewControllerMediatorDelegate: AnyObject {
    func playerViewControllerDidAppear(with book: BookCover)
    func playerViewControllerDidDisappear()
}

final class PlayerViewControllerMediator {
    static let shared = PlayerViewControllerMediator()
    
    private init() {}
    
    private lazy var delegates = [Weak<PlayerViewControllerMediatorDelegate>]()
}

// MARK: Public
extension PlayerViewControllerMediator {
    func notifyAboutAppear(with book: BookCover) {
        delegates.forEach { $0.weak?.playerViewControllerDidAppear(with: book) }
    }
    
    func notifyAboutDisappear() {
        delegates.forEach { $0.weak?.playerViewControllerDidDisappear() }
    }
}

// MARK: Observer
extension PlayerViewControllerMediator {
    func add(delegate: PlayerViewControllerMediatorDelegate) {
        let weakly = delegate as AnyObject
        delegates.append(Weak<PlayerViewControllerMediatorDelegate>(weakly))
        delegates = delegates.filter { $0.weak != nil }
    }

    func remove(delegate: PlayerViewControllerMediatorDelegate) {
        if let index = delegates.firstIndex(where: { $0.weak === delegate }) {
            delegates.remove(at: index)
        }
    }
}
