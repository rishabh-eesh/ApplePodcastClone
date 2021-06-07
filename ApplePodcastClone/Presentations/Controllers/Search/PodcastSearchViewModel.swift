//
//  PodcastSearchViewModel.swift
//  ApplePodcastClone
//
//  Created by Rishabh Dubey on 01/06/21.
//

import UIKit

protocol SearchViewModelDelegate: class {
    var searchText: String? { get set }
    func fetchSearchResults(searchText: String)
}

class PodcastSearchViewModel: SearchViewModelDelegate {
    
    var searchText: String? {
        didSet {
            fetchSearchResults(searchText: searchText ?? "")
        }
    }
    
    private var service: Networking
    
    private(set) var podcasts = Bindable<[Podcast]>()
    
    init(service: Networking) {
        self.service = service
    }
    
    func fetchSearchResults(searchText: String) {
        let endPoint = EndPoint.search(matching: searchText)
        let request = Request(url: endPoint.url, method: .GET)
        service.execute(requestProvider: request) { (results: SearchResults?, error) in
            if let error = error {
                print("Failed to get search data: ", error)
                return
            }
            
            //success
            guard let searchResults = results else { return }
            self.podcasts.value = searchResults.results
        }
    }
}
