//
//  CircleCrossGradientBtn.swift
//  Tasker
//
//  Created by KLuV on 11.03.2021.
//  Copyright © 2021 itotdel. All rights reserved.
//

import UIKit

class CircleCrossGradientBtn: UIView {

    private lazy var gradient: CAGradientLayer = {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [#colorLiteral(red: 0.6124999856, green: 0.9375732529, blue: 1, alpha: 1).cgColor, #colorLiteral(red: 0.2392156863, green: 0.6235294118, blue: 0.9960784314, alpha: 1).cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        layer.addSublayer(gradientLayer)
        return gradientLayer
    }()
    
    private lazy var cross: CAShapeLayer = {
        let pathLines = UIBezierPath()
        let crossLineLength = frame.height/3.5
        
        //Draw cross
        var startPoint = CGPoint(x: frame.width/2, y: frame.height/2 - crossLineLength/2)
        
        pathLines.move(to: startPoint)
        pathLines.addLine(to: CGPoint(x: startPoint.x, y: startPoint.y + crossLineLength))
        
        startPoint = CGPoint(x: startPoint.x - crossLineLength/2, y: frame.height/2)
        
        pathLines.move(to: startPoint)
        pathLines.addLine(to: CGPoint(x: startPoint.x + crossLineLength, y: frame.height/2))
        
        let shapeLayer = CAShapeLayer()
        
        shapeLayer.fillColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0).cgColor
        shapeLayer.strokeColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1).cgColor
        shapeLayer.lineWidth = 2
        shapeLayer.path = pathLines.cgPath
        
        layer.addSublayer(shapeLayer)
        
        return shapeLayer
    }()
    
    init() {
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradient.frame = bounds
        gradient.cornerRadius = bounds.width / 2.0
        
        cross.frame = bounds
        cross.cornerRadius = bounds.width / 2.0
    
        
    }
    
}

extension CircleCrossGradientBtn {
    private func setup() {
        guard let globalFrame = UIView.globalView?.frame else { return }
        let btnWidth = globalFrame.width/5 * 0.9
        let btnOrigin = CGPoint(x: globalFrame.width - btnWidth - 20, y: globalFrame.height - btnWidth - 20)
        frame = CGRect(x: btnOrigin.x, y: btnOrigin.y - self.globalSafeAreaInsets.bottom, width: btnWidth, height: btnWidth)
        
        self.layer.shadowOffset = CGSize(width: 10, height: 10)
        self.layer.shadowRadius = 5
        self.layer.shadowOpacity = 0.2
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: .allCorners, cornerRadii: CGSize(width: bounds.width / 2.0, height: bounds.width / 2.0)).cgPath
    }
}
