//
//  SpeechRecorderAnimationController.swift
//  Tasker
//
//  Created by KLuV on 03.03.2021.
//  Copyright © 2021 itotdel. All rights reserved.
//

import UIKit

class SpeechRecorderAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    
    var circle = UIView()
    
    private let presentDuration: TimeInterval
    private let dismissDuration: TimeInterval
    
    var isPresenting: Bool

    private var containerSnapshotAddBtn: UIView = UIView()
    private var containerSnapshotSpeakWave: UIView = UIView()
    private var containerSnapshotSpeechText: UIView = UIView()
    private var containerSnapshotSpeechInfoText: UIView = UIView()
    private var containerSnapshotSpeechSwipeCancel: UIView = UIView()
    
    init(presentDuration: TimeInterval, dismissDuration: TimeInterval, isPresenting: Bool = false) {
        self.presentDuration = presentDuration
        self.dismissDuration = dismissDuration
        self.isPresenting = isPresenting
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return isPresenting ? presentDuration : dismissDuration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        if isPresenting {
            presentTransition(using: transitionContext)
        } else {
            dismissTransition(using: transitionContext)
        }

    }
    
}

extension SpeechRecorderAnimationController {
        
    private func SquareAroundCircle(_ center: CGPoint, radius: CGFloat) -> CGRect {
        return CGRect(origin: center, size: CGSize.zero).insetBy(dx: -radius, dy: -radius)
    }
    
    func toImage(view: UIView, isOpaque: Bool) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, isOpaque, 0.0)
        
        defer { UIGraphicsEndImageContext() }
        
        if let context = UIGraphicsGetCurrentContext() {
            view.layer.render(in: context)
            let image = UIGraphicsGetImageFromCurrentImageContext()
            return image
        }
        return nil
     }
    
    private func presentTransition(using transitionContext: UIViewControllerContextTransitioning) {
     
        guard let toVC = transitionContext.viewController(forKey: .to) as? SpeechTaskViewController else { return }
                
        let containerView = transitionContext.containerView
                
        guard let addBtnView = toVC.getFirstViewForType(viewType: CircleCrossGradientBtn.self),
              let speakWaveView = toVC.getFirstViewForType(viewType: SpeakWave.self),
              let speechText = toVC.getFirstViewForType(viewType: SpeechText.self),
              let speechInfoText = toVC.getFirstViewForType(viewType: SpeechTextInfo.self),
              let speechSwipeCancel = toVC.getFirstViewForType(viewType: SpeechSwipeCancel.self)
        else { return }
                        
        let addBtnViewFrame = addBtnView.frame
        let speakWaveViewFrame = speakWaveView.frame
        let speechTextViewFrame = speechText.frame
        let speechInfoTextViewFrame = speechInfoText.frame
        let speechSwipeCancelViewFrame = speechSwipeCancel.frame
        
        //off shadow for speechVC
        addBtnView.layer.shadowColor = UIColor.clear.cgColor
        
        let snapshotSpeechText = UIImageView(image: toImage(view: speechText, isOpaque: false))
        
        guard let snapshotAddBtn = addBtnView.snapshotView(afterScreenUpdates: true),
              let snapshotSpeakWave = speakWaveView.snapshotView(afterScreenUpdates: true),
//              let snapshotSpeechText = UIImageView(image: toImage(view: speechText)),//speechText.snapshotView(afterScreenUpdates: true),
              let snapshotSpeechInfoText = speechInfoText.snapshotView(afterScreenUpdates: true),
              let snapshotSpeechSwipeCancel = speechSwipeCancel.snapshotView(afterScreenUpdates: true)
              else { return }
                
        
        containerSnapshotAddBtn = snapshotAddBtn
        containerSnapshotSpeakWave = snapshotSpeakWave
        containerSnapshotSpeechText = snapshotSpeechText
        containerSnapshotSpeechInfoText = snapshotSpeechInfoText
        containerSnapshotSpeechSwipeCancel = snapshotSpeechSwipeCancel
                
        speakWaveView.isHidden = true
        speechText.isHidden = true
        speechInfoText.isHidden = true
        speechSwipeCancel.isHidden = true
        
        containerSnapshotAddBtn.frame = addBtnViewFrame
        containerSnapshotSpeakWave.frame = speakWaveViewFrame
        containerSnapshotSpeechText.frame = speechTextViewFrame
        containerSnapshotSpeechInfoText.frame = speechInfoTextViewFrame
        containerSnapshotSpeechSwipeCancel.frame = speechSwipeCancelViewFrame
        
        let btnCenter = addBtnView.center
        
        let radius: CGFloat = {
            let x = max(btnCenter.x, toVC.view.frame.width - btnCenter.x)
            let y = max(btnCenter.y, toVC.view.frame.height - btnCenter.y)
            return sqrt(x * x + y * y)
        }()
        
        
        let startCirclePath = CGPath(ellipseIn: SquareAroundCircle(btnCenter, radius: 0), transform: nil)
        let endCirclePath = CGPath(ellipseIn: SquareAroundCircle(btnCenter, radius: radius), transform: nil)
                
        let mask = CAShapeLayer()
        mask.path = endCirclePath
        mask.fillRule = CAShapeLayerFillRule.evenOdd
        
        containerView.layer.mask = mask
        mask.frame = toVC.view.layer.bounds
        
        containerView.addSubview(toVC.view)
        containerView.addSubview(containerSnapshotAddBtn)
        containerView.addSubview(containerSnapshotSpeakWave)
        containerView.addSubview(containerSnapshotSpeechText)
        containerView.addSubview(containerSnapshotSpeechInfoText)
        containerView.addSubview(containerSnapshotSpeechSwipeCancel)
        
        //Animations
        
        let animationOpacity = CABasicAnimation(keyPath: "opacity")
        animationOpacity.duration = presentDuration
        animationOpacity.fromValue = 0.0
        animationOpacity.toValue = 1.0
        
        let decreaseTransorm = CGAffineTransform(scaleX: 0.1, y: 0.1)
        
        [containerSnapshotSpeakWave,
         containerSnapshotSpeechText,
         containerSnapshotSpeechInfoText].forEach({
            $0.transform = decreaseTransorm
         })
                
        containerSnapshotSpeechSwipeCancel.frame.origin.x += 100
        containerSnapshotSpeechSwipeCancel.layer.opacity = 0.0
                
        UIView.animate(withDuration: presentDuration, delay: 0.0, options: .curveEaseIn) {
            self.containerSnapshotSpeechSwipeCancel.frame.origin.x -= 100
            self.containerSnapshotSpeechSwipeCancel.layer.opacity = 1.0
        } completion: { (finished) in
        }

        UIView.animate(withDuration: presentDuration - 0.2, delay: 0.2, usingSpringWithDamping: 0.25, initialSpringVelocity: 0.5, options: .curveEaseIn) {
            
            [self.containerSnapshotSpeechText,
             self.containerSnapshotSpeakWave,
             self.containerSnapshotSpeechInfoText].forEach({
                $0.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
             })
                        
        } completion: { (finished) in
            print("finish anim \(finished)")
            
            [self.containerSnapshotSpeakWave,
             self.containerSnapshotSpeechText,
             self.containerSnapshotSpeechInfoText,
             self.containerSnapshotSpeechSwipeCancel].forEach({
                $0.isHidden = true
             })
            
            [speakWaveView,
             speechText,
             speechInfoText,
             speechSwipeCancel].forEach({
                $0.isHidden = false
             })
            
            containerView.layer.mask = nil
            self.containerSnapshotAddBtn.layer.removeAllAnimations()
            transitionContext.completeTransition(true)
        }

        let animation = CABasicAnimation(keyPath: "path")
        animation.duration = presentDuration - 0.4
        animation.fromValue = startCirclePath
        animation.toValue = endCirclePath
            
        let transformScale = CATransform3DMakeScale(1.4, 1.4, 1.0)
        
        let animationTransform = CABasicAnimation(keyPath: "transform")
        animationTransform.duration = presentDuration - 0.4
        animationTransform.fromValue = CATransform3DMakeScale(1.0, 1.0, 1.0)
        animationTransform.toValue = transformScale
        
        containerSnapshotAddBtn.layer.transform = CATransform3DMakeScale(1.4, 1.4, 1.0)
        containerSnapshotAddBtn.layer.add(animationTransform, forKey: "transformAnimation")

        mask.add(animation, forKey: "reveal")
        
    }

    private func dismissTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        guard let fromVC = transitionContext.viewController(forKey: .from) else { return }
        
        let containerView = transitionContext.containerView
        
        guard let addBtnView = fromVC.getFirstViewForType(viewType: CircleCrossGradientBtn.self),
              let speakWaveView = fromVC.getFirstViewForType(viewType: SpeakWave.self),
              let speechText = fromVC.getFirstViewForType(viewType: SpeechText.self),
              let speechInfoText = fromVC.getFirstViewForType(viewType: SpeechTextInfo.self),
              let speechSwipeCancel = fromVC.getFirstViewForType(viewType: SpeechSwipeCancel.self)
        else { return }
        
        containerSnapshotSpeechText = UIImageView(image: toImage(view: speechText, isOpaque: false))
        
        [addBtnView,
         speakWaveView,
         speechInfoText,
         speechSwipeCancel].forEach({
            $0.isHidden = true
         })
        
        [containerSnapshotSpeakWave,
         containerSnapshotSpeechInfoText,
         containerSnapshotSpeechSwipeCancel].forEach({
            $0.isHidden = false
         })
                
        let btnCenter = containerSnapshotAddBtn.center
 
        let radius: CGFloat = {
            let x = max(btnCenter.x, fromVC.view.frame.width - btnCenter.x)
            let y = max(btnCenter.y, fromVC.view.frame.height - btnCenter.y)
            return sqrt(x * x + y * y)
        }()
        
        let startCirclePath = CGPath(ellipseIn: SquareAroundCircle(btnCenter, radius: 0), transform: nil)
        let endCirclePath = CGPath(ellipseIn: SquareAroundCircle(btnCenter, radius: radius), transform: nil)
                
        let mask = CAShapeLayer()
        mask.path = startCirclePath
        mask.fillRule = CAShapeLayerFillRule.evenOdd
        
        containerView.layer.mask = mask
        mask.frame = fromVC.view.layer.bounds
                
        let animation = CABasicAnimation(keyPath: "path")
        animation.duration = dismissDuration
        animation.fromValue = endCirclePath
        animation.toValue = startCirclePath

        let animationOpacity = CABasicAnimation(keyPath: "opacity")
        animationOpacity.duration = dismissDuration
        animationOpacity.fromValue = 1.0
        animationOpacity.toValue = 0.0
    
        let transformScale = CATransform3DMakeScale(1.0, 1.0, 1.0)
        let transformDecrease = CGAffineTransform(scaleX: 0.5, y: 0.5)
        
        UIView.animate(withDuration: dismissDuration - 0.1) {
            speechText.transform = transformDecrease
        }
        
        UIView.animate(withDuration: dismissDuration) {
            [self.containerSnapshotSpeakWave,
             self.containerSnapshotSpeechInfoText,
             self.containerSnapshotSpeechSwipeCancel].forEach({
                $0.transform = transformDecrease
            })
        } completion: { (finished) in
            containerView.layer.mask = nil
            transitionContext.completeTransition(true)
        }

        let animationTransform = CABasicAnimation(keyPath: "transform")
        animationTransform.duration = dismissDuration
        animationTransform.fromValue = CATransform3DMakeScale(1.4, 1.4, 1.0)
        animationTransform.toValue = transformScale
        
        containerSnapshotAddBtn.layer.transform = transformScale
        containerSnapshotAddBtn.layer.add(animationTransform, forKey: "transformAnimation")
        
        mask.add(animation, forKey: "reveal")
    }
    

    
}
