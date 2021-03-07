//
//  FlipTransitionController.swift
//  Tasker
//
//  Created by KLuV on 05.02.2021.
//  Copyright © 2021 itotdel. All rights reserved.
//

import UIKit

class FlipTransitionController: NSObject, UIViewControllerTransitioningDelegate {
    
    private let animationDuration: TimeInterval = 0.8
    
    private lazy var animatorController = FlipAnimationController(animationDuration: animationDuration)
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        animatorController.isPresenting = true
        return animatorController
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        animatorController.isPresenting = false
        return animatorController
    }
    
}

