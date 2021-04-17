//
//  Font.swift
//  DoTask
//
//  Created by kluv on 29/09/2020.
//  Copyright © 2020 itotdel. All rights reserved.
//

import UIKit

enum FontFactory: String {
    case AvenirNextMedium = "AvenirNext-Medium"
    case AvenirNext = "AvenirNext"
    case AvenirNextRegular = "AvenirNext-Regular"
    case AvenirNextBold = "AvenirNext-Bold"
    case AvenirNextBoldItalic = "AvenirNext-BoldItalic"
    
    case Helvetica = "Helvetica"

    case HelveticaNeue = "HelveticaNeue"
    case HelveticaNeueBold = "HelveticaNeue-Bold"
    
    func of(size: CGFloat) -> UIFont {
      return UIFont(name: self.rawValue, size: size) ?? UIFont.systemFont(ofSize: size)
    }
}
