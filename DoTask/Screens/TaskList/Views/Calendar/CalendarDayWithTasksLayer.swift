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
        let radius: CGFloat = frame.height/4
        circleLayer.path = UIBezierPath(roundedRect: CGRect(x: 0, y: frame.height/4, width: (2.0 * radius), height: 2.0 * radius), cornerRadius: radius).cgPath
        circleLayer.strokeColor = Color.blueColor.uiColor.cgColor
        circleLayer.fillColor = Color.blueColor.uiColor.cgColor
        
        return circleLayer
    }()
    
    private lazy var dayWithDoneTasksLayer: CAShapeLayer = {
        let checkLayer = CAShapeLayer()
        
        let path = UIBezierPath()
        
        let startPoint = CGPoint(x: 0, y: frame.height/2)
        
        path.move(to: startPoint)
        
        var nextPoint = CGPoint(x: startPoint.x + frame.height/6, y: startPoint.y + frame.height/5)
        path.addLine(to: nextPoint)
        path.move(to: nextPoint)
        
        nextPoint = CGPoint(x: nextPoint.x + frame.height/3, y: startPoint.y - frame.height/5)
        path.addLine(to: nextPoint)
        
        checkLayer.path = path.cgPath
        checkLayer.lineWidth = StyleGuide.TaskList.Calendar.Sizes.dayWithDoneTasksLayerLineWidth
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
        
        let layerMargins: CGFloat = 2.0
        let layerWidth: CGFloat = frame.height/2
        let halfWidth: CGFloat = frame.width/2
        
        switch status {
        case .doneAndProgress:
            addSublayer(dayWithTasksLayer)
            addSublayer(dayWithDoneTasksLayer)
                        
            dayWithDoneTasksLayer.position = CGPoint(x: halfWidth - layerWidth - layerMargins, y: 0)
            dayWithTasksLayer.position = CGPoint(x: halfWidth + layerMargins, y: 0)
            
        case .allDone:
            addSublayer(dayWithDoneTasksLayer)
            
            dayWithDoneTasksLayer.position = CGPoint(x: halfWidth - (layerWidth/2), y: 0)
        case .inProgress:
            addSublayer(dayWithTasksLayer)
            
            dayWithTasksLayer.position = CGPoint(x: halfWidth - (layerWidth/2), y: 0)
        default:
            return
        }
        
    }
}
