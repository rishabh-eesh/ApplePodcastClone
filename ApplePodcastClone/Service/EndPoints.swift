//
//  EndPoints.swift
//  ApplePodcastClone
//
//  Created by Rishabh Dubey on 04/06/21.
//

import Foundation

enum HTTPMethods: String {
    case GET, POST
}

protocol RequestProviding {
    var url: URL { get set }
    func create() -> URLRequest
}

struct Request: RequestProviding {
    var url: URL
    var method: HTTPMethods
    var requestBody: Data? = nil
    
    init(url: URL, method: HTTPMethods, requestBody: Data? = nil) {
        self.url = url
        self.method = method
        self.requestBody = requestBody
    }

    func create() -> URLRequest {
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        urlRequest.httpBody = requestBody
        urlRequest.addValue("application/json", forHTTPHeaderField: "content-type")
        return urlRequest
    }
}

struct EndPoint {
    let path: String
    let queryItems: [URLQueryItem]?
}

extension EndPoint {
    var url: URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "itunes.apple.com"
        components.path = path
        components.queryItems = queryItems
        return components.url ?? URL(string: "")!
    }
}

extension EndPoint {
    // Search Podcast
    static func search(matching query: String) -> EndPoint {
        return EndPoint(path: "/search", queryItems: [
            .init(name: "term", value: query),
            .init(name: "media", value: "podcast")
        ])
    }
}
