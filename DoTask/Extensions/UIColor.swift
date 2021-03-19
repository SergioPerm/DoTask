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
//        if hexString == "00000000" {
//            self.init(red:1.0, green:1.0, blue:1.0, alpha: 0.0)
//        } else {
//            let hexString: String = hexString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
//            let scanner = Scanner(string: hexString)
//            if (hexString.hasPrefix("#")) {
//                scanner.scanLocation = 1
//            }
//            var color: UInt32 = 0
//            scanner.scanHexInt32(&color)
//            let mask = 0x000000FF
//            let r = Int(color >> 16) & mask
//            let g = Int(color >> 8) & mask
//            let b = Int(color) & mask
//            let red   = CGFloat(r) / 255.0
//            let green = CGFloat(g) / 255.0
//            let blue  = CGFloat(b) / 255.0
//            self.init(red:red, green:green, blue:blue, alpha:alpha)
//        }
        
        
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
//         if includeAlpha {
//             let alpha = String.init(format: "%02x", a[3])
//             return "\(color)\(alpha)"
//         }
         return color
        
//        var r:CGFloat = 0
//        var g:CGFloat = 0
//        var b:CGFloat = 0
//        var a:CGFloat = 0
//        getRed(&r, green: &g, blue: &b, alpha: &a)
//        let rgb:Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
//        return String(format:"#%06x", rgb)
    }
}
