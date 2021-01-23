//
//  PresentableController.swift
//  Tasker
//
//  Created by kluv on 22/11/2020.
//  Copyright © 2020 itotdel. All rights reserved.
//

import UIKit

enum PresentableControllerViewType {
    case slideMenu
    case containerChild
    case navigationStack
    case systemPopoverModal
    case presentWithTransition
}

protocol PresentableController: UIViewController {
    var presentableControllerViewType: PresentableControllerViewType { get set }
    var router: RouterType? { get set }
}

extension PresentableController where Self: UIViewController {
    func getNavigationController() -> UINavigationController? {
        return navigationController ?? nil
    }
}
