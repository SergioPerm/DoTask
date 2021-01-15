//
//  ColorDotView.swift
//  Tasker
//
//  Created by KLuV on 05.01.2021.
//  Copyright © 2021 itotdel. All rights reserved.
//

import UIKit

class ColorDotView: UIView {

    var currentColor: UIColor {
        didSet {
            drawDot()
        }
    }
    
    private let dotShape = CAShapeLayer()
    
    init() {
        self.currentColor = .white
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        drawDot()
    }
    
}

extension ColorDotView {
    private func setup() {
        translatesAutoresizingMaskIntoConstraints = false
    }
        
    private func drawDot() {
        dotShape.removeFromSuperlayer()
    
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: frame.width/2, y: frame.height/2), radius: frame.width/2, startAngle: 0.0, endAngle: CGFloat(Double.pi * 2), clockwise: true)
        dotShape.path = circlePath.cgPath
        dotShape.fillColor = currentColor.cgColor
        dotShape.strokeColor = currentColor.cgColor
        dotShape.lineWidth = 1.0
        
        layer.addSublayer(dotShape)
        
        let animationIn = CAKeyframeAnimation(keyPath: "transform.scale")
        
        animationIn.duration = 0.5
        animationIn.values = [1.0, 2.2, 1.0]
        animationIn.keyTimes = [0, 0.2, 0.8]
        
        layer.add(animationIn, forKey: "pulse")
    }
}
