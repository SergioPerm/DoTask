//
//  BarButtonItem.swift
//  DoTask
//
//  Created by KLuV on 28.02.2021.
//  Copyright © 2021 itotdel. All rights reserved.
//

import UIKit

class BarButtonItem: UIButton {

    //increase touch area
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        return bounds.insetBy(dx: -10, dy: -10).contains(point)
    }
}
