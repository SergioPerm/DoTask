//
//  CustomTransitioningController.swift
//  Tasker
//
//  Created by KLuV on 20.01.2021.
//  Copyright © 2021 itotdel. All rights reserved.
//

import UIKit

class CardModalTransitionController: NSObject, UIViewControllerTransitioningDelegate {
    
    private let animationDuration: TimeInterval
    private let estimatedFinalHeight: CGFloat
    private let viewController: UIViewController
    private let router: RouterType?
    
    private var interactionController: UIPercentDrivenInteractiveTransition?
    
    init(viewController: UIViewController, router: RouterType?, estimatedFinalHeight: CGFloat = UIScreen.main.bounds.height * 0.1, animationDuration: TimeInterval = 0.4) {
        self.viewController = viewController
        self.router = router
        self.animationDuration = animationDuration
        self.estimatedFinalHeight = estimatedFinalHeight
        
        super.init()
        
        setupInteraction()
    }

    private lazy var animatorController = CardModalAnimationController(estimatedFinalHeight: estimatedFinalHeight, animationDuration: animationDuration, isPresenting: true)

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
    }
    
    @objc private func swipeCloseAction(sender: UIPanGestureRecognizer) {
        let translate = sender.translation(in: sender.view)
        let percent   = translate.y / sender.view!.bounds.size.height

        if sender.state == .began {
            interactionController = UIPercentDrivenInteractiveTransition()

            viewController.dismiss(animated: true, completion: nil)
        } else if sender.state == .changed {
            interactionController?.update(percent)
        } else if sender.state == .ended {
            let velocity = sender.velocity(in: sender.view)
            print("\(velocity)")
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