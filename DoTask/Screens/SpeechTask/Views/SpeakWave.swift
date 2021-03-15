//
//  SpeakWave.swift
//  DoTask
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
    
    private let zoomLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.backgroundColor = #colorLiteral(red: 1, green: 0.8026864087, blue: 0.9260444804, alpha: 1).cgColor
        
        return layer
    }()
    
    private let microphoneImageView: UIImageView = {
        let image = UIImage(named: "microphone")?.maskWithColor(color: .white)
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    private var displayLink: CADisplayLink?
    private var currentSoundLevel: Float = 0.0
    private var currentScale: CGFloat = 0.0
    private var frameTime: CFTimeInterval = 0.0
    
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
        layer.masksToBounds = true
        
        zoomLayer.frame = bounds
        zoomLayer.transform = CATransform3DMakeScale(0.7, 0.7, 1.0)
        zoomLayer.cornerRadius = zoomLayer.frame.width / 2.0
        zoomLayer.bounds = zoomLayer.frame
        
        gradient.frame = bounds
        gradient.transform = CATransform3DMakeScale(0.5, 0.5, 1.0)
        gradient.cornerRadius = gradient.frame.width / 2.0
        gradient.bounds = gradient.frame
        
        microphoneHeightConstraint.constant = gradient.frame.width * 0.5
        microphoneWidthConstraint.constant = gradient.frame.width * 0.5
        layoutIfNeeded()
    }
    
}

extension SpeakWave {
    
    func stopAnimate() {
        displayLink?.remove(from: .main, forMode: .common)
        displayLink = nil
    }
    
    func setVolume(value: Float) {
        displayLink?.isPaused = false
        if value > 0.0 {
            currentSoundLevel = value
        }
    }
    
    @objc private func updateAnimation() {
        
        let now = CACurrentMediaTime()
        if now - frameTime < 0.03 {
            return
        }
        
        let zoomStep: CGFloat = 0.075
        let volumeStep: CGFloat = 0.23
        var newScale: CGFloat = 0.0
        
        if currentScale == 0.0 {
            currentScale = zoomLayer.transform.m11
        }
        
        if currentSoundLevel > 0.0 {
            
            //0.08 max 0.01 min
            let percentPower = CGFloat(currentSoundLevel) / 0.08
            let maxTransform: CGFloat = 0.7 + (0.7 * (percentPower))

            newScale = currentScale + volumeStep * percentPower
            if newScale > maxTransform {
                newScale = 1.0
                currentSoundLevel = 0.0
            }
        } else {
            if currentScale > 0.7 {
                newScale = currentScale - zoomStep
                if newScale < 0.7 {
                    newScale = 0.7
                }
            }
        }

        if newScale > 0.0 {
            zoomLayer.transform = CATransform3DMakeScale(newScale, newScale, 1.0)
            currentScale = newScale
            frameTime = CACurrentMediaTime()
        }
    }
    
    private func setup() {
        
        backgroundColor = .clear
        
        layer.addSublayer(zoomLayer)
        layer.addSublayer(gradient)
        
        addSubview(microphoneImageView)
                
        setupConstraints()
        
        displayLink = CADisplayLink(target: self, selector: #selector(updateAnimation))
        displayLink?.isPaused = true
        displayLink?.add(to: .main, forMode: .common)
    }
    
    private func setupConstraints() {
        
        microphoneHeightConstraint = microphoneImageView.heightAnchor.constraint(equalToConstant: frame.width * 0.3)
        microphoneWidthConstraint = microphoneImageView.widthAnchor.constraint(equalToConstant: frame.width * 0.3)
        
        let constraints = [
            microphoneImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            microphoneImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            microphoneHeightConstraint,
            microphoneWidthConstraint
        ]
        
        NSLayoutConstraint.activate(constraints)
        
    }
}
