//
//  DatePickerCollectionViewCell.swift
//  ToDoList
//
//  Created by kluv on 07/09/2020.
//  Copyright © 2020 com.kluv.itotdel. All rights reserved.
//

import UIKit

class CalendarPickerViewCell: UICollectionViewCell {
    static let reuseIdentifier = String(describing: CalendarPickerViewCell.self)

    private lazy var selectLayer: CALayer = {
        let circleLayer = CAShapeLayer()
        let radius: CGFloat = frame.width/2
        circleLayer.path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: 2.0 * radius, height: 2.0 * radius), cornerRadius: radius).cgPath
        circleLayer.position = CGPoint(x: radius - radius, y: radius - radius)
        circleLayer.fillColor = Color.blueColor.uiColor.cgColor
        
        return circleLayer
    }()
    
    private lazy var currentDayLayer: CALayer = {
        let circleLayer = CAShapeLayer()
        let radius: CGFloat = frame.width/2
        circleLayer.path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: (2.0 * radius) - 4, height: (2.0 * radius)-4), cornerRadius: radius).cgPath
        circleLayer.position = CGPoint(x: radius - radius + 2, y: radius - radius + 2)
        circleLayer.lineWidth = 2
        circleLayer.strokeColor = Color.blueColor.uiColor.cgColor
        circleLayer.fillColor = Color.clearColor.uiColor.cgColor
         
        return circleLayer
    }()
    
    @IBOutlet weak var dayLabel: UILabel!
    
    var day: DayModel? {
        didSet {
            guard let day = day else { return }
            
            dayLabel.text = day.number
            
            dayLabel.font = dayLabel.font.withSize(frame.width/(30/15))
            
            updateVisibleStatus()
        }
    }
}

// MARK: - Appearance
extension CalendarPickerViewCell {
    
    func updateVisibleStatus() {
        guard let day = day else { return }
                
        if !day.isWithinDisplayedMonth {
            currentDayLayer.removeFromSuperlayer()
            selectLayer.removeFromSuperlayer()
            dayLabel.textColor = .clear
            return
        }
        
        dayLabel.textColor = day.isWeekend ? Color.pinkColor.uiColor : Color.blueColor.uiColor
        
        if day.currentDay {
            if currentDayLayer.superlayer == nil {
                self.layer.sublayers?.insert(currentDayLayer, at: 0)
            }
        } else {
            currentDayLayer.removeFromSuperlayer()
        }

        if day.isSelected {
            dayLabel.textColor = Color.whiteColor.uiColor
            if selectLayer.superlayer == nil {
                self.layer.sublayers?.insert(selectLayer, at: 0)
            }
        } else {
            selectLayer.removeFromSuperlayer()
        }
        
    }
}
