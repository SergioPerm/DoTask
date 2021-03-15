//
//  UIViewController.swift
//  DoTask
//
//  Created by kluv on 28/09/2020.
//  Copyright © 2020 itotdel. All rights reserved.
//

import UIKit

extension UIViewController {
        
    func getFirstViewForType<T: UIView>(viewType: T.Type) -> T? {
        let result = view.subviews.compactMap {$0 as? T}
        
        if result.isEmpty {
            return nil
        }
        
        return result.first
    }
    
    func add(_ child: UIViewController) {
        addChild(child)
        view.addSubview(child.view)
        child.didMove(toParent: self)
    }
    
    func add(_ child: UIViewController, atIndex: Int) {
        addChild(child)
        view.insertSubview(child.view, at: atIndex)
        child.didMove(toParent: self)
    }
    
    func add(_ child: UIViewController, withDimmedBack: Bool) {
        add(child)
        if withDimmedBack {
            view.showDimmedBelowSubview(subview: child.view, for: view)
        }
    }
    
    func remove(withDimmedBack: Bool) {
        if withDimmedBack {
            view.removeDimmedView()
        }
        willMove(toParent: nil)
        view.removeFromSuperview()
        removeFromParent()
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
