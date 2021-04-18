//
//  SettingsTasksTransferOverdueToggle.swift
//  DoTask
//
//  Created by Сергей Лепинин on 18.04.2021.
//  Copyright © 2021 itotdel. All rights reserved.
//

import UIKit
import SnapKit

class SettingsTasksTransferOverdueSwitch: UIView {

    var changeSettingHandler: (() -> Void)?
    var transferOverdue: Bool {
        didSet {
            switchControl.isOn = transferOverdue
        }
    }
    
    let switchControl: UISwitch = {
        let switchCtrl = UISwitch()
        switchCtrl.translatesAutoresizingMaskIntoConstraints = false
        
        return switchCtrl
    }()
    
    let title: LocalizableLabel = {
        let label = LocalizableLabel()
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.localizableString = LocalizableStringResource(stringResource: R.string.localizable.settings_TRANSFER)
        label.font = FontFactory.AvenirNextMedium.of(size: StyleGuide.getSizeRelativeToScreenWidth(baseSize: 18))
        
        return label
    }()

    init() {
        self.transferOverdue = false
        super.init(frame: .zero)
        setup()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
}

extension SettingsTasksTransferOverdueSwitch {
    private func setup() {
        addSubview(title)
        addSubview(switchControl)
        
        switchControl.addTarget(self, action: #selector(toggleSwitchAction(sender:)), for: .valueChanged)
    }
    
    private func setupConstraints() {
        
        title.snp.makeConstraints({ make in
            make.left.equalToSuperview().offset(20)
            make.top.bottom.equalToSuperview()
            make.right.equalTo(switchControl.snp.left).offset(-10)
        })
        
        title.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        
        switchControl.snp.makeConstraints({ make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-20)
        })
        
    }
    
    @objc private func toggleSwitchAction(sender: UISwitch) {
        if let action = changeSettingHandler {
            action()
        }
    }
}
