//
//  importanceButton.swift
//  DoTask
//
//  Created by kluv on 11/10/2020.
//  Copyright © 2020 itotdel. All rights reserved.
//

import UIKit

enum ImportanceLevel: Int {
    case noImportant = 0
    case important = 1
    case veryImportant = 2
    case fuckedUpImportant = 3
    
    func currentValue() -> Int {
        return self.rawValue
    }
}

class ImportanceAccessory: UIView {
    
    private let onTapActionHandler: () -> Void
    
    private let diagonalAttitudeToHeightFrame: CGFloat = 0.55
    
    //Dictionary for storing magnification animation values
    private let importanceLevelMagnification: [ImportanceLevel: CGFloat] = {
        var maginificationDictionary = [ImportanceLevel: CGFloat]()
        maginificationDictionary[ImportanceLevel.noImportant] = 1.0
        maginificationDictionary[ImportanceLevel.important] = 1.2
        maginificationDictionary[ImportanceLevel.veryImportant] = 1.4
        maginificationDictionary[ImportanceLevel.fuckedUpImportant] = 1.7
        
        return maginificationDictionary
    }()
    
    var importanceLevel: ImportanceLevel
        
    private var marksShape: CAShapeLayer = CAShapeLayer()
    
    private var warningShape: CAShapeLayer = CAShapeLayer()
        
    init(onTapAction: @escaping () -> Void, importanceLevel: Int) {
        self.onTapActionHandler = onTapAction
        self.importanceLevel = ImportanceLevel(rawValue: importanceLevel) ?? .noImportant
        super.init(frame: CGRect.zero)
        setup()
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateFramesInShapes()
    }

}

extension ImportanceAccessory {
    private func setup() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapAction(sender:)))
        addGestureRecognizer(tapGesture)
    }
    
    private func updateFramesInShapes() {
        warningShape.frame = bounds
        drawWarningShape()
        drawMarks(marksFrame: bounds)
    }
    
    @objc private func tapAction(sender: UIView) {
        let levelToSet = importanceLevel.currentValue() == 3 ? 0 : importanceLevel.currentValue() + 1
        if let importanceLevel = ImportanceLevel(rawValue: levelToSet) {
            self.importanceLevel = importanceLevel
            updateFramesInShapes()
            
            if let magnificationLvl = importanceLevelMagnification[importanceLevel] {
                let animationIn = CAKeyframeAnimation(keyPath: "transform.scale")

                animationIn.values = [1.0, magnificationLvl, 1.0]
                animationIn.keyTimes = [0, 0.3, 0.8]
                
                layer.add(animationIn, forKey: "pulse")
            }
        }
        onTapActionHandler()
    }
    
    private func drawWarningShape() {
        warningShape.removeFromSuperlayer()
        
        let diagonal: CGFloat = frame.height * diagonalAttitudeToHeightFrame
        let sideByDiagonal: CGFloat = diagonal / sqrt(2)
        let inset = (frame.height - sideByDiagonal)/2
        let backInset = frame.width/2 - frame.height/2
        
        //Draw
        let rectPath = UIBezierPath(roundedRect: CGRect(x: backInset + inset, y: inset, width: sideByDiagonal, height: sideByDiagonal), cornerRadius: 2)
                
        let bounds: CGRect = rectPath.cgPath.boundingBox
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        
        let degree: CGFloat = 45.0
        let radians = degree / 180.0 * .pi
        var transform: CGAffineTransform = .identity
        transform = transform.translatedBy(x: center.x, y: center.y)
        transform = transform.rotated(by: radians)
        transform = transform.translatedBy(x: -center.x, y: -center.y)
        rectPath.apply(transform)

        //Shape
        warningShape = CAShapeLayer()
        
        warningShape.fillColor = R.color.commonColors.clear()!.cgColor
        warningShape.strokeColor = R.color.detailTask.accessoryStrokeHide()!.cgColor
        warningShape.lineWidth = 1
        warningShape.lineCap = .round
        warningShape.path = rectPath.cgPath
        
        layer.addSublayer(warningShape)
    }
    
    private func drawMarks(marksFrame: CGRect) {
        marksShape.removeFromSuperlayer()
        
        let numberOfMarks: CGFloat = importanceLevel.currentValue() == 0 ? 1.0 : CGFloat(importanceLevel.currentValue())
                
        let sideLenght = marksFrame.height
        let flowWidth = marksFrame.width
        let inset = sideLenght/3.3

        let lengthMark = (sideLenght - inset*2)/5*3
        let brickSize = lengthMark/5

        let bodyMark = brickSize * 3.25
        let spaceMark = brickSize * 0.5
        let dotMark = brickSize * 1.25

        let spaceBetweenMarks: CGFloat = dotMark/2

        var startPositionX = flowWidth/2 - dotMark*(numberOfMarks-1)/2 - spaceBetweenMarks*(numberOfMarks-1)/2

        let path = UIBezierPath()

        for _ in (1...Int(numberOfMarks)) {
            var startPoint = CGPoint(x: startPositionX, y: sideLenght/2 - lengthMark/2)
            
            path.move(to: startPoint)
            startPoint.y = startPoint.y + bodyMark
            path.addLine(to: CGPoint(x: startPoint.x, y: startPoint.y))
            startPoint.y = startPoint.y + spaceMark
            path.move(to: CGPoint(x: startPoint.x, y: startPoint.y))
            startPoint.y = startPoint.y + dotMark
            path.addLine(to: CGPoint(x: startPoint.x, y: startPoint.y))

            startPositionX += spaceBetweenMarks + dotMark
        }

        marksShape = CAShapeLayer()
        marksShape.fillColor = UIColor.clear.cgColor
        
        switch importanceLevel {
        case .noImportant:
            warningShape.strokeColor = R.color.detailTask.accessoryStrokeHide()!.cgColor
            warningShape.fillColor = R.color.commonColors.clear()!.cgColor
            marksShape.strokeColor = R.color.detailTask.accessoryStrokeHide()!.cgColor
        case .important:
            warningShape.strokeColor = R.color.detailTask.accesseryWarningImportant()!.cgColor
            warningShape.fillColor = R.color.detailTask.accesseryWarningImportant()!.cgColor
            marksShape.strokeColor = R.color.detailTask.background()!.cgColor
        case .veryImportant:
            warningShape.strokeColor = R.color.detailTask.accesseryWarningVeryImportantStroke()!.cgColor
            warningShape.fillColor = R.color.detailTask.accesseryWarningVeryImportantFill()!.cgColor
            marksShape.strokeColor = R.color.detailTask.background()!.cgColor
        case .fuckedUpImportant:
            warningShape.strokeColor = R.color.detailTask.accesseryWarningFuckImportant()!.cgColor
            warningShape.fillColor = R.color.detailTask.accesseryWarningFuckImportant()!.cgColor
            marksShape.strokeColor = R.color.detailTask.background()!.cgColor
        }
        
        marksShape.lineWidth = dotMark
        marksShape.path = path.cgPath
        marksShape.frame = marksFrame

        layer.addSublayer(marksShape)
    }
}
