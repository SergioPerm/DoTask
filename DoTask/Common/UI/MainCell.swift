//
//  MainCellShadow.swift
//  DoTask
//
//  Created by Сергей Лепинин on 18.03.2021.
//  Copyright © 2021 itotdel. All rights reserved.
//

import UIKit

class MainCellShadow: UIView {

    var setupShadowDone: Bool = false
    
    public func setupShadow() {
    
        let cornerRadius = StyleGuide.CommonViews.MainCell.Sizes.cornerRadius
        
        layer.cornerRadius = cornerRadius
        layer.shadowOffset = CGSize(width: 0, height: 3)
        layer.shadowRadius = StyleGuide.CommonViews.MainCell.Sizes.shadowRadius
        layer.shadowOpacity = StyleGuide.CommonViews.MainCell.Appearance.shadowOpacity
        layer.shadowPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: .allCorners, cornerRadii: CGSize(width: cornerRadius, height: cornerRadius)).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupShadow()
    }

}
