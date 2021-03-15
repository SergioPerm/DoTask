//
//  DayWithTasksLayer.swift
//  DoTask
//
//  Created by Сергей Лепинин on 14.03.2021.
//  Copyright © 2021 itotdel. All rights reserved.
//

import UIKit

class CalendarDayWithTasksLayer: CAShapeLayer {
    
    private var status: CalendarDayStatus = .empty
    
    private lazy var dayWithTasksLayer: CAShapeLayer = {
        let circleLayer = CAShapeLayer()
        let radius: CGFloat = frame.width/8
        circleLayer.path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: (2.0 * radius), height: 2.0 * radius), cornerRadius: radius).cgPath
        //circleLayer.position = CGPoint(x: frame.width/2 - radius, y: frame.height * 0.75)
        circleLayer.lineWidth = 1
        circleLayer.strokeColor = Color.blueColor.uiColor.cgColor
        circleLayer.fillColor = Color.blueColor.uiColor.cgColor
        
        return circleLayer
    }()
    
    private lazy var dayWithDoneTasksLayer: CAShapeLayer = {
        let checkLayer = CAShapeLayer()
        
        let path = UIBezierPath()
        
        let startPoint = CGPoint(x: 0, y: 2)
        
        path.move(to: startPoint)
        
        var nextPoint = CGPoint(x: startPoint.x + 2, y: startPoint.y + 2.5)
        path.addLine(to: nextPoint)
        path.move(to: nextPoint)
        
        nextPoint = CGPoint(x: nextPoint.x + 3, y: startPoint.y - 2.5)
        path.addLine(to: nextPoint)
        
        checkLayer.path = path.cgPath
        checkLayer.lineWidth = 2.5
        checkLayer.lineCap = .round
        checkLayer.fillColor =  #colorLiteral(red: 0.364339892, green: 0.7325225515, blue: 0.4118772155, alpha: 1).cgColor
        checkLayer.strokeColor = #colorLiteral(red: 0.364339892, green: 0.7325225515, blue: 0.4118772155, alpha: 1).cgColor
        
        return checkLayer
    }()
    
    override init(layer: Any) {
        super.init(layer: layer)
    }
    
    override init() {
        super.init()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
}

extension CalendarDayWithTasksLayer {
    func setCalendarDayStatus(status: CalendarDayStatus) {
        self.status = status
        updateStatus()
    }
    
    func setSelect(selected: Bool) {
        
        if selected {
            dayWithTasksLayer.fillColor = Color.whiteColor.uiColor.cgColor
            dayWithTasksLayer.strokeColor = Color.whiteColor.uiColor.cgColor
            dayWithDoneTasksLayer.fillColor = Color.whiteColor.uiColor.cgColor
            dayWithDoneTasksLayer.strokeColor = Color.whiteColor.uiColor.cgColor
        } else {
            dayWithTasksLayer.fillColor = Color.blueColor.uiColor.cgColor
            dayWithTasksLayer.strokeColor = Color.blueColor.uiColor.cgColor
            dayWithDoneTasksLayer.fillColor = #colorLiteral(red: 0.364339892, green: 0.7325225515, blue: 0.4118772155, alpha: 1).cgColor
            dayWithDoneTasksLayer.strokeColor = #colorLiteral(red: 0.364339892, green: 0.7325225515, blue: 0.4118772155, alpha: 1).cgColor
        }
        
    }
    
    private func updateStatus() {
        
        dayWithTasksLayer.removeFromSuperlayer()
        dayWithDoneTasksLayer.removeFromSuperlayer()
        
        switch status {
        case .doneAndProgress:
            addSublayer(dayWithTasksLayer)
            addSublayer(dayWithDoneTasksLayer)
            
            dayWithDoneTasksLayer.position = CGPoint(x: frame.width/2 - 6, y: 0)
            dayWithTasksLayer.position = CGPoint(x: frame.width/2 + 2, y: 0)
            
        case .allDone:
            addSublayer(dayWithDoneTasksLayer)
            
            dayWithDoneTasksLayer.position = CGPoint(x: frame.width/2 - (frame.width/8), y: 0)
        case .inProgress:
            addSublayer(dayWithTasksLayer)
            
            dayWithTasksLayer.position = CGPoint(x: frame.width/2 - (frame.width/8), y: 0)
        default:
            return
        }
        
        
    }
}
