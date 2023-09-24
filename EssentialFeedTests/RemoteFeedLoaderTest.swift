//
//  RemoteFeedLoaderTest.swift
//  EssentialFeedTests
//
//  Created by Saranya Ravi on 23/09/2023.
//

import XCTest
@testable import EssentialFeed

class RemoteFeedLoaderTest: XCTestCase {
    
    func test_init_doesNotRequestDataFromURL() {
        let (_, client) = makeSut()
        XCTAssertTrue(client.requestedURLs.isEmpty)
    }
    
    func test_load_requestDataFromURL() {
        let url = URL(string: "http://aurl.com")!
        let (sut, client) = makeSut(url: url)
        sut.load { _ in }
        XCTAssertEqual(client.requestedURLs, [url])
    }
    
    func test_loadtwice_requestDataFromURLTwice() {
        let url = URL(string: "http://aurl.com")!
        let (sut, client) = makeSut(url: url)
        sut.load { _ in }
        sut.load { _ in }

        XCTAssertEqual(client.requestedURLs, [url, url])
    }
    
    func test_loadDeliversErrorOnClientError() {
        let (sut, client) = makeSut()
        let clientError = NSError(domain: "Test", code: 0)
        var capturedErrors =  [RemoteFeedLoader.Error]()
        sut.load { capturedErrors.append($0) }
        client.complete(with: clientError)
        XCTAssertEqual(capturedErrors, [.connectivity])
    }
    
    func test_loadDataDeviversInvalidDataError() {
        let (sut, client) = makeSut()
        var capturedErrors =  [RemoteFeedLoader.Error]()
        sut.load { capturedErrors.append($0) }
        client.complete(withStatusCode: 400)
        XCTAssertEqual(capturedErrors, [.invalidData])
    }
    
    // MARK: Helpers
    
    private func makeSut(url: URL = URL(string: "http://aurl.com")!) -> (sut: RemoteFeedLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteFeedLoader(url: url, client: client)
        return (sut, client)
    }
    
    private class HTTPClientSpy: HTTPClient {
        var requestedURLs: [URL] {
            return messages.map { $0.url }
        }
                 
        private var messages = [(url: URL, completion: (Error?, HTTPURLResponse?) -> Void)]()
        func get(from url: URL, completion: @escaping (Error?, HTTPURLResponse?) -> Void) {
            messages.append((url, completion))
        }
        
        func complete(with error: Error, at index: Int = 0) {
            messages[index].completion(error, nil)
        }
        
        func complete(withStatusCode code: Int, at index: Int = 0) {
            let response = HTTPURLResponse(url: requestedURLs[index],
                                           statusCode: code,
                                           httpVersion: nil,
                                           headerFields: nil)
            messages[index].completion(nil, response)
        }
    }
}
