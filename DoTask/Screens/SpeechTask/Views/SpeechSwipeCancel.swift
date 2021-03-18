//
//  SpeechSwipeCancel.swift
//  DoTask
//
//  Created by KLuV on 07.03.2021.
//  Copyright © 2021 itotdel. All rights reserved.
//

import UIKit

class SpeechSwipeCancel: UIView {

    private let arrowImageView: UIImageView = {
        let image = R.image.speechTask.leftArrow()?.maskWithColor(color: .white)
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    private let textLabel: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = UIFont(name: "AvenirNext-Regular", size: StyleGuide.getFontSizeRelativeToScreen(baseSize: 14))
        label.text = "Swipe to left for CANCEL"
        label.textColor = .white
        
        return label
    }()
    
    init() {
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
}

extension SpeechSwipeCancel {
    private func setup() {
        
        guard let globalFrame = UIView.globalView?.frame else { return }
        
        addSubview(arrowImageView)
        addSubview(textLabel)
        
        let arrowSide = globalFrame.width * StyleGuide.SpeechTask.SpeechSwipe.Sizes.Ratio.arrowImageSideSize
        let textLabelWidthAnchor = textLabel.widthAnchor.constraint(equalToConstant: 50)
        textLabelWidthAnchor.priority = UILayoutPriority(250)
        
        let constraints = [
            arrowImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            arrowImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            arrowImageView.topAnchor.constraint(equalTo: topAnchor),
            arrowImageView.heightAnchor.constraint(equalToConstant: arrowSide),
            arrowImageView.widthAnchor.constraint(equalToConstant: arrowSide),
            textLabel.leadingAnchor.constraint(equalTo: arrowImageView.trailingAnchor, constant: 20),
            textLabel.topAnchor.constraint(equalTo: topAnchor),
            textLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            textLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            textLabelWidthAnchor,
            textLabel.heightAnchor.constraint(equalToConstant: arrowSide)
        ]
        
        NSLayoutConstraint.activate(constraints)
        
    }
}
