//
//  UIView.swift
//  Tasker
//
//  Created by kluv on 29/09/2020.
//  Copyright © 2020 itotdel. All rights reserved.
//

import UIKit

extension UIView {
    
    static var dimmedViews = [UIView]()
    
    var globalView: UIView? {
        return UIApplication.shared.windows.first { $0.isKeyWindow }
    }
    
    var globalFrame: CGRect? {
        let rootView = UIApplication.shared.windows.first { $0.isKeyWindow }
        return self.superview?.convert(self.frame, to: rootView)
    }
    
    
    
    func showDimmedBelowSubview(subview: UIView, for view: UIView) {
        UIView.dimmedViews.append(UIView())// = UIView()
        
        guard let dimmedView = UIView.dimmedViews.last else { return }
        
        dimmedView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        dimmedView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        dimmedView.frame = view.bounds

        view.insertSubview(dimmedView, belowSubview: subview)
    }
    
    func removeDimmedView() {
        if let dimmedView = UIView.dimmedViews.popLast(){
            dimmedView.removeFromSuperview()
        }
    }
    
    func shake(duration: CFTimeInterval) {
        let shakeValues = [-5, 5, -5, 5, -3, 3, -2, 2, 0]

        let translation = CAKeyframeAnimation(keyPath: "transform.translation.x");
        translation.timingFunction = CAMediaTimingFunction(name: .linear)
        translation.values = shakeValues
        
        let rotation = CAKeyframeAnimation(keyPath: "transform.rotation.z")
        rotation.values = shakeValues.map { (Int(Double.pi) * $0) / 180 }
        
        let shakeGroup = CAAnimationGroup()
        shakeGroup.animations = [translation, rotation]
        shakeGroup.duration = 1.0
        layer.add(shakeGroup, forKey: "shakeIt")
    }
    
}
