//
//  BookDownloadObserver.swift
//  BookSummaries
//
//  Created by Андрей Чернышев on 21.07.2022.
//

final class BookDownloadObserver: DownloadBookDelegate {
    var progress: ((Book, Float) -> Void)?
    
    func download(book: Book, percentDownloaded: Float) {
        progress?(book, percentDownloaded)
    }
}
