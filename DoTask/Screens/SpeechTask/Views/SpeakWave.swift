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
        
        let color1 = StyleGuide.SpeechTask.SpeakWave.Colors.gradientColor1.cgColor
        let color2 = StyleGuide.SpeechTask.SpeakWave.Colors.gradientColor2.cgColor
                
        gradientLayer.colors = [color1, color2]
        
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        
        return gradientLayer
    }()
    
    private let zoomLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.backgroundColor = StyleGuide.SpeechTask.SpeakWave.Colors.zoomLayerColor.cgColor
        
        return layer
    }()
    
    private let microphoneImageView: UIImageView = {
        let image = R.image.speechTask.microphone()?.maskWithColor(color: .white)
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    private var displayLink: CADisplayLink?
    private var currentSoundLevel: Float = 0.0
    private var currentScale: CGFloat = 0.0
    private var currentFrameTime: CFTimeInterval = 0.0
    private var minFrameTime: CFTimeInterval = 0.03
    private let zoomStep: CGFloat = 0.075
    private let volumeStep: CGFloat = 0.23
    
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
        
        let zoomLayerStartScale = StyleGuide.SpeechTask.SpeakWave.Sizes.Scale.zoomLayerXYStartScale
        let gradientLayerStartScale = StyleGuide.SpeechTask.SpeakWave.Sizes.Scale.gradientLayerXYStartScale
                
        let micWidthRatioToGradient = StyleGuide.SpeechTask.SpeakWave.Sizes.Ratio.micWidthRatioToGradient
        
        zoomLayer.frame = bounds
        zoomLayer.transform = CATransform3DMakeScale(zoomLayerStartScale, zoomLayerStartScale, 1.0)
        zoomLayer.cornerRadius = zoomLayer.frame.width / 2.0
        zoomLayer.bounds = zoomLayer.frame
        
        gradient.frame = bounds
        gradient.transform = CATransform3DMakeScale(gradientLayerStartScale, gradientLayerStartScale, 1.0)
        gradient.cornerRadius = gradient.frame.width / 2.0
        gradient.bounds = gradient.frame
        
        microphoneHeightConstraint.constant = gradient.frame.width * micWidthRatioToGradient
        microphoneWidthConstraint.constant = gradient.frame.width * micWidthRatioToGradient
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
        if now - currentFrameTime < minFrameTime {
            return
        }
        
        var newScale: CGFloat = 0.0
        
        if currentScale == 0.0 {
            currentScale = zoomLayer.transform.m11
        }
        
        let minScale = StyleGuide.SpeechTask.SpeakWave.Sizes.Scale.zoomLayerXYStartScale
        
        if currentSoundLevel > 0.0 {
            
            //0.08 max 0.01 min
            let percentPower = CGFloat(currentSoundLevel) / 0.08
            let maxTransform: CGFloat = minScale + (minScale * (percentPower))

            newScale = currentScale + volumeStep * percentPower
            if newScale > maxTransform {
                newScale = 1.0
                currentSoundLevel = 0.0
            }
        } else {
            if currentScale > minScale {
                newScale = currentScale - zoomStep
                if newScale < minScale {
                    newScale = minScale
                }
            }
        }

        if newScale > 0.0 {
            zoomLayer.transform = CATransform3DMakeScale(newScale, newScale, 1.0)
            currentScale = newScale
            currentFrameTime = CACurrentMediaTime()
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
        
        let micWidthRatioToGradient = StyleGuide.SpeechTask.SpeakWave.Sizes.Ratio.micWidthRatioToGradient
        
        microphoneHeightConstraint = microphoneImageView.heightAnchor.constraint(equalToConstant: gradient.frame.width * micWidthRatioToGradient)
        microphoneWidthConstraint = microphoneImageView.widthAnchor.constraint(equalToConstant: gradient.frame.width * micWidthRatioToGradient)
        
        let constraints = [
            microphoneImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            microphoneImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            microphoneHeightConstraint,
            microphoneWidthConstraint
        ]
        
        NSLayoutConstraint.activate(constraints)
        
    }
}
