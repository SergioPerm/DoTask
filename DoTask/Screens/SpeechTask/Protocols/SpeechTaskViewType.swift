//
//  SpeechTaskViewType.swift
//  DoTask
//
//  Created by Сергей Лепинин on 03.04.2021.
//  Copyright © 2021 itotdel. All rights reserved.
//

import UIKit

protocol SpeechTaskViewType: PresentableController {
    var longTapRecognizer: UILongPressGestureRecognizer? { get set }
    var shortcutUID: String? { get set }
    var taskDate: Date? { get set }
    
    var onDoNotAllowSpeech: (()->())? { get set }
}
