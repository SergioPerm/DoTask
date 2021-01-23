//
//  CustomTransitioningController.swift
//  Tasker
//
//  Created by KLuV on 20.01.2021.
//  Copyright © 2021 itotdel. All rights reserved.
//

import UIKit

class DetailShortcutTransitionController: NSObject, UIViewControllerTransitioningDelegate {
    
    private let animationDuration: TimeInterval
    private let estimatedFinalHeight: CGFloat
    
    weak var interactionController: UIPercentDrivenInteractiveTransition?
    
    init(estimatedFinalHeight: CGFloat = UIScreen.main.bounds.height * 0.1, animationDuration: TimeInterval = 0.4) {
        self.animationDuration = animationDuration
        self.estimatedFinalHeight = estimatedFinalHeight
    }

    private lazy var animatorController = SwipeableModalAnimationController(estimatedFinalHeight: estimatedFinalHeight, animationDuration: animationDuration, isPresenting: true)

    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        animatorController.isPresenting = true
        return animatorController
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        animatorController.isPresenting = false
        return animatorController
    }
        
    func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactionController
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactionController
    }
    
}
