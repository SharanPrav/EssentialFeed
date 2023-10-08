//
//  FeedLoader.swift
//  EssentialFeed
//
//  Created by Saranya Ravi on 23/09/2023.
//

import Foundation

enum  LoadFeedResult<Error: Swift.Error> {
    case success([FeedItem])
    case failure(Error)
}

protocol FeedLoader {
    associatedtype Error: Swift.Error
    func load(completion: @escaping (LoadFeedResult<Error>) -> Void)
}
