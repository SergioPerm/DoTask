//
//  SpeechText.swift
//  DoTask
//
//  Created by KLuV on 07.03.2021.
//  Copyright © 2021 itotdel. All rights reserved.
//

import UIKit

class SpeechText: UITextView {
    
    private let placeholderText = ""
    
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
        if !text.isEmpty {
            self.text = text
            updateTextFont()
        }
        
        if isEmpty() && !text.isEmpty {
            textAlignment = .left
        }
    }
    
    func updateTextFont() {
        if bounds.size.equalTo(CGSize.zero) {
            return
        }

        guard let textFont = font else { return }
        
        let textViewSize = frame.size
        let fixedWidth = textViewSize.width
        let expectSize = sizeThatFits(CGSize(width: fixedWidth, height: CGFloat(MAXFLOAT)))

        var expectFont = textFont
        if (expectSize.height > textViewSize.height) {
            while (sizeThatFits(CGSize(width: fixedWidth, height: CGFloat(MAXFLOAT))).height > textViewSize.height) {
                expectFont = textFont.withSize(font!.pointSize - 1)
                font = expectFont
            }
        }
    }
    
    private func setMinimumFontSize() {
        if contentSize.height > frame.height {
            guard let textFont = font else {
                return
            }
            font = textFont.withSize(textFont.pointSize - 0.2)
            sizeToFit()
                        
            setMinimumFontSize()
        }
    }
    
    func isEmpty() -> Bool{
        if text == placeholderText {
            return true
        }
        return false
    }
    
    private func setup() {
        text = placeholderText
        
        isEditable = false
        showsVerticalScrollIndicator = false
            
        backgroundColor = .clear
        
        font = UIFont(name: "AvenirNext-Bold", size: StyleGuide.getFontSizeRelativeToScreen(baseSize: 32))
        textColor = .white
        textAlignment = .center
    }
}

