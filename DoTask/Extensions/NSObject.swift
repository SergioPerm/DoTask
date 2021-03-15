//
//  NSObject.swift
//  DoTask
//
//  Created by kluv on 27/11/2020.
//  Copyright © 2020 itotdel. All rights reserved.
//

import Foundation

extension NSObject {
    var className: String {
        return String(describing: type(of: self))
    }
    
    static var className: String {
        if let classString = NSStringFromClass(self).components(separatedBy: CharacterSet(charactersIn: ".")).last {
            return classString
        }
        
        return String(describing: self)
    }
}

