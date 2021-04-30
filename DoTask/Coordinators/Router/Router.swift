//
//  ContainerPresenterController.swift
//  DoTask
//
//  Created by kluv on 22/11/2020.
//  Copyright © 2020 itotdel. All rights reserved.
//

import UIKit

class Router: NSObject, RouterType {

    var presentableControllers: [PresentableController?] = []
    var rootViewController: UIViewController
    
    private var completions: [UIViewController: () -> Void] = [:]
    private var transitions: [UIViewController: UIViewControllerTransitioningDelegate] = [:]
    
    private var persistentViewControllers: [PersistentViewControllerType: UIViewController] = [:]
    
    private var rootNavigationController: UINavigationController?
    
    init(rootViewController: UIViewController) {
        self.rootViewController = rootViewController
        super.init()
    }
    
    func pop(vc: PresentableController) {
            
        presentableControllers = presentableControllers.filter { $0! != vc as UIViewController }
                
        switch vc.presentableControllerViewType {
        case .containerChild:
            vc.remove(withDimmedBack: false)
        case .mainNavigationStack:
            //rootNavigationController?.popViewController(animated: true)
            if let presentableControllerNavBar = getNavigationController(from: vc) {
                presentableControllerNavBar.popViewController(animated: true)
            }
        case .mainNavigationStackWithTransition:
            if let presentableControllerNavBar = getNavigationController(from: vc) {
                presentableControllerNavBar.popViewController(animated: true)
            }
        case .selfNavigationStack:
            if let presentableControllerNavBar = getNavigationController(from: vc) {
                presentableControllerNavBar.popViewController(animated: true)
            }
        case .selfNavigationStackWithTransition:
            if let presentableControllerNavBar = getNavigationController(from: vc) {
                presentableControllerNavBar.popViewController(animated: true)
            }
        case .systemPopoverModal:
            vc.dismiss(animated: true, completion: nil)
        case .presentWithTransition:
            vc.dismiss(animated: true, completion: {
                self.transitions.removeValue(forKey: vc)
            })
        }
        
        runCompletion(for: vc)
    }
    
    func push(vc: PresentableController, completion: (() -> Void)? = nil, transition: UIViewControllerTransitioningDelegate? = nil) {
        
        if let persistentType = vc.persistentType {
            if vc == persistentViewControllers[persistentType] {
                return
            }
        }
        
        presentableControllers.append(vc)
        
        if let completion = completion {
            completions[vc] = completion
        }
        
        if let transition = transition {
            transitions[vc] = transition
        }
                        
        switch vc.presentableControllerViewType {
        case .containerChild:
            rootViewController.add(vc, atIndex: 0)
        case .mainNavigationStack:
            if let presentableControllerNavBar = getNavigationController(from: vc) {
                presentableControllerNavBar.pushViewController(vc, animated: false)
                presentableControllerNavBar.delegate = self
                rootViewController.add(presentableControllerNavBar)
            } else {
                //Instantiate first navigation controller
                rootNavigationController = UINavigationController(rootViewController: vc)
                
                if let rootNavigationController = rootNavigationController {
                    rootNavigationController.delegate = self
                    rootViewController.add(rootNavigationController)
                }
            }
        case .mainNavigationStackWithTransition:
            if let presentableControllerNavBar = getNavigationController(from: vc) {
                presentableControllerNavBar.pushViewController(vc, animated: true)
                presentableControllerNavBar.delegate = self
                rootViewController.add(presentableControllerNavBar)
            } else {
                //Instantiate first navigation controller
                let navigationController = UINavigationController(rootViewController: vc)
                navigationController.delegate = self
                rootViewController.add(navigationController)
            }
        case .selfNavigationStack:
            if let presentableControllerNavBar = getNavigationController(from: vc) {
                presentableControllerNavBar.pushViewController(vc, animated: true)
                //presentableControllerNavBar.delegate = self
            } else {
                //Instantiate first navigation controller
                let navigationController = UINavigationController(rootViewController: vc)
                //navigationController.delegate = self
                rootViewController.add(navigationController)
            }
        case .selfNavigationStackWithTransition:
            if let presentableControllerNavBar = getNavigationController(from: vc) {
                if let transitionDelegate = transitions[vc] {
                    vc.transitioningDelegate = transitionDelegate
                }
                presentableControllerNavBar.pushViewController(vc, animated: true)
                presentableControllerNavBar.delegate = self
            } else {
                //Instantiate first navigation controller
                let navigationController = UINavigationController(rootViewController: vc)
                navigationController.delegate = self
                rootViewController.add(navigationController)
            }
        case .presentWithTransition:
            vc.modalPresentationStyle = .custom
            
            if let transitionDelegate = transitions[vc] {
                vc.transitioningDelegate = transitionDelegate
            }
            
            let rootVC = rootViewController.presentedViewController ?? rootViewController
            
            rootVC.present(vc, animated: true, completion: nil)
        case .systemPopoverModal:
            rootViewController.modalPresentationStyle = .overFullScreen
            rootViewController.present(vc, animated: true, completion: nil)
        }
        
        if let persistentType = vc.persistentType {
            persistentViewControllers[persistentType] = vc
        }
    }
    
    func getLastViewFromRootNavigationStack() -> UIViewController? {
        if let navigationController = rootNavigationController {
            return navigationController.visibleViewController
        }
        return nil
    }
    
    func getPersistentViewController(persistentType: PersistentViewControllerType) -> UIViewController? {
        return persistentViewControllers[persistentType]
    }
}

extension Router {
    private func getNavigationController(from vc: PresentableController) -> UINavigationController? {
        return presentableControllers.compactMap {
            $0?.getNavigationController()
        }.last
    }
    
    private func runCompletion(for controller: UIViewController) {
        guard let completion = completions[controller] else { return }
        completion()
        completions.removeValue(forKey: controller)
    }
}

extension Router: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        // Ensure the view controller is popping
//        guard let poppedViewController = navigationController.transitionCoordinator?.viewController(forKey: .from),
//            !navigationController.viewControllers.contains(poppedViewController) else {
//            return
//        }
//
//        if let presentableController = poppedViewController as? PresentableController {
//            pop(vc: presentableController)
//        }
    }
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        return transitions[toVC]?.animationController?(forPresented: toVC, presenting: toVC, source: fromVC)
    }
}
