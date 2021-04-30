//
//  NavigationSwipeTransitionController.swift
//  DoTask
//
//  Created by Сергей Лепинин on 27.04.2021.
//  Copyright © 2021 itotdel. All rights reserved.
//

import UIKit

final class NavigationSwipeTransitionController: NSObject, UINavigationControllerDelegate {
    var interactionController: UIPercentDrivenInteractiveTransition?

    private let router: RouterType?
    private let navigationController: UINavigationController?
    
    init(router: RouterType?, vc: UINavigationController) {
        self.router = router
        self.navigationController = vc
        super.init()
        
        let swipeGesture = UIPanGestureRecognizer(target: self, action: #selector(swipeCloseAction(sender:)))
        vc.view.addGestureRecognizer(swipeGesture)
    }
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        switch operation {
        case .push:
            return NavigationSwipeAnimationController(presenting: true)
        case .pop:
            return NavigationSwipeAnimationController(presenting: false)
        default:
            return nil
        }
    }

    func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactionController
    }
}

extension NavigationSwipeTransitionController {
    @objc private func swipeCloseAction(sender: UIPanGestureRecognizer) {
        
        guard let gestureRecognizerView = sender.view else {
            interactionController = nil
            return
        }
        
        let percent = sender.translation(in: gestureRecognizerView).x / gestureRecognizerView.bounds.size.width
        
        if sender.state == .began {
            interactionController = UIPercentDrivenInteractiveTransition()

            if let presentableVC = navigationController?.viewControllers.last as? PresentableController {
                router?.pop(vc: presentableVC)
            }
        } else if sender.state == .changed {
            interactionController?.update(percent)
        } else if sender.state == .ended {
            let velocity = sender.velocity(in: sender.view)
            if percent > 0.5 || velocity.y >= 2000 {
                interactionController?.finish()
            } else {
                interactionController?.completionSpeed = percent
                interactionController?.cancel()
            }
            interactionController = nil
        }
    }
}
