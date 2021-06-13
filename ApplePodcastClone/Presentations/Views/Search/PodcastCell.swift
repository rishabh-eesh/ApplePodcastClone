//
//  PodcastCell.swift
//  ApplePodcastClone
//
//  Created by Rishabh Dubey on 02/06/21.
//

import UIKit

class PodcastCell: UITableViewCell {
    
    let podcastImageView = UIImageView(cornerRadius: 14, contentMode: .scaleAspectFit)
    let artistNameLabel = UILabel(text: "Artist name", font: .systemFont(ofSize: 16), numberOfLines: 2)
    let trackNameLabel = UILabel(text: "Track name", font: .systemFont(ofSize: 14), textColor: .darkGray, numberOfLines: 2)
    let trackCountLabel = UILabel(text: "No. of tracks", font: .boldSystemFont(ofSize: 13), textColor: .gray)
    
    override class func description() -> String {
        String(describing: self)
    }
    
    var podcast: Podcast! {
        didSet {
            artistNameLabel.text = podcast.artistName
            trackNameLabel.text = podcast.trackName
            
            let episodeString = podcast.trackCount ?? 0 > 1 ? "Episodes" : "Episode"
            trackCountLabel.text = "\(podcast.trackCount ?? 0) \(episodeString)"

            podcastImageView.sd_setImage(with: podcast.podcastUrl)
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    fileprivate func setupViews() {
        podcastImageView.constrainWidth(constant: 70)
        podcastImageView.constrainHeight(constant: 70)

        let stackView = HStackView(arrangedSubviews: [
            podcastImageView,
            VStackView(arrangedSubviews: [
                artistNameLabel,
                trackNameLabel,
                trackCountLabel
            ], spacing: 6)
        ], spacing: 16)
        
        stackView.alignment = .center
        addSubview(stackView)
        stackView.fillSuperview(padding: .init(top: 8, left: 16, bottom: 8, right: 16))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
