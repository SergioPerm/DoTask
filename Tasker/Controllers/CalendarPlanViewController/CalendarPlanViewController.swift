//
//  CalendarPlanViewController.swift
//  Tasker
//
//  Created by kluv on 24/10/2020.
//  Copyright © 2020 itotdel. All rights reserved.
//

import UIKit

enum ArrowDirection: CGFloat {
    case Up = 1.0
    case Down = -1.0
    
    func currentValue() -> CGFloat {
        return self.rawValue
    }
    
    func getYPosition(yPos: CGFloat) -> CGFloat {
        return yPos * self.rawValue
    }
}

class CalendarPlanViewController: UIViewController {

    // MARK: View properties
    private let startPoint: CGPoint
    
//    private let viewFrame: CGRect = {
//
//        let globalView = UIView.globalSafeAreaFrame
//
//        let origin = CGPoint(x: globalView.width - (startPoint.x * 2), y: globalView.width * 0.1)
//        let size = CGSize(width: globalView.width * 0.9, height: globalView.width * 0.9)
//        return CGRect()
//    }()
//
//    private let viewFrameOnStart: CGRect = {
//
//        let globalView = UIView.globalSafeAreaFrame
//
//        let origin = CGPoint(x: globalView.width - (globalView.width * 0.1), y: globalView.height - (globalView.width * 0.1))
//        let size = CGSize(width: globalView.width * 0.9, height: globalView.width * 0.9)
//        return CGRect()
//    }()
    
    // MARK: Init
    
    init(startPoint: CGPoint) {
        self.startPoint = startPoint
        super.init(nibName: nil, bundle: nil)
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: View-Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        
    }
    



}

extension CalendarPlanViewController {
    private func setup() {
        setupFrames()
        
        
        view.backgroundColor = UIColor.green
        //view.frame = CGRect(origin: CGPoint, size: <#T##CGSize#>)
        
    }
    
    private func setupFrames() {
        
        let globalFrame = UIView.globalSafeAreaFrame
        
        let arrowDirection: ArrowDirection = startPoint.y < globalFrame.height/2 ? .Up : .Down
        
        let arrowPath = UIBezierPath()
        arrowPath.move(to: startPoint)
        arrowPath.addLine(to: CGPoint(x: startPoint.x - 15, y: startPoint.y + arrowDirection.getYPosition(yPos: 10)))
        
        arrowPath.move(to: startPoint)
        arrowPath.addLine(to: CGPoint(x: startPoint.x + 15, y: startPoint.y + arrowDirection.getYPosition(yPos: 10)))
        
        let shape = CAShapeLayer()
        shape.path = arrowPath.cgPath
        shape.strokeColor = UIColor.black.cgColor
        shape.borderWidth = 2.0
        
        view.layer.addSublayer(shape)
        view.frame = CGRect(origin: CGPoint(x: view.frame.origin.x + 20, y: startPoint.y + 10), size: CGSize(width: view.frame.width - 40, height: view.frame.width - 40))
        
//        let sideLenght = globalView.width - (startPoint.x * 2)
//
//        let size = CGSize(width: sideLenght, height: sideLenght)
//
//        viewFrame = CGRect(origin: startPoint, size: <#T##CGSize#>)
        
    }
    

}
