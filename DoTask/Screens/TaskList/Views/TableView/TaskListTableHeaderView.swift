//
//  TaskListTableHeaderView.swift
//  DoTask
//
//  Created by KLuV on 04.02.2021.
//  Copyright © 2021 itotdel. All rights reserved.
//

import UIKit

class TaskListTableHeaderView: UIView {

    var viewModel: TaskListPeriodItemViewModelType? {
        willSet {
            viewModel?.outputs.doneCounterEvent.unsubscribe(self)
        }
        didSet {
            bindViewModel()
        }
    }
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = R.color.taskList.background()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
             
    private let counter: TaskCounter = {
        let counter = TaskCounter()
        counter.translatesAutoresizingMaskIntoConstraints = false
        
        return counter
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        titleLabel.sizeToFit()
        //titleLabel.frame = CGRect.init(x: 0, y: 5, width: frame.width, height: StyleGuide.TaskList.Sizes.headerTitleHeight)
    }
    
}

extension TaskListTableHeaderView {
    
    private func setup() {
        addSubview(titleLabel)
        
        addSubview(counter)
        counter.isHidden = true
                
        let titleWidthConstraint = titleLabel.widthAnchor.constraint(equalToConstant: 10)
        titleWidthConstraint.priority = UILayoutPriority(250)
        
        let constraints: [NSLayoutConstraint] = [
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            titleWidthConstraint,
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            counter.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 15),
            counter.widthAnchor.constraint(equalToConstant: 50),
            counter.heightAnchor.constraint(equalToConstant: StyleGuide.TaskList.Sizes.counterHeight),
            counter.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    private func bindViewModel() {
                
        counter.isHidden = true
        
        if let title = viewModel?.outputs.title {
            titleLabel.text = "  \(title)"
        }
        
        if let textColor = viewModel?.outputs.titleHexColor {
            titleLabel.textColor = UIColor(hexString: textColor)
        }
                
        guard let viewModel = viewModel else { return }

        if viewModel.outputs.taskListMode == .calendar {
            titleLabel.font = FontFactory.AvenirNextBold.of(size: StyleGuide.getSizeRelativeToScreenWidth(baseSize: 19))
        } else {
            titleLabel.font = FontFactory.AvenirNextBold.of(size: StyleGuide.getSizeRelativeToScreenWidth(baseSize: 27))
        }
        
        if let doneCounter = viewModel.outputs.doneCounter {
            counter.isHidden = false
            counter.updateCount(counter: doneCounter)
        }
        
        viewModel.outputs.doneCounterEvent.subscribe(self) { (this, doneCounter) in
            if let doneCounter = doneCounter {
                this.counter.updateCount(counter: doneCounter)
            }
        }
                
    }
}
