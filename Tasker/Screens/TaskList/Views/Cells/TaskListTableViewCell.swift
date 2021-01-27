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
    
    var viewModel: TaskListItemViewModelType? {
        didSet {
            bindViewModel()
        }
    }
        
    public var doneHandler: ((_ taskIdentifier: String)->())?
    
    // MARK: Cell properties
    private let dateFormatter: DateFormatter = DateFormatter()
    private let timeFormatter: DateFormatter = DateFormatter()
    
    //private var taskIdentifier: String?
        
    private let shapeLayer = CAShapeLayer()
        
    // MARK: View's properties
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = StyleGuide.TaskList.Colors.cellMainTitle
        label.font = StyleGuide.TaskList.Fonts.cellMainTitle
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = StyleGuide.TaskList.Colors.cellAdditionalTitle
        label.font = StyleGuide.TaskList.Fonts.cellAdditionalTitle
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.textColor = StyleGuide.TaskList.Colors.cellAdditionalTitle
        label.font = StyleGuide.TaskList.Fonts.cellAdditionalTitle
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let checkView: UIView = {
        let checkView = UIView()
        
        checkView.translatesAutoresizingMaskIntoConstraints = false
        checkView.layer.borderWidth = 2.5
        checkView.layer.borderColor = #colorLiteral(red: 1, green: 0.2130734228, blue: 0.6506573371, alpha: 0.8470588235).cgColor
        checkView.layer.cornerRadius = 4
        checkView.layer.backgroundColor = #colorLiteral(red: 1, green: 0.2130734228, blue: 0.6506573371, alpha: 0.1099601066)
    
        return checkView
    }()
    
    private let doneView: UIView = {
        let tapView = UIView()
        tapView.translatesAutoresizingMaskIntoConstraints = false
                
        return tapView
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
                
    private let importanceView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    // MARK: Initializers
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        shapeLayer.removeFromSuperlayer()
    }
    
}

extension TaskListTableViewCell {
    
    private func bindViewModel() {
        
        viewModel?.outputs.title.bind { title in
            self.titleLabel.text = title
        }
        
        viewModel?.outputs.date.bind { date in
            self.dateLabel.text = date
        }
        
        viewModel?.outputs.reminderTime.bind { time in
            self.timeLabel.text = time
        }
        
        viewModel?.outputs.importantColor.bind { hexColor in
            if let hexColor = hexColor {
                let importanceColor = UIColor(hexString: hexColor)
                self.shadowLayer.layer.shadowColor = importanceColor.cgColor
            } else {
                self.shadowLayer.layer.shadowColor = UIColor.black.cgColor
            }
        }
        
        viewModel?.outputs.shortcutColor.bind { hexColor in
            if let hexColor = hexColor {
                let shortcutColor = UIColor(hexString: hexColor)
                self.importanceView.backgroundColor = shortcutColor
                self.checkView.layer.borderColor = shortcutColor.cgColor
                self.checkView.layer.backgroundColor = shortcutColor.withAlphaComponent(0.11).cgColor
            } else {
                self.importanceView.backgroundColor = .clear
                self.checkView.layer.borderColor = #colorLiteral(red: 1, green: 0.2130734228, blue: 0.6506573371, alpha: 0.8470588235).cgColor
                self.checkView.layer.backgroundColor = #colorLiteral(red: 1, green: 0.2130734228, blue: 0.6506573371, alpha: 0.1099601066)
            }
        }
    }
    
    // MARK: Setup Cell
    
    private func setup() {
        selectionStyle = .none
        
        contentView.addSubview(shadowLayer)
                
        var constraints = [
            shadowLayer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            shadowLayer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            shadowLayer.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: -2),
            shadowLayer.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.8)
        ]
        
        contentView.addSubview(backView)
        
        constraints.append(contentsOf: [
            backView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            backView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            backView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: -2),
            backView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.8)
        ])
        
        doneView.addSubview(checkView)
        
        constraints.append(contentsOf: [
            checkView.widthAnchor.constraint(equalToConstant: 24),
            checkView.heightAnchor.constraint(equalToConstant: 24),
            checkView.centerYAnchor.constraint(equalTo: doneView.centerYAnchor),
            checkView.centerXAnchor.constraint(equalTo: doneView.centerXAnchor)
        ])
        
        contentView.addSubview(doneView)
        
        constraints.append(contentsOf: [
            doneView.leadingAnchor.constraint(equalTo: backView.leadingAnchor, constant: 10),
            doneView.centerYAnchor.constraint(equalTo: backView.centerYAnchor),
            doneView.topAnchor.constraint(equalTo: backView.topAnchor),
            doneView.bottomAnchor.constraint(equalTo: backView.bottomAnchor),
            doneView.widthAnchor.constraint(equalToConstant: 40)
        ])
        
        backView.addSubview(titleLabel)
        
        constraints.append(contentsOf: [
            titleLabel.centerYAnchor.constraint(equalTo: backView.centerYAnchor, constant: -10),
            titleLabel.leadingAnchor.constraint(equalTo: doneView.trailingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: backView.trailingAnchor, constant: -20),
            titleLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
        
        backView.addSubview(dateLabel)
        backView.addSubview(timeLabel)
        
        constraints.append(contentsOf: [
            dateLabel.centerYAnchor.constraint(equalTo: backView.centerYAnchor, constant: 12),
            dateLabel.leadingAnchor.constraint(equalTo: doneView.trailingAnchor, constant: 10),
            dateLabel.heightAnchor.constraint(equalToConstant: 20),
            timeLabel.centerYAnchor.constraint(equalTo: backView.centerYAnchor, constant: 12),
            timeLabel.leadingAnchor.constraint(equalTo: dateLabel.trailingAnchor, constant: 10),
            timeLabel.trailingAnchor.constraint(equalTo: backView.trailingAnchor, constant: -40)
        ])
        
        backView.addSubview(importanceView)
        
        constraints.append(contentsOf: [
            importanceView.topAnchor.constraint(equalTo: backView.topAnchor),
            importanceView.bottomAnchor.constraint(equalTo: backView.bottomAnchor),
            importanceView.trailingAnchor.constraint(equalTo: backView.trailingAnchor),
            importanceView.widthAnchor.constraint(equalToConstant: 20)
        ])
                        
        contentView.backgroundColor = .clear
        
        NSLayoutConstraint.activate(constraints)
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapDoneAction(sender:)))
        doneView.addGestureRecognizer(tapRecognizer)
    }
        
    // MARK: Actions
    
    @objc private func tapDoneAction(sender: UIView) {
        animateCheckMark(view: checkView) {
            //if let taskIdentifier = self.taskIdentifier {
                self.viewModel?.inputs.setDone()
            //}
        }
    }
    
    // MARK: Animations
    
    public func animateSelection(onFinish: @escaping ()->()) {
        CATransaction.begin()
        CATransaction.setCompletionBlock {
            onFinish()
        }
        
        let animationIn = CAKeyframeAnimation(keyPath: "shadowOpacity")
        
        animationIn.values = [0.3, 0.1, 0.3]
        animationIn.keyTimes = [0, 0.6, 1.0]
                
        shadowLayer.layer.add(animationIn, forKey: "pulse")
        
        CATransaction.commit()
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

// MARK: Setup shadow

class ShadowView: UIView {

    var setupShadowDone: Bool = false
        
    public func setupShadow() {
        if setupShadowDone { return }
        self.layer.cornerRadius = 8
        self.layer.shadowOffset = CGSize(width: 0, height: 3)
        self.layer.shadowRadius = 3
        self.layer.shadowOpacity = 0.3
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
