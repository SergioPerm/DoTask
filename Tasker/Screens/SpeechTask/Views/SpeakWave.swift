//
//  SpeakWave.swift
//  Tasker
//
//  Created by KLuV on 05.03.2021.
//  Copyright © 2021 itotdel. All rights reserved.
//

import UIKit

class SpeakWave: UIView {

    private lazy var gradient: CAGradientLayer = {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [#colorLiteral(red: 1, green: 0.7027073819, blue: 0.9019589665, alpha: 1).cgColor, #colorLiteral(red: 1, green: 0.2117647059, blue: 0.6509803922, alpha: 1).cgColor]
        
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        
        return gradientLayer
    }()
    
    private let microphoneImageView: UIImageView = {
        let image = UIImage(named: "microphone")?.maskWithColor(color: .white)
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    private var microphoneHeightConstraint = NSLayoutConstraint()
    private var microphoneWidthConstraint = NSLayoutConstraint()
    
    init() {
        super.init(frame: CGRect.zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = bounds.width / 2.0
        
        gradient.frame = bounds
        gradient.transform = CATransform3DMakeScale(0.8, 0.8, 1.0)
        gradient.cornerRadius = gradient.frame.width / 2.0
        gradient.bounds = gradient.frame
        
        microphoneHeightConstraint.constant = gradient.frame.width * 0.5
        microphoneWidthConstraint.constant = gradient.frame.width * 0.5
        layoutIfNeeded()
    }
    
}

extension SpeakWave {
    private func setup() {
        
        backgroundColor = #colorLiteral(red: 1, green: 0.8026864087, blue: 0.9260444804, alpha: 1)
        
        layer.addSublayer(gradient)
        addSubview(microphoneImageView)
                
        setupConstraints()
    }
    
    private func setupConstraints() {
        
        microphoneHeightConstraint = microphoneImageView.heightAnchor.constraint(equalToConstant: frame.width * 0.5)
        microphoneWidthConstraint = microphoneImageView.widthAnchor.constraint(equalToConstant: frame.width * 0.5)
        
        let constraints = [
            microphoneImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            microphoneImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            microphoneHeightConstraint,
            microphoneWidthConstraint
        ]
        
        NSLayoutConstraint.activate(constraints)
        
    }
}
