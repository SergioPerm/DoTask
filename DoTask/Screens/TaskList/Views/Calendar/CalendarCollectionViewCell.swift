//
//  CalendarCollectionViewCell.swift
//  DoTask
//
//  Created by KLuV on 16.02.2021.
//  Copyright © 2021 itotdel. All rights reserved.
//

import UIKit

class CalendarCollectionViewCell: UICollectionViewCell {
    
    var viewModel: CalendarDayViewModelType? {
        willSet {
            if newValue == nil {
                viewModel?.outputs.dayWithStatusEvent.unsubscribe(self)
                viewModel?.outputs.isSelectedEvent.unsubscribe(self)
            }
        }
        didSet {
            bindViewModel()
        }
    }
    
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
        
        circleLayer.path = UIBezierPath(roundedRect: CGRect(x: 0.0, y: 0.0, width: 2.0 * radius, height: 2.0 * radius), cornerRadius: radius).cgPath
                                        
        circleLayer.position = CGPoint(x: 0.0, y: 0.0)
        circleLayer.lineWidth = StyleGuide.TaskList.Calendar.Sizes.currentDayLayerLineWidth
        circleLayer.strokeColor = Color.blueColor.uiColor.cgColor
        circleLayer.fillColor = Color.clearColor.uiColor.cgColor
         
        return circleLayer
    }()
    
    private lazy var dayWithTasksLayer: CalendarDayWithTasksLayer = {
        let layer = CalendarDayWithTasksLayer()
        layer.frame = CGRect(x: frame.width / 4, y: frame.height * 0.7, width: frame.width / 2, height: frame.width / 4)
          
        return layer
    }()
        
    private let dayLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 17)
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.textColor = StyleGuide.MainColors.blue
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        viewModel = nil
        currentDayLayer.removeFromSuperlayer()
        selectLayer.removeFromSuperlayer()
        dayWithTasksLayer.removeFromSuperlayer()
    }
}

extension CalendarCollectionViewCell {
    
    private func setup() {
        contentView.addSubview(dayLabel)
        
        let constraints: [NSLayoutConstraint] = [
            dayLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            dayLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            dayLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            dayLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    private func bindViewModel() {
        guard let viewModel = viewModel else { return }
        dayLabel.text = viewModel.outputs.dayString
        dayLabel.font = dayLabel.font.withSize(UIView.globalSafeAreaFrame.width * StyleGuide.CalendarDatePicker.ratioToScreenWidthCellFont)
        
        viewModel.outputs.isSelectedEvent.subscribe(self) { this, selected in
            this.onIsSelectedChanged(selected: selected)
        }
        
        viewModel.outputs.dayWithStatusEvent.subscribe(self) { this, status in
            this.updateDayWithTasksLayer(status: status)
        }
        
        updateVisibleStatus()
    }
    
    private func updateDayWithTasksLayer(status: CalendarDayStatus) {
        dayWithTasksLayer.removeFromSuperlayer()
        
        if status != .empty {
            dayWithTasksLayer.setCalendarDayStatus(status: status)
            layer.addSublayer(dayWithTasksLayer)
        }
    }
    
    private func onIsSelectedChanged(selected: Bool) {
        selectLayer.removeFromSuperlayer()
        
        guard let viewModel = viewModel else { return }
        
        if !viewModel.outputs.isWithinDisplayedMonth {
            return
        }
        
        dayWithTasksLayer.setSelect(selected: selected)
                
        if selected {
            layer.sublayers?.insert(selectLayer, at: 0)
        }
        
        updateDayTextColor()
    }
    
    private func updateDayTextColor() {
        
        guard let viewModel = viewModel else { return }
        
        if !viewModel.outputs.isWithinDisplayedMonth {
            dayLabel.textColor = #colorLiteral(red: 0.8125689471, green: 0.8125689471, blue: 0.8125689471, alpha: 1)
        } else if viewModel.outputs.isSelected {
            dayLabel.textColor = Color.whiteColor.uiColor
        } else {
            dayLabel.textColor = viewModel.outputs.isWeekend ? Color.pinkColor.uiColor : Color.blueColor.uiColor
        }
    }
    
    private func updateVisibleStatus() {
        currentDayLayer.removeFromSuperlayer()

        guard let viewModel = viewModel else { return }
        
        onIsSelectedChanged(selected: viewModel.outputs.isSelected)
        updateDayWithTasksLayer(status: viewModel.outputs.dayWithStatus)
        updateDayTextColor()
                
        if viewModel.outputs.currentDay {
            self.layer.addSublayer(currentDayLayer)
        }
    }
}
