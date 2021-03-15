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
//        willSet {
//            if newValue == nil {
//                viewModel?.outputs.taskListModeEvent.unsubscribe(self)
//            }
//        }
        didSet {
            bindViewModel()
        }
    }
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor.white
        
        return label
    }()
    
    private let titleLayer: CATextLayer = {
        let textLayer = CATextLayer()
        textLayer.font = Font.tableHeader.uiFont
        textLayer.fontSize = 27
        textLayer.foregroundColor = StyleGuide.MainColors.blue.cgColor
        textLayer.contentsScale = UIScreen.main.scale
        
        return textLayer
    }()
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(titleLabel)
        titleLabel.layer.addSublayer(titleLayer)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
                
        titleLabel.frame = CGRect.init(x: 0, y: 0, width: frame.width, height: StyleGuide.TaskList.Sizes.headerTitleHeight)
        titleLayer.frame = titleLabel.bounds
    }
    
}

extension TaskListTableHeaderView {
    private func bindViewModel() {
        
        if let title = viewModel?.outputs.title {
            titleLayer.string = "  \(title)"
        }
        
        guard let viewModel = viewModel else { return }

        if viewModel.outputs.taskListMode == .calendar {
            titleLayer.fontSize = 19
        } else {
            titleLayer.fontSize = 27
        }
        
//        viewModel?.outputs.taskListModeEvent.subscribe(self, handler: { this, mode in
//            if mode == .calendar {
//                this.titleLayer.fontSize = 19
//            } else {
//                this.titleLayer.fontSize = 27
//            }
//        })
        
//        viewModel?.outputs.taskListMode.bind { [weak self] mode in
//            if mode == .calendar {
//                self?.titleLayer.fontSize = 19
//            } else {
//                self?.titleLayer.fontSize = 27
//            }
//        }
        
    }
}
