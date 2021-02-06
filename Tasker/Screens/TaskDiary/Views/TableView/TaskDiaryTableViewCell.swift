//
//  TaskDiaryTableViewCell.swift
//  Tasker
//
//  Created by KLuV on 04.02.2021.
//  Copyright © 2021 itotdel. All rights reserved.
//

import UIKit

class TaskDiaryTableViewCell: UITableViewCell {

    // MARK: External propperies
    
    var viewModel: TaskDiaryItemViewModelType? {
        didSet {
            bindViewModel()
        }
    }
        
    public var unsetDoneHandler: ((_ taskIdentifier: String)->())?
    
    // MARK: Cell properties
    private let dateFormatter: DateFormatter = DateFormatter()
    private let timeFormatter: DateFormatter = DateFormatter()
    
    //private var taskIdentifier: String?
        
    private var isAnimatedOnSelect: Bool = false
    
    private let shapeLayer = CAShapeLayer()
        
    // MARK: View's properties
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = StyleGuide.TaskList.Colors.cellMainTitle
        label.font = StyleGuide.TaskList.Fonts.cellMainTitle
        label.numberOfLines = 0
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
        
        view.layer.cornerRadius = 10
        view.layer.maskedCorners = [.layerMinXMaxYCorner]
        
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

extension TaskDiaryTableViewCell {
    
    // MARK: Bind View-model
    
    private func bindViewModel() {
        
        viewModel?.outputs.title.bind { [weak self] title in
            self?.titleLabel.text = title
            self?.shadowLayer.setupShadowDone = false
        }
        
        viewModel?.outputs.date.bind { [weak self] date in
            self?.dateLabel.text = date
        }
        
        viewModel?.outputs.reminderTime.bind { [weak self] time in
            self?.timeLabel.text = time
        }
        
        viewModel?.outputs.importantColor.bind { [weak self] hexColor in
            if let hexColor = hexColor {
                let importanceColor = UIColor(hexString: hexColor)
                self?.backView.layer.backgroundColor = importanceColor.cgColor
            } else {
                self?.backView.layer.backgroundColor = UIColor.white.cgColor
            }
        }
        
        viewModel?.outputs.shortcutColor.bind { [weak self] hexColor in
            if let hexColor = hexColor {
                let shortcutColor = UIColor(hexString: hexColor)
                self?.importanceView.backgroundColor = shortcutColor
                self?.checkView.layer.borderColor = shortcutColor.cgColor
                self?.checkView.layer.backgroundColor = shortcutColor.withAlphaComponent(0.11).cgColor
            } else {
                self?.importanceView.backgroundColor = .clear
                self?.checkView.layer.borderColor = #colorLiteral(red: 1, green: 0.2130734228, blue: 0.6506573371, alpha: 0.8470588235).cgColor
                self?.checkView.layer.backgroundColor = #colorLiteral(red: 1, green: 0.2130734228, blue: 0.6506573371, alpha: 0.1099601066)
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
            shadowLayer.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            shadowLayer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -7)
        ]
        
        contentView.addSubview(backView)
        
        constraints.append(contentsOf: [
            backView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            backView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            backView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            backView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -7)
        ])
        
        doneView.addSubview(checkView)
        
        constraints.append(contentsOf: [
            checkView.widthAnchor.constraint(equalToConstant: 24),
            checkView.heightAnchor.constraint(equalToConstant: 24),
            checkView.topAnchor.constraint(equalTo: doneView.topAnchor, constant: 12),
            checkView.centerXAnchor.constraint(equalTo: doneView.centerXAnchor)
        ])
        
        contentView.addSubview(doneView)
        
        constraints.append(contentsOf: [
            doneView.leadingAnchor.constraint(equalTo: backView.leadingAnchor, constant: 10),
            doneView.topAnchor.constraint(equalTo: backView.topAnchor),
            doneView.widthAnchor.constraint(equalToConstant: 40),
            doneView.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        backView.addSubview(titleLabel)
        
        let titleHeightConstraint = titleLabel.heightAnchor.constraint(equalToConstant: 20)
        titleHeightConstraint.priority = UILayoutPriority(250)
        
        constraints.append(contentsOf: [
            titleLabel.topAnchor.constraint(equalTo: backView.topAnchor, constant: 10),
            titleLabel.bottomAnchor.constraint(equalTo: dateLabel.topAnchor, constant: -10),
            titleLabel.leadingAnchor.constraint(equalTo: doneView.trailingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: importanceView.leadingAnchor, constant: -10),
            titleHeightConstraint
        ])
        
        backView.addSubview(dateLabel)
        backView.addSubview(timeLabel)
                
        constraints.append(contentsOf: [
            dateLabel.bottomAnchor.constraint(equalTo: backView.bottomAnchor, constant: -10),
            dateLabel.leadingAnchor.constraint(equalTo: doneView.trailingAnchor, constant: 10),
            dateLabel.heightAnchor.constraint(equalToConstant: 20),
            dateLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 10),
            timeLabel.bottomAnchor.constraint(equalTo: backView.bottomAnchor, constant: -10),
            timeLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 10),
            timeLabel.leadingAnchor.constraint(equalTo: dateLabel.trailingAnchor, constant: 10),
            timeLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
        
        backView.addSubview(importanceView)
        
        constraints.append(contentsOf: [
            importanceView.topAnchor.constraint(equalTo: backView.topAnchor),
            importanceView.trailingAnchor.constraint(equalTo: backView.trailingAnchor),
            importanceView.widthAnchor.constraint(equalToConstant: 20),
            importanceView.heightAnchor.constraint(equalToConstant: 50)
        ])
                        
        contentView.backgroundColor = .white
        
        NSLayoutConstraint.activate(constraints)
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapDoneAction(sender:)))
        doneView.addGestureRecognizer(tapRecognizer)
    }
        
    // MARK: Actions
    
    @objc private func tapDoneAction(sender: UIView) {
        animateCheckMark(view: checkView) {
            self.viewModel?.inputs.unsetDone()
        }
    }
    
    // MARK: Animations
    
    public func animateSelection(onFinish: @escaping ()->()) {
        if isAnimatedOnSelect { return }
        
        isAnimatedOnSelect = true
        
        CATransaction.begin()
        CATransaction.setCompletionBlock {
            onFinish()
            self.isAnimatedOnSelect = false
        }
        
        let animationIn = CAKeyframeAnimation(keyPath: "shadowOpacity")
        
        animationIn.values = [0.3, 0.1, 0.3]
        animationIn.keyTimes = [0, 0.6, 1.0]
                
        shadowLayer.layer.add(animationIn, forKey: "pulse")
        
        CATransaction.commit()
    }
    
    private func animateCheckMark(view: UIView, finishHandler: (()->())?) {
        CATransaction.begin()
        CATransaction.setCompletionBlock {
            if let finishAction = finishHandler {
                finishAction()
            }
        }
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 3, y: view.bounds.height/2))
        path.addLine(to: CGPoint(x: view.bounds.width/2 - 3, y: view.bounds.height - 3))
        path.addLine(to: CGPoint(x: view.bounds.width - 3, y: 4))
        
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = StyleGuide.MainColors.blue.cgColor
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
