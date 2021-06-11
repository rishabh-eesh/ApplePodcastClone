//
//  ViewController.swift
//  ApplePodcastClone
//
//  Created by Rishabh Dubey on 29/05/21.
//

import UIKit
//import AppCenterAnalytics

class ViewController: UIViewController {

    let greetingLabel = UILabel(text: "Hello", font: .boldSystemFont(ofSize: 16))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        view.addSubview(greetingLabel)
        greetingLabel.centerInSuperview()
        
        greetingLabel.text = getGreeting()
    }
    
    func getGreeting() -> String {
        let hour = Calendar.current.component(.hour, from: Date())
        var greetingText: String = ""
        switch hour {
        case 0..<4:
            greetingText = "Hello"
        case 4..<12:
            greetingText = "Good morning"
        case 12..<18:
            greetingText = "Good afternoon"
        case 18..<24:
            greetingText = "Good evening"
        default:
            break
        }
        return greetingText
    }
    
    
}

extension String {
    var isDigits: Bool {
        if isEmpty { return false }
        // The inverted set of .decimalDigits is every character minus digits
        let nonDigits = CharacterSet.decimalDigits.inverted
        return rangeOfCharacter(from: nonDigits) == nil
    }
}
