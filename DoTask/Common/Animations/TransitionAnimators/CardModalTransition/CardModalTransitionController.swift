//
//  CustomTransitioningController.swift
//  DoTask
//
//  Created by KLuV on 20.01.2021.
//  Copyright © 2021 itotdel. All rights reserved.
//

import UIKit

class CardModalTransitionController: NSObject, UIViewControllerTransitioningDelegate {
    
    private let animationDuration: TimeInterval
    private let viewController: UIViewController
    private let interactionView: UIView?
    private let router: RouterType?
    
    private var interactionController: UIPercentDrivenInteractiveTransition?
    
    init(viewController: UIViewController, interactionView: UIView? = nil, router: RouterType?, animationDuration: TimeInterval = 0.4) {
        self.viewController = viewController
        self.router = router
        self.animationDuration = animationDuration
        self.interactionView = interactionView
        
        super.init()
        
        setupInteraction()
    }

    private lazy var animatorController = CardModalAnimationController(animationDuration: animationDuration, isPresenting: true)

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

extension CardModalTransitionController {
    private func setupInteraction() {
        let swipeGesture = UIPanGestureRecognizer(target: self, action: #selector(swipeCloseAction(sender:)))
        viewController.view.addGestureRecognizer(swipeGesture)
        
        if let interactionView = interactionView {
            let swipeGesture = UIPanGestureRecognizer(target: self, action: #selector(swipeCloseAction(sender:)))
            
            interactionView.addGestureRecognizer(swipeGesture)
            
            if let gestureDelegate = viewController as? UIGestureRecognizerDelegate {
                swipeGesture.delegate = gestureDelegate
            }
        }
    }
    
    @objc private func swipeCloseAction(sender: UIPanGestureRecognizer) {
        let translate = sender.translation(in: sender.view)
        let percent   = translate.y / viewController.view.frame.height

        if sender.state == .began {
            interactionController = UIPercentDrivenInteractiveTransition()

            viewController.dismiss(animated: true, completion: nil)
        } else if sender.state == .changed {
            interactionController?.update(percent)
        } else if sender.state == .ended {
            let velocity = sender.velocity(in: sender.view)
            if percent > 0.5 || velocity.y >= 2000 {
                if let viewController = viewController as? PresentableController {
                    router?.pop(vc: viewController)
                }
                interactionController?.finish()
            } else {
                interactionController?.completionSpeed = percent
                interactionController?.cancel()
            }
            interactionController = nil
        }
    }
}
