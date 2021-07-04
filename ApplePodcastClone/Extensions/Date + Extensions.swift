//
//  Date + Extensions.swift
//  ApplePodcastClone
//
//  Created by Rishabh Dubey on 13/06/21.
//

import Foundation

extension Date {
    func toString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy"
        return dateFormatter.string(from: self)
    }
}
