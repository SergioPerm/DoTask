//
//  ShowInMenuView.swift
//  DoTask
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
    
    private let label: LocalizableLabel = {
        let label = LocalizableLabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.localizableString = LocalizableStringResource(stringResource: R.string.localizable.show_IN_MAINLIST)
        label.font = FontFactory.AvenirNextMedium.of(size: StyleGuide.getSizeRelativeToScreenWidth(baseSize: 21))
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.numberOfLines = 1
        
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
        
        let labelTrailing = label.trailingAnchor.constraint(equalTo: toggleSwitch.leadingAnchor, constant: -10)
        
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        
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
        
        let borderHeight = StyleGuide.DetailShortcut.ShowInMainList.Sizes.borderHeight
        
        topBorderShape.frame = CGRect(x: 0, y: 0, width: frame.width, height: borderHeight)
        topBorderShape.backgroundColor = R.color.shortcutDetail.borderColor()!.cgColor
        
        bottomBorderShape.frame = CGRect(x: 0, y: frame.height - borderHeight, width: frame.width, height: borderHeight)
        bottomBorderShape.backgroundColor = R.color.shortcutDetail.borderColor()!.cgColor
        
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
