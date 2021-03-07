//
//  SpeechTaskAssembly.swift
//  Tasker
//
//  Created by KLuV on 28.02.2021.
//  Copyright © 2021 itotdel. All rights reserved.
//

import UIKit

class SpeechTaskAssembly {
    static func createInstance(router: RouterType?, recognizer: UILongPressGestureRecognizer, shortcutFilter: String?) -> SpeechTaskViewController {
        let vc = SpeechTaskViewController(router: router, recognizer: recognizer,  presentableControllerViewType: .presentWithTransition)
        
        return vc
    }
}
