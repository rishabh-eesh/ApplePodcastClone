//
//  ViewController.swift
//  ApplePodcastClone
//
//  Created by Rishabh Dubey on 29/05/21.
//

import UIKit
import AppCenterAnalytics

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(handleAddEvent))
    }

    @objc func handleAddEvent() {
        Analytics.trackEvent("Favorites Initialized")
    }
}
