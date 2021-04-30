//
//  PresentableController.swift
//  DoTask
//
//  Created by kluv on 22/11/2020.
//  Copyright © 2020 itotdel. All rights reserved.
//

import UIKit

enum PersistentViewControllerType {
    case taskList
}

enum PresentableControllerViewType {
    case containerChild
    case mainNavigationStack
    case mainNavigationStackWithTransition
    case selfNavigationStack
    case selfNavigationStackWithTransition
    case systemPopoverModal
    case presentWithTransition
}

protocol PresentableController: UIViewController {
    var presentableControllerViewType: PresentableControllerViewType { get set }
    var router: RouterType? { get set }
    var persistentType: PersistentViewControllerType? { get set }
    
    func getNavigationController() -> UINavigationController?
}

extension PresentableController {
    func getNavigationController() -> UINavigationController? {
        return navigationController ?? nil
    }
}
