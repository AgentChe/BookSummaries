//
//  BookViewModel.swift
//  BookSummaries
//
//  Created by Андрей Чернышев on 11.07.2022.
//

import RxSwift
import RxCocoa

final class BookViewModel {
    lazy var elements = makeElements()
}

// MARK: Private
private extension BookViewModel {
    func makeElements() -> Driver<[BookTableElement]> {
        .deferred {
            let books: [BookBrochure] = [
                BookBrochure(id: 1,
                             name: "Unlimited Memory",
                             author: "Grandmaster Kevin Horsley",
                             image: URL(string: "https://artworld.ru/images/cms/content/catalog3/rodriguez_kartina_maslom_sinie_gory_jr220117.jpeg")!),
                BookBrochure(id: 1,
                             name: "Unlimited Memory",
                             author: "Grandmaster Kevin Horsley",
                             image: URL(string: "https://artworld.ru/images/cms/content/catalog3/rodriguez_kartina_maslom_sinie_gory_jr220117.jpeg")!),
                BookBrochure(id: 1,
                             name: "Unlimited Memory",
                             author: "Grandmaster Kevin Horsley",
                             image: URL(string: "https://artworld.ru/images/cms/content/catalog3/rodriguez_kartina_maslom_sinie_gory_jr220117.jpeg")!),
                BookBrochure(id: 1,
                             name: "Unlimited Memory",
                             author: "Grandmaster Kevin Horsley",
                             image: URL(string: "https://artworld.ru/images/cms/content/catalog3/rodriguez_kartina_maslom_sinie_gory_jr220117.jpeg")!),
                BookBrochure(id: 1,
                             name: "Unlimited Memory",
                             author: "Grandmaster Kevin Horsley",
                             image: URL(string: "https://artworld.ru/images/cms/content/catalog3/rodriguez_kartina_maslom_sinie_gory_jr220117.jpeg")!),
            ]
            
            return .just([
                .bookImage(URL(string: "https://artworld.ru/images/cms/content/catalog3/rodriguez_kartina_maslom_sinie_gory_jr220117.jpeg")!),
                .offset(36.scale),
                .progress(0.4),
                .offset(20.scale),
                .bookName("Be a free range human"),
                .offset(5.scale),
                .authorName("Ms. Freacky"),
                .offset(18.scale),
                .info(BookInfoElement(chaptersCount: 13, min: 13)),
                .offset(30.scale),
                .title("Chapters"),
                .offset(34.scale),
                .introduction,
                .offset(34.scale),
                .chapter(BookChapterElement(chapter: BookChapter(shortDescription: "Self-employment makes a lot more sense when you reaize that there;s no such thing as a secure job anymore",
                                                                 title: "",
                                                                 text: ""),
                                            number: "1")),
                .offset(16.scale),
                .separator,
                .offset(16.scale),
                .chapter(BookChapterElement(chapter: BookChapter(shortDescription: "Self-employment makes a lot more sense when you reaize that there;s no such thing as a secure job anymore",
                                                                 title: "",
                                                                 text: ""),
                                            number: "2")),
                .offset(16.scale),
                .separator,
                .offset(16.scale),
                .chapter(BookChapterElement(chapter: BookChapter(shortDescription: "Self-employment makes a lot more sense when you reaize that there;s no such thing as a secure job anymore",
                                                                 title: "",
                                                                 text: ""),
                                            number: "3")),
                .offset(16.scale),
                .separator,
                .offset(16.scale),
                .chapter(BookChapterElement(chapter: BookChapter(shortDescription: "Self-employment makes a lot more sense when you reaize that there;s no such thing as a secure job anymore",
                                                                 title: "",
                                                                 text: ""),
                                            number: "4")),
                .offset(16.scale),
                .separator,
                .offset(16.scale),
                .chapter(BookChapterElement(chapter: BookChapter(shortDescription: "Self-employment makes a lot more sense when you reaize that there;s no such thing as a secure job anymore",
                                                                 title: "",
                                                                 text: ""),
                                            number: "5")),
                .offset(24.scale),
                .seeAll,
                .offset(30.scale),
                .title("What is it about?"),
                .offset(16.scale),
                .whatAbout("Have you ever imagined that you travel into the comic? Who is the main you most want to meet? My favorite hero is such a person!?"),
                .offset(30.scale),
                .title("Author"),
                .offset(16.scale),
                .author(BookAuthorElement(image: URL(string: "https://artworld.ru/images/cms/content/catalog3/rodriguez_kartina_maslom_sinie_gory_jr220117.jpeg")!,
                                          name: "Ms. Freacky")),
                .offset(46.scale),
                .title("Similar books"),
                .offset(16.scale),
                .books(books),
                .offset(21.scale),
                .title("Explore categories"),
                .offset(16.scale),
                .categories([
                    Category(id: 1,
                             name: "Romance",
                             image: URL(string: "https://artworld.ru/images/cms/content/catalog3/rodriguez_kartina_maslom_sinie_gory_jr220117.jpeg")!),
                    Category(id: 1,
                             name: "Romance",
                             image: URL(string: "https://artworld.ru/images/cms/content/catalog3/rodriguez_kartina_maslom_sinie_gory_jr220117.jpeg")!),
                    Category(id: 1,
                             name: "Romance",
                             image: URL(string: "https://artworld.ru/images/cms/content/catalog3/rodriguez_kartina_maslom_sinie_gory_jr220117.jpeg")!),
                    Category(id: 1,
                             name: "Romance",
                             image: URL(string: "https://artworld.ru/images/cms/content/catalog3/rodriguez_kartina_maslom_sinie_gory_jr220117.jpeg")!),
                    Category(id: 1,
                             name: "Romance",
                             image: URL(string: "https://artworld.ru/images/cms/content/catalog3/rodriguez_kartina_maslom_sinie_gory_jr220117.jpeg")!)
                ])
            ])
        }
    }
}
