//
//  TaskListTableViewCell.swift
//  Tasker
//
//  Created by kluv on 28/09/2020.
//  Copyright © 2020 itotdel. All rights reserved.
//

import UIKit

class TaskListTableViewCell: UITableViewCell {
    
    // MARK: External propperies
    
    public var taskModel: TaskModel? {
        didSet {
            guard let taskModel = taskModel else {
                titleLabel.text = ""
                dateLabel.text = ""
                return
            }
            
            titleLabel.text = taskModel.title
            
            if let taskDate = taskModel.taskDate {
                dateLabel.text = dateFormatter.string(from: taskDate)
            } else {
                dateLabel.text = ""
            }
            
            taskIdentifier = taskModel.uid
        }
    }
    
    public var doneHandler: ((_ taskIdentifier: String)->())?
    
    // MARK: Cell properties
    private let dateFormatter: DateFormatter = DateFormatter()
    
    private var taskIdentifier: String?
        
    private let shapeLayer = CAShapeLayer()
        
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = #colorLiteral(red: 0.2369126672, green: 0.6231006994, blue: 1, alpha: 1)
        
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 10)
        label.textColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        
        return label
    }()
    
    private let doneView: UIView = {
        let view = UIView()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.borderWidth = 2
        view.layer.borderColor = #colorLiteral(red: 1, green: 0.2130734228, blue: 0.6506573371, alpha: 0.8470588235)
        view.layer.cornerRadius = 3
                
        return view
    }()
    
    private let shadowLayer: ShadowView = {
        let shadowLayer = ShadowView()
        shadowLayer.translatesAutoresizingMaskIntoConstraints = false
        shadowLayer.backgroundColor = .white
        
        return shadowLayer
    }()
    
    private let backView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        
        view.layer.cornerRadius = 8
        view.layer.masksToBounds = true
        
        return view
    }()
        
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        shapeLayer.removeFromSuperlayer()
    }
    
}

extension TaskListTableViewCell {
    private func setup() {
        dateFormatter.dateFormat = "dd/MM/yyyy"
        
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
        
        addSubview(doneView)
        
        constraints.append(contentsOf: [
            doneView.heightAnchor.constraint(equalToConstant: 24),
            doneView.widthAnchor.constraint(equalToConstant: 24),
            doneView.leadingAnchor.constraint(equalTo: backView.leadingAnchor, constant: 20),
            doneView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        backView.addSubview(titleLabel)
        
        constraints.append(contentsOf: [
            titleLabel.centerYAnchor.constraint(equalTo: backView.centerYAnchor, constant: -10),
            titleLabel.leadingAnchor.constraint(equalTo: doneView.trailingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: backView.trailingAnchor, constant: -20),
            titleLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
        
        backView.addSubview(dateLabel)
        
        constraints.append(contentsOf: [
            dateLabel.centerYAnchor.constraint(equalTo: backView.centerYAnchor, constant: 12),
            dateLabel.leadingAnchor.constraint(equalTo: doneView.trailingAnchor, constant: 10),
            dateLabel.trailingAnchor.constraint(equalTo: backView.trailingAnchor, constant: -20),
            dateLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
        
        backgroundColor = .clear
        
        NSLayoutConstraint.activate(constraints)
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapDoneAction(sender:)))
        doneView.addGestureRecognizer(tapRecognizer)
    }
    
    public func animateSelection(onFinish: @escaping ()->()) {
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
    
    @objc private func tapDoneAction(sender: UIView) {
        animateCheckMark(view: doneView) {
            if let taskIdentifier = self.taskIdentifier, let doneHandler = self.doneHandler {
                doneHandler(taskIdentifier)
            }
        }
    }
    
    private func animateCheckMark(view: UIView, finishHandler:@escaping (()->())) {
        CATransaction.begin()
        CATransaction.setCompletionBlock {
            finishHandler()
        }
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 3, y: view.bounds.height/2))
        path.addLine(to: CGPoint(x: view.bounds.width/2 - 3, y: view.bounds.height - 3))
        path.addLine(to: CGPoint(x: view.bounds.width - 3, y: 4))
        
        shapeLayer.fillColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0).cgColor
        shapeLayer.strokeColor = #colorLiteral(red: 0.1115362046, green: 0.701875, blue: 0.1496753436, alpha: 0.8470588235).cgColor
        shapeLayer.lineWidth = 3
        shapeLayer.path = path.cgPath
        
        view.layer.addSublayer(shapeLayer)
        
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = 0
        animation.duration = 0.3
        shapeLayer.add(animation, forKey: "myAnimation")
        CATransaction.commit()
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
