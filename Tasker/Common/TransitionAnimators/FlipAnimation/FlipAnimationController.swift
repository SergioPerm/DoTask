//
//  FlipAnimationController.swift
//  Tasker
//
//  Created by KLuV on 05.02.2021.
//  Copyright © 2021 itotdel. All rights reserved.
//

import UIKit

class FlipAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    
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

extension FlipAnimationController {
    private func presentTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewController(forKey: .from),
              let toVC = transitionContext.viewController(forKey: .to),
              let snapshotTo = toVC.view.snapshotView(afterScreenUpdates: true),
              let snaphotFrom = fromVC.view.snapshotView(afterScreenUpdates: true)
        else {
            return
        }
        
        let containerView = transitionContext.containerView
               
        let bgView = UIView(frame: toVC.view.frame)
        bgView.backgroundColor = StyleGuide.MainColors.blue
                
        var transform: CATransform3D = CATransform3DIdentity
        transform.m43 = (toVC.view.frame.width * -1) / 2
        
        let transofrm2 = CATransform3DMakeScale(1.5, 1.5, 1.0)
        
        bgView.layer.transform = CATransform3DConcat(transform, transofrm2);
        
        snapshotTo.frame = toVC.view.frame
        snaphotFrom.frame = fromVC.view.frame
        
        containerView.addSubview(snaphotFrom)
        containerView.addSubview(snapshotTo)
        containerView.addSubview(toVC.view)
        
        containerView.insertSubview(bgView, at: 0)
        
        toVC.view.isHidden = true
        
        snaphotFrom.layer.cornerRadius = 12
        snaphotFrom.layer.masksToBounds = true
        snapshotTo.layer.cornerRadius = 12
        snapshotTo.layer.masksToBounds = true
        
        AnimationHelper.perspectiveTransform(for: containerView)
        snapshotTo.layer.transform = CATransform3DConcat(ViewControlerScale.modelPresentationScale.transform, AnimationHelper.yRotation(.pi / 2))
        
        let duration = transitionDuration(using: transitionContext)
    
        fromVC.view.isHidden = true
        
        UIView.animateKeyframes(
            withDuration: duration,
            delay: 0,
            options: .calculationModeCubic,
            animations: {
                UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 1/4) {
                    snaphotFrom.layer.transform = ViewControlerScale.modelPresentationScale.transform
                }
                
                UIView.addKeyframe(withRelativeStartTime: 1/4, relativeDuration: 1/4) {
                    snaphotFrom.layer.transform = CATransform3DConcat(ViewControlerScale.modelPresentationScale.transform, AnimationHelper.yRotation(-.pi / 2))
                    fromVC.view.layer.transform = CATransform3DConcat(ViewControlerScale.modelPresentationScale.transform, AnimationHelper.yRotation(-.pi / 2))
                }
                
                UIView.addKeyframe(withRelativeStartTime: 2/4, relativeDuration: 1/4) {
                    snapshotTo.layer.transform = CATransform3DConcat(ViewControlerScale.modelPresentationScale.transform, AnimationHelper.yRotation(0.0))
                }
                
                UIView.addKeyframe(withRelativeStartTime: 3/4, relativeDuration: 1/4) {
                    fromVC.view.layer.transform = ViewControlerScale.reset.transform
                    snapshotTo.layer.transform = ViewControlerScale.reset.transform
                }
            },
            completion: { _ in
                fromVC.view.layer.transform = AnimationHelper.yRotation(0.0)
                fromVC.view.isHidden = false
                toVC.view.isHidden = false
                snapshotTo.removeFromSuperview()
                snaphotFrom.removeFromSuperview()
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            })
        
    }
    
    private func dissmisTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        guard let fromVC = transitionContext.viewController(forKey: .from),
              let toVC = transitionContext.viewController(forKey: .to),
              let snapshotFrom = fromVC.view.snapshotView(afterScreenUpdates: false),
              let snapshotTo = toVC.view.snapshotView(afterScreenUpdates: false)
        else {
            return
        }
        
        let containerView = transitionContext.containerView
       
        containerView.addSubview(snapshotFrom)
        containerView.addSubview(snapshotTo)
                
        fromVC.view.isHidden = true
        
        snapshotFrom.layer.cornerRadius = 12
        snapshotFrom.layer.masksToBounds = true
        
        snapshotTo.layer.cornerRadius = 12
        snapshotTo.layer.masksToBounds = true
        
        AnimationHelper.perspectiveTransform(for: containerView)
        snapshotTo.layer.transform = CATransform3DConcat(ViewControlerScale.modelPresentationScale.transform, AnimationHelper.yRotation(.pi / 2))

        let duration = transitionDuration(using: transitionContext)
        
        toVC.view.isHidden = true
        
        UIView.animateKeyframes(
            withDuration: duration,
            delay: 0,
            options: .calculationModeCubic,
            animations: {
                UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 1/4) {
                    snapshotFrom.layer.transform = ViewControlerScale.modelPresentationScale.transform
                }
                
                UIView.addKeyframe(withRelativeStartTime: 1/4, relativeDuration: 1/4) {
                    snapshotFrom.layer.transform = CATransform3DConcat(AnimationHelper.yRotation(-.pi / 2), ViewControlerScale.modelPresentationScale.transform)
                }

                UIView.addKeyframe(withRelativeStartTime: 2/4, relativeDuration: 1/4) {
                    snapshotTo.layer.transform = CATransform3DConcat(ViewControlerScale.modelPresentationScale.transform, AnimationHelper.yRotation(0.0))
                }

                UIView.addKeyframe(withRelativeStartTime: 3/4, relativeDuration: 1/4) {
                    snapshotTo.layer.transform = ViewControlerScale.reset.transform
                }

            },

            completion: { _ in
                fromVC.view.isHidden = false
                toVC.view.isHidden = false
                toVC.view.layer.cornerRadius = 0
                toVC.view.layer.masksToBounds = false
                snapshotFrom.removeFromSuperview()
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            })
    }
}
