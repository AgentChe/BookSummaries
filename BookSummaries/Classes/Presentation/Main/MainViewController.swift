//
//  MainViewController.swift
//  BookSummaries
//
//  Created by Андрей Чернышев on 07.07.2022.
//

import UIKit
import RxSwift

final class MainViewController: UIViewController {
    lazy var mainView = MainView()
    
    private lazy var disposeBag = DisposeBag()
    
    private lazy var coordinator = MainViewCoordinator(parentVC: self)
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        rx.methodInvoked(#selector(UIViewController.viewDidLayoutSubviews))
            .take(1)
            .subscribe(onNext: { [weak self] _ in
                self?.update(selectedTab: .forYou)
            })
            .disposed(by: disposeBag)
        
        mainView.playerView.delegate = self
        addActionsToTabs()
        mainView.showPlayer(show: false)
    }
}

// MARK: Make
extension MainViewController {
    static func make() -> MainViewController {
        let vc = MainViewController()
        PlayerViewControllerMediator.shared.add(delegate: vc)
        vc.navigationItem.backButtonTitle = " "
        return vc
    }
}

// MARK: PlayerViewControllerMediatorDelegate
extension MainViewController: PlayerViewControllerMediatorDelegate {
    func playerViewControllerDidAppear(with book: BookCover) {
        mainView.showPlayer(show: false)
        mainView.playerView.resignControlOnPlayer()
        mainView.playerView.fill(book: book)
    }
    
    func playerViewControllerDidDisappear() {
        mainView.showPlayer(show: true)
        mainView.playerView.becomeControlOnPlayer()
    }
}

// MARK: TabPlayerViewDelegate
extension MainViewController: TabPlayerViewDelegate {
    func tabPlayerDidCloseTapped() {
        mainView.showPlayer(show: false)
        mainView.playerView.resignControlOnPlayer()
        
        AudioPlayerManager.shared.clear()
    }
}
 
// MARK: Private
private extension MainViewController {
    func addActionsToTabs() {
        Observable
            .merge([
                mainView.tabView.forYouItem
                    .rx.tap.map { TabView.Tab.forYou },
                
                mainView.tabView.libraryItem
                    .rx.tap.map { TabView.Tab.library },
                
                mainView.tabView.exploreItem
                    .rx.tap.map { TabView.Tab.explore }
            ])
            .subscribe(onNext: { [weak self] tab in
                self?.update(selectedTab: tab)
            })
            .disposed(by: disposeBag)
    }
    
    func update(selectedTab: TabView.Tab) {
        coordinator.change(tab: selectedTab)
    }
}
