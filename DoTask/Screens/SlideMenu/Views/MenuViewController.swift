//
//  LeftMenuViewController.swift
//  DoTask
//
//  Created by kluv on 29/10/2020.
//  Copyright © 2020 itotdel. All rights reserved.
//

import UIKit

protocol MenuParentControllerType: AnyObject {
    func willMenuExpand()
    func didMenuCollapse()
    func getView() -> UIView
}

class MenuViewController: UIViewController, PresentableController, SlideMenuViewType {

    var presentableControllerViewType: PresentableControllerViewType
    var router: RouterType?
    var persistentType: PersistentViewControllerType?
    
    private var viewModel: MenuViewModelType
    private var menuCellFactory: MenuCellFactoryType? {
        didSet {
            menuCellFactory?.cellTypes.forEach({ $0.register(tableView)})
        }
    }
    
    // MARK: Menu properties
    private var swipeRecognizer: UIPanGestureRecognizer?
    
    enum SlideOutMenuState {
      case menuCollapsed
      case menuExpanded
    }
    
    private var currentState: SlideOutMenuState = .menuCollapsed
    private var isMove = false
    
    private var swipeEnabled = true
    
    private var tableView: UITableView!
    
    private var selectedCell: UITableViewCell?
    
    // MARK: SlideMenuHandlers
    var openSettingsHandler: ((SlideMenuViewType?) -> Void)?
    var openTaskListHandler: ((SlideMenuViewType?, String?) -> Void)?
    var openTaskDiaryHandler: ((SlideMenuViewType?) -> Void)?
    var openDetailShortcutHandler: ((String?) -> Void)?
    
    // MARK: Init
    
    init(viewModel: MenuViewModel, presenter: RouterType?, presentableControllerViewType: PresentableControllerViewType) {
        self.viewModel = viewModel
        self.router = presenter
        self.presentableControllerViewType = presentableControllerViewType
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: View life-cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //start init screen
        if let taskListAction = openTaskListHandler {
            taskListAction(self, nil)
        }
        
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.inputs.shortcutTableView = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    // MARK: SlideMenuViewType
    
    var enabled: Bool {
        return currentState == .menuExpanded
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
}

// MARK: Setup view

extension MenuViewController {
    private func setup() {
        view.backgroundColor = R.color.menu.background()
                
        tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        
        menuCellFactory = MenuCellFactory()
        viewModel.inputs.createShortcutHandler = {
            if let openDetailShortcutAction = self.openDetailShortcutHandler {
                openDetailShortcutAction(nil)
            }
        }
        view.addSubview(tableView)
        
        tableView.frame = CGRect(origin: view.frame.origin, size: CGSize(width: view.frame.width * StyleGuide.SlideMenu.Sizes.RatioToScreenWidth.ratioToScreenExpandWidth, height: view.frame.height))
         
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.rowHeight = CGFloat(StyleGuide.SlideMenu.Sizes.midRowHeight)
        tableView.backgroundColor = .white
    }
}

// MARK: Menu confgigure

extension MenuViewController {
    private func animateLeftmenu(shouldExpand: Bool) {
        if shouldExpand {
            currentState = .menuExpanded
            parentController?.willMenuExpand()
            animateCenterPanel(targetPosition: view.frame.width * StyleGuide.SlideMenu.Sizes.RatioToScreenWidth.ratioToScreenExpandWidth) { _ in
                self.isMove = !self.isMove
            }
        } else {
            animateCenterPanel(targetPosition: 0) { _ in
                self.currentState = .menuCollapsed
                self.parentController?.didMenuCollapse()
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
        let offsetToExpand = view.frame.width * StyleGuide.SlideMenu.Sizes.RatioToScreenWidth.ratioToScreenOffsetToExpand
        let expandWidth = view.frame.width * StyleGuide.SlideMenu.Sizes.RatioToScreenWidth.ratioToScreenExpandWidth
        
        let draggingVelocityExpand: CGFloat = 1.5
        let draggingVelocityAfterExpand: CGFloat = 0.3
        
    
        switch recognizer.state {
        case .began:
            if currentState == .menuCollapsed {
                let location = recognizer.location(in: parentController?.getView())
                
                if location.x > (view.frame.width * 0.2) {
                    swipeEnabled = false
                } else {
                    swipeEnabled = true
                }
            } else {
                swipeEnabled = true
            }
        case .changed:
            if !swipeEnabled {
                return
            }
            
            if let rView = recognizer.view {
                                
                let centerX = view.bounds.width/2
                var draggingDisctance = recognizer.translation(in: view).x
                let currentCenterX = rView.center.x
                
                //Only left menu
                if (currentCenterX + draggingDisctance) < centerX {
                    draggingDisctance -= ((currentCenterX + draggingDisctance) - centerX)
                }
                
                if rView.frame.origin.x >= expandWidth{
                    draggingDisctance *= draggingVelocityAfterExpand
                } else if rView.frame.origin.x > offsetToExpand {
                    draggingDisctance *= draggingVelocityExpand
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
            settingsAction(self)
        }
    }
    
}

// MARK: UIGestureRecognizerDelegate
extension MenuViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        
        return false
    }
}

// MARK: UITableViewDataSource

extension MenuViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.outputs.tableSections[section].tableCells.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.outputs.tableSections.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cellFactory = menuCellFactory else {
            return UITableViewCell()
        }
        
        let cellViewModel = viewModel.outputs.tableSections[indexPath.section].tableCells[indexPath.row]
        
        return cellFactory.generateCell(viewModel: cellViewModel, tableView: tableView, for: indexPath)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerHeight = CGFloat(viewModel.outputs.tableSections[section].sectionHeight)
        
        let headerView = UIView()
        headerView.frame = CGRect(x: 0, y: 0, width: 0, height: headerHeight)
        
        return headerView
    }
}

// MARK: UITableViewDelegate

extension MenuViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(viewModel.outputs.tableSections[indexPath.section].tableCells[indexPath.row].rowHeight)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat(viewModel.outputs.tableSections[section].sectionHeight)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let taskListAction = openTaskListHandler,
              let taskDiaryAction = openTaskDiaryHandler else { return }

        viewModel.inputs.selectItem(for: indexPath)

        if let shortcutViewModel = viewModel.outputs.tableSections[indexPath.section].tableCells[indexPath.row] as? ShortcutMenuItemViewModel {

            taskListAction(self, shortcutViewModel.shortcut.uid)

        } else if let menuItemViewModel = viewModel.outputs.tableSections[indexPath.section].tableCells[indexPath.row] as? MenuItemViewModelMainType {

            switch menuItemViewModel.menuType {
            case .mainList:
                taskListAction(self, nil)
            case .diaryList:
                taskDiaryAction(self)
            }
        }
    }
        
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        if let shortcutViewModel = viewModel.outputs.tableSections[indexPath.section].tableCells[indexPath.row] as? ShortcutMenuItemViewModel {
            
            let shortcutUID = shortcutViewModel.shortcut.uid
            
            let contextEditShortcut = UIContextualAction(style: .normal, title: nil, handler: { (contextualAction, view, completion) in
                if let opendetailShoartcutAction = self.openDetailShortcutHandler {
                    opendetailShoartcutAction(shortcutUID)
                }
                completion(true)
            })
            
            if let editImage =  R.image.menu.edit()?.cgImage {
                contextEditShortcut.image = ImageWithoutRender(cgImage: editImage, scale: 1.2, orientation: .up)
            }
            
            contextEditShortcut.backgroundColor = .white
            
            let configuration = UISwipeActionsConfiguration(actions: [contextEditShortcut])
            configuration.performsFirstActionWithFullSwipe = false
            
            return configuration
        }
        
        return nil
    }
}

extension MenuViewController: ShortcutListTableViewType {
    func tableViewReload() {
        tableView.reloadData()
    }
    
    func tableViewBeginUpdates() {
        tableView.beginUpdates()
    }
    
    func tableViewEndUpdates() {
        tableView.endUpdates()
    }
    
    func tableViewInsertRow(at newIndexPath: IndexPath) {
        tableView.insertRows(at: [newIndexPath], with: .top)
    }
    
    func tableViewDeleteRow(at indexPath: IndexPath) {
        tableView.deleteRows(at: [indexPath], with: .bottom)
    }
    
    func tableViewUpdateRow(at indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? ShortcutMenuTableViewCell {
            cell.updateCell()
        }
    }
}

// MARK: CreateShortcutMenuTableViewCellDelegate
extension MenuViewController: CreateShortcutMenuTableViewCellDelegate {
    func createShortcutAction() {
        if let openDetailShortcutAction = openDetailShortcutHandler {
            openDetailShortcutAction(nil)
        }
    }
}
