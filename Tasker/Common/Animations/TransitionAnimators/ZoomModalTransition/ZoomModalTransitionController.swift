//
//  ZoomModalTransitionController.swift
//  Tasker
//
//  Created by KLuV on 31.01.2021.
//  Copyright © 2021 itotdel. All rights reserved.
//

import UIKit

class ZoomModalTransitionController: NSObject, UIViewControllerTransitioningDelegate {
    
    private let animationDuration: TimeInterval = 0.3
    
    private lazy var animatorController = ZoomModalAnimationController(animationDuration: animationDuration)
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        animatorController.isPresenting = true
        return animatorController
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        animatorController.isPresenting = false
        return animatorController
    }
    
}
