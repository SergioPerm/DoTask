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
        circleLayer.fillColor = #colorLiteral(red: 0.305240575, green: 0.7878151489, blue: 0.8980392157, alpha: 1).cgColor
        
        return circleLayer
    }()
    
    private lazy var currentDayLayer: CALayer = {
        let circleLayer = CAShapeLayer()
        let radius: CGFloat = frame.width/2
        circleLayer.path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: (2.0 * radius) - 4, height: (2.0 * radius)-4), cornerRadius: radius).cgPath
        circleLayer.position = CGPoint(x: radius - radius + 2, y: radius - radius + 2)
        circleLayer.lineWidth = 2
        circleLayer.strokeColor = #colorLiteral(red: 0.305240575, green: 0.7878151489, blue: 0.8980392157, alpha: 1).cgColor
        circleLayer.fillColor = UIColor.clear.cgColor
         
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
        
        dayLabel.textColor = day.isWeekend ? #colorLiteral(red: 1, green: 0.5330614917, blue: 0.5982242903, alpha: 1) : #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
        
        if day.currentDay {
            if currentDayLayer.superlayer == nil {
                self.layer.sublayers?.insert(currentDayLayer, at: 0)
            }
        } else {
            currentDayLayer.removeFromSuperlayer()
        }

        if day.isSelected {
            if selectLayer.superlayer == nil {
                self.layer.sublayers?.insert(selectLayer, at: 0)
                self.dayLabel.textColor = .white
            }
        } else {
            selectLayer.removeFromSuperlayer()
        }
        
    }
}
