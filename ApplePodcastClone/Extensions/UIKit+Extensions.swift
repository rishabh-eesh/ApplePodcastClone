//
//  UIKit+Extensions.swift
//  ApplePodcastClone
//
//  Created by Rishabh Dubey on 02/06/21.
//

import UIKit

extension UIImageView {
    convenience init(cornerRadius: CGFloat, contentMode: UIView.ContentMode = .scaleAspectFill) {
        self.init(image: nil)
        self.layer.cornerRadius = cornerRadius
        self.clipsToBounds = true
        self.contentMode = contentMode
    }
}

extension UILabel {
    convenience init(text: String, font: UIFont, textColor: UIColor = .black, numberOfLines: Int = 1) {
        self.init()
        self.text = text
        self.font = font
        self.textColor = textColor
        self.numberOfLines = numberOfLines
    }
}


