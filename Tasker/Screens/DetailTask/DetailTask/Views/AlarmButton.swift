//
//  AlarmButton.swift
//  Tasker
//
//  Created by kluv on 12/10/2020.
//  Copyright © 2020 itotdel. All rights reserved.
//

import UIKit

class AlarmButton: UIView {
    
    public var alarmIsSet: Bool {
        didSet {
            redrawAlarmShape(alarmFrame: bounds)
        }
    }
    
    private let bellHeightAttitudeToHeightFrame: CGFloat = 0.45
    private let bellWidthAttitudeToHeightFrame: CGFloat = 0.31
    
    private let onTapActionHandler: () -> Void
    
    private var alarmShape: CAShapeLayer = CAShapeLayer()
    
    init(onTapAction: @escaping () -> Void, alarmSet: Bool = false) {
        self.alarmIsSet = alarmSet
        self.onTapActionHandler = onTapAction
        super.init(frame: CGRect.zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        redrawAlarmShape(alarmFrame: bounds)
    }
}

extension AlarmButton {
    private func setup() {
          let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapAction(sender:)))
        addGestureRecognizer(tapGesture)
    }
    
    @objc private func tapAction(sender: UITapGestureRecognizer) {
        onTapActionHandler()
    }
    
    private func redrawAlarmShape(alarmFrame: CGRect) {
        alarmShape.removeFromSuperlayer()
        
        //setup size of bell
        let bellHeight = frame.height * bellHeightAttitudeToHeightFrame
        let bellWidth = frame.height * bellWidthAttitudeToHeightFrame
        let bellVisorLenght = bellWidth * 0.2
        let inset = (frame.height - bellHeight)/2
                        
        //draw
        let path = UIBezierPath()
        
        let startPosition = CGPoint(x: frame.width/2 - bellWidth/2, y: inset + bellWidth/2)
        path.move(to: startPosition)
        
        var bellBrush = startPosition
        
        path.addArc(withCenter: CGPoint(x: bellBrush.x + bellWidth/2, y: bellBrush.y),
        radius: bellWidth/2,
            startAngle: Angle(degrees: 180).toRadians(),
        endAngle: Angle(degrees: 0).toRadians(),
        clockwise: true)

        bellBrush = CGPoint(x: bellBrush.x + bellWidth, y: bellBrush.y + bellHeight * 0.4)
        path.addLine(to: bellBrush)

        bellBrush = CGPoint(x: bellBrush.x + bellVisorLenght, y: bellBrush.y)
        path.move(to: bellBrush)

        bellBrush = CGPoint(x: bellBrush.x - bellWidth - bellVisorLenght * 2, y: bellBrush.y)
        path.addLine(to: bellBrush)

        bellBrush = CGPoint(x: bellBrush.x + bellVisorLenght * 2 + bellWidth/2, y: bellBrush.y + bellVisorLenght)
        path.move(to: bellBrush)

        path.addArc(withCenter: CGPoint(x: bellBrush.x - bellVisorLenght, y: bellBrush.y),
        radius: bellVisorLenght,
            startAngle: Angle(degrees: 10).toRadians(),
        endAngle: Angle(degrees: 170).toRadians(),
        clockwise: true)

        bellBrush = CGPoint(x: bellBrush.x - (bellVisorLenght * 2 + bellWidth/2), y: bellBrush.y - bellVisorLenght)
        path.move(to: bellBrush)

        bellBrush = CGPoint(x: bellBrush.x + bellVisorLenght, y: bellBrush.y)
        path.move(to: bellBrush)

        bellBrush = CGPoint(x: bellBrush.x, y: bellBrush.y - bellHeight * 0.4)
        path.addLine(to: bellBrush)

        bellBrush = CGPoint(x: startPosition.x + (bellWidth/2 - bellVisorLenght/2), y: startPosition.y - (bellWidth/2) * 1.3)
        path.move(to: bellBrush)

        bellBrush = CGPoint(x: bellBrush.x + bellVisorLenght, y: bellBrush.y)
        path.addLine(to: bellBrush)
                
        //Shape
        alarmShape = CAShapeLayer()
        
        alarmShape.fillColor = alarmIsSet ? UIColor.yellow.cgColor : UIColor.clear.cgColor
        alarmShape.strokeColor = alarmIsSet ? UIColor.black.cgColor : #colorLiteral(red: 0.8865944131, green: 0.8865944131, blue: 0.8865944131, alpha: 1).cgColor
        alarmShape.lineWidth = 1.5
        alarmShape.lineCap = .round
        alarmShape.path = path.cgPath
                    
        layer.addSublayer(alarmShape)
    }
}
