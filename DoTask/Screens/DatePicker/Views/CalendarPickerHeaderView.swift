//
//  CalendarPickerHeaderView.swift
//  ToDoList
//
//  Created by kluv on 09/09/2020.
//  Copyright © 2020 com.kluv.itotdel. All rights reserved.
//

import UIKit

class CalendarPickerHeaderView: UIView {

    let kCONTENT_XIB_NAME = "CalendarPickerHeaderView"
    var borderBottom: CALayer = CALayer()
    let borderWidth: CGFloat = StyleGuide.CalendarDatePicker.borderWidth
    let borderColor = StyleGuide.CalendarDatePicker.borderColor.cgColor
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var monthYearLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    func commonInit() {
        let nib = UINib(nibName: kCONTENT_XIB_NAME, bundle: Bundle.main)
        nib.instantiate(withOwner: self, options: nil)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(contentView)
        self.addConstraints()
        self.addBorder()
    }
    
    func addConstraints() {
        NSLayoutConstraint.activate([
            self.topAnchor.constraint(equalTo: contentView.topAnchor),
            self.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            self.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            self.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    func addBorder() {
        borderBottom.frame = CGRect(x: 0, y: frame.height - borderWidth, width: frame.width, height: borderWidth)
        borderBottom.backgroundColor = borderColor
        layer.addSublayer(borderBottom)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        monthYearLabel.font = Font.calendarPickerFooterFont.uiFont.withSize(StyleGuide.CalendarDatePicker.ratioToViewWidthFont * frame.width)
        
        borderBottom.frame = CGRect(x: 0, y: frame.height - borderWidth, width: frame.width, height: borderWidth)
    }
    
}
