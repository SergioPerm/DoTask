//
//  SpeechRecorderTransitionController.swift
//  Tasker
//
//  Created by KLuV on 03.03.2021.
//  Copyright © 2021 itotdel. All rights reserved.
//

import UIKit

class SpeechRecorderTransitionController: NSObject, UIViewControllerTransitioningDelegate {
    
    private let presentDuration: TimeInterval = 0.7
    private let dismissDuration: TimeInterval = 0.3
    
    private lazy var animatorController = SpeechRecorderAnimationController(presentDuration: presentDuration, dismissDuration: dismissDuration)
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        animatorController.isPresenting = true
        return animatorController
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        animatorController.isPresenting = false
        return animatorController
    }
    
}
