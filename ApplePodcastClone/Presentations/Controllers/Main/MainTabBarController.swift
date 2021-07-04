//
//  MainTabBarController.swift
//  ApplePodcastClone
//
//  Created by Rishabh Dubey on 29/05/21.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    // MARK: - Properties
    let playerView = PlayerView()
    
    var maximizeTopAnchoredConstraints: NSLayoutConstraint?
    var minimizeTopAnchoredConstraints: NSLayoutConstraint?
    
    // MARK: - ViewController LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.accessibilityIdentifier = "MainTabBarController"
        
        tabBar.tintColor = .purple
        
        setupViewController()
        setupPlayerView()
    }
    
    // MARK: - TabBar ViewControllers Setup
    fileprivate func setupViewController() {
        viewControllers = [
            createTabBarController(viewController: PodcastSearchViewController(), title: "Search", imageName: TabBarIcon.search.rawValue),
            createTabBarController(viewController: ViewController(), title: "Favorites", imageName: TabBarIcon.favorites.rawValue),
            createTabBarController(viewController: ViewController(), title: "Downloads", imageName: TabBarIcon.downloads.rawValue)
        ]
    }
    
    // MARK: - Setup Player
    fileprivate func setupPlayerView() {
        
//        playerView.backgroundColor = .lightGray
        view.insertSubview(playerView, belowSubview: tabBar)

        playerView.anchor(top: nil, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor)
        
        maximizeTopAnchoredConstraints = playerView.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height)
        maximizeTopAnchoredConstraints?.isActive = true
        
        minimizeTopAnchoredConstraints = playerView.topAnchor.constraint(equalTo: tabBar.topAnchor, constant: -64)
//        minimizeTopAnchoredConstraints?.isActive = true
        
    }
    
    // Maximize player
    func maximizePlayer(episode: Episode?) {
        maximizeTopAnchoredConstraints?.isActive = true
        maximizeTopAnchoredConstraints?.constant = 0
        minimizeTopAnchoredConstraints?.isActive = false
        
        if episode != nil {
            playerView.episode = episode
        }
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut) {
            self.view.layoutIfNeeded()
            
            self.tabBar.frame.origin.y = self.view.frame.size.height
            
            self.playerView.miniPlayerView.alpha = 0
            self.playerView.maximizedStackView.alpha = 1
        }
    }
    
    // Minimize player
    @objc func minimizePlayer() {
        maximizeTopAnchoredConstraints?.isActive = false
        minimizeTopAnchoredConstraints?.isActive = true
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut) {
            self.view.layoutIfNeeded()
            
            self.tabBar.frame.origin.y = self.view.frame.height - self.tabBar.frame.height
            
            self.playerView.miniPlayerView.alpha = 1
            self.playerView.maximizedStackView.alpha = 0
        }
    }
    
    // MARK:- Helper function
    fileprivate func createTabBarController(viewController: UIViewController, title: String, imageName: String) -> UIViewController {
        let navController = UINavigationController(rootViewController: viewController)
        navController.navigationBar.prefersLargeTitles = true
        viewController.navigationItem.title = title
        viewController.view.backgroundColor = .white
        navController.tabBarItem.title = title
        navController.tabBarItem.image = UIImage(named: imageName)
        return navController
    }
}

// MARK: TabBar icons
enum TabBarIcon: String {
    case favorites
    case search
    case downloads
}
