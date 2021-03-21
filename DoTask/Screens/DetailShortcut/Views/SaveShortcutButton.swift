//
//  SaveShortcutButton.swift
//  DoTask
//
//  Created by KLuV on 05.01.2021.
//  Copyright © 2021 itotdel. All rights reserved.
//

import UIKit

class SaveShortcutButton: UIView {

    init() {
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateShadow()
    }

}

extension SaveShortcutButton {
    private func updateShadow() {
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: 10).cgPath
    }
    
    private func setup() {
        
        layer.cornerRadius = StyleGuide.DetailShortcut.SaveBtn.Sizes.cornerRadiud
        backgroundColor = StyleGuide.DetailTask.Colors.addSubtaskbtnColor
        translatesAutoresizingMaskIntoConstraints = false
        
        let label = UILabel()
        label.text = "Save"
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(label)
        
        NSLayoutConstraint.activate([
            label.centerYAnchor.constraint(equalTo: centerYAnchor),
            label.centerXAnchor.constraint(equalTo: centerXAnchor),
            label.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.8)
        ])
        
        clipsToBounds = false
        layer.shadowColor = #colorLiteral(red: 0.5, green: 0.5, blue: 0.5, alpha: 1).cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        layer.shadowRadius = StyleGuide.DetailShortcut.SaveBtn.Sizes.cornerRadiud
        
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
