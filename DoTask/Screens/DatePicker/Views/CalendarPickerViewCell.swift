//
//  DatePickerCollectionViewCell.swift
//  ToDoList
//
//  Created by kluv on 07/09/2020.
//  Copyright © 2020 com.kluv.itotdel. All rights reserved.
//

import UIKit

class CalendarPickerViewCell: UICollectionViewCell {

    override func prepareForReuse() {
        super.prepareForReuse()
        day = nil
        currentDayLayer.removeFromSuperlayer()
        selectLayer.removeFromSuperlayer()
    }
    
    private lazy var selectLayer: CALayer = {
        let circleLayer = CAShapeLayer()
        let radius: CGFloat = frame.width/2
        circleLayer.path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: 2.0 * radius, height: 2.0 * radius), cornerRadius: radius).cgPath
        circleLayer.position = CGPoint(x: radius - radius, y: radius - radius)
        circleLayer.fillColor = R.color.datePicker.selectCellFill()!.cgColor
        
        return circleLayer
    }()
    
    private lazy var currentDayLayer: CALayer = {
        let circleLayer = CAShapeLayer()
        let radius: CGFloat = frame.width/2
        circleLayer.path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: (2.0 * radius) - 4, height: (2.0 * radius)-4), cornerRadius: radius).cgPath
        circleLayer.position = CGPoint(x: radius - radius + 2, y: radius - radius + 2)
        circleLayer.lineWidth = 2
        circleLayer.strokeColor = R.color.datePicker.currentDayStroke()!.cgColor
        circleLayer.fillColor = R.color.calendar.currentDayFill()!.cgColor
         
        return circleLayer
    }()
    
    @IBOutlet weak var dayLabel: UILabel!
    
    var day: CalendarPickerDay? {
        didSet {
            dayLabel.text = day?.number
            dayLabel.font = dayLabel.font.withSize(StyleGuide.getSizeRelativeToScreenWidth(baseSize: 17))
            
            updateVisibleStatus()
        }
    }
}

// MARK: - Appearance
extension CalendarPickerViewCell {
    
    func updateVisibleStatus() {
        currentDayLayer.removeFromSuperlayer()
        selectLayer.removeFromSuperlayer()
        dayLabel.textColor = .clear
        
        guard let day = day else { return }
              
        if !day.isWithinDisplayedMonth {
            dayLabel.textColor = R.color.datePicker.outDayText()
            return
        }
                
        if day.pastDate {
            dayLabel.textColor = day.isWeekend ? R.color.datePicker.pastDayTextWeekEnd() : R.color.datePicker.pastDayTextWeek()
        } else {
            dayLabel.textColor = day.isWeekend ? R.color.datePicker.dayTextWeekEnd() : R.color.datePicker.dayTextWeek()
        }
        
        if day.isSelected {
            dayLabel.textColor = R.color.calendar.selectText()
            layer.sublayers?.insert(selectLayer, at: 0)
        }
        
        if day.currentDay {
            self.layer.sublayers?.insert(currentDayLayer, at: 0)
        }

    }
}
