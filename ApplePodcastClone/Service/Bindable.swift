//
//  Bindable.swift
//  ApplePodcastClone
//
//  Created by Rishabh Dubey on 01/06/21.
//

import Foundation

class Bindable<T> {
    
    var value: T? {
        didSet {
            observer?(value)
        }
    }
    
    var observer: ((T?) -> ())?
    
    func bind(observer: @escaping (T?) -> ()) {
        self.observer = observer
    }
}
