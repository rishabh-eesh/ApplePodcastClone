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

extension UIButton {
    convenience init(title: String, font: UIFont = .systemFont(ofSize: 14), titleColor: UIColor = .black) {
        self.init(type: .system)
        setTitle(title, for: .normal)
        titleLabel?.font = font
        setTitleColor(titleColor, for: .normal)
    }
}

extension UIImage {
    static func systemImage(imageName: String, color: UIColor = .black, size: CGFloat, weight: UIImage.SymbolWeight, scale: UIImage.SymbolScale) -> UIImage {
        let config = UIImage.SymbolConfiguration(pointSize: size, weight: weight, scale: scale)
        return UIImage(systemName: imageName, withConfiguration: config)!.withTintColor(color, renderingMode: .alwaysOriginal)
    }
}
