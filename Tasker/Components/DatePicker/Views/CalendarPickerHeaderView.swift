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
    var borderBottom: CALayer?
    let borderWidth: CGFloat = 0.3
    let borderColor =  #colorLiteral(red: 0.8892104444, green: 0.8892104444, blue: 0.8892104444, alpha: 1).cgColor
    
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
        borderBottom = CALayer()
        borderBottom!.frame = CGRect(x: 0, y: frame.height - borderWidth, width: frame.width, height: borderWidth)
        borderBottom!.backgroundColor = borderColor
        layer.addSublayer(borderBottom!)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        //auto font size 280 / 22
        monthYearLabel.font = monthYearLabel.font.withSize(frame.width/(280/22))
        
        guard let border = borderBottom else { return }
        border.frame = CGRect(x: 0, y: frame.height - borderWidth*2, width: frame.width, height: borderWidth)
    }
    
}
