//
//  ColorCollectionViewCell.swift
//  DoTask
//
//  Created by KLuV on 05.01.2021.
//  Copyright © 2021 itotdel. All rights reserved.
//

import UIKit

class ColorCollectionViewCell: UICollectionViewCell {
    
    weak var viewModel: ColorSelectionItemViewModelType? {
        willSet {
            guard let _ = viewModel else {
                return
            }
            
            viewModel?.outputs.selectEvent.unsubscribe(self)
        }
        didSet {
            bindViewModel()
        }
    }
        
    private let colorShape: CAShapeLayer = CAShapeLayer()
    private let selectShape: CAShapeLayer = CAShapeLayer()
    
    // MARK: Initializers
                
    override func layoutIfNeeded() {
        super.layoutIfNeeded()
        drawColorShape()
    }
    
}

extension ColorCollectionViewCell {
    private func bindViewModel() {
        drawColorShape()
        
        viewModel?.outputs.selectEvent.subscribe(self, handler: { (this, selected) in
            this.drawColorShape()
        })
    }
    
    private func drawColorShape() {
        
        colorShape.removeFromSuperlayer()
        selectShape.removeFromSuperlayer()
        
        guard let viewModel = viewModel else { return }
                
        let cellColor = UIColor(hexString: viewModel.outputs.colorHex)
        
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: frame.width/2, y: frame.height/2), radius: frame.width/4, startAngle: 0.0, endAngle: CGFloat(Double.pi * 2), clockwise: true)
        colorShape.path = circlePath.cgPath
        colorShape.fillColor = cellColor.cgColor
        colorShape.strokeColor = cellColor.cgColor
        colorShape.lineWidth = StyleGuide.DetailShortcut.ColorCollectionViewCell.Sizes.colorCircleLineWidth
        
        layer.addSublayer(colorShape)
        
        if viewModel.outputs.select {
            let selectCirclePath = UIBezierPath(arcCenter: CGPoint(x: frame.width/2, y: frame.height/2), radius: frame.width/4 - 4, startAngle: 0.0, endAngle: CGFloat(Double.pi * 2), clockwise: true)
            
            selectShape.path = selectCirclePath.cgPath
            selectShape.fillColor = UIColor.clear.cgColor
            selectShape.strokeColor = UIColor.white.cgColor
            selectShape.lineWidth = StyleGuide.DetailShortcut.ColorCollectionViewCell.Sizes.colorCircleSelectLineWidth
            
            layer.addSublayer(selectShape)
        }
                
    }
}
