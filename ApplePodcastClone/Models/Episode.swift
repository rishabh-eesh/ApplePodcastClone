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
    let author: String
    var imageUrl: String?
    var streamUrl: String
    
    init(feedItem: RSSFeedItem) {
        self.title = feedItem.title ?? ""
        self.pubDate = feedItem.pubDate ?? Date()
        self.description = feedItem.iTunes?.iTunesSubtitle ?? feedItem.description ?? ""
        self.author = feedItem.iTunes?.iTunesAuthor ?? ""
        self.imageUrl = feedItem.iTunes?.iTunesImage?.attributes?.href
        self.streamUrl = feedItem.enclosure?.attributes?.url ?? ""
    }
    
    var episodeUrl: URL? {
        return URL(string: imageUrl?.toSecureHTTPS() ?? "")
    }
    
    var streamAudioUrl: URL? {
        return URL(string: streamUrl)
    }
}
