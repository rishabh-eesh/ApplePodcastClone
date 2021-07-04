//
//  EpisodesViewModel.swift
//  ApplePodcastClone
//
//  Created by Rishabh Dubey on 12/06/21.
//

import Foundation
import FeedKit

class EpisodesViewModel {
    
    private(set) var episodes = Bindable<[Episode]>()
    
    init(feedUrl: String?) {
        guard let url = feedUrl else { return }
        
        fetchEpisodes(feedUrl: url)
    }
    
    func fetchEpisodes(feedUrl: String) {
        guard let url = URL(string: feedUrl.toSecureHTTPS()) else { return }
        DispatchQueue.global(qos: .background).async {
            let parser = FeedParser(URL: url)
            parser.parseAsync { (result) in
                switch result {
                case .success(let feed):
                    guard let rssFeed = feed.rssFeed else { return }
                    self.episodes.value = rssFeed.toEpisodes()
                case .failure(let error):
                    debugPrint("Failed to get feed: ", error.localizedDescription)
                }
            }
        }
    }
}
