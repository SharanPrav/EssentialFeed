//
//  RemoteFeedLoaderTest.swift
//  EssentialFeedTests
//
//  Created by Saranya Ravi on 23/09/2023.
//

import XCTest

class RemoteFeedLoader {
    func load() {
        HTTPClient.shared.requestedURL = URL(string: "http://aurl.com")
    }
}

class HTTPClient {
    static let shared = HTTPClient()
     
    private init() {}
    
    var requestedURL: URL?
}

class RemoteFeedLoaderTest: XCTestCase {
    
    func test_init_doesNotRequestDataFromURL() {
        let client = HTTPClient.shared
        let sut = RemoteFeedLoader()
        XCTAssertNil(client.requestedURL)
    }
    
    func test_load_requestDataFromURL() {
        let client = HTTPClient.shared
        let sut = RemoteFeedLoader()
        
        sut.load()
        
        XCTAssertNotNil(client.requestedURL)
    }
}
