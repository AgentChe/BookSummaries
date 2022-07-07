//
//  ForYouViewModel.swift
//  BookSummaries
//
//  Created by Андрей Чернышев on 07.07.2022.
//

import RxSwift
import RxCocoa

final class ForYouViewModel {
    var tryAgain: ((Error) -> (Observable<Void>))?
    
    lazy var elements = makeElements()
    lazy var activity = RxActivityIndicator()
    
    private lazy var observableRetrySingle = ObservableRetrySingle()
}

// MARK: Private
private extension ForYouViewModel {
    func makeElements() -> Driver<[ForYouTableElement]> {
        .deferred {
            let result: [ForYouTableElement] = [
                .freeBook(Self.mockBook()),
                .offset(30.scale),
                .title("ForYou.TodayHotSummaries".localized),
                .offset(16.scale),
                .books(Self.mockBooks()),
                .offset(23.scale),
                .title("ForYou.Challenges".localized),
                .offset(16.scale),
                .challenges(Self.mockChallenges()),
                .offset(30.scale),
                .title("ForYou.YouMayLike".localized),
                .offset(16.scale),
                .books(Self.mockBooks()),
                .offset(24.scale),
                .rankingTitle("Top reads of 2021"),
                .offset(24.scale),
                .ranking(ForYouRankingElement(number: "1",
                                              book: Self.mockBook())),
                .offset(16.scale),
                .separator,
                .offset(16.scale),
                .ranking(ForYouRankingElement(number: "2",
                                              book: Self.mockBook())),
                .offset(16.scale),
                .separator,
                .offset(16.scale),
                .ranking(ForYouRankingElement(number: "3",
                                              book: Self.mockBook())),
                .offset(16.scale),
                .separator,
                .offset(16.scale),
                .ranking(ForYouRankingElement(number: "4",
                                              book: Self.mockBook())),
                .offset(16.scale),
                .separator,
                .offset(16.scale),
                .ranking(ForYouRankingElement(number: "5",
                                              book: Self.mockBook())),
                .offset(30.scale),
                .title("ForYou.ExploreCategories".localized),
                .offset(16.scale),
                .categories(Self.mockCategories()),
                .offset(30.scale),
                .newReleasesTitle("ForYou.NewReleases".localized),
                .offset(16.scale),
                .books(Self.mockBooks())
            ]
            
            return .just(result)
        }
    }
}

// MARK: TODO
private extension ForYouViewModel {
    static func mockBooks() -> [Book] {
        [
            mockBook(),
            mockBook(),
            mockBook(),
            mockBook(),
            mockBook(),
            mockBook(),
            mockBook(),
            mockBook(),
            mockBook()
        ]
    }
    
    static func mockBook() -> Book {
        let b1 = Book(id: Int.random(in: 1...100000),
                      name: "Thinking Fast and Slow",
                      author: "Daniel Kahneman",
                      image: URL(string: "https://artworld.ru/images/cms/content/catalog3/rodriguez_kartina_maslom_sinie_gory_jr220117.jpeg")!)
        
        let b2 = Book(id: Int.random(in: 1...100000),
                      name: "Be a Free Range Human",
                      author: "Ms. Freacky",
                      image: URL(string: "https://shopudachi.ru/catalog/kartina_po_nomeram_tsvetnoy_mg2054_malenkaya_balerina.html")!)
        
        let b3 = Book(id: Int.random(in: 1...100000),
                      name: "The Law of Success",
                      author: "Napoleon Hill",
                      image: URL(string: "https://www.theartnewspaper.ru/media/images/2_gWojpO8.width-1290.png")!)
        
        let b4 = Book(id: Int.random(in: 1...100000),
                      name: "Unlimited Memory",
                      author: "Grandmaster Kevin Horsley",
                      image: URL(string: "https://media.istockphoto.com/photos/the-dog-on-white-background-double-exposure-monochrome-picture-picture-id514111732?s=612x612")!)
        
        return [b1, b2, b3, b4].randomElement()!
    }
    
    static func mockChallenges() -> [Challenge] {
        [
            mockChallenge(),
            mockChallenge(),
            mockChallenge(),
            mockChallenge(),
            mockChallenge()
        ]
    }
    
    static func mockChallenge() -> Challenge {
        Challenge(id: Int.random(in: 1...100000),
                           name: "40 day challenge",
                           title: "Self-confidence",
                           image: URL(string: "https://cdn2.relax-fm.ru/proxy/vardata/modules/news/files/1/253/news_file_253_5d30b6388af21.jpg?w=800&h=634&t=1563473038")!)
    }
    
    static func mockCategories() -> [Category] {
        [
            mockCategory(),
            mockCategory(),
            mockCategory(),
            mockCategory(),
            mockCategory(),
            mockCategory(),
            mockCategory(),
            mockCategory()
        ]
    }
    
    static func mockCategory() -> Category {
        return Category(id: Int.random(in: 1...100000),
                        name: "Romance",
                        image: URL(string: "https://cdn2.relax-fm.ru/proxy/vardata/modules/news/files/1/253/news_file_253_5d30b6388af21.jpg?w=800&h=634&t=1563473038")!)
    }
}
