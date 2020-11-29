//
//  Button.swift
//  Tasker
//
//  Created by kluv on 29/09/2020.
//  Copyright © 2020 itotdel. All rights reserved.
//

import UIKit

struct Button {
    static func makeStandartButton(image: UIImage?, text: String? = nil) -> UIButton {
        let button = UIButton(type: .custom)
        
        if let image = image {
            button.setImage(image, for: .normal)
        }
        
        if let text = text {
            button.setTitle(text, for: .normal)
            button.setTitleColor(.black, for: .normal)
        }
                
        return button
    }
}

extension UIButton {
    func image(_ img: UIImage) -> UIButton {
        setImage(img, for: .normal)
        return self
    }
    
    func autolayout(_ atl: Bool) -> UIButton {
        translatesAutoresizingMaskIntoConstraints = !atl
        return self
    }
    
    func title(_ ttl: String) -> UIButton {
        setTitle(ttl, for: .normal)
        setTitleColor(.black, for: .normal)
        return self
    }
    
    func font(_ fnt: UIFont) -> UIButton {
        titleLabel?.font = fnt
        return self
    }
    
    func textColor(_ ttlColor: UIColor) -> UIButton {
        setTitleColor(ttlColor, for: .normal)
        return self
    }
}
