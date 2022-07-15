//
//  ContentMediator.swift
//  BookSummaries
//
//  Created by Андрей Чернышев on 12.07.2022.
//

import RxSwift
import RxCocoa

protocol ContentMediatorDelegate: AnyObject {
    func contentMediatorDidSaved(bookId: Int)
    func contentMediatorDidRemovedSaved(bookId: Int)
    func contentMediatorDidUpdated(bookReadingProgress: BookReadingProgress)
}

final class ContentMediator {
    static let shared = ContentMediator()
    
    private var delegates = [Weak<ContentMediatorDelegate>]()
    
    private lazy var bookIdDidSavedTrigger = PublishRelay<Int>()
    private lazy var bookIdDidRemoveFromSavedTrigger = PublishRelay<Int>()
    private lazy var bookReadingProgressUpdatedTrigger = PublishRelay<BookReadingProgress>()
    
    private init() {}
}

// MARK: Public
extension ContentMediator {
    func notifyAboutSaved(bookId: Int) {
        DispatchQueue.main.async { [weak self] in
            self?.delegates.forEach {
                $0.weak?.contentMediatorDidSaved(bookId: bookId)
            }
            
            self?.bookIdDidSavedTrigger.accept(bookId)
        }
    }
    
    func notifyAboutRemoveSaved(bookId: Int) {
        DispatchQueue.main.async { [weak self] in
            self?.delegates.forEach {
                $0.weak?.contentMediatorDidRemovedSaved(bookId: bookId)
            }
            
            self?.bookIdDidRemoveFromSavedTrigger.accept(bookId)
        }
    }
    
    func notifyAboutUpdate(bookReadingProgress: BookReadingProgress) {
        DispatchQueue.main.async { [weak self] in
            self?.delegates.forEach {
                $0.weak?.contentMediatorDidUpdated(bookReadingProgress: bookReadingProgress)
            }
            
            self?.bookReadingProgressUpdatedTrigger.accept(bookReadingProgress)
        }
    }
}

// MARK: Public (Triggers)
extension ContentMediator {
    var bookIdDidSaved: Signal<Int> {
        bookIdDidSavedTrigger.asSignal()
    }
    
    var bookIdDidRemoveFromSaved: Signal<Int> {
        bookIdDidRemoveFromSavedTrigger.asSignal()
    }
    
    var bookReadingProgressUpdated: Signal<BookReadingProgress> {
        bookReadingProgressUpdatedTrigger.asSignal()
    }
}

// MARK: Public (Observer)
extension ContentMediator {
    func add(delegate: ContentMediatorDelegate) {
        let weakly = delegate as AnyObject
        delegates.append(Weak<ContentMediatorDelegate>(weakly))
        delegates = delegates.filter { $0.weak != nil }
    }
    
    func remove(delegate: ContentMediatorDelegate) {
        if let index = delegates.firstIndex(where: { $0.weak === delegate }) {
            delegates.remove(at: index)
        }
    }
}
