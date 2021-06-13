//
//  RSSFeed + Extension.swift
//  ApplePodcastClone
//
//  Created by Rishabh Dubey on 12/06/21.
//

import Foundation
import FeedKit

extension RSSFeed {
    
    func toEpisodes() -> [Episode] {
        let imageUrl = iTunes?.iTunesImage?.attributes?.href
        
        var episodes = [Episode]()
        items?.forEach({ (item) in
            var episode = Episode(feedItem: item)
            
            if imageUrl == nil {
                episode.imageUrl = imageUrl
            }
            episodes.append(episode)
        })
        
        return episodes
    }
}
