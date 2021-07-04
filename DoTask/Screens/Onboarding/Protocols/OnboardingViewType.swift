//
//  OnboardingViewType.swift
//  DoTask
//
//  Created by Sergio Lechini on 14.06.2021.
//  Copyright © 2021 itotdel. All rights reserved.
//

import Foundation

protocol OnboardingViewType: PresentableController {
    var onDoNotAllowNotify: (()->())? { get set }
    var onDoNotAllowSpeech: (()->())? { get set }
}
