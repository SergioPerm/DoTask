//
//  SpeechTaskAssembly.swift
//  DoTask
//
//  Created by KLuV on 28.02.2021.
//  Copyright © 2021 itotdel. All rights reserved.
//

import UIKit

class SpeechTaskAssembly {
    static func createInstance(router: RouterType?, recognizer: UILongPressGestureRecognizer, shortcutFilter: String?) -> SpeechTaskViewController {
        
        let dataSource = TaskListDataSourceCoreData(context: CoreDataService.shared.context, shortcutFilter: nil)
        let viewModel = SpeechTaskViewModel(dataSource: dataSource)
        
        let vc = SpeechTaskViewController(viewModel: viewModel, router: router, recognizer: recognizer,  presentableControllerViewType: .presentWithTransition)
        
        return vc
    }
}
