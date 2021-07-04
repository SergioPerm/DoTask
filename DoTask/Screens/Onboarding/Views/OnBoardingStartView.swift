//
//  OnBoardingStartView.swift
//  DoTask
//
//  Created by Sergio Lechini on 14.06.2021.
//  Copyright © 2021 itotdel. All rights reserved.
//

import UIKit
import SnapKit
import Lottie

class OnBoardingStartView: UIView {

    weak var viewModel: OnboardingStartViewModelType? {
        didSet {
            bindViewModel()
        }
    }
        
    private let imageLogo: UIImageView = {
        let imageView = UIImageView(image: R.image.launchText())
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
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
    
    private let additionalLabel: LocalizableLabel = {
        let label = LocalizableLabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.font = FontFactory.HelveticaNeue.of(size: StyleGuide.getSizeRelativeToScreenWidth(baseSize: 15))
        label.numberOfLines = 0
        
        return label
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

private extension OnBoardingStartView {
    func setup() {
        backgroundColor = .white
        
        animationView = AnimationView()
        
        guard let animationView = animationView else { return }
        
        animationView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(animationView)
        addSubview(imageLogo)
        addSubview(mainLabel)

    }
    
    func setupConstraints() {
                
        guard let animationView = animationView else { return }
        animationView.snp.makeConstraints({ make in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.7)
            make.height.equalTo(animationView.snp.width)
            make.top.equalToSuperview()
        })
        
        imageLogo.snp.makeConstraints({ make in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.25)
            make.height.equalTo(imageLogo.snp.width).multipliedBy(0.8)
            make.top.equalTo(animationView.snp.bottom)
        })
        
        mainLabel.snp.makeConstraints({ make in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.8)
            make.top.equalTo(imageLogo.snp.bottom).offset(10)
            make.bottom.equalToSuperview().offset(-10)
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
    }
}
