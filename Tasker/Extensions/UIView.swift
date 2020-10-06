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
    
}
