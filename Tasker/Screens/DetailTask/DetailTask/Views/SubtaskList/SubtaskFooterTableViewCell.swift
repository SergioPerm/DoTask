//
//  SubtaskFooterTableViewCell.swift
//  Tasker
//
//  Created by KLuV on 24.12.2020.
//  Copyright © 2020 itotdel. All rights reserved.
//

import UIKit

protocol SubtaskFooterTableViewCellDelegate: class {
    func addSubtask()
}

class SubtaskFooterTableViewCell: UITableViewCell {

    weak var cellDelegate: SubtaskFooterTableViewCellDelegate?
    
    private var heightConstraint: NSLayoutConstraint = NSLayoutConstraint()
    
    private let addSubtaskButton: UIView = {
        let addBtn = UIView()
        addBtn.translatesAutoresizingMaskIntoConstraints = false
        addBtn.backgroundColor = StyleGuide.TaskList.Colors.cellMainTitle
        addBtn.layer.cornerRadius = 3
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Add subtask"
        label.textAlignment = .center
        label.numberOfLines = 0
                
        addBtn.addSubview(label)
        
        let constraints = [
            label.leadingAnchor.constraint(equalTo: addBtn.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: addBtn.trailingAnchor),
            label.topAnchor.constraint(equalTo: addBtn.topAnchor),
            label.bottomAnchor.constraint(equalTo: addBtn.bottomAnchor)
        ]
        
        NSLayoutConstraint.activate(constraints)
        
        return addBtn
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        showCellLater()
        heightConstraint.constant = 33
        layoutIfNeeded()
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        showCellLater()
    }
}

extension SubtaskFooterTableViewCell {
    
    private func showCellLater() {
        addSubtaskButton.isHidden = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.addSubtaskButton.isHidden = false
        }
    }
    
    private func setup() {
        
        selectionStyle = .none
    
        contentView.addSubview(addSubtaskButton)
        
        heightConstraint = addSubtaskButton.heightAnchor.constraint(equalToConstant: 33)
        
        let constraints = [
            addSubtaskButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            addSubtaskButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            addSubtaskButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            heightConstraint
        ]
        
        NSLayoutConstraint.activate(constraints)
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(addSubtaskAction(sender:)))
        addSubtaskButton.addGestureRecognizer(tapRecognizer)
        
    }
    
    @objc private func addSubtaskAction(sender: UITapGestureRecognizer) {
        if let delegate = cellDelegate {
            delegate.addSubtask()
        }
    }
}
