//
//  UINavigationBar.swift
//  DoTask
//
//  Created by KLuV on 04.02.2021.
//  Copyright © 2021 itotdel. All rights reserved.
//

import UIKit

extension UINavigationBar {
    func setFlatNavBar() {
        if #available(iOS 13.0, *) {
            self.standardAppearance.backgroundColor = R.color.mainNavBar.backgorund()
            self.standardAppearance.backgroundEffect = nil
            self.standardAppearance.shadowImage = UIImage()
            self.standardAppearance.shadowColor = .clear
            self.standardAppearance.backgroundImage = UIImage()
        } else {
            // Fallback on earlier versions
            self.backgroundColor = .clear
            self.setBackgroundImage(UIImage(), for:.default)
            self.shadowImage = UIImage()
            self.layoutIfNeeded()
        }
    }
}
