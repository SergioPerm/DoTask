//
//  UITableViewCell.swift
//  DoTask
//
//  Created by kluv on 05/10/2020.
//  Copyright © 2020 itotdel. All rights reserved.
//

import UIKit

extension UITableViewCell {
    //static let reuseIdentifier = String(describing: UITableViewCell.self)
    
    
    static var reuseIdentifier: String {
        String(describing: self)
    }
}
