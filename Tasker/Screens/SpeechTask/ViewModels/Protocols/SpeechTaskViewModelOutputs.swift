//
//  SpeechTaskViewModelOutputs.swift
//  Tasker
//
//  Created by KLuV on 09.03.2021.
//  Copyright © 2021 itotdel. All rights reserved.
//

import Foundation

protocol SpeechTaskViewModelOutputs {
    var speechTextChangeEvent: Event<String> { get }
    var volumeLevel: Event<Float> { get }
}
