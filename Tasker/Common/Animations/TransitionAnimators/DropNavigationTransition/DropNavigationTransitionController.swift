//
//  DropNavigationTransitionController.swift
//  Tasker
//
//  Created by KLuV on 08.02.2021.
//  Copyright © 2021 itotdel. All rights reserved.
//

import UIKit

class DropNavigationTransitionController: NSObject, UIViewControllerTransitioningDelegate {
    private let animationDuration: TimeInterval = 0.3
    
    private lazy var animatorController = DropNavigationAnimationController(animationDuration: animationDuration)
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        animatorController.isPresenting = true
        return animatorController
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        animatorController.isPresenting = false
        return animatorController
    }
}
