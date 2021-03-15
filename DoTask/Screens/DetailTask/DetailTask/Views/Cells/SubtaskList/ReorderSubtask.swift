//
//  ReorderCellButton.swift
//  DoTask
//
//  Created by KLuV on 28.12.2020.
//  Copyright © 2020 itotdel. All rights reserved.
//

import UIKit

class ReorderSubtask: UIView {

    private let controlRatioWidthRelativeAtFrame: CGFloat = 0.6
    private let controlShape = CAShapeLayer()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        drawControl()
    }
    
}

extension ReorderSubtask {
    private func drawControl() {
        controlShape.removeFromSuperlayer()
        
        let lineWidth: CGFloat = 2
        
        let linePath = UIBezierPath()
        
        let controlWidth = frame.width * controlRatioWidthRelativeAtFrame
        let sidePadding = (frame.width - controlWidth) / 2
        
        linePath.move(to: CGPoint(x: sidePadding, y: frame.height/2))
        linePath.addLine(to: CGPoint(x: sidePadding + controlWidth, y: frame.height/2))
        
        linePath.move(to: CGPoint(x: sidePadding, y: frame.height/2 - 5))
        linePath.addLine(to: CGPoint(x: sidePadding + controlWidth, y: frame.height/2 - 5))
        
        linePath.move(to: CGPoint(x: sidePadding, y: frame.height/2 + 5))
        linePath.addLine(to: CGPoint(x: sidePadding + controlWidth, y: frame.height/2 + 5))
            
        controlShape.path = linePath.cgPath
        controlShape.lineWidth = lineWidth
        controlShape.lineCap = .round
        controlShape.strokeColor = UIColor.gray.cgColor
        
        layer.addSublayer(controlShape)
    }
}
