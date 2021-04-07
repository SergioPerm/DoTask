//
//  SettingsLanguageTableViewCell.swift
//  DoTask
//
//  Created by Сергей Лепинин on 06.04.2021.
//  Copyright © 2021 itotdel. All rights reserved.
//

import UIKit

class SettingsLanguageTableViewCell: UITableViewCell {

    private let icon: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    private let languageTitle: LocalizableLabel = {
        let label = LocalizableLabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.textAlignment = .left
        label.font = FontFactory.AvenirNextMedium.of(size: StyleGuide.getSizeRelativeToScreenWidth(baseSize: 20))
        
        return label
    }()
    
    private let checkmark: UIImageView = {
        let imageView = UIImageView(image: R.image.settings.checkmark())
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
}

extension SettingsLanguageTableViewCell {
    private func setup() {
        contentView.addSubview(icon)
        contentView.addSubview(languageTitle)
        contentView.addSubview(checkmark)
        
        let cellHeight = StyleGuide.Settings.Sizes.cellHeight
        let iconSize = StyleGuide.Settings.Sizes.iconSize
        let arrowSize = StyleGuide.Settings.Sizes.controlSize
        
        icon.snp.makeConstraints({ make in
            make.left.equalTo(25)
            make.centerY.equalToSuperview()
            make.width.equalTo(iconSize)
            make.height.equalTo(iconSize)
        })
        
        languageTitle.snp.makeConstraints({ make in
            make.left.equalTo(icon.snp.right).offset(15)
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(cellHeight)
            make.width.equalTo(10).priority(.low)
        })
        
        languageTitle.snp.contentCompressionResistanceHorizontalPriority = 751
        
        checkmark.snp.makeConstraints({ make in
            make.height.equalTo(arrowSize)
            make.width.equalTo(arrowSize)
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-25)
        })
    }
}
