//
//  CalendarButton.swift
//  Tasker
//
//  Created by kluv on 12/10/2020.
//  Copyright © 2020 itotdel. All rights reserved.
//

import UIKit

class CalendarButton: UIView {
    
    private let onTapActionHandler: () -> Void
    
    private var dayLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 10, weight: .heavy)
        label.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        label.textAlignment = .center
        
        return label
    }()
    
    public var day: Date? {
        didSet {
            guard let day = day else {
                dayLabel.text = ""
                return
            }
            
            let calendar = Calendar.current.taskCalendar
            let components = calendar.dateComponents([.day], from: day)
            if let day = components.day {
                dayLabel.text = "\(day)"
            }
        }
    }
    
    private lazy var calendarShape: CAShapeLayer = {
        let flowWidth = frame.width
        
        let sideLength = frame.height * 0.55
        let inset = (frame.height - sideLength)/2
        
        let backInset = flowWidth/2 - frame.height/2
        let scale: CGFloat = 0.8
        let sideHeight: CGFloat = sideLength*scale
        
        let hingeLenght: CGFloat = 5.0
        
        let calendarOrigin = CGPoint(x: backInset + inset, y: inset + (sideLength-(sideHeight))/2)
        let calendarSize = CGSize(width: sideLength, height: sideHeight)
                
        let rectPath = UIBezierPath(roundedRect: CGRect(origin: calendarOrigin, size: calendarSize), cornerRadius: 2)
                    
        var hingeBrush = CGPoint(x: calendarOrigin.x + sideLength/3, y: calendarOrigin.y - hingeLenght/2)
        rectPath.move(to: hingeBrush)
        hingeBrush = CGPoint(x: hingeBrush.x, y: hingeBrush.y + hingeLenght)
        rectPath.addLine(to: hingeBrush)
        hingeBrush = CGPoint(x: hingeBrush.x + sideLength/3, y: calendarOrigin.y - hingeLenght/2)
        rectPath.move(to: hingeBrush)
        hingeBrush = CGPoint(x: hingeBrush.x, y: hingeBrush.y + hingeLenght)
        rectPath.addLine(to: hingeBrush)
        
        let shapeLayer = CAShapeLayer()
        
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = Color.blueColor.uiColor.cgColor
        shapeLayer.lineWidth = 1
        shapeLayer.lineCap = .round
        shapeLayer.path = rectPath.cgPath
                    
        layer.addSublayer(shapeLayer)
        
        return shapeLayer
    }()
    
    init(onTapAction: @escaping () -> Void, day: Date?) {
        self.day = day
        
        if let day = day {
            let calendar = Calendar.current.taskCalendar
            let components = calendar.dateComponents([.day], from: day)
            if let day = components.day {
                dayLabel.text = "\(day)"
            }
        } else {
            dayLabel.text = ""
        }
        
        self.onTapActionHandler = onTapAction
        super.init(frame: CGRect.zero)
        setup()
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        calendarShape.frame = bounds
    }
    
}

extension CalendarButton {
    
    private func setup() {
        addSubview(dayLabel)
        dayLabel.textColor = Color.blueColor.uiColor
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapAction(sender:)))
        addGestureRecognizer(tapGesture)
    }
    
    @objc private func tapAction(sender: UITapGestureRecognizer) {
        onTapActionHandler()
    }
    
}
