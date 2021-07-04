//
//  EpisodeCell.swift
//  ApplePodcastClone
//
//  Created by Rishabh Dubey on 13/06/21.
//

import UIKit

class EpisodeCell: UITableViewCell {
    
    var episode: Episode! {
        didSet {
            pubDateLabel.text = episode.pubDate.toString()
            titleLabel.text = episode.title
            descriptionLabel.text = episode.description
            episodeImageView.sd_setImage(with: episode.episodeUrl)
        }
    }
    
    let episodeImageView = UIImageView(cornerRadius: 14, contentMode: .scaleAspectFit)
    let pubDateLabel = UILabel(text: "Pub Date", font: .boldSystemFont(ofSize: 13), textColor: .darkGray)
    let titleLabel = UILabel(text: "Title", font: .systemFont(ofSize: 16), numberOfLines: 2)
    let descriptionLabel = UILabel(text: "No. of tracks", font: .systemFont(ofSize: 14), textColor: .gray, numberOfLines: 2)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        
        setupViews()
    }
    
    fileprivate func setupViews() {
        episodeImageView.constrainWidth(constant: 70)
        episodeImageView.constrainHeight(constant: 70)

        let stackView = HStackView(arrangedSubviews: [
            episodeImageView,
            VStackView(arrangedSubviews: [
                pubDateLabel,
                titleLabel,
                descriptionLabel
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
