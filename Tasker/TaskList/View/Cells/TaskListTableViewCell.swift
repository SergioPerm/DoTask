//
//  TaskListTableViewCell.swift
//  Tasker
//
//  Created by kluv on 28/09/2020.
//  Copyright © 2020 itotdel. All rights reserved.
//

import UIKit

class TaskListTableViewCell: UITableViewCell {
        
    let cellLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = .red
        
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(cellLabel)
        
        backgroundColor = .green
        
        cellLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        cellLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20).isActive = true
        cellLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 20).isActive = true
        cellLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
