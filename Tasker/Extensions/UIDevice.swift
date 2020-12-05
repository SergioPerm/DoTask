//
//  UIDevice.swift
//  Tasker
//
//  Created by kluv on 11/10/2020.
//  Copyright © 2020 itotdel. All rights reserved.
//

import UIKit

extension UIDevice {
    /// Returns `true` if the device has a notch
    static var hasNotch: Bool {
        guard #available(iOS 11.0, *), let window = UIApplication.shared.windows.filter({$0.isKeyWindow}).first else { return false }
        if UIDevice.current.orientation.isPortrait {
            return window.safeAreaInsets.top >= 44
        } else {
            return window.safeAreaInsets.left > 0 || window.safeAreaInsets.right > 0
        }
    }
}
