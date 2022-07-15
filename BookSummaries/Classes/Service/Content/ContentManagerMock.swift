//
//  ContentManagerMock.swift
//  BookSummaries
//
//  Created by Андрей Чернышев on 13.07.2022.
//

import RxSwift
import Foundation

// TODO: Удалить после интеграциия с бэком
final class ContentManagerMock: ContentManagerProtocol {
    enum Constants {
        static let readingBooksKey = "content_manager_reading_books_key"
    }
    
    static let imageUrls = [
        URL(string: "https://cdn1.ozone.ru/multimedia/1007119597.jpg")!,
        URL(string: "https://s0.rbk.ru/v6_top_pics/media/img/3/16/755954419776163.jpg")!,
        URL(string: "https://storage.yvision.kz/images/user/creepy_neko/E96lKtOC8HgN4r77z66axAAFMn9l3I.jpg")!
    ]
    
    static let avatarUrls = [
        URL(string: "https://cdn.culture.ru/images/bae1a8d2-ab58-5ed2-9388-38a8b9a4232d/w_388,h_504,c_fill,g_center/6587b85db05cba9b3dd3bd9b9588b065.jpg")!,
        URL(string: "https://static.wikia.nocookie.net/writers/images/f/ff/Aleksander_Puszkin.jpg/revision/latest/scale-to-width-down/631?cb=20071205045233&path-prefix=ru")!,
        URL(string: "https://gorky.media/wp-content/uploads/2016/09/nitsshe.jpg")!
    ]
    
    static let booksCovers: [BookCover] = [
        .init(id: Int.random(in: 1...10),
              name: "Unlimited Memory",
              author: Author(name: "Grandmaster Kevin Horsley",
                             photoUrl: avatarUrls.randomElement()!),
              imageUrl: imageUrls.randomElement()!,
              rankingId: 1),
        .init(id: Int.random(in: 1...10),
              name: "The Law of Success",
              author: Author(name: "Napoleon Hill",
                             photoUrl: avatarUrls.randomElement()!),
              imageUrl: imageUrls.randomElement()!,
              rankingId: 1),
        .init(id: Int.random(in: 1...10),
              name: "Breath",
              author: Author(name: "James Nestor",
                             photoUrl: avatarUrls.randomElement()!),
              imageUrl: imageUrls.randomElement()!,
              rankingId: 1),
        .init(id: Int.random(in: 1...10),
              name: "Unlimited Memory",
              author: Author(name: "Ms. Freacky",
                             photoUrl: avatarUrls.randomElement()!),
              imageUrl: imageUrls.randomElement()!,
              rankingId: 1)
    ]
    
    static let chapterText = "What most of the self-help advice we get on life does is help us fivate on what we lack. They pinpoint the things we see as our personal pailures and shortcomings and emphasize them for us. If you feel you’re not beautiful enough, you stand in front of the mirror and repeat affirmations that you’re beautiful.\n\nSociety keeps telling us to be more, more, and more positive all the time. And to be positive all the time, we are constantly getting the same message again and again, which is to give a fuck about everything, again and again. Sadly, giving more fuck doesn’t guarantee you to be positive and live a better life.\n\nWhat most of the self-help advice we get on life does is help us fivate on what we lack. They pinpoint the things we see as our personal pailures and shortcomings and emphasize them for us. If you feel you’re not beautiful enough, you stand in front of the mirror and repeat affirmations that you’re beautiful.\n\nSociety keeps telling us to be more, more, and more positive all the time. And to be positive all the time, we are constantly getting the same message again and again, which is to give a fuck about everything, again and again. Sadly, giving more fuck doesn’t guarantee you to be positive and live a better life."
}

// MARK: Public
extension ContentManagerMock {
    func obtainCategories(forceUpdate: Bool) -> Single<[Category]> {
        Single<[Category]>
            .create { event in
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    let array: [Category] = [
                        .init(id: 1, name: "Romance", imageUrl: Self.imageUrls.randomElement()!),
                        .init(id: 2, name: "Thriller", imageUrl: Self.imageUrls.randomElement()!),
                        .init(id: 3, name: "Psyhchology", imageUrl: Self.imageUrls.randomElement()!),
                        .init(id: 4, name: "Detectiv", imageUrl: Self.imageUrls.randomElement()!),
                        .init(id: 5, name: "Lirika", imageUrl: Self.imageUrls.randomElement()!)
                    ]
                    
                    let success = [true, true, true].randomElement()!

                    success ? event(.success(array)) : event(.failure(SignError.tokenNotFound))
                }
                
                return Disposables.create()
            }
    }
    
    func obtainRankings(forceUpdate: Bool) -> Single<[Ranking]> {
        Single<[Ranking]>
            .create { event in
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    let array: [Ranking] = [
                        .init(id: 1, name: "Top reads of 2021"),
                        .init(id: 2, name: "Top new releases"),
                        .init(id: 3, name: "Top Psyhchology"),
                        .init(id: 4, name: "May be like"),
                        .init(id: 5, name: "Top reads of 2022"),
                        .init(id: 6, name: "Bestseller")
                    ]
                    
                    let success = [true, true, true].randomElement()!

                    success ? event(.success(array)) : event(.failure(SignError.tokenNotFound))
                }
                
                return Disposables.create()
            }
    }
    
    func obtainBookKit(bookId: Int) -> Single<BookKit?> {
        Single<BookKit?>
            .create { event in
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    func chapter() -> BookChapter {
                        BookChapter(shortDescription: "Self-employment makes a lot more sense when you reaize that there;s no such thing as a secure job anymore \(Int.random(in: 1...100000000))",
                                                  title: "Don’t try to be somebody you’re not; be very selective with what to give a fuck about",
                                                  text: Self.chapterText)
                    }
                    
                    let book = Book(id: Int.random(in: 1...10),
                                    name: "Unlimited Memory",
                                    imageUrl: Self.imageUrls.randomElement()!,
                                    author: Author(name: "Napoleon Hill",
                                                   photoUrl: Self.avatarUrls.randomElement()!),
                                    rankingId: 1,
                                    time: 13,
                                    audioUrl: URL(string: "http://commondatastorage.googleapis.com/codeskulptor-demos/DDR_assets/Kangaroo_MusiQue_-_The_Neverwritten_Role_Playing_Game.mp3")!,
                                    shareLink: URL(string: "http://commondatastorage.googleapis.com/codeskulptor-demos/DDR_assets/Kangaroo_MusiQue_-_The_Neverwritten_Role_Playing_Game.mp3")!,
                                    isSaved: Bool.random(),
                                    introduction: BookChapter(shortDescription: "",
                                                              title: "Introduction",
                                                              text: Self.chapterText),
                                    chapters: [chapter(), chapter(), chapter(), chapter(), chapter(), chapter(), chapter(), chapter(), chapter(), chapter(), chapter()],
                                    whatAbout: "Have you ever imagined that you travel into the comic? Who is the main you most want to meet? My favorite hero is such a person!?")
                    
                    let kit = BookKit(book: book,
                                      similarBooks: Self.booksCovers)
                    
                    let success = [true, true, true].randomElement()!

                    success ? event(.success(kit)) : event(.failure(SignError.tokenNotFound))
                }
                
                return Disposables.create()
            }
    }
    
    func obtainForYouKit() -> Single<ForYouKit?> {
        Single<ForYouKit?>
            .create { event in
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    let kit = ForYouKit(freeBook: Self.booksCovers.randomElement()!,
                                        todaysHotSummaries: Self.booksCovers,
                                        challenges: [
                                            .init(id: 1, name: "40 day challenge", title: "Self-confidence", imageUrl: Self.imageUrls.randomElement()!),
                                            .init(id: 2, name: "40 day challenge", title: "Self-confidence", imageUrl: Self.imageUrls.randomElement()!),
                                            .init(id: 3, name: "40 day challenge", title: "Self-confidence", imageUrl: Self.imageUrls.randomElement()!),
                                            .init(id: 4, name: "40 day challenge", title: "Self-confidence", imageUrl: Self.imageUrls.randomElement()!)
                                        ],
                                        youMayLike: Self.booksCovers,
                                        rankings: [
                                            .init(rankingId: 1, books: Self.booksCovers),
                                            .init(rankingId: 2, books: Self.booksCovers)
                                        ])
                    
                    let success = [true, true, true].randomElement()!

                    success ? event(.success(kit)) : event(.failure(SignError.tokenNotFound))
                }
                
                return Disposables.create()
            }
    }
    
    func save(bookId: Int) -> Single<Bool> {
        Single<Bool>
            .create { event in
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    let success = [true, true, true].randomElement()!

                    success ? event(.success(true)) : event(.failure(SignError.tokenNotFound))
                }
                
                return Disposables.create()
            }
    }
    
    func removeSaved(bookId: Int) -> Single<Bool> {
        Single<Bool>
            .create { event in
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    let success = [true, true, true].randomElement()!

                    success ? event(.success(true)) : event(.failure(SignError.tokenNotFound))
                }
                
                return Disposables.create()
            }
    }
    
    func obtainSavedBooksCover() -> Single<[BookCover]> {
        Single<[BookCover]>
            .create { event in
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    let array = Self.booksCovers
                    
                    let success = [true, true, true, false].randomElement()!

                    success ? event(.success(array)) : event(.failure(SignError.tokenNotFound))
                }
                
                return Disposables.create()
            }
    }
    
    func obtainExploreKit() -> Single<ExploreKit?> {
        Single<ExploreKit?>
            .create { event in
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    let kit = ExploreKit(trendingSearches: Self.booksCovers,
                                         popularRequests: ["Character", "Why does my brain do this", "Wellbeing", "Emotions", "How do I prioritize myself?"])
                    
                    let success = [true, true, true, false].randomElement()!

                    success ? event(.success(kit)) : event(.failure(SignError.tokenNotFound))
                }
                
                return Disposables.create()
            }
    }
    
    func searchBooks(at: String) -> Single<[BookCover]> {
        Single<[BookCover]>
            .create { event in
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    let array = Self.booksCovers
                    
                    let success = [true, true, true, false].randomElement()!

                    success ? event(.success(array)) : event(.failure(SignError.tokenNotFound))
                }
                
                return Disposables.create()
            }
    }
    
    func obtainCategoryBooksCover(categoryId: Int) -> Single<[BookCover]> {
        Single<[BookCover]>
            .create { event in
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    let array = Self.booksCovers
                    
                    let success = [true, true, true, false].randomElement()!

                    success ? event(.success(array)) : event(.failure(SignError.tokenNotFound))
                }
                
                return Disposables.create()
            }
    }
    
    func obtainRankingBooksCover(rankingId: Int) -> Single<[BookCover]> {
        Single<[BookCover]>
            .create { event in
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    let array = Self.booksCovers
                    
                    let success = [true, true, true, false].randomElement()!

                    success ? event(.success(array)) : event(.failure(SignError.tokenNotFound))
                }
                
                return Disposables.create()
            }
    }
    
    func obtainReadingBooks() -> Single<[BookReadingProgress]> {
        Single<[BookReadingProgress]>.create { event in
            guard
                let data = UserDefaults.standard.data(forKey: Constants.readingBooksKey),
                let books = try? JSONDecoder().decode([BookReadingProgress].self, from: data)
            else {
                event(.success([]))
                return Disposables.create()
            }
            
            event(.success(books))
            
            return Disposables.create()
        }
    }
    
    func set(bookReadingProgress: BookReadingProgress) -> Single<Void> {
        obtainReadingBooks()
            .flatMap { readingBooks -> Single<Void> in
                Single<Void>.create { event in
                    var result = readingBooks
                    
                    if let index = result.firstIndex(where: { $0.book.id == bookReadingProgress.book.id }) {
                        result[index] = bookReadingProgress
                    } else {
                        result.append(bookReadingProgress)
                    }
                    
                    if let data = try? JSONEncoder().encode(result) {
                        UserDefaults.standard.set(data, forKey: Constants.readingBooksKey)
                        
                        ContentMediator.shared.notifyAboutUpdate(bookReadingProgress: bookReadingProgress)
                    }
                    
                    event(.success(Void()))
                    
                    return Disposables.create()
                }
            }
    }
}
