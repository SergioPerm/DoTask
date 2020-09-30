//
//  CalendarPickerFooterView.swift
//  ToDoList
//
//  Created by kluv on 09/09/2020.
//  Copyright © 2020 com.kluv.itotdel. All rights reserved.
//

import UIKit

class CalendarPickerFooterView: UIView {
    
    let kCONTENT_XIB_NAME = "CalendarPickerFooterView"
    var borderTop: CALayer?
    var borderMiddle: CALayer?
    var borderMiddleVertical: CALayer?
    let borderWidth: CGFloat = 0.3
    let borderColor =  #colorLiteral(red: 0.8892104444, green: 0.8892104444, blue: 0.8892104444, alpha: 1).cgColor
    
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
        let nib = UINib(nibName: kCONTENT_XIB_NAME, bundle: Bundle.main)
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
        borderTop = CALayer()
        borderTop!.frame = CGRect(x: 0, y: 0, width: frame.width, height: borderWidth)
        borderTop!.backgroundColor = borderColor
        layer.addSublayer(borderTop!)
        
        borderMiddleVertical = CALayer()
        borderMiddleVertical!.frame = CGRect(x: frame.width/2, y: frame.height/2, width: borderWidth, height: frame.height/2)
        borderMiddleVertical!.backgroundColor = borderColor
        layer.addSublayer(borderMiddleVertical!)
       
        borderMiddle = CALayer()
        borderMiddle!.frame = CGRect(x: 0, y: frame.height/2, width: frame.width, height: borderWidth)
        borderMiddle!.backgroundColor = borderColor
        layer.addSublayer(borderMiddle!)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let fontSize = frame.width/(280/15)
        
        currentDateLabel.font = currentDateLabel.font.withSize(fontSize)
        cancelButton.titleLabel?.font = cancelButton.titleLabel?.font.withSize(fontSize)
        saveButton.titleLabel?.font = saveButton.titleLabel?.font.withSize(fontSize)
        
        guard let borderTop = borderTop, let borderMiddleVertical = borderMiddleVertical, let borderMiddle = borderMiddle else { return }
        borderTop.frame = CGRect(x: 0, y: borderWidth*2, width: frame.width, height: borderWidth)
        borderMiddle.frame = CGRect(x: 0, y: frame.height/2 - borderWidth*2, width: frame.width, height: borderWidth)
        borderMiddleVertical.frame = CGRect(x: frame.width/2, y: frame.height/2, width: borderWidth, height: frame.height/2)
    }
}
