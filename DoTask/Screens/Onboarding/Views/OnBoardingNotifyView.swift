//
//  OnBoardingNotifyView.swift
//  DoTask
//
//  Created by Sergio Lechini on 14.06.2021.
//  Copyright © 2021 itotdel. All rights reserved.
//

import UIKit
import SnapKit
import Lottie

class OnBoardingNotifyView: UIView {

    weak var viewModel: OnBoardingNotifyViewModelType? {
        didSet {
            bindViewModel()
        }
    }
            
    private let mainLabel: LocalizableLabel = {
        let label = LocalizableLabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.font = FontFactory.AvenirNextRegular.of(size: StyleGuide.getSizeRelativeToScreenWidth(baseSize: 20))
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = R.color.launch.launcTextColor()
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        
        return label
    }()
    
    private let allowNotificationsBtn: LocalizableButton = {
        let btn = LocalizableButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.backgroundColor = R.color.commonColors.pink()
        btn.titleLabel?.textColor = .white
        btn.titleLabel?.textAlignment = .center
        btn.titleLabel?.font = FontFactory.HelveticaNeue.of(size: StyleGuide.getSizeRelativeToScreenWidth(baseSize: 20))
        
        btn.layer.cornerRadius = 15
        
        return btn
    }()
    
    private var animationView: AnimationView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
}

private extension OnBoardingNotifyView {
    func setup() {
        backgroundColor = .white
        
        animationView = AnimationView()
        
        guard let animationView = animationView else { return }
        
        animationView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(animationView)
        addSubview(mainLabel)
        addSubview(allowNotificationsBtn)

        allowNotificationsBtn.localizableString = LocalizableStringResource(stringResource: R.string.localizable.onboarding_ALLOW_NOTIFY)
        allowNotificationsBtn.addTarget(self, action: #selector(allowNotifyAction(sender:)), for: .touchUpInside)
    }
    
    func setupConstraints() {
                
        guard let animationView = animationView else { return }
        animationView.snp.makeConstraints({ make in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.6)
            make.height.equalTo(animationView.snp.width)
            make.top.equalToSuperview().offset(20)
        })
                
        mainLabel.snp.makeConstraints({ make in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.8)
            make.bottom.equalTo(allowNotificationsBtn.snp.top).offset(-10)
            make.top.equalTo(animationView.snp.bottom).offset(20)
        })
        
        allowNotificationsBtn.snp.makeConstraints({ make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-16)
            make.width.equalToSuperview().multipliedBy(0.7)
            make.height.equalTo(50)
        })
                
    }
    
    func bindViewModel() {
        
        guard let viewModel = viewModel, let animationView = animationView else { return }
        
        mainLabel.localizableString = viewModel.outputs.mainText
        
        animationView.animation = Animation.named(viewModel.outputs.lottieAnimationName)
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        animationView.animationSpeed = 0.5
                 
        animationView.play()
        
        viewModel.outputs.hideAllowBtnAfterCheckEvent.subscribe(self) { this in
            this.allowNotificationsBtn.isHidden = true
        }
    }
    
    @objc func allowNotifyAction(sender: UIButton) {
        viewModel?.inputs.allowNotify()
    }
}

