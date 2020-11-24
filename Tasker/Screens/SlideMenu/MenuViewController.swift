//
//  LeftMenuViewController.swift
//  Tasker
//
//  Created by kluv on 29/10/2020.
//  Copyright © 2020 itotdel. All rights reserved.
//

import UIKit

protocol SlideMenuHandlers {
    var openSettingsHandler: (() -> Void)? { get set }
}

protocol SlideMenuViewType {
    var parentController: UIViewController? { get set }
    
    func toggleMenu()
    func presentMenu()
}

class MenuViewController: UIViewController, PresentableController, SlideMenuHandlers, SlideMenuViewType {
    var presentableControllerViewType: PresentableControllerViewType
    var presenter: PresenterController?
    weak var parentController: UIViewController? {
        didSet {
            let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
            parentController?.navigationController?.view.addGestureRecognizer(panGestureRecognizer)
        }
    }
    
//    weak var delegate: MenuViewControllerDelegate? {
//        didSet {
//            _ = UINavigationController(rootViewController: self)
//            let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
//            delegate?.navigationController?.view.addGestureRecognizer(panGestureRecognizer)
//        }
//    }
    
    enum SlideOutMenuState {
      case menuCollapsed
      case menuExpanded
    }
    
    var currentState: SlideOutMenuState = .menuCollapsed
    
    private lazy var screenHalfQuarterWidth: CGFloat = {
        return view.bounds.width/8
    }()
    private lazy var offsetToMenuExpand: CGFloat = {
        return screenHalfQuarterWidth*2
    }()
    
    var isMove = false
    
    var menuNavigationController: UINavigationController!
    
    var openSettingsHandler: (() -> Void)?
    
    init(presenter: PresenterController?, presentableControllerViewType: PresentableControllerViewType) {
        self.presenter = presenter
        self.presentableControllerViewType = presentableControllerViewType
                
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("disappear")
    }
    
    func toggleMenu() {
        let notAlreadyExpanded = currentState != .menuExpanded
        
        //        if notAlreadyExpanded {
        //            configureMenuViewController()
        //        }
        
        animateLeftmenu(shouldExpand: notAlreadyExpanded)
    }
    
    func presentMenu() {
        configureMenuViewController()
        toggleMenu()
    }

}

extension MenuViewController {
    private func setup() {
        
        view.backgroundColor = UIColor.white
        
        let btn = UIButton()
        btn.tintImageWithColor(color: Color.blueColor.uiColor, image: UIImage(named: "settings"))
        
        let globalSafeFrame = UIView.globalSafeAreaFrame
        
        btn.frame = CGRect(x: 25, y: globalSafeFrame.origin.y + 10, width: 25, height: 25)
        view.addSubview(btn)
        
        btn.addTarget(self, action: #selector(menuBtnAction(sender:)), for: .touchUpInside)
    
    }
    
    private func configureMenuViewController() {
        if currentState == .menuCollapsed {
            presenter?.push(vc: self, completion: nil)
        }
    }
            
    private func animateLeftmenu(shouldExpand: Bool) {
        
        if shouldExpand {
            currentState = .menuExpanded
            animateCenterPanel(targetPosition: screenHalfQuarterWidth*4) { _ in
                self.isMove = !self.isMove
            }
        } else {
            animateCenterPanel(targetPosition: 0) { _ in
                self.currentState = .menuCollapsed
                self.presenter?.pop(vc: self)
            }
        }
        
    }
    
    private func animateCenterPanel(targetPosition: CGFloat, completion: ((Bool) -> Void)? = nil) {
        
        let dampingRatio: CGFloat = targetPosition == 0 ? 1 : 0.6
        
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: dampingRatio,
                       initialSpringVelocity: 0,
                       options: .curveEaseInOut,
                       animations: {
                        self.parentController?.navigationController?.view.frame.origin.x = targetPosition
        }, completion: completion)
        
    }
                
    // MARK: Gesture recognizer
    @objc func handlePanGesture(_ recognizer: UIPanGestureRecognizer) {
        let gestureIsDraggingFromLeftToRight = recognizer.velocity(in: parentController?.view).x > 0
    
        switch recognizer.state {
        case .began:
            if gestureIsDraggingFromLeftToRight {
                configureMenuViewController()
            }
        
        case .changed:
            if let rView = recognizer.view {
                                
                let centerX = view.bounds.width/2
                var draggingDisctance = recognizer.translation(in: view).x
                let currentCenterX = rView.center.x
                
                //Only left menu
                if (currentCenterX + draggingDisctance) < centerX {
                    draggingDisctance -= ((currentCenterX + draggingDisctance) - centerX)
                }
                
                if rView.frame.origin.x > offsetToMenuExpand {
                    draggingDisctance *= 1.5
                }
                
                rView.center.x = rView.center.x + draggingDisctance
                recognizer.setTranslation(CGPoint.zero, in: view)

            }
            
        case .ended:
            if let rView = recognizer.view {
                let hasMoveGreaterThanHalfway = rView.frame.origin.x > offsetToMenuExpand
                
                animateLeftmenu(shouldExpand: hasMoveGreaterThanHalfway)
            }
            
        default:
            break
            
        }
        
    }
    
    @objc private func menuBtnAction(sender: UIBarButtonItem) {
        if let settingsAction = openSettingsHandler {
            settingsAction()
        }
    }
}

