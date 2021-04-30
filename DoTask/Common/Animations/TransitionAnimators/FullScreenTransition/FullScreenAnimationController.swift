//
//  FullScreenAnimationController.swift
//  DoTask
//
//  Created by Сергей Лепинин on 28.04.2021.
//  Copyright © 2021 itotdel. All rights reserved.
//

import UIKit

final class FullScreenAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    
    var isPresenting: Bool
    
    init(isPresenting: Bool = false) {
        self.isPresenting = isPresenting
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.0
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        if isPresenting {
            presentTransition(using: transitionContext)
        } else {
            dissmisTransition(using: transitionContext)
        }
    }
}

extension FullScreenAnimationController {
    private func presentTransition(using transitionContext: UIViewControllerContextTransitioning) {
        transitionContext.completeTransition(true)
    }
    
    private func dissmisTransition(using transitionContext: UIViewControllerContextTransitioning) {
        transitionContext.completeTransition(true)
    }
}
