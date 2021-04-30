//
//  DropNavigationAnimationController.swift
//  DoTask
//
//  Created by KLuV on 08.02.2021.
//  Copyright © 2021 itotdel. All rights reserved.
//

import UIKit

class FromRightToLeftAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    
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
            dissmisTransition(using: transitionContext)
        }

    }
    
}

extension FromRightToLeftAnimationController {
    private func presentTransition(using transitionContext: UIViewControllerContextTransitioning) {
                
        guard let toVC = transitionContext.viewController(forKey: .to)
        else {
            return
        }
        
        let containerView = transitionContext.containerView
        
        guard let snapshotTo = toVC.view.snapshotView(afterScreenUpdates: true) else { return }
        
        snapshotTo.frame = toVC.view.frame
        snapshotTo.frame.origin.x += toVC.view.frame.width
        
        containerView.addSubview(toVC.view)
        containerView.addSubview(snapshotTo)
        
        toVC.view.isHidden = true
        
        UIView.animate(withDuration: animationDuration,
                       delay: 0.0,
                       options: .curveEaseIn) {
            snapshotTo.frame.origin.x -= toVC.view.frame.width
        } completion: { (finished) in
            toVC.view.isHidden =  false
            snapshotTo.removeFromSuperview()
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
    
    private func dissmisTransition(using transitionContext: UIViewControllerContextTransitioning) {
                
        guard let fromVC = transitionContext.viewController(forKey: .from)
        else {
            return
        }
        
        let containerView = transitionContext.containerView
        
        fromVC.view.layoutIfNeeded()
        guard let snapshotTo = fromVC.view.snapshotImageView() else { return }
        
        snapshotTo.frame = fromVC.view.frame
        
        containerView.addSubview(fromVC.view)
        containerView.addSubview(snapshotTo)
        
        fromVC.view.isHidden = true
        
        UIView.animate(withDuration: animationDuration,
                       delay: 0.0,
                       options: .curveEaseIn) {
            snapshotTo.frame.origin.x += fromVC.view.frame.width
        } completion: { (finished) in
            fromVC.view.isHidden =  false
            snapshotTo.removeFromSuperview()
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }

    }
}
