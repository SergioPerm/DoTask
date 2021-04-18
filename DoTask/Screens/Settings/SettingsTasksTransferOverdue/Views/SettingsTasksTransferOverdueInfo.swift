//
//  SettingsTasksTransferOverdueInfo.swift
//  DoTask
//
//  Created by Сергей Лепинин on 18.04.2021.
//  Copyright © 2021 itotdel. All rights reserved.
//

import UIKit

class SettingsTasksTransferOverdueInfo: UIView {
    
    let title: LocalizableLabel = {
        let label = LocalizableLabel()
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.localizableString = LocalizableStringResource(stringResource: R.string.localizable.settings_TRANSFER_INFO)
        label.font = FontFactory.AvenirNextMedium.of(size: StyleGuide.getSizeRelativeToScreenWidth(baseSize: 15))
        label.numberOfLines = 3
        
        return label
    }()

    init() {
        super.init(frame: .zero)
        setup()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

}

extension SettingsTasksTransferOverdueInfo {
    private func setup() {
        addSubview(title)
    }
    
    private func setupConstraints() {
        title.snp.makeConstraints({ make in
            make.top.bottom.equalToSuperview()
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
        })
    }
}
