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
        sut.load()
        XCTAssertEqual(client.requestedURLs, [url])
    }
    
    func test_loadtwice_requestDataFromURLTwice() {
        let url = URL(string: "http://aurl.com")!
        let (sut, client) = makeSut(url: url)
        sut.load()
        sut.load()

        XCTAssertEqual(client.requestedURLs, [url, url])
    }
    
    func test_loadDeliversErrorOnClientError() {
        let (sut, client) = makeSut()
        client.error = NSError(domain: "Test", code: 0)
        var capturedError: RemoteFeedLoader.Error?
        sut.load { error in capturedError = error }
        XCTAssertEqual(capturedError, .connectivity)
    }
    
    // MARK: Helpers
    
    private func makeSut(url: URL = URL(string: "http://aurl.com")!) -> (sut: RemoteFeedLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteFeedLoader(url: url, client: client)
        return (sut, client)
    }
    
    private class HTTPClientSpy: HTTPClient {
        var requestedURLs = [URL]()
        var error: Error?
         
        func get(from url: URL, completion: @escaping (Error) -> Void) {
            if let error = error {
                completion(error)
            }
            requestedURLs.append(url)
        }
    }
}
