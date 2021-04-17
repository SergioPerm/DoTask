//
//  TaskListEmptyTableViewCell.swift
//  DoTask
//
//  Created by KLuV on 21.02.2021.
//  Copyright © 2021 itotdel. All rights reserved.
//

import UIKit
import SnapKit

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
    
    private let infoLabel: LocalizableLabel = {
        let label = LocalizableLabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = .gray
        label.numberOfLines = 0
        
        return label
    }()
    
    private var infoViewHeightConstraint: Constraint?
    
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
        
        infoLabel.removeFromSuperview()

        if viewModel.info != nil {
            infoLabel.localizableString = viewModel.info
            infoView.addSubview(infoLabel)
            setupLabelConstraints()
        }
                
        let rowHeight = CGFloat(viewModel.rowHeight)

        infoViewHeightConstraint?.update(offset: rowHeight)
        
        layoutIfNeeded()
    }
    
    private func setup() {
        selectionStyle = .none
        contentView.addSubview(infoView)
                        
        setupConstraints()
    }
    
    private func setupConstraints() {
        infoView.snp.makeConstraints({ make in
            self.infoViewHeightConstraint = make.height.equalTo(1.0).priority(.low).constraint
            make.left.top.right.bottom.equalToSuperview()
        })
    }
    
    private func setupLabelConstraints() {
        infoLabel.snp.makeConstraints({ make in
            make.centerY.centerX.equalToSuperview()
            make.width.equalTo(UIView.globalSafeAreaFrame.width * 0.7)
        })
    }
}
