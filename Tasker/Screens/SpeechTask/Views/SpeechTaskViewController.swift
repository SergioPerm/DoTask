//
//  SpeechTaskViewController.swift
//  Tasker
//
//  Created by KLuV on 28.02.2021.
//  Copyright © 2021 itotdel. All rights reserved.
//

import UIKit

class SpeechTaskViewController: UIViewController, PresentableController {
            
    var presentableControllerViewType: PresentableControllerViewType
    var router: RouterType?
    var persistentType: PersistentViewControllerType?
    
    private var longTapRecognizer: UILongPressGestureRecognizer
    
    private let speakWave: SpeakWave = {
        let view = SpeakWave()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    typealias TestAlias = UILabel
    
    private let crossBtn = CircleCrossGradientBtn()
        
    private let speechText: SpeechText = {
        let label = SpeechText()
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()
    
    private let infoText: SpeechTextInfo = {
        let label = SpeechTextInfo()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let swipeToCancel: SpeechSwipeCancel = {
        let swipeView = SpeechSwipeCancel()
        swipeView.translatesAutoresizingMaskIntoConstraints = false
        
        return swipeView
    }()

    init(router: RouterType?, recognizer: UILongPressGestureRecognizer, presentableControllerViewType: PresentableControllerViewType, persistentType: PersistentViewControllerType? = nil) {
        self.router = router
        self.presentableControllerViewType = presentableControllerViewType
        self.longTapRecognizer = recognizer
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
             
}

// MARK: Setup

extension SpeechTaskViewController {
 
    private func setup() {
        view.backgroundColor = StyleGuide.MainColors.blue
        
        longTapRecognizer.addTarget(self, action: #selector(tapAction(sender:)))
        view.addGestureRecognizer(longTapRecognizer)
        
        let btnWidth = crossBtn.frame.width
        guard let globalFrame = UIView.globalView?.frame else { return }
        let btnOrigin = CGPoint(x: globalFrame.width - btnWidth - 20, y: globalFrame.height - btnWidth - 20 - view.globalSafeAreaInsets.bottom)
        
        crossBtn.frame.origin = btnOrigin
                
        [crossBtn, speakWave, speechText, infoText, swipeToCancel].forEach({
            self.view.addSubview($0)
        })
                
        setupConstraints()
    }
    
    private func setupConstraints() {
        
        guard let globalFrame = UIView.globalView?.frame else { return }
        
        let speakWaveWidth = globalFrame.width * 0.4
                
        let swipeToCancelHeightConstraint = swipeToCancel.heightAnchor.constraint(equalToConstant: 10)
        swipeToCancelHeightConstraint.priority = UILayoutPriority(250)
        
        let constraints = [
            speakWave.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            speakWave.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            speakWave.widthAnchor.constraint(equalToConstant: speakWaveWidth),
            speakWave.heightAnchor.constraint(equalToConstant: speakWaveWidth),
            speechText.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            speechText.topAnchor.constraint(equalTo: view.topAnchor, constant: 80),
            speechText.widthAnchor.constraint(equalToConstant: globalFrame.width * 0.7),
            infoText.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            infoText.widthAnchor.constraint(equalToConstant: globalFrame.width * 0.7),
            infoText.topAnchor.constraint(equalTo: speakWave.bottomAnchor, constant: 50),
            swipeToCancel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            swipeToCancel.trailingAnchor.constraint(equalTo: crossBtn.leadingAnchor, constant: 30),
            swipeToCancel.centerYAnchor.constraint(equalTo: crossBtn.centerYAnchor),
            swipeToCancelHeightConstraint
        ]
        
        NSLayoutConstraint.activate(constraints)
        
        view.layoutIfNeeded()
    }
    
}

// MARK: Actions

extension SpeechTaskViewController {
    
    @objc private func tapAction(sender: UILongPressGestureRecognizer) {
        if sender.state == .ended || sender.state == .cancelled {
            popWhenRelease()
        }
    }
    
    private func popWhenRelease() {
        longTapRecognizer.removeTarget(self, action: #selector(tapAction(sender:)))
        router?.pop(vc: self)
    }
    
}
