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

    weak var viewModel: SettingsItemViewModelType? {
        didSet {
            bindViewModel()
        }
    }
    
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
    
    private let settingsTitle: LocalizableLabel = {
        let label = LocalizableLabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.textAlignment = .left
        label.font = FontFactory.AvenirNextMedium.of(size: StyleGuide.getSizeRelativeToScreenWidth(baseSize: 20))
        
        return label
    }()
    
    private let settingsValue: LocalizableLabel = {
        let label = LocalizableLabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .gray
        label.textAlignment = .right
        label.font = FontFactory.AvenirNextMedium.of(size: StyleGuide.getSizeRelativeToScreenWidth(baseSize: 20))
        
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
    private func bindViewModel() {
        
        guard let viewModel = viewModel else { return }
        
        icon.image = UIImage(data: viewModel.outputs.iconData)
        settingsValue.isHidden = !viewModel.outputs.singleValueSetting
        settingsTitle.localizableString = viewModel.outputs.itemTitle
        settingsValue.localizableString = viewModel.outputs.itemValue
        
    }
    
    private func setup() {
                
        selectionStyle = .none
        
        contentView.addSubview(icon)
        contentView.addSubview(settingsTitle)
        contentView.addSubview(settingsValue)
        contentView.addSubview(arrow)
        
        let cellHeight = StyleGuide.Settings.Sizes.cellHeight
        let iconSize = StyleGuide.Settings.Sizes.iconSize
        let arrowSize = StyleGuide.Settings.Sizes.controlSize
        
        icon.snp.makeConstraints({ make in
            make.left.equalTo(25)
            make.centerY.equalToSuperview()
            make.width.equalTo(iconSize)
            make.height.equalTo(iconSize)
        })
        
        settingsTitle.snp.makeConstraints({ make in
            make.left.equalTo(icon.snp.right).offset(15)
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(cellHeight)
            make.width.equalTo(10).priority(.low)
        })

        settingsTitle.snp.contentCompressionResistanceHorizontalPriority = 751

        settingsValue.snp.makeConstraints({ make in
            make.left.equalTo(settingsTitle.snp.right).offset(15)
            make.top.bottom.equalToSuperview()
            make.height.equalTo(cellHeight)
            make.width.equalTo(10).priority(.low)
            make.right.equalTo(arrow.snp.left).offset(-15)
        })

        arrow.snp.makeConstraints({ make in
            make.height.equalTo(arrowSize)
            make.width.equalTo(arrowSize)
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-25)
        })
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapHandler(sender:)))
        contentView.addGestureRecognizer(tapRecognizer)
    }
    
    @objc private func tapHandler(sender: UITapGestureRecognizer) {
        viewModel?.inputs.selectItem()
    }
}
