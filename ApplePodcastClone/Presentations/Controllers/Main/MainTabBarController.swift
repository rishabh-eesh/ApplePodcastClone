//
//  MainTabBarController.swift
//  ApplePodcastClone
//
//  Created by Rishabh Dubey on 29/05/21.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBar.tintColor = .purple
        
        setupViewController()
    }
    
    // MARK: - TabBar ViewControllers Setup
    fileprivate func setupViewController() {
        viewControllers = [
            createTabBarController(viewController: PodcastSearchViewController(), title: "Search", imageName: TabBarIcon.search.rawValue),
            createTabBarController(viewController: ViewController(), title: "Favorites", imageName: TabBarIcon.favorites.rawValue),
            createTabBarController(viewController: ViewController(), title: "Downloads", imageName: TabBarIcon.downloads.rawValue)
        ]
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
