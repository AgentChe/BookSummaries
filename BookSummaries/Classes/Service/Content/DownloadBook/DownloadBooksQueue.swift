//
//  DownloadBooksQueue.swift
//  BookSummaries
//
//  Created by Андрей Чернышев on 20.07.2022.
//

final class DownloadBooksQueue {
    static let shared = DownloadBooksQueue()
    
    private init() {}
    
    var operations = [Int: DownloadBookOperation]()
}

// MARK: Public
extension DownloadBooksQueue {
    func download(book: Book, completion: @escaping ((LocalBook?) -> Void)) {
        let key = book.id
        
        let operation = DownloadBookOperation(book: book)
        operations[key] = operation
        
        operation.download { [weak self] result in
            self?.operations.removeValue(forKey: key)
            
            completion(result)
        }
    }
}
