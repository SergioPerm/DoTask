//
//  ReorderCellButton.swift
//  DoTask
//
//  Created by KLuV on 28.12.2020.
//  Copyright © 2020 itotdel. All rights reserved.
//

import UIKit

class ReorderSubtask: UIView {

    private let controlRatioWidthRelativeAtFrame: CGFloat = StyleGuide.DetailTask.Sizes.ratioToFrameWidth.reorderControlWidth
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
        let interLineSpacing: CGFloat = 5
        
        //middle line
        linePath.move(to: CGPoint(x: sidePadding, y: frame.height/2))
        linePath.addLine(to: CGPoint(x: sidePadding + controlWidth, y: frame.height/2))
        
        //top line
        linePath.move(to: CGPoint(x: sidePadding, y: frame.height/2 - interLineSpacing))
        linePath.addLine(to: CGPoint(x: sidePadding + controlWidth, y: frame.height/2 - interLineSpacing))
        
        //bottom line
        linePath.move(to: CGPoint(x: sidePadding, y: frame.height/2 + interLineSpacing))
        linePath.addLine(to: CGPoint(x: sidePadding + controlWidth, y: frame.height/2 + interLineSpacing))
            
        controlShape.path = linePath.cgPath
        controlShape.lineWidth = lineWidth
        controlShape.lineCap = .round
        controlShape.strokeColor = UIColor.gray.cgColor
        
        layer.addSublayer(controlShape)
    }
}
