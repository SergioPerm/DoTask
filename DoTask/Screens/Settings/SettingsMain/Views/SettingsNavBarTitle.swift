//
//  SettingsNavBarTitle.swift
//  DoTask
//
//  Created by Сергей Лепинин on 06.04.2021.
//  Copyright © 2021 itotdel. All rights reserved.
//

import UIKit
import SnapKit

class SettingsNavBarTitle: UIView {
    
    private let titleLabel: LocalizableLabel = {
        let label = LocalizableLabel()
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = FontFactory.AvenirNextMedium.of(size: StyleGuide.getSizeRelativeToScreenWidth(baseSize: 21))
        
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        titleLabel.frame = bounds
    }
            
}

extension SettingsNavBarTitle {
    private func setup() {
        backgroundColor = .clear
        
        titleLabel.frame = bounds
        
        addSubview(titleLabel)
        
        titleLabel.localizableString = LocalizableStringResource(stringResource: R.string.localizable.settings_TITLE)
        
        titleLabel.snp.makeConstraints({ make in
            make.left.top.right.bottom.equalToSuperview()
        })
    }
    
    func setTitle(localizeString: LocalizableStringResource?) {
        titleLabel.localizableString = localizeString
    }
}
