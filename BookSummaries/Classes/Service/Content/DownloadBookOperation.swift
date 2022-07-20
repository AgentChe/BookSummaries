//
//  DownloadBookOperation.swift
//  BookSummaries
//
//  Created by Андрей Чернышев on 20.07.2022.
//

import Kingfisher
import Foundation

final class DownloadBookOperation {
    private let book: Book
    
    private var completion: ((LocalBook?) -> Void)?
    
    private var imageCached: Bool?
    private var audioCached: (Bool, URL?)?
    
    init(book: Book) {
        self.book = book
    }
}

// MARK: Public
extension DownloadBookOperation {
    func download(completion: @escaping (LocalBook?) -> Void) {
        self.completion = completion
        
        cacheBookImage()
        cacheBookAudio()
    }
}

// MARK: Private
private extension DownloadBookOperation {
    func cacheBookImage() {
        KingfisherManager.shared.retrieveImage(with: book.imageUrl, completionHandler: { [weak self] result in
            switch result {
            case .success:
                self?.imageCached = true
            case .failure:
                self?.imageCached = false
            }
            
            self?.checkup()
        })
    }
    
    func cacheBookAudio() {
        guard let directoryUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            audioCached = (false, nil)
            checkup()
            return
        }
        
        let destinationUrl = directoryUrl.appendingPathComponent(book.audioUrl.lastPathComponent)
        
        guard !FileManager.default.fileExists(atPath: destinationUrl.path) else {
            audioCached = (true, destinationUrl)
            checkup()
            return
        }
        
        URLSession.shared.downloadTask(with: book.audioUrl) { [weak self] (location, response, error) in
            guard let location = location, error == nil else {
                self?.audioCached = (false, nil)
                self?.checkup()
                return
            }
            
            do {
                try FileManager.default.moveItem(at: location, to: destinationUrl)
                
                self?.audioCached = (true, destinationUrl)
                self?.checkup()
            } catch {
                self?.audioCached = (false, nil)
                self?.checkup()
            }
        }.resume()
    }
    
    func checkup() {
        guard let imageCached = imageCached, let audioCached = audioCached else {
            return
        }
        
        if imageCached, audioCached.0, let audioUrl = audioCached.1 {
            let localBook = LocalBook(original: book, localAudioURL: audioUrl)
            completion?(localBook)
        } else {
            completion?(nil)
        }
    }
}
