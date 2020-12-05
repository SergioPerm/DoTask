//
//  SlideMenuAssembly.swift
//  Tasker
//
//  Created by KLuV on 03.12.2020.
//  Copyright © 2020 itotdel. All rights reserved.
//

import Foundation

class SlideMenuAssembly {
    static func createInstance(presenter: PresenterController?) -> MenuViewController {
        return MenuViewController.init(presenter: presenter, presentableControllerViewType: .menuViewController)
    }
}
