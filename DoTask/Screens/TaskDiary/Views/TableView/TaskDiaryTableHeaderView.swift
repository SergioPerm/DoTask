//
//  TaskDiaryTableHeaderView.swift
//  DoTask
//
//  Created by KLuV on 05.02.2021.
//  Copyright © 2021 itotdel. All rights reserved.
//

import UIKit

class TaskDiaryTableHeaderView: UIView {

    private let titleLabel: UILabel = {
        let label = UILabel()
        
        label.font = FontFactory.AvenirNextBold.of(size: StyleGuide.getSizeRelativeToScreenWidth(baseSize: 27))
        
        label.textColor = #colorLiteral(red: 0.2392156863, green: 0.6235294118, blue: 0.9960784314, alpha: 1)
        label.backgroundColor = UIColor.white
        
        return label
    }()
        
    init(title: String, frame: CGRect) {
        titleLabel.text = "  \(title)"
        
        super.init(frame: frame)
        
        addSubview(titleLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        titleLabel.frame = CGRect.init(x: 0, y: 5, width: frame.width, height: StyleGuide.TaskList.Sizes.headerTitleHeight)
    }
    
}
