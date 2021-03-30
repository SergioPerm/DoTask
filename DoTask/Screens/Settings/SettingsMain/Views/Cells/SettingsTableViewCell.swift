//
//  SettingsTableViewCell.swift
//  DoTask
//
//  Created by Сергей Лепинин on 30.03.2021.
//  Copyright © 2021 itotdel. All rights reserved.
//

import UIKit
import SnapKit

class SettingsTableViewCell: UITableViewCell {

    private let icon: UIImageView = {
        let imageView = UIImageView(image: R.image.settings.language())
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    private let arrow: UIImageView = {
        let imageView = UIImageView(image: R.image.settings.rightArrow()?.maskWithColor(color: .gray))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    private let settingsTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.textAlignment = .left
        label.font = FontFactory.AvenirNextMedium.of(size: 20)
        
        return label
    }()
    
    private let settingsValue: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .gray
        label.textAlignment = .right
        label.font = FontFactory.AvenirNextMedium.of(size: 20)
        
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

}

extension SettingsTableViewCell {
    private func setup() {
        
        settingsTitle.text = "Language"
        settingsValue.text = "English"
        
        contentView.addSubview(icon)
        contentView.addSubview(settingsTitle)
        contentView.addSubview(settingsValue)
        contentView.addSubview(arrow)
        
        icon.snp.makeConstraints({ make in
            make.left.equalTo(25)
            make.centerY.equalToSuperview()
            make.width.equalTo(25)
            make.height.equalTo(25)
        })
        
        settingsTitle.snp.makeConstraints({ make in
            make.left.equalTo(icon.snp.right).offset(15)
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(50)
            make.width.equalTo(10).priority(.low)
        })
        
        settingsTitle.snp.contentCompressionResistanceHorizontalPriority = 751

        settingsValue.snp.makeConstraints({ make in
            make.left.equalTo(settingsTitle.snp.right).offset(15)
            make.top.bottom.equalToSuperview()
            make.height.equalTo(50)
            make.width.equalTo(10).priority(.low)
            make.right.equalTo(arrow.snp.left).offset(-15)
        })
        
        arrow.snp.makeConstraints({ make in
            make.height.equalTo(15)
            make.width.equalTo(15)
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-25)
        })
    }
}
