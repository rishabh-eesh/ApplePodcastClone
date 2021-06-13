//
//  EpisodesController.swift
//  ApplePodcastClone
//
//  Created by Rishabh Dubey on 12/06/21.
//

import UIKit

class EpisodesController: UITableViewController {

    // MARK:- Properties
    private let podcast: Podcast
    
    // Constructor injection
    init(podcast: Podcast) {
        self.podcast = podcast
        super.init(style: .plain)
    }
    
    // View Model
    fileprivate var viewModel: EpisodesViewModel!
    
    // MARK:- Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel = EpisodesViewModel(feedUrl: podcast.feedUrl)
        setupView()
        setupTableView()
        setupBindings()
    }
    
    fileprivate func setupView() {
        title = podcast.trackName
    }
    
    fileprivate func setupTableView() {
        tableView.register(EpisodeCell.self)
        tableView.tableFooterView = UIView()
    }
    
    fileprivate func setupBindings() {
        viewModel.episodes.bind { [weak self] _ in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension EpisodesController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.episodes.value?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let episode = viewModel.episodes.value?[indexPath.row] else { preconditionFailure("Didn't get the podcast in search") }
        let cell = tableView.dequeueReusableCell(EpisodeCell.self)!
        cell.episode = episode
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        100
    }
}

class EpisodeCell: UITableViewCell {
    
    var episode: Episode! {
        didSet {
            titleLabel.text = episode.title
            descriptionLabel.text = episode.description
            
            episodeImageView.sd_setImage(with: episode.episodeUrl)
        }
    }
    
    let episodeImageView = UIImageView(cornerRadius: 14, contentMode: .scaleAspectFit)
    let pubDateLabel = UILabel(text: "Track name", font: .systemFont(ofSize: 14), textColor: .darkGray, numberOfLines: 2)
    let titleLabel = UILabel(text: "Artist name", font: .systemFont(ofSize: 16), numberOfLines: 2)
    let descriptionLabel = UILabel(text: "No. of tracks", font: .boldSystemFont(ofSize: 13), textColor: .gray, numberOfLines: 2)
    
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
