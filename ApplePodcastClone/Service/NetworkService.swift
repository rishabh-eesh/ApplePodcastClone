//
//  NetworkService.swift
//  ApplePodcastClone
//
//  Created by Rishabh Dubey on 01/06/21.
//

import Foundation

protocol Networking {
    func execute<T: Decodable>(requestProvider: RequestProviding, completion: @escaping (T?, Error?) -> ())
}

class NetworkService: Networking {
    
    static let shared = NetworkService()
    
    func execute<T: Decodable>(requestProvider: RequestProviding, completion: @escaping (T?, Error?) -> ()) {
//        guard let url = requestProvider.urlRequest else { return }
        URLSession.shared.dataTask(with: requestProvider.create()) { (data, response, error) in
            if let error = error {
                completion(nil, error)
                return
            }
            
            //success
            guard let data = data else { return }
            
            do {
                let objects = try JSONDecoder().decode(T.self, from: data)
                completion(objects, nil)
            } catch let error {
                completion(nil, error)
            }
        }.resume()
    }
}

//MARK: - EndPoints
///https://itunes.apple.com/search?term=garyvee&media=podcast

enum APIError: Error {
    case requestFailed
    case jsonConversionFailure
    case invalidData
    case responseUnsuccessful
    case jsonParsingFailure
    var localizedDescription: String {
        switch self {
        case .requestFailed: return "Request Failed"
        case .invalidData: return "Invalid Data"
        case .responseUnsuccessful: return "Response Unsuccessful"
        case .jsonParsingFailure: return "JSON Parsing Failure"
        case .jsonConversionFailure: return "JSON Conversion Failure"
        }
    }
}
