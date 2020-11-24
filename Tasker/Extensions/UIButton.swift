//
//  UIButton.swift
//  Tasker
//
//  Created by kluv on 24/11/2020.
//  Copyright © 2020 itotdel. All rights reserved.
//

import UIKit

extension UIButton {
    func tintImageWithColor(color: UIColor, image: UIImage?) {
        let tintedImage = image?.withRenderingMode(.alwaysTemplate)
        self.setImage(tintedImage, for: .normal)
        self.tintColor = color
    }
}
