//
//  PodcastSearchViewController.swift
//  ApplePodcastClone
//
//  Created by Rishabh Dubey on 01/06/21.
//

import UIKit
import AppCenterAnalytics

class PodcastSearchViewController: UITableViewController {
    
    var dummyPodcasts = [Podcast]()
    
    private var searchTask: DispatchWorkItem?
    
    let searchController = UISearchController(searchResultsController: nil)
    
    private let cellID = "cellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        setupSearchBar()
        
        
    }
    
    fileprivate func setupTableView() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
    }
    
    fileprivate func setupSearchBar() {
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
    }
}

extension PodcastSearchViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        searchTask?.cancel()
        let task = DispatchWorkItem {
            
            NetworkService.shared.fetch(endPoint: .search(matching: searchText)) { (results: SearchResults?, error) in
                if let error = error {
                    print("Failed to get search data: ", error)
                    return
                }
                
                //success
                guard let searchResults = results else { return }
                self.dummyPodcasts = searchResults.results
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
        
        searchTask = task
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7, execute: task)
    }
}

extension PodcastSearchViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dummyPodcasts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        
        let podcast = dummyPodcasts[indexPath.row]
        cell.imageView?.image = #imageLiteral(resourceName: "favorites")
        cell.textLabel?.text = "\(podcast.artistName ?? "")\n\(podcast.trackName ?? "")"
        cell.textLabel?.numberOfLines = 0
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        Analytics.trackEvent(dummyPodcasts[indexPath.row].artistName ?? "")
    }
}
