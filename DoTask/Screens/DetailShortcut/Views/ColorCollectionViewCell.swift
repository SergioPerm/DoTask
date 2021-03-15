//
//  ColorCollectionViewCell.swift
//  DoTask
//
//  Created by KLuV on 05.01.2021.
//  Copyright © 2021 itotdel. All rights reserved.
//

import UIKit

class ColorCollectionViewCell: UICollectionViewCell {
    
    var selectedColor: Bool {
        didSet {
            drawColorShape()
        }
    }
    
    var cellColor: UIColor? {
        didSet {
            drawColorShape()
        }
    }
    
    private let colorShape: CAShapeLayer = CAShapeLayer()
    private let selectShape: CAShapeLayer = CAShapeLayer()
    
    // MARK: Initializers
    
    override init(frame: CGRect) {
        self.selectedColor = false
        super.init(frame: frame)
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutIfNeeded() {
        super.layoutIfNeeded()
        drawColorShape()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        selectedColor = false
    }
}

extension ColorCollectionViewCell {
    private func drawColorShape() {
        
        colorShape.removeFromSuperlayer()
        selectShape.removeFromSuperlayer()
        
        guard let cellColor = cellColor else { return }
        
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: frame.width/2, y: frame.height/2), radius: frame.width/4, startAngle: 0.0, endAngle: CGFloat(Double.pi * 2), clockwise: true)
        colorShape.path = circlePath.cgPath
        colorShape.fillColor = cellColor.cgColor
        colorShape.strokeColor = cellColor.cgColor
        colorShape.lineWidth = 1.0
        
        layer.addSublayer(colorShape)
        
        if selectedColor {
            let selectCirclePath = UIBezierPath(arcCenter: CGPoint(x: frame.width/2, y: frame.height/2), radius: frame.width/4 - 4, startAngle: 0.0, endAngle: CGFloat(Double.pi * 2), clockwise: true)
            
            selectShape.path = selectCirclePath.cgPath
            selectShape.fillColor = UIColor.clear.cgColor
            selectShape.strokeColor = UIColor.white.cgColor
            selectShape.lineWidth = 2.0
            
            layer.addSublayer(selectShape)
        }
                
    }
}
