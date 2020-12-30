//
//  SubtasksFooterView.swift
//  Tasker
//
//  Created by KLuV on 23.12.2020.
//  Copyright © 2020 itotdel. All rights reserved.
//

import UIKit

class SubtasksFooterView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension SubtasksFooterView {
    private func setup() {
        let footerTitle = UILabel()
        footerTitle.translatesAutoresizingMaskIntoConstraints = false
        footerTitle.text = " -> Add new subtask"
        footerTitle.font = Font.detailTaskStandartTitle.uiFont
        footerTitle.textColor = .gray
        footerTitle.backgroundColor = .green
        
        addSubview(footerTitle)
        
        let constraints = [
            footerTitle.centerYAnchor.constraint(equalTo: centerYAnchor),
            footerTitle.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            footerTitle.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            footerTitle.heightAnchor.constraint(equalToConstant: 20)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
}
