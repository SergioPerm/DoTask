//
//  TaskListEmptyTableViewCell.swift
//  DoTask
//
//  Created by KLuV on 21.02.2021.
//  Copyright © 2021 itotdel. All rights reserved.
//

import UIKit

class TaskListEmptyTableViewCell: UITableViewCell, TableViewCellType {

    weak var viewModel: TaskListEmptyItemViewModelType? {
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
    
    private var infoViewHeightConstrains: NSLayoutConstraint = NSLayoutConstraint()
    
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
        guard let viewModel = viewModel else { return }
        
        if viewModel.info == "" {
            infoLabel.removeFromSuperview()
        } else {
            if infoLabel.superview == nil {
                infoView.addSubview(infoLabel)
                setupLabelConstraints()
            }
            infoLabel.text = viewModel.info
        }
                
        let rowHeight = CGFloat(viewModel.rowHeight)

        infoViewHeightConstrains.constant = rowHeight
        layoutIfNeeded()
    }
    
    private func setup() {
                
        selectionStyle = .none
        
        contentView.addSubview(infoView)
        infoView.addSubview(infoLabel)
        
        infoLabel.text = ""
        
        infoViewHeightConstrains = infoView.heightAnchor.constraint(equalToConstant: 1)
        infoViewHeightConstrains.priority = UILayoutPriority(250)
        
        let constraints: [NSLayoutConstraint] = [
            infoView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            infoView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            infoView.topAnchor.constraint(equalTo: contentView.topAnchor),
            infoView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            infoViewHeightConstrains
        ]
        
        NSLayoutConstraint.activate(constraints)
        
        setupLabelConstraints()
    }
    
    private func setupLabelConstraints() {
        let constraints: [NSLayoutConstraint] = [
            infoLabel.centerXAnchor.constraint(equalTo: infoView.centerXAnchor),
            infoLabel.centerYAnchor.constraint(equalTo: infoView.centerYAnchor)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
}
