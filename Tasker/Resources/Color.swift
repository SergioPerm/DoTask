//
//  Colors.swift
//  Tasker
//
//  Created by kluv on 09/10/2020.
//  Copyright © 2020 itotdel. All rights reserved.
//

import UIKit

enum Color {
    case blueColor
    case pinkColor
    case whiteColor
    case clearColor
    
    var uiColor : UIColor {
        switch self {
        case .blueColor: return #colorLiteral(red: 0.2392156863, green: 0.6235294118, blue: 0.9960784314, alpha: 1)
        case .pinkColor: return #colorLiteral(red: 1, green: 0.2117647059, blue: 0.6509803922, alpha: 0.8470588235)
        case .whiteColor: return #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        case .clearColor: return .clear
        }
    }
}
