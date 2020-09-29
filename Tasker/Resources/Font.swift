//
//  Font.swift
//  Tasker
//
//  Created by kluv on 29/09/2020.
//  Copyright © 2020 itotdel. All rights reserved.
//

import UIKit

enum Font {
    case detailTaskStandartTitle
    
    var uiFont : UIFont {
        switch self {
        case .detailTaskStandartTitle: return UIFont(name: "HelveticaNeue", size: 15) ?? UIFont.systemFont(ofSize: 15)
        }
    }
}
