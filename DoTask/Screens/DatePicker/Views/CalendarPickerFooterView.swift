//
//  CalendarPickerFooterView.swift
//  ToDoList
//
//  Created by kluv on 09/09/2020.
//  Copyright © 2020 com.kluv.itotdel. All rights reserved.
//

import UIKit

class CalendarPickerFooterView: UIView {
    
    var borderTop: CALayer = CALayer()
    var borderMiddle: CALayer = CALayer()
    var borderMiddleVertical: CALayer = CALayer()
    let borderWidth: CGFloat = StyleGuide.CalendarDatePicker.borderWidth
    let borderColor: CGColor = StyleGuide.CalendarDatePicker.borderColor.cgColor
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var currentDateLabel: UILabel!
    @IBOutlet weak var clearDateButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    func commonInit() {
        let nib = UINib(nibName: self.className, bundle: Bundle.main)
        nib.instantiate(withOwner: self, options: nil)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(contentView)
        self.addConstraints()
        self.addBorders()
    }
    
    func addConstraints() {
        NSLayoutConstraint.activate([
            self.topAnchor.constraint(equalTo: contentView.topAnchor),
            self.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            self.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            self.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    func addBorders() {
        borderTop.frame = CGRect(x: 0, y: 0, width: frame.width, height: borderWidth)
        borderTop.backgroundColor = borderColor
        layer.addSublayer(borderTop)
        
        borderMiddleVertical.frame = CGRect(x: frame.width/2, y: frame.height/2, width: borderWidth, height: frame.height/2)
        borderMiddleVertical.backgroundColor = borderColor
        layer.addSublayer(borderMiddleVertical)

        borderMiddle.frame = CGRect(x: 0, y: frame.height/2, width: frame.width, height: borderWidth)
        borderMiddle.backgroundColor = borderColor
        layer.addSublayer(borderMiddle)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let font = FontFactory.HelveticaNeueBold.of(size: StyleGuide.getSizeRelativeToScreenWidth(baseSize: 19))
        currentDateLabel.font = font
        cancelButton.titleLabel?.font = font
        saveButton.titleLabel?.font = font
        
        borderTop.frame = CGRect(x: 0, y: borderWidth*2, width: frame.width, height: borderWidth)
        borderMiddle.frame = CGRect(x: 0, y: frame.height/2 - borderWidth*2, width: frame.width, height: borderWidth)
        borderMiddleVertical.frame = CGRect(x: frame.width/2, y: frame.height/2, width: borderWidth, height: frame.height/2)
    }
}
