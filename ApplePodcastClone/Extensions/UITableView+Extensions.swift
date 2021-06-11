//
//  UITableView+Extension.swift
//  ApplePodcastClone
//
//  Created by Rishabh Dubey on 02/06/21.
//

import UIKit

extension UITableView {

    //MARK: - Register a cell
    func dequeueReusableCell<T>(_ type: T.Type) -> T? {
        let className = String(describing: type)
        return dequeueReusableCell(withIdentifier: className) as? T
    }
    
    //MARK: - Dequeue a cell
    func register(_ type: UITableViewCell.Type) {
        let className = String(describing: type)
        return self.register(type, forCellReuseIdentifier: className)
    }
}
