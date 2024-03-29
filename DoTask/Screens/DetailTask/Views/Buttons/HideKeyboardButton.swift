//
//  HideKeyboardButton.swift
//  DoTask
//
//  Created by KLuV on 03.01.2021.
//  Copyright © 2021 itotdel. All rights reserved.
//

import UIKit

class HideKeyboardButton: UIView {

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
extension HideKeyboardButton {
    
    private func updateShadow() {
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: StyleGuide.DetailTask.Sizes.addSubtaskBtnCornerRadius).cgPath
    }
    
    private func setup() {
        layer.cornerRadius = StyleGuide.DetailTask.Sizes.addSubtaskBtnCornerRadius
        backgroundColor = R.color.detailTask.hideKeyboardBtn()
        
        let label = UILabel()
        label.text = "⌨️"
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(label)
        
        NSLayoutConstraint.activate([
            label.centerYAnchor.constraint(equalTo: centerYAnchor),
            label.centerXAnchor.constraint(equalTo: centerXAnchor),
            label.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.8)
        ])
        
        clipsToBounds = false
        layer.shadowColor = R.color.detailTask.hideKeyboardBtnShadow()!.cgColor
        layer.shadowOpacity = 0.4
        layer.shadowOffset = CGSize(width: -1.0, height: 0.0)
        layer.shadowRadius = StyleGuide.DetailTask.Sizes.addSubtaskBtnCornerRadius
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapAction(sender:)))
        tapRecognizer.delegate = self
        addGestureRecognizer(tapRecognizer)
    }
    
    @objc private func tapAction(sender: UITapGestureRecognizer) {
        let animationIn = CAKeyframeAnimation(keyPath: "transform.scale")
        
        animationIn.values = [1.0, 0.9, 1.0]
        animationIn.keyTimes = [0, 0.3, 0.7]
        
        layer.add(animationIn, forKey: "pulse")
    }
}

extension HideKeyboardButton: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
}
