//
//  PresentableController.swift
//  Tasker
//
//  Created by kluv on 22/11/2020.
//  Copyright © 2020 itotdel. All rights reserved.
//

import UIKit

enum PresentableControllerViewType {
    case menuViewController
    case modalViewController
    case navigationStackController
    case systemModalController
}

protocol PresentableController: UIViewController {
    var presentableControllerViewType: PresentableControllerViewType { get set }
    var presenter: PresenterController? { get set }
}

extension PresentableController where Self: UIViewController {
    func getNavigationController() -> UINavigationController? {
        return navigationController ?? nil
    }
}
