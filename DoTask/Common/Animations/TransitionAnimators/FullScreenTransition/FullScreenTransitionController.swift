//
//  FullScreenTransitionController.swift
//  DoTask
//
//  Created by Сергей Лепинин on 28.04.2021.
//  Copyright © 2021 itotdel. All rights reserved.
//

import UIKit

final class FullScreenTransitionController: NSObject, UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return FullScreenAnimationController(isPresenting: true)
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return FullScreenAnimationController(isPresenting: false)
    }
    
}
