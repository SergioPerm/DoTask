//
//  SettingsAssembly.swift
//  Tasker
//
//  Created by kluv on 24/11/2020.
//  Copyright © 2020 itotdel. All rights reserved.
//

import Foundation

class SettingsAssembly {
    static func createInstance(presenter: RouterType?) -> SettingsViewController {
        return SettingsViewController(presenter: presenter, presentableControllerViewType: .navigationStack)
    }
}
