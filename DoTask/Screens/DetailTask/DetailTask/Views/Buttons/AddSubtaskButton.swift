//
//  AddSubtaskButton.swift
//  DoTask
//
//  Created by KLuV on 28.12.2020.
//  Copyright © 2020 itotdel. All rights reserved.
//

import UIKit

class AddSubtaskButton: UIView {

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

extension AddSubtaskButton {
    
    private func updateShadow() {
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: 10).cgPath
    }
    
    private func setup() {
        
        layer.cornerRadius = 10
        backgroundColor = StyleGuide.DetailTask.Colors.addSubtaskbtnColor
        
        let label = UILabel()
        label.text = "Add subtask"
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
        layer.shadowOpacity = 0.7
        layer.shadowOffset = CGSize(width: 5.0, height: 5.0)
        layer.shadowRadius = 10
        
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

extension AddSubtaskButton: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
}
