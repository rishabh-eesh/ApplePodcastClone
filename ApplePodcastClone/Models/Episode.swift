//
//  pisode.swift
//  ApplePodcastClone
//
//  Created by Rishabh Dubey on 12/06/21.
//

import Foundation
import FeedKit

struct Episode {
    let title: String
    let pubDate: Date
    let description: String
    var imageUrl: String?
    
    init(feedItem: RSSFeedItem) {
        self.title = feedItem.title ?? ""
        self.pubDate = feedItem.pubDate ?? Date()
        self.description = feedItem.description ?? ""
        self.imageUrl = feedItem.iTunes?.iTunesImage?.attributes?.href
    }
    
    var episodeUrl: URL? {
        return URL(string: imageUrl ?? "")
    }
}
