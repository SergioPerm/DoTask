//
//  SettingsTasksShortcutTableViewCell.swift
//  DoTask
//
//  Created by Сергей Лепинин on 16.04.2021.
//  Copyright © 2021 itotdel. All rights reserved.
//

import UIKit
import SnapKit

class SettingsTasksShortcutTableViewCell: UITableViewCell, TableViewCellType {

    weak var viewModel: SettingsTasksShortcutItemViewModelType? {
        didSet {
            bindViewModel()
        }
    }
    
    private let shapeView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let shape: CAShapeLayer = {
        let layer = CAShapeLayer()
        
        return layer
    }()

    private let title: UILabel = {
        let label = UILabel()
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        drawShape()
    }
    
}

extension SettingsTasksShortcutTableViewCell {
    private func bindViewModel() {
        
        guard let viewModel = viewModel else { return }
        
        shape.removeFromSuperlayer()
        if let hexColor = viewModel.outputs.hexColor {
            shapeView.layer.addSublayer(shape)
            shape.fillColor = UIColor(hexString: hexColor).cgColor
            shape.strokeColor = UIColor(hexString: hexColor).cgColor
        }
        
        title.text = viewModel.outputs.itemTitle
        checkmark.isHidden = !viewModel.outputs.select
        
        viewModel.outputs.selectChangeEvent.subscribe(self) { (this, select) in
            this.checkmark.isHidden = !select
        }
                
    }
    
    private func drawShape() {
        let iconSize = StyleGuide.Settings.Sizes.iconSize
        let circleSize = iconSize/2
        
        let path = UIBezierPath(arcCenter: CGPoint(x: iconSize/2, y: iconSize/2), radius: circleSize/2, startAngle: 0.0, endAngle: CGFloat(Double.pi * 2), clockwise: true)
        
        shape.path = path.cgPath
        shape.lineWidth = 1.0
    }
    
    private func setup() {
        selectionStyle = .none
        
        contentView.addSubview(shapeView)
        contentView.addSubview(title)
        contentView.addSubview(checkmark)
        
        let cellHeight = StyleGuide.Settings.Sizes.cellHeight
        let iconSize = StyleGuide.Settings.Sizes.iconSize
        let controlSize = StyleGuide.Settings.Sizes.controlSize

        shapeView.snp.makeConstraints({ make in
            make.left.equalTo(20)
            make.centerY.equalToSuperview()
            make.width.equalTo(iconSize)
            make.height.equalTo(iconSize)
        })
        
        title.snp.makeConstraints({ make in
            make.left.equalTo(shapeView.snp.right).offset(10)
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(cellHeight)
            make.width.equalTo(10).priority(.low)
        })
        
        title.snp.contentCompressionResistanceHorizontalPriority = 751
        
        checkmark.snp.makeConstraints({ make in
            make.height.equalTo(controlSize)
            make.width.equalTo(controlSize)
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-20)
        })
    }
}
