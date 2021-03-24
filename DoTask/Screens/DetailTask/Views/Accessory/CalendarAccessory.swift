//
//  CalendarButton.swift
//  DoTask
//
//  Created by kluv on 12/10/2020.
//  Copyright © 2020 itotdel. All rights reserved.
//

import UIKit

class CalendarAccessory: UIView {
    
    private let calendarWidthAttitudeToHeightFrame: CGFloat = 0.55
    
    private let onTapActionHandler: () -> Void
    
    private var dayLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: StyleGuide.getSizeRelativeToScreenWidth(baseSize: 10), weight: .heavy)
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
    
    private var calendarShape: CAShapeLayer = CAShapeLayer()
    
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
        drawCalendar()
    }
    
}

extension CalendarAccessory {
    
    private func drawCalendar() {
        calendarShape.removeFromSuperlayer()
        
        //Setup calendar size
        let scaleForHeight: CGFloat = 0.8

        let sideWidth = frame.height * calendarWidthAttitudeToHeightFrame
        let hingeLenght: CGFloat = sideWidth/5
        let inset = (frame.height - sideWidth)/2

        let backInset = frame.width/2 - frame.height/2
        let sideHeight: CGFloat = sideWidth * scaleForHeight

        let calendarOrigin = CGPoint(x: backInset + inset, y: inset + (sideWidth-(sideHeight))/2)
        let calendarSize = CGSize(width: sideWidth, height: sideHeight)

        //Draw
        let rectPath = UIBezierPath(roundedRect: CGRect(origin: calendarOrigin, size: calendarSize), cornerRadius: 2)

        var hingeBrush = CGPoint(x: calendarOrigin.x + sideWidth/3, y: calendarOrigin.y - hingeLenght/2)
        rectPath.move(to: hingeBrush)
        hingeBrush = CGPoint(x: hingeBrush.x, y: hingeBrush.y + hingeLenght)
        rectPath.addLine(to: hingeBrush)
        hingeBrush = CGPoint(x: hingeBrush.x + sideWidth/3, y: calendarOrigin.y - hingeLenght/2)
        rectPath.move(to: hingeBrush)
        hingeBrush = CGPoint(x: hingeBrush.x, y: hingeBrush.y + hingeLenght)
        rectPath.addLine(to: hingeBrush)

        //Shape
        calendarShape = CAShapeLayer()

        calendarShape.fillColor = UIColor.clear.cgColor
        calendarShape.strokeColor = Color.blueColor.uiColor.cgColor
        calendarShape.lineWidth = 1
        calendarShape.lineCap = .round
        calendarShape.path = rectPath.cgPath

        layer.addSublayer(calendarShape)
    }
    
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
