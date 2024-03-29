//
//  CustomAnimationController.swift
//  DoTask
//
//  Created by KLuV on 20.01.2021.
//  Copyright © 2021 itotdel. All rights reserved.
//

import UIKit

class CardModalAnimationController: NSObject, UIViewControllerAnimatedTransitioning {

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
    
    let animationDuration: TimeInterval
    var isPresenting: Bool
    var dimmView: UIView = UIView()
    var rootVC: UIViewController?
    
    init(rootVC: UIViewController? = nil, animationDuration: TimeInterval, isPresenting: Bool) {
        self.rootVC = rootVC
        self.animationDuration = animationDuration
        self.isPresenting = isPresenting
    }

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return animationDuration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {

        guard var fromVC = transitionContext.viewController(forKey: .from),
        let toVC = transitionContext.viewController(forKey: .to) else { return }
          
        if let rootVC = rootVC {
            fromVC = rootVC
        }
        
        let containerView = transitionContext.containerView

        if isPresenting {
            let originalFrame = toVC.view.frame
            toVC.view.frame.origin.y = fromVC.view.frame.maxY
            containerView.addSubview(toVC.view)
                        
            dimmView.backgroundColor = R.color.animations.dimmIn()
            dimmView.frame = fromVC.view.bounds
            fromVC.view.addSubview(dimmView)
            fromVC.view.bringSubviewToFront(dimmView)
            
            UIView.animate(withDuration: animationDuration, animations: {
                
                self.dimmView.backgroundColor = R.color.animations.dimmOut()
                
                toVC.view.frame = originalFrame

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
                
                self.dimmView.backgroundColor = R.color.animations.dimmIn()
            }, completion: { _ in
                if !transitionContext.transitionWasCancelled {
                    self.dimmView.removeFromSuperview()
                }
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            })
        }
        
    }
    
}
