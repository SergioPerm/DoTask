//
//  Font.swift
//  DoTask
//
//  Created by kluv on 29/09/2020.
//  Copyright © 2020 itotdel. All rights reserved.
//

import UIKit

enum FontFactory: String {
    case Regular = "AvenirNext-Medium"
    case TypeWriting = "Helvetica"
    
    func of(size: CGFloat) -> UIFont {
      return UIFont(name: self.rawValue, size: size) ?? UIFont.systemFont(ofSize: size)
    }
}

enum Font {
    case detailTaskStandartTitle
    case detailTaskTextView
    case cellMainTitle
    case cellAdditionalTitle
    case cellAdditionalTitleBold
    case mainTitle
    case mainTitle2
    case tableHeader
    case tableHeaderLittle
    case timePickerBtnFont
    case calendarPickerFooterFont
    case mainMenuCellFont
    case additionalMenuCellFont

    var uiFont : UIFont {
        switch self {
        case .detailTaskStandartTitle: return UIFont(name: "AvenirNext-Bold", size: 15) ?? UIFont.systemFont(ofSize: 15)
        case .detailTaskTextView: return UIFont(name: "AvenirNext", size: 20) ?? UIFont.systemFont(ofSize: 20)
        case .cellAdditionalTitle: return UIFont(name: "HelveticaNeue", size: 12) ?? UIFont.systemFont(ofSize: 12)
        case .cellAdditionalTitleBold: return UIFont(name: "HelveticaNeue-Bold", size: 12) ?? UIFont.systemFont(ofSize: 12)
        case .cellMainTitle: return FontFactory.Regular.of(size: 15)
        case .mainTitle: return UIFont(name: "AvenirNext-BoldItalic", size: 27) ?? UIFont.systemFont(ofSize: 27)
        case .mainTitle2: return UIFont(name: "AvenirNext-BoldItalic", size: 21) ?? UIFont.systemFont(ofSize: 21)
        case .tableHeader: return UIFont(name: "AvenirNext-Bold", size: 27) ?? UIFont.systemFont(ofSize: 27)
        case .tableHeaderLittle: return UIFont(name: "AvenirNext-Bold", size: 19) ?? UIFont.systemFont(ofSize: 19)
        case .timePickerBtnFont: return UIFont(name: "HelveticaNeue-Bold", size: 17) ?? UIFont.systemFont(ofSize: 17)
        case .calendarPickerFooterFont: return UIFont(name: "HelveticaNeue-Bold", size: 19) ?? UIFont.systemFont(ofSize: 19)
        case .mainMenuCellFont: return UIFont(name: "HelveticaNeue-Bold", size: 19) ?? UIFont.systemFont(ofSize: 19)
        case .additionalMenuCellFont: return UIFont(name: "HelveticaNeue-Bold", size: 17) ?? UIFont.systemFont(ofSize: 17)
        }
    }
}
