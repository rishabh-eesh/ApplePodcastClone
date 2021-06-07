//
//  PodcastCell.swift
//  ApplePodcastClone
//
//  Created by Rishabh Dubey on 02/06/21.
//

import UIKit

class PodcastCell: UITableViewCell {
    
    let podcastImageView = UIImageView(cornerRadius: 14, contentMode: .scaleAspectFit)
    let primaryGenreName = UILabel(text: "Primary Genre Name", font: .boldSystemFont(ofSize: 13), textColor: .gray)
    let artistName = UILabel(text: "Artist name", font: .systemFont(ofSize: 16), numberOfLines: 2)
    let trackName = UILabel(text: "Track name", font: .systemFont(ofSize: 13), textColor: .gray, numberOfLines: 2)
    
    override class func description() -> String {
        String(describing: self)
    }
    
    var podcast: Podcast! {
        didSet {
            primaryGenreName.text = podcast.primaryGenreName.uppercased()
            artistName.text = podcast.artistName
            trackName.text = podcast.trackName

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
                primaryGenreName,
                artistName,
                trackName
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
