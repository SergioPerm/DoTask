//
//  LeftMenuViewController.swift
//  Tasker
//
//  Created by kluv on 29/10/2020.
//  Copyright © 2020 itotdel. All rights reserved.
//

import UIKit

protocol SlideMenuHandlers: class {
    var openSettingsHandler: (() -> Void)? { get set }
}

protocol SlideMenuViewType: class {
    var parentController: MenuParentControllerType? { get set }
    var enabled: Bool { get set }
    
    func toggleMenu()
    func presentMenu()
}

protocol MenuParentControllerType: class {
    func willMenuExpand()
    func didMenuCollapse()
    func getView() -> UIView
}

class MenuViewController: UIViewController, PresentableController, SlideMenuHandlers, SlideMenuViewType {
    
    var presentableControllerViewType: PresentableControllerViewType
    var presenter: PresenterController?
    
    // MARK: Menu properties
    private var swipeRecognizer: UIPanGestureRecognizer?
    
    enum SlideOutMenuState {
      case menuCollapsed
      case menuExpanded
    }
    
    private var currentState: SlideOutMenuState = .menuCollapsed
    private var isMove = false
    
    private var tableView: UITableView!
    
    // MARK: SlideMenuHandlers
    var openSettingsHandler: (() -> Void)?
        
    // MARK: Init
    
    init(presenter: PresenterController?, presentableControllerViewType: PresentableControllerViewType) {
        self.presenter = presenter
        self.presentableControllerViewType = presentableControllerViewType
        self.enabled = true
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: View life-cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("disappear")
    }
    
    // MARK: SlideMenuViewType
    
    var enabled: Bool {
        didSet {
            swipeRecognizer?.isEnabled = enabled
        }
    }
    
    weak var parentController: MenuParentControllerType? {
        didSet {
            swipeRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
            
            if let swipeRecognizer = swipeRecognizer {
                swipeRecognizer.delegate = self
                parentController?.getView().addGestureRecognizer(swipeRecognizer)
            }
        }
    }
    
    func toggleMenu() {
        let notAlreadyExpanded = currentState != .menuExpanded
        animateLeftmenu(shouldExpand: notAlreadyExpanded)
    }
    
    func presentMenu() {
        configureMenuViewController()
        toggleMenu()
    }
}

// MARK: Setup view

extension MenuViewController {
    private func setup() {
        view.backgroundColor = StyleGuide.SlideMenu.viewBGColor
        
        tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(TopMenuTableViewCell.self, forCellReuseIdentifier: TopMenuTableViewCell.className)
        tableView.register(MainMenuTableViewCell.self, forCellReuseIdentifier: MainMenuTableViewCell.className)
        tableView.register(CreateShortcutMenuTableViewCell.self, forCellReuseIdentifier: CreateShortcutMenuTableViewCell.className)
        tableView.register(ShortcutMenuTableViewCell.self, forCellReuseIdentifier: ShortcutMenuTableViewCell.className)
        
        
        view.addSubview(tableView)
        
        tableView.frame = CGRect(origin: view.frame.origin, size: CGSize(width: view.frame.width * StyleGuide.SlideMenu.ratioToScreenExpandWidth, height: view.frame.height))
         
        tableView.separatorStyle = .none
        tableView.rowHeight = 40
        tableView.backgroundColor = .white
    }
}

// MARK: Menu confgigure

extension MenuViewController {
    private func configureMenuViewController() {
        if currentState == .menuCollapsed {
            presenter?.push(vc: self, completion: nil)
        }
    }
            
    private func animateLeftmenu(shouldExpand: Bool) {
        if shouldExpand {
            currentState = .menuExpanded
            parentController?.willMenuExpand()
            animateCenterPanel(targetPosition: view.frame.width * StyleGuide.SlideMenu.ratioToScreenExpandWidth) { _ in
                self.isMove = !self.isMove
            }
        } else {
            animateCenterPanel(targetPosition: 0) { _ in
                self.currentState = .menuCollapsed
                self.parentController?.didMenuCollapse()
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
                        self.parentController?.getView().frame.origin.x = targetPosition
        }, completion: completion)
    }
}

// MARK: Actions

extension MenuViewController {
    
    // MARK: Swipe action
    @objc private func handlePanGesture(_ recognizer: UIPanGestureRecognizer) {
        let gestureIsDraggingFromLeftToRight = recognizer.velocity(in: parentController?.getView()).x > 0
    
        let offsetToExpand = view.frame.width * StyleGuide.SlideMenu.ratioToScreenOffsetToExpand
        
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
                
                if rView.frame.origin.x > offsetToExpand {
                    draggingDisctance *= 1.5
                }
                
                rView.center.x = rView.center.x + draggingDisctance
                recognizer.setTranslation(CGPoint.zero, in: view)

            }
            
        case .ended:
            if let rView = recognizer.view {
                let hasMoveGreaterThanHalfway = rView.frame.origin.x > offsetToExpand
                
                animateLeftmenu(shouldExpand: hasMoveGreaterThanHalfway)
            }
            
        default:
            break
            
        }
        
    }
    
    // MARK: Settings action
    @objc private func menuSettingsAction(sender: UIBarButtonItem) {
        if let settingsAction = openSettingsHandler {
            settingsAction()
        }
    }
}

// MARK: UIGestureRecognizerDelegate
extension MenuViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {

        //solve gesture conflicts for edit tableviewcell
        let panGesture = gestureRecognizer as! UIPanGestureRecognizer
        let gestureIsDraggingFromRightToLeft = panGesture.velocity(in: parentController?.getView()).x < 0
        
        if gestureIsDraggingFromRightToLeft && currentState == .menuCollapsed {
            return true
        }

        return false
    }
}

// MARK: UITableViewDataSource

extension MenuViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else if section == 1 {
            return 2
        } else {
            return 7
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: TopMenuTableViewCell.className, for: indexPath) as! TopMenuTableViewCell
            
            return cell
        } else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: MainMenuTableViewCell.className, for: indexPath) as! MainMenuTableViewCell
            
            if indexPath.row == 0 {
                cell.icon.image = UIImage(named: "colorFlat")
                cell.title.text = "Task list"
            } else {
                cell.icon.image = UIImage(named: "diary")
                cell.title.text = "Task diary"
            }
            
            return cell
        } else {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: CreateShortcutMenuTableViewCell.className, for: indexPath) as! CreateShortcutMenuTableViewCell
                
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: ShortcutMenuTableViewCell.className, for: indexPath) as! ShortcutMenuTableViewCell
                
                if indexPath.row == 1 {
                    cell.shapeView.backgroundColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
                    cell.title.text = "Work"
                } else if indexPath.row == 2 {
                    cell.shapeView.backgroundColor = #colorLiteral(red: 0.5725490451, green: 0, blue: 0.2313725501, alpha: 1)
                    cell.title.text = "Travel"
                } else if indexPath.row == 3 {
                    cell.shapeView.backgroundColor = #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1)
                    cell.title.text = "Common"
                } else if indexPath.row == 4 {
                    cell.shapeView.backgroundColor = #colorLiteral(red: 0.9764705896, green: 0.751592625, blue: 0.02233285838, alpha: 1)
                    cell.title.text = "Relationships"
                } else if indexPath.row == 5 {
                    cell.shapeView.backgroundColor = #colorLiteral(red: 0.9501484036, green: 0.3136262298, blue: 0.3514909744, alpha: 1)
                    cell.title.text = "Sport"
                } else if indexPath.row == 6 {
                    cell.shapeView.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
                    cell.title.text = "Health"
                }
                
                return cell
            }
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 1 {
            let view = UIView()
            view.frame = CGRect(x: 0, y: 0, width: 0, height: 30)
            return view
        } else if section == 2 {
            let view = UIView()
            view.frame = CGRect(x: 0, y: 0, width: 0, height: 10)
            return view
        } else {
            return nil
        }
    }
}

extension MenuViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 1{
            return 50
        }
        return 40
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 1 {
            return 30
        } else if section == 2 {
            return 10
        } else {
            return CGFloat.leastNormalMagnitude
        }
    }
}
