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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
            
        NotificationCenter.default.addObserver(self, selector: #selector(self.methodOfReceivedNotification(notification:)), name: Notification.Name("NotificationIdentifier"), object: nil)
    }
    
    @objc func methodOfReceivedNotification(notification: Notification) {
        
    }
    
    fileprivate func setupView() {
        title = podcast.trackName
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: Notification.Name("NotificationIdentifier"), object: nil)
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

// MARK:- UITableView Delegates
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        showPlayerView(indexPath)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        100
    }
    
    func showPlayerView(_ indexPath: IndexPath) {
        let episode = viewModel.episodes.value?[indexPath.row]
        let mainTabBarController = UIApplication.shared.windows.filter { $0.isKeyWindow }.first?.rootViewController as? MainTabBarController
        mainTabBarController?.maximizePlayer(episode: episode)
        
//        let window = UIApplication.shared.windows.filter { $0.isKeyWindow }.first
//
//        let playerView = PlayerView()
//        playerView.episode = episode
//        playerView.frame = view.frame
//
//        window?.addSubview(playerView)
    }
}
