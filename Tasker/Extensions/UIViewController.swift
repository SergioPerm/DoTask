//
//  UIViewController.swift
//  Tasker
//
//  Created by kluv on 28/09/2020.
//  Copyright © 2020 itotdel. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func addSubviewAtIndex(_ child: UIViewController, at index: Int ) {
        addChild(child)
        view.insertSubview(child.view, at: index)
        child.didMove(toParent: self)
    }
    
    func add(_ child: UIViewController) {
        addChild(child)
        view.addSubview(child.view)
        child.didMove(toParent: self)
    }
    
    func remove() {
        willMove(toParent: nil)
        view.removeFromSuperview()
        removeFromParent()
    }
    
    func getSaveAreaLayoutGuide() -> UILayoutGuide {
        var safeAreaGuide = UILayoutGuide()
        
        if #available(iOS 11.0, *) {
            let window = UIApplication.shared.windows[0]
            safeAreaGuide = window.safeAreaLayoutGuide
        }
        
        return safeAreaGuide
    }
}
