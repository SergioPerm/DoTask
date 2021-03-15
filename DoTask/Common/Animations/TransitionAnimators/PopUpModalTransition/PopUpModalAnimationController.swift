//
//  PopUpModalAnimationController.swift
//  DoTask
//
//  Created by KLuV on 31.01.2021.
//  Copyright © 2021 itotdel. All rights reserved.
//

import UIKit

class PopUpModalAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    
    let estimatedFinalHeight: CGFloat
    let animationDuration: TimeInterval
    var isPresenting: Bool
    var dimmView: UIView = UIView()
    var rootVC: UIViewController?
    
    init(rootVC: UIViewController?, estimatedFinalHeight: CGFloat, animationDuration: TimeInterval, isPresenting: Bool) {
        self.rootVC = rootVC
        self.estimatedFinalHeight = estimatedFinalHeight
        self.animationDuration = animationDuration
        self.isPresenting = isPresenting
    }

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return animationDuration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {

        guard let fromVC = transitionContext.viewController(forKey: .from),
        let toVC = transitionContext.viewController(forKey: .to),
        let rootVC = rootVC else { return }
          
        let containerView = transitionContext.containerView

        if isPresenting {
            toVC.view.frame.origin.y = fromVC.view.frame.maxY
            containerView.addSubview(toVC.view)
                        
            dimmView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
            dimmView.frame = rootVC.view.frame
            
            if fromVC.presentingViewController == nil {
                rootVC.view.addSubview(dimmView)
                rootVC.view.bringSubviewToFront(dimmView)
            } else {
                fromVC.view.addSubview(dimmView)
                fromVC.view.bringSubviewToFront(dimmView)
            }
                        
            UIView.animate(withDuration: animationDuration, animations: {
                self.dimmView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.6600057827)
                
                toVC.view.frame.origin.y = self.estimatedFinalHeight
                toVC.view.frame.size.height = UIScreen.main.bounds.height - self.estimatedFinalHeight
                toVC.view.layer.cornerRadius = 12
            }, completion: { _ in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            })
        } else {
            let snapshot = fromVC.view.snapshotView(afterScreenUpdates: true)
            snapshot?.frame = fromVC.view.frame
            containerView.addSubview(snapshot!)
            fromVC.view.isHidden = true
            UIView.animate(withDuration: animationDuration, animations: {
                fromVC.view.frame.origin.y = UIScreen.main.bounds.maxY
                snapshot?.frame.origin.y = UIScreen.main.bounds.maxY
                  
                self.dimmView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
            }, completion: { _ in
                fromVC.view.isHidden = false
                snapshot?.removeFromSuperview()
                if !transitionContext.transitionWasCancelled {
                    self.dimmView.removeFromSuperview()
                }
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            })
        }
        
    }
    
}
