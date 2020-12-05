//
//  UIBarButtonItem.swift
//  Tasker
//
//  Created by kluv on 24/10/2020.
//  Copyright © 2020 itotdel. All rights reserved.
//

import UIKit

extension UIBarButtonItem {
    func getCenterPositionRelativeToGlobalView() -> CGPoint {
        if let barBtnItemView = self.value(forKey: "view") as? UIView {
            let globalView = UIView.globalView
            
            let originRelativeMainView = barBtnItemView.convert(barBtnItemView.frame.origin, to: globalView)
            return CGPoint(x: originRelativeMainView.x + barBtnItemView.frame.midX/2, y: originRelativeMainView.y + barBtnItemView.frame.midY/2)
        }
        
        return CGPoint.zero
    }
    
    func tintImageWithColor(color: UIColor) {
        self.image = image?.withRenderingMode(.alwaysTemplate)
        self.tintColor = color
    }
}
