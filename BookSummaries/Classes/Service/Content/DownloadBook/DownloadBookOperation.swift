//
//  DownloadBookOperation.swift
//  BookSummaries
//
//  Created by Андрей Чернышев on 20.07.2022.
//

import Kingfisher
import Foundation

protocol DownloadBookDelegate: AnyObject {
    func download(book: Book, percentDownloaded: Float)
}

final class DownloadBookOperation: NSObject {
    weak var delegate: DownloadBookDelegate?
    
    private let book: Book
    
    private var completion: ((LocalBook?) -> Void)?
    
    private var imageCached: Bool?
    private var audioCached: (Bool, URL?)?
    
    private var downloadTask: URLSessionDownloadTask?
    
    private var destinationUrl: URL? {
        guard let directoryUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return nil
        }
        
        return directoryUrl.appendingPathComponent(book.audioUrl.lastPathComponent)
    }
    
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
    
    func stop() {
        downloadTask?.cancel()
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
        guard let destinationUrl = destinationUrl else {
            audioCached = (false, nil)
            checkup()
            return
        }
        
        guard !FileManager.default.fileExists(atPath: destinationUrl.path) else {
            audioCached = (true, destinationUrl)
            checkup()
            return
        }
        
        let configuration = URLSessionConfiguration.default
        let operationQueue = OperationQueue.main
        let session = URLSession(configuration: configuration, delegate: self, delegateQueue: operationQueue)
            
        downloadTask = session.downloadTask(with: book.audioUrl)
        downloadTask?.resume()
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

// MARK: URLSessionDownloadDelegate
extension DownloadBookOperation: URLSessionDownloadDelegate {
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        guard let destinationUrl = destinationUrl else {
            audioCached = (false, nil)
            checkup()
            return
        }
        
        do {
            try FileManager.default.moveItem(at: location, to: destinationUrl)
            
            audioCached = (true, destinationUrl)
            checkup()
        } catch {
            audioCached = (false, nil)
            checkup()
        }
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        if error != nil {
            audioCached = (false, nil)
            checkup()
        }
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        let percentDownloaded = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite) * 100
        delegate?.download(book: book, percentDownloaded: percentDownloaded)
    }
}
