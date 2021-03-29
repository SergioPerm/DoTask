//
//  SpeechTextInfo.swift
//  DoTask
//
//  Created by KLuV on 07.03.2021.
//  Copyright © 2021 itotdel. All rights reserved.
//

import UIKit

class SpeechTextInfo: UILabel {

    init() {
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
}

extension SpeechTextInfo {
    private func setup() {
        text = "Release to quick save"
 
        font = UIFont(name: "AvenirNext", size: StyleGuide.getSizeRelativeToScreenWidth(baseSize: 14))
        textColor = .white
        textAlignment = .center
    }
}
