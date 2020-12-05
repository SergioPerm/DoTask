//
//  ContainerPresenterController.swift
//  Tasker
//
//  Created by kluv on 22/11/2020.
//  Copyright © 2020 itotdel. All rights reserved.
//

import UIKit

class ContainerPresenterController: UIViewController, PresenterController {
    var presentableControllers: [PresentableController?] = []
    var completions: [UIViewController: () -> Void] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func pop(vc: PresentableController) {
        presentableControllers = presentableControllers.filter { $0! != vc as UIViewController }
                
        switch vc.presentableControllerViewType {
        case .menuViewController:
            vc.remove(withDimmedBack: false)
        case .modalViewController:
            vc.remove(withDimmedBack: true)
        case .navigationStackController:
            if let presentableControllerNavBar = getNavigationController(from: vc) {
                presentableControllerNavBar.popViewController(animated: true)
            }
        }
        
        runCompletion(for: vc)
    }
    
    func push(vc: PresentableController, completion: (() -> Void)? = nil) {
        presentableControllers.append(vc)
        
        if let completion = completion {
            completions[vc] = completion
        }
        
        switch vc.presentableControllerViewType {
        case .menuViewController:
            add(vc, atIndex: 0)
        case .modalViewController:
            add(vc, withDimmedBack: true)
        case .navigationStackController:
            if let presentableControllerNavBar = getNavigationController(from: vc) {
                presentableControllerNavBar.pushViewController(vc, animated: false)
                presentableControllerNavBar.delegate = self
                add(presentableControllerNavBar)
            } else {
                //Instantiate first navigation controller
                let navigationController = UINavigationController(rootViewController: vc)
                navigationController.delegate = self
                add(navigationController)
            }
        }
    }
}

extension ContainerPresenterController {
    private func getNavigationController(from vc: PresentableController) -> UINavigationController? {
        return presentableControllers.compactMap { $0?.getNavigationController() }.last
    }
    
    private func runCompletion(for controller: UIViewController) {
        guard let completion = completions[controller] else { return }
        completion()
        completions.removeValue(forKey: controller)
    }
}

extension ContainerPresenterController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        // Ensure the view controller is popping
        guard let poppedViewController = navigationController.transitionCoordinator?.viewController(forKey: .from),
            !navigationController.viewControllers.contains(poppedViewController) else {
            return
        }
        
        if let presentableController = poppedViewController as? PresentableController {
            pop(vc: presentableController)
        }
    }
}
