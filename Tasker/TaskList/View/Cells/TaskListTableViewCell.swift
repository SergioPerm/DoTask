//
//  TaskListTableViewCell.swift
//  Tasker
//
//  Created by kluv on 28/09/2020.
//  Copyright © 2020 itotdel. All rights reserved.
//

import UIKit

class TaskListTableViewCell: UITableViewCell {
        
    let cellLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = .red
        
        return label
    }()
    
    let shadowLayer: ShadowView = {
        let shadowLayer = ShadowView()
        shadowLayer.translatesAutoresizingMaskIntoConstraints = false
        shadowLayer.backgroundColor = .white
        
        return shadowLayer
    }()
    
    let backView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        
        view.layer.cornerRadius = 8
        view.layer.masksToBounds = true
        
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        addSubview(shadowLayer)
                
        var constraints = [
            shadowLayer.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            shadowLayer.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            shadowLayer.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -2),
            shadowLayer.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.8)
        ]
        
        addSubview(backView)
        
        constraints.append(contentsOf: [
            backView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            backView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            backView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -2),
            backView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.8)
        ])
        
        backView.addSubview(cellLabel)
        
        backgroundColor = .clear
        
        cellLabel.centerYAnchor.constraint(equalTo: backView.centerYAnchor).isActive = true
        cellLabel.leadingAnchor.constraint(equalTo: backView.leadingAnchor, constant: 20).isActive = true
        cellLabel.trailingAnchor.constraint(equalTo: backView.trailingAnchor, constant: 20).isActive = true
        cellLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        NSLayoutConstraint.activate(constraints)
        
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func animateSelection(onFinish: @escaping ()->()) {
        UIView.animateKeyframes(withDuration: 0.4,
                                delay: 0, options: .calculationModeCubic,
                                animations: {
                                    UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.2) {
                                        self.shadowLayer.layer.shadowOpacity = 0.1
                                    }
                                    UIView.addKeyframe(withRelativeStartTime: 0.2, relativeDuration: 0.4) {
                                        self.shadowLayer.layer.shadowOpacity = 0.3
                                    }
        }) { finished in
            if finished {
                onFinish()
            }
        }
    }
}

class ShadowView: UIView {

    var setupShadowDone: Bool = false
        
    public func setupShadow() {
        if setupShadowDone { return }
        self.layer.cornerRadius = 8
        self.layer.shadowOffset = CGSize(width: 0, height: 3)
        self.layer.shadowRadius = 3
        self.layer.shadowOpacity = 0.3
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: .allCorners, cornerRadii: CGSize(width: 10, height: 10)).cgPath
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
        
        setupShadowDone = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupShadow()
    }
}
