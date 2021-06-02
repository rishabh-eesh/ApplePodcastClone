//
//  Podcast.swift
//  ApplePodcastClone
//
//  Created by Rishabh Dubey on 01/06/21.
//

import Foundation

struct SearchResults: Decodable {
    let resultCount: Int
    let results: [Podcast]
}

struct Podcast: Decodable {
    let artistName: String?
    let trackName: String?
}
