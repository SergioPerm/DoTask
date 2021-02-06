//
//  ZoomModalAnimationController.swift
//  Tasker
//
//  Created by KLuV on 31.01.2021.
//  Copyright © 2021 itotdel. All rights reserved.
//

import UIKit

class ZoomModalAnimationController: NSObject, UIViewControllerAnimatedTransitioning {

    enum ViewControlerScale {
        case modelPresentationScale
        case reset
        var transform: CATransform3D {
            switch self {
            case .modelPresentationScale:
                return CATransform3DMakeScale(0.80, 0.80, 1)
            case .reset:
                return CATransform3DMakeScale(1, 1, 1)
            }
        }
    }
    
    private let animationDuration: TimeInterval
    var isPresenting: Bool
    private var dimmView: UIView = UIView()
    
    init(animationDuration: TimeInterval, isPresenting: Bool = false) {
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
                    
            dimmView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
            dimmView.frame = fromVC.view.bounds
            fromVC.view.addSubview(dimmView)
            fromVC.view.bringSubviewToFront(dimmView)
                        
            toVC.view.layer.transform = ViewControlerScale.modelPresentationScale.transform
            toVC.view.alpha = 0.0
            containerView.addSubview(toVC.view)
            
            UIView.animate(withDuration: animationDuration) {
                self.dimmView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.3694176804)
                
                toVC.view.alpha = 1.0
                toVC.view.layer.transform = ViewControlerScale.reset.transform
            } completion: { (finished) in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            }

            
        } else {
            
            containerView.addSubview(fromVC.view)
            
            UIView.animate(withDuration: animationDuration) {
                self.dimmView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
                fromVC.view.layer.transform = ViewControlerScale.modelPresentationScale.transform
                fromVC.view.alpha = 0.0
            } completion: { (finished) in
                if !transitionContext.transitionWasCancelled {
                    self.dimmView.removeFromSuperview()
                }
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            }
        }
    }
}
