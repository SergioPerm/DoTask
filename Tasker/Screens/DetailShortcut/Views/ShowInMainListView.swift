//
//  ShowInMenuView.swift
//  Tasker
//
//  Created by KLuV on 05.01.2021.
//  Copyright © 2021 itotdel. All rights reserved.
//

import UIKit

class ShowInMainListView: UIView {

    var showInMainList: Bool {
        didSet {
            toggleSwitch.setOn(showInMainList, animated: false)
        }
    }
    
    private let label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Show in main list"
        
        return label
    }()
    
    private let toggleSwitch: UISwitch = {
        let toggleSwitch = UISwitch()
        toggleSwitch.translatesAutoresizingMaskIntoConstraints = false
        
        return toggleSwitch
    }()
    
    private let topBorderShape: CAShapeLayer = CAShapeLayer()
    private let bottomBorderShape: CAShapeLayer = CAShapeLayer()
    
    var toggleShowInMainListHandler: (() -> Void)?
    
    init() {
        self.showInMainList = false
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        drawBorders()
    }
    
}

// MARK: Setup

extension ShowInMainListView {
    private func setup() {
        translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(label)
        addSubview(toggleSwitch)
        
        let labelTrailing = label.trailingAnchor.constraint(equalTo: toggleSwitch.leadingAnchor)
        labelTrailing.priority = UILayoutPriority(250)
        
        let constraints = [
            label.leadingAnchor.constraint(equalTo: leadingAnchor),
            label.topAnchor.constraint(equalTo: topAnchor),
            label.bottomAnchor.constraint(equalTo: bottomAnchor),
            labelTrailing,
            toggleSwitch.centerYAnchor.constraint(equalTo: centerYAnchor),
            toggleSwitch.trailingAnchor.constraint(equalTo: trailingAnchor)
        ]
        
        NSLayoutConstraint.activate(constraints)
        
        toggleSwitch.addTarget(self, action: #selector(toggleSwitchAction(sender:)), for: .valueChanged)
    }
    
    private func drawBorders() {
        topBorderShape.removeFromSuperlayer()
        bottomBorderShape.removeFromSuperlayer()
        
        topBorderShape.frame = CGRect(x: 0, y: 0, width: frame.width, height: 1)
        topBorderShape.backgroundColor = #colorLiteral(red: 0.8463017875, green: 0.8463017875, blue: 0.8463017875, alpha: 1).cgColor
        
        bottomBorderShape.frame = CGRect(x: 0, y: frame.height - 2, width: frame.width, height: 1)
        bottomBorderShape.backgroundColor = #colorLiteral(red: 0.8463017875, green: 0.8463017875, blue: 0.8463017875, alpha: 1).cgColor
        
        layer.addSublayer(topBorderShape)
        layer.addSublayer(bottomBorderShape)
    }
}

// MARK: Actions

extension ShowInMainListView {
    @objc private func toggleSwitchAction(sender: UISwitch) {
        if let showInMainListAction = toggleShowInMainListHandler {
            showInMainListAction()
        }
    }
}
