//
//  DropNavigationAnimationController.swift
//  Tasker
//
//  Created by KLuV on 08.02.2021.
//  Copyright © 2021 itotdel. All rights reserved.
//

import UIKit

class DropNavigationAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    
    private let animationDuration: TimeInterval
    var isPresenting: Bool

    init(animationDuration: TimeInterval, isPresenting: Bool = false) {
        self.animationDuration = animationDuration
        self.isPresenting = isPresenting
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return animationDuration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        if isPresenting {
            presentTransition(using: transitionContext)
        } else {
            //dissmisTransition(using: transitionContext)
        }

    }
    
}

extension DropNavigationAnimationController {
    private func presentTransition(using transitionContext: UIViewControllerContextTransitioning) {
                
        guard let fromVC = transitionContext.viewController(forKey: .from),
              let toVC = transitionContext.viewController(forKey: .to)
        else {
            return
        }
        
        let containerView = transitionContext.containerView
        
        toVC.view.layoutIfNeeded()
        guard let snapshotTo = toVC.view.snapshotImageView() else { return }
        //guard let snapshotTo = toVC.view.snapshotView(afterScreenUpdates: true) else { return }
        
        snapshotTo.frame = toVC.view.frame
        snapshotTo.frame.origin.y -= toVC.view.frame.height
        
        containerView.addSubview(toVC.view)
        containerView.addSubview(snapshotTo)
        
        toVC.view.isHidden = true
        
        UIView.animate(withDuration: animationDuration,
                       delay: 0.0,
                       options: .curveEaseIn) {
            snapshotTo.frame.origin.y += toVC.view.frame.height
        } completion: { (finished) in
            toVC.view.isHidden =  false
            snapshotTo.removeFromSuperview()
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }

    }
}
