//
//  DetailAccessoryView.swift
//  DoTask
//
//  Created by KLuV on 04.01.2021.
//  Copyright © 2021 itotdel. All rights reserved.
//

import UIKit

class DetailAccessoryView: UIView {
    
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

extension DetailAccessoryView {
    
    private func updateShadow() {
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: StyleGuide.DetailTask.Sizes.accessoryCornerRadius).cgPath
    }
    
    private func setup() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .white
        layer.cornerRadius = StyleGuide.DetailTask.Sizes.accessoryCornerRadius
        
        clipsToBounds = false
        layer.shadowColor = R.color.detailTask.accessoryShadow()!.cgColor
        layer.shadowOpacity = 0.2
        layer.shadowOffset = CGSize(width: 0.0, height: 6.0)
        layer.shadowRadius = StyleGuide.DetailTask.Sizes.accessoryCornerRadius
    }
    
}
