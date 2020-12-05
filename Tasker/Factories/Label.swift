//
//  Label.swift
//  Tasker
//
//  Created by kluv on 29/09/2020.
//  Copyright © 2020 itotdel. All rights reserved.
//

import UIKit

struct Label {
    static func makeDetailTaskStandartLabel (with title: String? = nil, textColor: UIColor) -> UILabel {
        UILabel()
            .color(textColor)
            .font(Font.detailTaskStandartTitle.uiFont)
            .text(title)
            .lines(1)
            .lineBreak(.byTruncatingTail)
            .autolayout(true)
    }
    
    static func makeCellAdditionalLabel (with title: String? = nil, textColor: UIColor) -> UILabel {
        UILabel()
            .color(textColor)
            .font(Font.cellAdditionalTitle.uiFont)
            .text(title)
            .lines(1)
            .lineBreak(.byTruncatingTail)
            .autolayout(true)
    }
    
    static func makeCellMainLabel (with title: String? = nil, textColor: UIColor) -> UILabel {
        UILabel()
            .color(textColor)
            .font(Font.cellMainTitle.uiFont)
            .text(title)
            .lines(1)
            .lineBreak(.byTruncatingTail)
            .autolayout(true)
    }
}

extension UILabel {
    func autolayout(_ atl: Bool) -> UILabel {
        translatesAutoresizingMaskIntoConstraints = !atl
        return self
    }
    
    func color(_ clr: UIColor) -> UILabel {
        textColor = clr
        return self
    }
    
    func font(_ fnt: UIFont) -> UILabel {
        font = fnt
        return self
    }
    
    func lines(_ lns: Int) -> UILabel {
        numberOfLines = lns
        return self
    }
    
    func alignment(_ al: NSTextAlignment) -> UILabel {
        textAlignment = al
        return self
    }
    
    func text(_ txt: String?) -> UILabel {
        text = txt
        return self
    }
    
    func lineBreak(_ lb: NSLineBreakMode) -> UILabel {
        lineBreakMode = lb
        return self
    }
    
    func adjustFontSize(_ adjust : Bool = true) -> UILabel {
        adjustsFontSizeToFitWidth = adjust
        return self
    }
}
