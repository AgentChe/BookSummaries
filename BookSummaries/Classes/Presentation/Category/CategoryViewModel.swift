//
//  CategoryViewModel.swift
//  BookSummaries
//
//  Created by Андрей Чернышев on 11.07.2022.
//

import RxSwift
import RxCocoa

final class CategoryViewModel {
    var tryAgain: ((Error) -> (Observable<Void>))?
    
    lazy var elements = makeElements()
    lazy var activity = RxActivityIndicator()
    
    private lazy var observableRetrySingle = ObservableRetrySingle()
}

// MARK: Private
private extension CategoryViewModel {
    func makeElements() -> Driver<[BookBrochure]> {
        .deferred {
            .just([
                .init(id: 1,
                      name: "The Miracle Morning",
                      author: "Stephen Guise",
                      image: URL(string: "https://artworld.ru/images/cms/content/catalog3/rodriguez_kartina_maslom_sinie_gory_jr220117.jpeg")!),
                .init(id: 1,
                      name: "The Miracle Morning",
                      author: "Stephen Guise",
                      image: URL(string: "https://artworld.ru/images/cms/content/catalog3/rodriguez_kartina_maslom_sinie_gory_jr220117.jpeg")!),
                .init(id: 1,
                      name: "The Miracle Morning",
                      author: "Stephen Guise",
                      image: URL(string: "https://artworld.ru/images/cms/content/catalog3/rodriguez_kartina_maslom_sinie_gory_jr220117.jpeg")!),
                .init(id: 1,
                      name: "The Miracle Morning",
                      author: "Stephen Guise",
                      image: URL(string: "https://artworld.ru/images/cms/content/catalog3/rodriguez_kartina_maslom_sinie_gory_jr220117.jpeg")!),
                .init(id: 1,
                      name: "The Miracle Morning",
                      author: "Stephen Guise",
                      image: URL(string: "https://artworld.ru/images/cms/content/catalog3/rodriguez_kartina_maslom_sinie_gory_jr220117.jpeg")!),
                .init(id: 1,
                      name: "The Miracle Morning",
                      author: "Stephen Guise",
                      image: URL(string: "https://artworld.ru/images/cms/content/catalog3/rodriguez_kartina_maslom_sinie_gory_jr220117.jpeg")!),
                .init(id: 1,
                      name: "The Miracle Morning",
                      author: "Stephen Guise",
                      image: URL(string: "https://artworld.ru/images/cms/content/catalog3/rodriguez_kartina_maslom_sinie_gory_jr220117.jpeg")!),
                .init(id: 1,
                      name: "The Miracle Morning",
                      author: "Stephen Guise",
                      image: URL(string: "https://artworld.ru/images/cms/content/catalog3/rodriguez_kartina_maslom_sinie_gory_jr220117.jpeg")!),
                .init(id: 1,
                      name: "The Miracle Morning",
                      author: "Stephen Guise",
                      image: URL(string: "https://artworld.ru/images/cms/content/catalog3/rodriguez_kartina_maslom_sinie_gory_jr220117.jpeg")!),
                .init(id: 1,
                      name: "The Miracle Morning",
                      author: "Stephen Guise",
                      image: URL(string: "https://artworld.ru/images/cms/content/catalog3/rodriguez_kartina_maslom_sinie_gory_jr220117.jpeg")!),
                .init(id: 1,
                      name: "The Miracle Morning",
                      author: "Stephen Guise",
                      image: URL(string: "https://artworld.ru/images/cms/content/catalog3/rodriguez_kartina_maslom_sinie_gory_jr220117.jpeg")!),
                .init(id: 1,
                      name: "The Miracle Morning",
                      author: "Stephen Guise",
                      image: URL(string: "https://artworld.ru/images/cms/content/catalog3/rodriguez_kartina_maslom_sinie_gory_jr220117.jpeg")!)
            ])
        }
    }
}
