//
//  CustomAnimationController.swift
//  Tasker
//
//  Created by KLuV on 20.01.2021.
//  Copyright © 2021 itotdel. All rights reserved.
//

import UIKit

class SwipeableModalAnimationController: NSObject, UIViewControllerAnimatedTransitioning {

    enum ViewControlerScale {
        case modelPresentationScale
        case reset
        var transform: CATransform3D {
            switch self {
            case .modelPresentationScale:
                return CATransform3DMakeScale(0.90, 0.90, 1)
            case .reset:
                return CATransform3DMakeScale(1, 1, 1)
            }
        }
    }
    
    let estimatedFinalHeight: CGFloat
    let animationDuration: TimeInterval
    var isPresenting: Bool
    var dimmView: UIView = UIView()
    
    init(estimatedFinalHeight: CGFloat, animationDuration: TimeInterval, isPresenting: Bool) {
        self.estimatedFinalHeight = estimatedFinalHeight
        self.animationDuration = animationDuration
        self.isPresenting = isPresenting
    }

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return animationDuration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {

        guard let fromVC = transitionContext.viewController(forKey: .from),
        let toVC = transitionContext.viewController(forKey: .to) else { return }
          
        let containerView = transitionContext.containerView

        if isPresenting {
            toVC.view.frame.origin.y = fromVC.view.frame.maxY
            containerView.addSubview(toVC.view)
                        
            dimmView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
            dimmView.frame = fromVC.view.frame
            fromVC.view.addSubview(dimmView)
            fromVC.view.bringSubviewToFront(dimmView)
            
            UIView.animate(withDuration: animationDuration, animations: {
                
                self.dimmView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.6600057827)
                
                toVC.view.frame.origin.y = self.estimatedFinalHeight
                fromVC.view.layer.transform =
                    ViewControlerScale.modelPresentationScale.transform

                fromVC.view.layer.cornerRadius = 12
                fromVC.view.layer.masksToBounds = true
                
                toVC.view.layer.cornerRadius = 12
            }, completion: { _ in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            })
        } else {
            containerView.addSubview(fromVC.view)
            UIView.animate(withDuration: animationDuration, animations: {
                fromVC.view.frame.origin.y = UIScreen.main.bounds.maxY
                toVC.view.layer.transform = ViewControlerScale.reset.transform
                                
                fromVC.view.layer.cornerRadius = 0
                toVC.view.layer.cornerRadius = 0
                
                self.dimmView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
            }, completion: { _ in
                if !transitionContext.transitionWasCancelled {
                    self.dimmView.removeFromSuperview()
                }
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            })
        }
        
    }
    
}
