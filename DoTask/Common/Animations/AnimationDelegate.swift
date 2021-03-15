//
//  AnimationDelegate.swift
//  DoTask
//
//  Created by KLuV on 05.03.2021.
//  Copyright © 2021 itotdel. All rights reserved.
//

import UIKit

class AnimationDelegate: NSObject, CAAnimationDelegate {
    
    fileprivate let completion: () -> Void

    init(completion: @escaping () -> Void) {
        self.completion = completion
    }

    func animationDidStop(_: CAAnimation, finished: Bool) {
        completion()
    }
}
