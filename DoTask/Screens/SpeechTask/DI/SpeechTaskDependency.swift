//
//  SpeechTaskDependency.swift
//  DoTask
//
//  Created by Сергей Лепинин on 03.04.2021.
//  Copyright © 2021 itotdel. All rights reserved.
//

import Foundation
import DITranquillity

class SpeechTaskDependency: DIPart {
    static func load(container: DIContainer) {
        container.register(SpeechTaskViewModel.init(dataSource:))
            .as(SpeechTaskViewModelType.self)
        
        container.register{
            SpeechTaskViewController(viewModel: $0, router: $1, presentableControllerViewType: .presentWithTransition, persistentType: .none)
        }.as(SpeechTaskViewType.self)
    }
}
