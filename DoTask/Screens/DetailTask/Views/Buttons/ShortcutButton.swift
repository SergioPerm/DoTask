//
//  ShortcutButton.swift
//  DoTask
//
//  Created by KLuV on 12.01.2021.
//  Copyright © 2021 itotdel. All rights reserved.
//

import UIKit

class ShortcutButton: UIView {

    var shortcutBtnData: ShortcutData {
        didSet {
            titleLabel.text = shortcutBtnData.title ?? "Shortcut"
            if let btnHexColor = shortcutBtnData.colorHex {
                let color = UIColor(hexString: btnHexColor)
                backgroundColor = color
                layer.borderColor = color.cgColor
                titleLabel.textColor = .white
            } else {
                backgroundColor = .white
                layer.borderWidth = StyleGuide.DetailTask.Sizes.shortcutBtnLineWidth
                layer.borderColor = R.color.detailTask.shortcutBtn()!.cgColor
                titleLabel.textColor = R.color.detailTask.shortcutBtn()
            }
        }
    }
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = FontFactory.AvenirNextBold.of(size: StyleGuide.getSizeRelativeToScreenWidth(baseSize: 17))
        
        return label
    }()
    
    init() {
        self.shortcutBtnData = ShortcutData(title: nil, colorHex: nil)
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension ShortcutButton {
    private func setup() {
        layer.cornerRadius = StyleGuide.DetailTask.Sizes.shortcutSelectCornerRadius
                        
        addSubview(titleLabel)
                
        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10)
        ])
        
        titleLabel.text = "Shortcut"
        backgroundColor = .white
        layer.borderWidth = StyleGuide.DetailTask.Sizes.shortcutBtnLineWidth
        layer.borderColor = R.color.detailTask.shortcutBtn()!.cgColor
        titleLabel.textColor = R.color.detailTask.shortcutBtn()
    }
}
