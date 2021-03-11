//
//  TaskAddButton.swift
//  Tasker
//
//  Created by kluv on 07/10/2020.
//  Copyright © 2020 itotdel. All rights reserved.
//

import UIKit

class TaskAddButton: CircleCrossGradientBtn {
        
    private let onTapActionHandler: () -> Void
    private let onLongTapActionHandler: (_ recognizer: UILongPressGestureRecognizer) -> Void
    
    init(onTapAction: @escaping () -> Void, onLongTapAction: @escaping (_ recognizer: UILongPressGestureRecognizer) -> Void) {
        self.onTapActionHandler = onTapAction
        self.onLongTapActionHandler = onLongTapAction
        super.init()
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
}

extension TaskAddButton {
    private func setup() {

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapAction(sender:)))
        addGestureRecognizer(tapGesture)
        
        let longTapGesture = UILongPressGestureRecognizer(target: self, action: #selector(longTapAction(sender:)))
        
        addGestureRecognizer(longTapGesture)
    }
    
    @objc private func longTapAction(sender: UILongPressGestureRecognizer) {
        
        if sender.state == .began {
            onLongTapActionHandler(sender)
        } else if sender.state == .ended || sender.state == .cancelled {
            addGestureRecognizer(sender)
            sender.addTarget(self, action: #selector(longTapAction(sender:)))
        }
        
    }
    
    @objc private func tapAction(sender: UIView) {
        CATransaction.begin()
        CATransaction.setCompletionBlock {
            self.onTapActionHandler()
        }
        
        let animationIn = CAKeyframeAnimation(keyPath: "transform.scale")
        
        animationIn.values = [1.0, 0.8, 1.0]
        animationIn.keyTimes = [0, 0.3, 0.8]
        
        layer.add(animationIn, forKey: "pulse")
        
        CATransaction.commit()
    }
}

