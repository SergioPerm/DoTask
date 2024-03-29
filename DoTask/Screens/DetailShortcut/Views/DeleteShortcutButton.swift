//
//  DeleteShortcutButton.swift
//  DoTask
//
//  Created by KLuV on 11.01.2021.
//  Copyright © 2021 itotdel. All rights reserved.
//

import UIKit

class DeleteShortcutButton: UIView {

    init() {
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        //updateShadow()
    }

}

extension DeleteShortcutButton {
    private func updateShadow() {
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: 10).cgPath
    }
    
    private func setup() {
        
        layer.cornerRadius = StyleGuide.DetailShortcut.DeleteBtn.Sizes.cornerRadius
        backgroundColor = R.color.shortcutDetail.deleteShortcutBtn()
        translatesAutoresizingMaskIntoConstraints = false
        
        let label = LocalizableLabel()
        label.localizableString = LocalizableStringResource(stringResource: R.string.localizable.deletE)
        label.font = FontFactory.Helvetica.of(size: StyleGuide.getSizeRelativeToScreenWidth(baseSize: 17))
        label.textColor = R.color.shortcutDetail.deleteShortcutBtnText()
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.numberOfLines = 1
        label.baselineAdjustment = .alignCenters
        
        addSubview(label)
        
        NSLayoutConstraint.activate([
            label.centerYAnchor.constraint(equalTo: centerYAnchor),
            label.centerXAnchor.constraint(equalTo: centerXAnchor),
            label.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.8)
        ])
                
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapAction(sender:)))
        addGestureRecognizer(tapRecognizer)
    }
    
    @objc private func tapAction(sender: UITapGestureRecognizer) {
        let animationIn = CAKeyframeAnimation(keyPath: "transform.scale")
        
        animationIn.values = [1.0, 0.9, 1.0]
        animationIn.keyTimes = [0, 0.3, 0.7]
        
        layer.add(animationIn, forKey: "pulse")
    }
}
