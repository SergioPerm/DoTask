//
//  SpeechText.swift
//  DoTask
//
//  Created by KLuV on 07.03.2021.
//  Copyright © 2021 itotdel. All rights reserved.
//

import UIKit
import SnapKit

class SpeechText: UITextView {
    
    private let placeholderText = ""
    
    private let speakLabel: LocalizableLabel = {
        let label = LocalizableLabel()
        label.textAlignment = .center
        label.font = FontFactory.AvenirNextBold.of(size: StyleGuide.getSizeRelativeToScreenWidth(baseSize: 32))
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.localizableString = LocalizableStringResource(stringResource: R.string.localizable.speaK)
        
        return label
    }()
    
    init() {
        super.init(frame: .zero, textContainer: nil)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
}

extension SpeechText {
    
    func setSpeechText(text: String) {
        if !speakLabel.isHidden {
            speakLabel.isHidden = true
            textAlignment = .left
            updateTextFont()
        }
        
        let contentOffset = contentSize.height - frame.height
        
        if contentOffset > 0 {
            setContentOffset(CGPoint(x: 0, y: contentOffset), animated: true)
        }
        
        self.text = text
    }
    
    func updateTextFont() {
        font = FontFactory.AvenirNext.of(size: StyleGuide.getSizeRelativeToScreenWidth(baseSize: 23))
    }
        
    func isEmpty() -> Bool {
        if text == placeholderText {
            return true
        }
        return false
    }
    
    private func setup() {
        isEditable = false
        showsVerticalScrollIndicator = false
            
        backgroundColor = .clear
        
        textColor = .white
        textAlignment = .center
        
        addSubview(speakLabel)
        
        speakLabel.snp.makeConstraints({ make in
            make.centerY.centerX.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalToSuperview()
        })
    }
}

