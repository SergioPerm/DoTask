//
//  SpeechTaskViewController.swift
//  DoTask
//
//  Created by KLuV on 28.02.2021.
//  Copyright © 2021 itotdel. All rights reserved.
//

import UIKit
import SnapKit

class SpeechTaskViewController: UIViewController, SpeechTaskViewType {
            
    var presentableControllerViewType: PresentableControllerViewType
    var router: RouterType?
    var persistentType: PersistentViewControllerType?
    
    private var viewModel: SpeechTaskViewModelType {
        didSet {
            bindViewModel()
        }
    }
    
    var longTapRecognizer: UILongPressGestureRecognizer?
    var shortcutUID: String? {
        didSet {
            if let shortcutUID = shortcutUID {
                viewModel.inputs.setShortcut(uid: shortcutUID)
            }
        }
    }
    var taskDate: Date?
    
    private let speakWave: SpeakWave = {
        let view = SpeakWave()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
        
    private let crossBtn = CircleCrossGradientBtn()
        
    private let speechText: SpeechText = {
        let label = SpeechText()
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()
    
    private let infoText: SpeechTextInfo = {
        let label = SpeechTextInfo()
        
        return label
    }()
    
    private let swipeToCancel: SpeechSwipeCancel = {
        let swipeView = SpeechSwipeCancel()
        swipeView.translatesAutoresizingMaskIntoConstraints = false
        
        return swipeView
    }()
    
    private var trailingSwipeToCancelConstraint: NSLayoutConstraint = NSLayoutConstraint()
    private var prevPointOnSwipe: CGFloat = 0.0
    
    init(viewModel: SpeechTaskViewModelType, router: RouterType?, presentableControllerViewType: PresentableControllerViewType, persistentType: PersistentViewControllerType? = nil) {
        self.viewModel = viewModel
        self.router = router
        self.presentableControllerViewType = presentableControllerViewType
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        bindViewModel()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
                       
        viewModel.inputs.startRecording()
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        speakWave.stopAnimate()
        
        viewModel.outputs.speechTextChangeEvent.unsubscribe(self)
        viewModel.outputs.volumeLevel.unsubscribe(self)
    }
             
}

// MARK: Setup

extension SpeechTaskViewController {
 
    private func bindViewModel() {
                
        viewModel.outputs.speechTextChangeEvent.subscribe(self) { this, speechText in
            this.speechText.setSpeechText(text: speechText)
        }
        
        viewModel.outputs.volumeLevel.subscribe(self) { this, volumeLevel in
            self.speakWave.setVolume(value: volumeLevel)
        }
        
    }
    
    private func setup() {
        view.backgroundColor = R.color.commonColors.blue()!
        
        if let longTapRecognizer = longTapRecognizer {
            longTapRecognizer.addTarget(self, action: #selector(tapAction(sender:)))
            view.addGestureRecognizer(longTapRecognizer)
        }
                        
        [crossBtn, speakWave, speechText, infoText, swipeToCancel].forEach({
            self.view.addSubview($0)
        })
                
        setupConstraints()
    }
    
    private func setupConstraints() {
        
        guard let globalFrame = UIView.globalView?.frame else { return }
        
        let speakWaveWidth = globalFrame.width * StyleGuide.SpeechTask.Sizes.RatioToScreenWidth.speakWaveWidth
                
        let swipeToCancelHeightConstraint = swipeToCancel.heightAnchor.constraint(equalToConstant: 10)
        swipeToCancelHeightConstraint.priority = UILayoutPriority(250)
        
        trailingSwipeToCancelConstraint = swipeToCancel.trailingAnchor.constraint(equalTo: crossBtn.leadingAnchor, constant: -40)
        
        let leadingSwipeToCancel = swipeToCancel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30)
        leadingSwipeToCancel.priority = UILayoutPriority(250)
        
        let constraints = [
            speechText.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            speechText.topAnchor.constraint(equalTo: view.topAnchor, constant: 50),
            speechText.widthAnchor.constraint(equalToConstant: globalFrame.width * StyleGuide.SpeechTask.Sizes.RatioToScreenWidth.speakWaveWidth),
            speechText.bottomAnchor.constraint(equalTo: speakWave.topAnchor),
            infoText.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            infoText.widthAnchor.constraint(equalToConstant: globalFrame.width * StyleGuide.SpeechTask.Sizes.RatioToScreenWidth.speakWaveWidth),
            infoText.topAnchor.constraint(equalTo: speakWave.bottomAnchor, constant: 50),
            leadingSwipeToCancel,
            trailingSwipeToCancelConstraint,
            swipeToCancel.centerYAnchor.constraint(equalTo: crossBtn.centerYAnchor),
            swipeToCancelHeightConstraint
        ]
        
        NSLayoutConstraint.activate(constraints)
        
        speakWave.snp.makeConstraints { (make) in
            make.center.equalTo(view)
            make.width.height.equalTo(speakWaveWidth)
        }
        
        view.layoutIfNeeded()
    }
    
}

// MARK: Actions

extension SpeechTaskViewController {
        
    @objc private func tapAction(sender: UILongPressGestureRecognizer) {
        
        switch sender.state {
        case .changed:
            
            let globalFrame = UIView.globalSafeAreaFrame
                        
            if prevPointOnSwipe == 0.0 {
                prevPointOnSwipe = sender.location(in: view).x
            }
            
            let closeZoneX = globalFrame.width * StyleGuide.SpeechTask.Sizes.RatioToScreenWidth.closeZoneToSwipe
            
            let currentX = sender.location(in: view).x
            
            if closeZoneX > currentX {
                popSpeech()
            }
            
            trailingSwipeToCancelConstraint.constant -= prevPointOnSwipe - currentX
            prevPointOnSwipe = currentX

            view.setNeedsLayout()
        case .ended:
            trailingSwipeToCancelConstraint.constant = -30
            view.setNeedsLayout()
            saveTaskAndPop()
        case .cancelled:
            saveTaskAndPop()
        default:
            return
        }
        
    }
    
    private func saveTaskAndPop() {
        viewModel.inputs.saveTask(taskTitle: speechText.text)
        popSpeech()
    }
    
    private func popSpeech() {
        if let longTapRecognizer = longTapRecognizer {
            longTapRecognizer.removeTarget(self, action: #selector(tapAction(sender:)))
        }
        router?.pop(vc: self)
    }
    
}

