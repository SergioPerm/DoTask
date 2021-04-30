//
//  DropNavigationTransitionController.swift
//  DoTask
//
//  Created by KLuV on 08.02.2021.
//  Copyright © 2021 itotdel. All rights reserved.
//

import UIKit

class FromRightToLeftTransitionController: NSObject, UIViewControllerTransitioningDelegate {
    private let animationDuration: TimeInterval = 0.3
    private var interactionController: UIPercentDrivenInteractiveTransition?
    private weak var interactionViewController: UIViewController?
    private lazy var animatorController = FromRightToLeftAnimationController(animationDuration: animationDuration)
    private let router: RouterType?
    
    init(vc: UINavigationController, router: RouterType?) {
        self.interactionViewController = vc
        self.router = router
        
        super.init()
        setupInteractionFor(vc: vc)
    }
    
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

extension FromRightToLeftTransitionController {
    private func setupInteractionFor(vc: UINavigationController) {
        let swipeGesture = UIPanGestureRecognizer(target: self, action: #selector(swipeCloseAction(sender:)))
        
        if let vc = vc.viewControllers.first {
            vc.view.addGestureRecognizer(swipeGesture)
        }
    }
    
    @objc private func swipeCloseAction(sender: UIPanGestureRecognizer) {
        
        guard let interactionViewController = interactionViewController else { return }
        
        let translate = sender.translation(in: sender.view)
        let percent   = translate.x / interactionViewController.view.frame.width
        
        if sender.state == .began {
            interactionController = UIPercentDrivenInteractiveTransition()

            interactionViewController.dismiss(animated: true, completion: nil)
        } else if sender.state == .changed {
            interactionController?.update(percent)
        } else if sender.state == .ended {
            let velocity = sender.velocity(in: sender.view)
            if percent > 0.5 || velocity.y >= 2000 {
                if let viewController = interactionViewController as? PresentableController {
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
