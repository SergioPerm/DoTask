//
//  CheckCellButton.swift
//  DoTask
//
//  Created by KLuV on 27.12.2020.
//  Copyright © 2020 itotdel. All rights reserved.
//

import UIKit

class CheckSubtask: UIView {

    var check: Bool {
        didSet {
            redrawShapes()
        }
    }
    
    private var circleShape: CAShapeLayer = CAShapeLayer()
    private var checkShape: CAShapeLayer = CAShapeLayer()
    
    init(check: Bool = false) {
        self.check = check
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        redrawShapes()
    }
    
}

extension CheckSubtask {

    private func redrawShapes() {
        circleShape.removeFromSuperlayer()
        checkShape.removeFromSuperlayer()
        if check {
            if checkShape.superlayer == nil {
                drawCheck()
            }
        } else {
            if circleShape.superlayer == nil {
                drawCircle()
            }
        }
    }
    
    private func drawCircle() {
        circleShape = CAShapeLayer()
        
        let lineWidth: CGFloat = 2.0
        
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: frame.width/2, y: frame.height/2), radius: frame.height/2 - lineWidth, startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: true)
        
        circleShape.path = circlePath.cgPath
        circleShape.lineWidth = lineWidth
        circleShape.lineCap = .round
        circleShape.strokeColor = StyleGuide.TaskList.Colors.cellMainTitle.cgColor
        circleShape.fillColor = UIColor.clear.cgColor
        
        layer.addSublayer(circleShape)
        
        addAnimation(shape: circleShape)
    }
    
    private func addAnimation(shape: CAShapeLayer) {
        let animation = CABasicAnimation(keyPath: "opacity")
        animation.fromValue = 0
        animation.toValue = 1
        animation.duration = 0.3
        shape.add(animation, forKey: "myAnimation")
    }
    
    private func drawCheck() {
        
        checkShape = CAShapeLayer()
        
        let lineWidth: CGFloat = 3.0
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: lineWidth, y: frame.height/2))
        path.addLine(to: CGPoint(x: frame.width/2 - lineWidth, y: bounds.height - lineWidth))
        path.addLine(to: CGPoint(x: bounds.width - lineWidth, y: lineWidth * 2))
        
        checkShape.fillColor = UIColor.clear.cgColor
        checkShape.strokeColor = StyleGuide.TaskList.Colors.cellMainTitle.cgColor
        checkShape.lineWidth = 3
        checkShape.path = path.cgPath
        
        layer.addSublayer(checkShape)
        
        addAnimation(shape: checkShape)
    }
}
