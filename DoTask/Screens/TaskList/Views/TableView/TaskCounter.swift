//
//  TaskCounter.swift
//  DoTask
//
//  Created by Сергей Лепинин on 28.03.2021.
//  Copyright © 2021 itotdel. All rights reserved.
//

import UIKit

class TaskCounter: UIView {

    private let label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = R.color.taskList.counterText()
        label.font = FontFactory.AvenirNextBold.of(size: StyleGuide.getSizeRelativeToScreenWidth(baseSize: 15))
        label.textAlignment = .center
        
        return label
    }()
    
    private let gradient: CAGradientLayer = {
        let gradient = CAGradientLayer()
        gradient.colors = [R.color.taskList.gradientCounter1()!.cgColor, R.color.taskList.gradientCounter2()!.cgColor]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        
        return gradient
    }()

    init() {
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradient.frame = bounds
    }
    
}

extension TaskCounter {
    private func setup() {
        
        gradient.frame = frame
        gradient.cornerRadius = StyleGuide.getSizeRelativeToScreenWidth(baseSize: 10)
        layer.addSublayer(gradient)
        addSubview(label)
        
        let constraints: [NSLayoutConstraint] = [
            label.leadingAnchor.constraint(equalTo: leadingAnchor),
            label.topAnchor.constraint(equalTo: topAnchor),
            label.trailingAnchor.constraint(equalTo: trailingAnchor),
            label.bottomAnchor.constraint(equalTo: bottomAnchor)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    func updateCount(counter: DoneCounter) {
        label.text = "\(counter.doneCount)/\(counter.allCount)"
    }
}
