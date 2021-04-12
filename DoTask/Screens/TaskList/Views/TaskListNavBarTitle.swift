//
//  TaskListNavBarTitle.swift
//  DoTask
//
//  Created by KLuV on 19.02.2021.
//  Copyright © 2021 itotdel. All rights reserved.
//

import UIKit

protocol TaskListNavBarTitle {
    func showMainTitle()
    func showMonth(date: Date)
    func setShortcut(shortcut: ShortcutData?)
    func setTaskListMode(taskListMode: TaskListMode)
}

class TaskListNavBarTitleView: UIView {

    private var shortcut: ShortcutData? {
        didSet {
            guard let _ = shortcut else {
                colorDotWidthConstraint.constant = 0
                colorDotTrailingConstraint.constant = 0
                dotShape.removeFromSuperlayer()
                layoutIfNeeded()
                return
            }
            
            colorDotWidthConstraint.constant = 10
            colorDotTrailingConstraint.constant = -10
            layoutIfNeeded()
            drawDot()
        }
    }
    private var taskListMode: TaskListMode
        
    private let titleLabel: LocalizableLabel = {
        let label = LocalizableLabel()
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
        
    private let parentView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
                
        return view
    }()
    
    private let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        
        return view
    }()
    
    private var colorDotView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private var colorDotTrailingConstraint: NSLayoutConstraint = NSLayoutConstraint()
    private var colorDotWidthConstraint: NSLayoutConstraint = NSLayoutConstraint()
    
    private var dotShape: CAShapeLayer = CAShapeLayer()
    
    init(frame: CGRect, taskListMode: TaskListMode) {
        self.taskListMode = taskListMode
        
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        parentView.frame = bounds
    }
    
}

extension TaskListNavBarTitleView {
    private func setup() {
        backgroundColor = .clear
        
        colorDotView.frame = CGRect(x: 0, y: 0, width: 0, height: bounds.height)
        
        parentView.frame = bounds
        
        containerView.addSubview(colorDotView)
        containerView.addSubview(titleLabel)
        
        parentView.addSubview(containerView)
        
        let titleWidthConstraint = titleLabel.widthAnchor.constraint(equalToConstant: 0)
        titleWidthConstraint.priority = UILayoutPriority(250)
        
        colorDotTrailingConstraint = colorDotView.trailingAnchor.constraint(equalTo: titleLabel.leadingAnchor, constant: 0)
        colorDotWidthConstraint = colorDotView.widthAnchor.constraint(equalToConstant: 0)
        
        let containerViewWidthConstraint = containerView.widthAnchor.constraint(equalToConstant: 0)
        containerViewWidthConstraint.priority = UILayoutPriority(250)
        
        let constraints: [NSLayoutConstraint] = [
            containerView.topAnchor.constraint(equalTo: parentView.topAnchor),
            containerView.bottomAnchor.constraint(equalTo: parentView.bottomAnchor),
            containerView.centerXAnchor.constraint(equalTo: parentView.centerXAnchor),
            colorDotView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            colorDotView.topAnchor.constraint(equalTo: containerView.topAnchor),
            colorDotView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            colorDotTrailingConstraint,
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            titleWidthConstraint,
            colorDotWidthConstraint,
            containerViewWidthConstraint
        ]
                
        addSubview(parentView)
        
        NSLayoutConstraint.activate(constraints)
    }
        
    private func showStandartTitle(animated: Bool = false) {
        let font = FontFactory.AvenirNextBoldItalic.of(size: StyleGuide.getSizeRelativeToScreenWidth(baseSize: 27))
        
        let navTitle = NSMutableAttributedString(string: "Do", attributes:[
                                                    NSAttributedString.Key.foregroundColor: R.color.commonColors.blue()!,
                                                    NSAttributedString.Key.font: font])

        navTitle.append(NSMutableAttributedString(string: "Task", attributes:[
                                                    NSAttributedString.Key.font: font,
                                                    NSAttributedString.Key.foregroundColor: R.color.commonColors.pink()!]))

        if animated {
            animateTitle(newTitle: navTitle)
        } else {
            titleLabel.attributedText = navTitle
        }
    }
        
    private func showMonthTitle(date: Date, animated: Bool = false) {
        titleLabel.font = FontFactory.AvenirNextBold.of(size: 21)
        titleLabel.textColor = R.color.mainNavBar.monthText()!
                
        if animated {
            animateTitle(date: date)
        } else {
            titleLabel.setDateWithFormat(date: date, format: "MMMM")
        }
    }
    
    private func animateTitle(newTitle: NSAttributedString) {
        
        UIView.animate(withDuration: 0.075) {
            self.parentView.frame.origin.y = 20
            self.parentView.layer.opacity = 0.0
        } completion: { (finished) in
            self.parentView.frame.origin.y = -20
            self.titleLabel.attributedText = newTitle
            
            UIView.animate(withDuration: 0.075, delay: 0.0, options: .beginFromCurrentState) {
                self.parentView.frame.origin.y = 0
                self.parentView.layer.opacity = 1.0
            } completion: { (finished) in
            }
        }
    }
    
    private func animateTitle(date: Date) {
        
        UIView.animate(withDuration: 0.075) {
            self.parentView.frame.origin.y = 20
            self.parentView.layer.opacity = 0.0
        } completion: { (finished) in
            self.parentView.frame.origin.y = -20
            self.titleLabel.setDateWithFormat(date: date, format: "MMMM")
            
            UIView.animate(withDuration: 0.075, delay: 0.0, options: .beginFromCurrentState) {
                self.parentView.frame.origin.y = 0
                self.parentView.layer.opacity = 1.0
            } completion: { (finished) in
            }
        }
    }
    
    private func drawDot() {
        dotShape.removeFromSuperlayer()

        guard let shortcutHexColor = shortcut?.colorHex else { return }
        
        let dotRadius = colorDotView.frame.width * StyleGuide.TaskList.NavBar.Sizes.RatioToParentFrame.shortcutColorDotRadius
        
        let dotColor = UIColor(hexString: shortcutHexColor).cgColor
        
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: colorDotView.frame.width/2, y: colorDotView.frame.height/2), radius: dotRadius, startAngle: 0.0, endAngle: CGFloat(Double.pi * 2), clockwise: true)
        dotShape.path = circlePath.cgPath
        dotShape.fillColor = dotColor
        dotShape.strokeColor = dotColor
        dotShape.lineWidth = StyleGuide.TaskList.NavBar.Sizes.shortcutColorDotLineWidth

        colorDotView.layer.addSublayer(dotShape)
    }
    
}

extension TaskListNavBarTitleView: TaskListNavBarTitle {
    func setTaskListMode(taskListMode: TaskListMode) {
        self.taskListMode = taskListMode
        if taskListMode == .list {
            showStandartTitle(animated: true)
        }
    }
    
    func setShortcut(shortcut: ShortcutData?) {
        self.shortcut = shortcut
    }
    
    func showMonth(date: Date) {
        showMonthTitle(date: date, animated: true)
    }
    
    func showMainTitle() {
        showStandartTitle(animated: true)
    }
}
