//
//  UIColor.swift
//  DoTask
//
//  Created by KLuV on 05.01.2021.
//  Copyright © 2021 itotdel. All rights reserved.
//

import UIKit

extension UIColor {
    convenience init(hexString: String, alpha: CGFloat = 1.0) {

        var cString:String = hexString.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }

        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)

        self.init(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
        
    }
    
    func toHexString() -> String {
        
        guard self.cgColor.numberOfComponents == 4 else {
             return "Color not RGB."
         }
         let a = self.cgColor.components!.map { Int($0 * CGFloat(255)) }
         let color = String.init(format: "%02x%02x%02x", a[0], a[1], a[2])

         return color

    }
}
