//
//  PodcastSearchViewController.swift
//  ApplePodcastClone
//
//  Created by Rishabh Dubey on 01/06/21.
//

import UIKit
import AppCenterAnalytics
import SDWebImage

class PodcastSearchViewController: UITableViewController {
    
    private var viewModel: PodcastSearchViewModel!
    
    private var searchTask: DispatchWorkItem?
    
    let searchController = UISearchController(searchResultsController: nil)
    
    let blankListLabel = UILabel(text: "Please enter search query", font: .boldSystemFont(ofSize: 20), textColor: .label, numberOfLines: 2)
    
    //MARK: - ViewController Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = PodcastSearchViewModel(service: NetworkService.shared)
        
        setupTableView()
        setupSearchBar()
        setupBindings()
    }
    
    fileprivate func setupTableView() {
        tableView.accessibilityIdentifier = "PodcastSearchTable"
        tableView.register(PodcastCell.self)
        tableView.tableFooterView = UIView()
        
        // Set label
        tableView.addSubview(blankListLabel)
        blankListLabel.textAlignment = .center
        blankListLabel.fillSuperview(padding: .init(top: 80, left: 24, bottom: 0, right: 24))
        blankListLabel.centerXInSuperview()
    }
    
    fileprivate func setupSearchBar() {
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "All Podcasts"
    }
    
    fileprivate func setupBindings() {
        viewModel.podcasts.bind { [weak self] _ in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
}

extension PodcastSearchViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchTask?.cancel()
        let task = DispatchWorkItem { [weak self] in
            // fetch search results from api
            self?.viewModel.searchText = searchText
        }
        
        searchTask = task
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7, execute: task)
    }
}

extension PodcastSearchViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        blankListLabel.isHidden = viewModel.podcasts.value?.count != 0
        return viewModel.podcasts.value?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let podcast = viewModel.podcasts.value?[indexPath.row] else { preconditionFailure("Didn't get the podcast in search") }
        let cell = tableView.dequeueReusableCell(PodcastCell.self)!
        cell.podcast = podcast
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        Analytics.trackEvent(dummyPodcasts[indexPath.row].artistName ?? "")
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let podcast = viewModel.podcasts.value?[indexPath.row] else { return }
        
//        NotificationCenter.default.post(name: Notification.Name("NotificationIdentifier"), object: nil)
        let episodesController = EpisodesController(podcast: podcast)
        navigationController?.pushViewController(episodesController, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        100
    }
}
