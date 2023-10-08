//
//  RemoteFeedLoader.swift
//  EssentialFeed
//
//  Created by Saranya Ravi on 23/09/2023.
//

import Foundation

internal final class RemoteFeedLoader {
    private let url: URL
    private let client: HTTPClient

    public enum Error: Swift.Error {
        case connectivity
        case invalidData
    }
    
    public typealias Result = LoadFeedResult<Error>
    
    public init(url: URL, client: HTTPClient) {
        self.client = client
        self.url = url
    }

    func load(completion: @escaping (Result) -> Void) {
        client.get(from: url) {[weak self] result in
            guard self != nil else {
                return
            }
            
            switch result {
            case let .success(data, response):
                completion(FeedItemsMapper.map(data, response))
            case .failure:
                completion(.failure(.connectivity))
            }
        }
    }
}


