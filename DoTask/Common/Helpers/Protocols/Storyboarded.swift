//
//  Storyboarded.swift
//  DoTask
//
//  Created by KLuV on 10.12.2020.
//  Copyright © 2020 itotdel. All rights reserved.
//

import UIKit

protocol Storyboarded {
    static func instantiate() -> Self
}

extension Storyboarded where Self: UIViewController {
    static func instantiate() -> Self {
        let fullName = NSStringFromClass(self)
        let className = fullName.components(separatedBy: ".")[1]

        let storyboard = UIStoryboard(name: "testStoryboard", bundle: Bundle.main)

        return storyboard.instantiateViewController(withIdentifier: className) as! Self
    }
}
