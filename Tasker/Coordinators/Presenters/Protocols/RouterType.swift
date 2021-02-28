//
//  PresenterController.swift
//  Tasker
//
//  Created by kluv on 22/11/2020.
//  Copyright © 2020 itotdel. All rights reserved.
//

import UIKit

protocol RouterType: class {
    var presentableControllers: [PresentableController?] { get set }
    var rootViewController: UIViewController { get set }
    
    func push(vc: PresentableController, completion: (() -> Void)?, transition: UIViewControllerTransitioningDelegate?)
    func pop(vc: PresentableController)
    
    func getPersistentViewController(persistentType: PersistentViewControllerType) -> UIViewController?
    
    func getLastViewFromRootNavigationStack() -> UIViewController?
}
