//
//  SettingsTableViewCell.swift
//  DoTask
//
//  Created by Сергей Лепинин on 30.03.2021.
//  Copyright © 2021 itotdel. All rights reserved.
//

import UIKit
import SnapKit

class SettingsTasksNewTimeTableViewCell: UITableViewCell {

    weak var viewModel: SettingsTasksNewTimeItemViewModelType? {
        willSet {
            viewModel?.outputs.selectChangeEvent.unsubscribe(self)
        }
        didSet {
            bindViewModel()
        }
    }
    
    private let icon: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    private let timeTitle: LocalizableLabel = {
        let label = LocalizableLabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.textAlignment = .left
        label.font = FontFactory.AvenirNextMedium.of(size: StyleGuide.getSizeRelativeToScreenWidth(baseSize: 18))
        
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

extension SettingsTasksNewTimeTableViewCell {
    private func bindViewModel() {
        guard let viewModel = viewModel else { return }
        
        icon.image = UIImage(data: viewModel.outputs.iconData)
        timeTitle.localizableString = viewModel.outputs.itemTitle
        checkmark.isHidden = !viewModel.outputs.select
        
        viewModel.outputs.selectChangeEvent.subscribe(self) { (this, select) in
            self.checkmark.isHidden = !select
        }
    }
    
    private func setup() {
        
        selectionStyle = .none
        
        contentView.addSubview(icon)
        contentView.addSubview(timeTitle)
        contentView.addSubview(checkmark)
        
        let cellHeight = StyleGuide.Settings.Sizes.cellHeight
        let iconSize = StyleGuide.Settings.Sizes.iconSize
        let controlSize = StyleGuide.Settings.Sizes.controlSize
        
        icon.snp.makeConstraints({ make in
            make.left.equalTo(20)
            make.centerY.equalToSuperview()
            make.width.equalTo(iconSize)
            make.height.equalTo(iconSize)
        })
        
        timeTitle.snp.makeConstraints({ make in
            make.left.equalTo(icon.snp.right).offset(10)
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(cellHeight)
            make.width.equalTo(10).priority(.low)
        })
        
        timeTitle.snp.contentCompressionResistanceHorizontalPriority = 751
        
        checkmark.snp.makeConstraints({ make in
            make.height.equalTo(controlSize)
            make.width.equalTo(controlSize)
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-20)
        })
    }
}
