//
//  SpeechTextInfo.swift
//  DoTask
//
//  Created by KLuV on 07.03.2021.
//  Copyright © 2021 itotdel. All rights reserved.
//

import UIKit

class SpeechTextInfo: LocalizableLabel {
    override init() {
        super.init()
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

extension SpeechTextInfo {
    private func setup() {
        font = FontFactory.AvenirNext.of(size: StyleGuide.getSizeRelativeToScreenWidth(baseSize: 14))
        textColor = .white
        textAlignment = .center
        localizableString = LocalizableStringResource(stringResource: R.string.localizable.release_TO_SAVE)
        
        translatesAutoresizingMaskIntoConstraints = false
    }
}
