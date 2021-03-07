//
//  SpeechText.swift
//  Tasker
//
//  Created by KLuV on 07.03.2021.
//  Copyright © 2021 itotdel. All rights reserved.
//

import UIKit

class SpeechText: UILabel {
    
    init() {
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
}

extension SpeechText {
    private func setup() {
        text = "Speak"
        
        numberOfLines = 5
        font = UIFont(name: "AvenirNext-Bold", size: StyleGuide.getFontSizeRelativeToScreen(baseSize: 32))
        textColor = .white
        textAlignment = .center
    }
}
