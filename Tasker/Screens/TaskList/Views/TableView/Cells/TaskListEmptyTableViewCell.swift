//
//  TaskListEmptyTableViewCell.swift
//  Tasker
//
//  Created by KLuV on 21.02.2021.
//  Copyright © 2021 itotdel. All rights reserved.
//

import UIKit

class TaskListEmptyTableViewCell: UITableViewCell, TableViewCellType {

    var viewModel: TaskListEmptyItemViewModelType? {
        didSet {
            bindViewModel()
        }
    }
    
    private let infoView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        
        return view
    }()
    
    private let infoLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = .gray
        
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension TaskListEmptyTableViewCell {
    
    private func bindViewModel() {
        
    }
    
    private func setup() {
        selectionStyle = .none
        
        contentView.addSubview(infoView)
        infoView.addSubview(infoLabel)
        
        infoLabel.text = "The day is empty"
        
        let constraints: [NSLayoutConstraint] = [
            infoView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            infoView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            infoView.topAnchor.constraint(equalTo: contentView.topAnchor),
            infoView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            infoLabel.leadingAnchor.constraint(equalTo: infoView.leadingAnchor),
            infoLabel.trailingAnchor.constraint(equalTo: infoView.trailingAnchor),
            infoLabel.topAnchor.constraint(equalTo: infoView.topAnchor, constant: 30),
            infoLabel.bottomAnchor.constraint(equalTo: infoView.bottomAnchor, constant: -30)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
}
