//
//  LocalBook.swift
//  BookSummaries
//
//  Created by Андрей Чернышев on 20.07.2022.
//

import Foundation

struct LocalBook: Codable, Hashable {
    let original: Book
    let local: Book // копия оригинального объекта, но с урл на локальный загруженный файл
    
    init(original: Book, localAudioURL: URL) {
        self.original = original
        self.local = Book(id: original.id,
                          name: original.name,
                          imageUrl: original.imageUrl,
                          author: original.author,
                          rankingId: original.rankingId,
                          time: original.time,
                          audioUrl: localAudioURL,
                          shareLink: original.shareLink,
                          isSaved: original.isSaved,
                          introduction: original.introduction,
                          chapters: original.chapters,
                          whatAbout: original.whatAbout)
    }
}
