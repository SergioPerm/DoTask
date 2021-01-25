//
//  TaskListViewController.swift
//  Tasker
//
//  Created by kluv on 27/09/2020.
//  Copyright © 2020 itotdel. All rights reserved.
//

import UIKit

class TaskListViewController: UIViewController, PresentableController {
    
    var presentableControllerViewType: PresentableControllerViewType
    var router: RouterType?
    var persistentType: PersistentViewControllerType?
    
    // MARK: - Dependencies
    public let viewModel: TaskListViewModel
    
    private var tableView: UITableView!
    
    var slideMenu: SlideMenuViewType?
    private var withSlideMenu: Bool
    
    var editTaskAction: ((_ taskUID: String?, _ shortcutUID: String?) ->  Void)?
    
    var shortcutFilter: String? {
        didSet {
            applyShortcutFilter()
        }
    }
    
    init(viewModel: TaskListViewModel, router: RouterType?, presentableControllerViewType: PresentableControllerViewType, persistentType: PersistentViewControllerType? = nil) {
        self.viewModel = viewModel
        self.router = router
        self.presentableControllerViewType = presentableControllerViewType
        self.withSlideMenu = true
        self.persistentType = persistentType
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.viewWillAppear(view: self)
        
        //viewModel.clearData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewModel.viewWillDisappear()
    }
    
}

extension TaskListViewController {
    private func setupView() {
        
        if let navBar = self.navigationController?.navigationBar {
            if #available(iOS 13.0, *) {
                navBar.standardAppearance.backgroundColor = UIColor.white//UIColor.clear
                navBar.standardAppearance.backgroundEffect = nil
                navBar.standardAppearance.shadowImage = UIImage()
                navBar.standardAppearance.shadowColor = .clear
                navBar.standardAppearance.backgroundImage = UIImage()
            } else {
                // Fallback on earlier versions
                navBar.backgroundColor = .clear
                navBar.setBackgroundImage(UIImage(), for:.default)
                navBar.shadowImage = UIImage()
                navBar.layoutIfNeeded()
            }
        }
        
        setupNavigationBarTitle()
        
        //Menu btn
        let menuBtn = UIButton()
        menuBtn.addTarget(self, action: #selector(tapMenuAction(sender:)), for: .touchUpInside)
        menuBtn.tintImageWithColor(color: Color.blueColor.uiColor, image: UIImage(named: "menu"))
        
        let menuBarItem = UIBarButtonItem(customView: menuBtn)
        let currWidth = menuBarItem.customView?.widthAnchor.constraint(equalToConstant: 25)
        currWidth?.isActive = true
        let currHeight = menuBarItem.customView?.heightAnchor.constraint(equalToConstant: 25)
        currHeight?.isActive = true
        
        self.navigationItem.leftBarButtonItem = menuBarItem
        
        tableView = UITableView(frame: .zero, style: .grouped)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(TaskListTableViewCell.self, forCellReuseIdentifier: TaskListTableViewCell.className)
        
        view.addSubview(tableView)
        
        tableView.frame = view.frame
        
        tableView.separatorStyle = .none
        tableView.rowHeight = 75
        tableView.backgroundColor = .white
        tableView.showsVerticalScrollIndicator = false
        
        let btn = TaskAddButton {
            if let editAction = self.editTaskAction {
                editAction(nil, self.shortcutFilter)
            }
        }
        view.insertSubview(btn, aboveSubview: tableView)
        

        self.navigationController?.view.layer.masksToBounds = false
        self.navigationController?.view.layer.shadowColor = Color.blueColor.uiColor.cgColor
        self.navigationController?.view.layer.shadowOpacity = 0.1
        self.navigationController?.view.layer.shadowOffset = CGSize(width: -4, height: 2)
 

        self.navigationController?.view.layer.shadowPath = UIBezierPath(rect: (self.navigationController?.view.bounds)!).cgPath
    }
    
    private func setupNavigationBarTitle() {
        
        var isMainTaskList = false
        if let shortcutFilter = shortcutFilter {
            isMainTaskList = shortcutFilter.isEmpty
        } else {
            isMainTaskList = true
        }
        
        let navLabel = UILabel()
        
        if isMainTaskList {
            let navTitle = NSMutableAttributedString(string: "Task", attributes:[
                                                        NSAttributedString.Key.foregroundColor: Color.blueColor.uiColor,
                                                        NSAttributedString.Key.font: Font.mainTitle.uiFont])
            
            navTitle.append(NSMutableAttributedString(string: "er", attributes:[
                                                        NSAttributedString.Key.font: Font.mainTitle2.uiFont,
                                                        NSAttributedString.Key.foregroundColor: Color.pinkColor.uiColor]))
            
            navLabel.attributedText = navTitle
        } else {
            guard let shortcutFilter = shortcutFilter else { return }
            guard let shortcut = viewModel.getShortcut(shortcutUID: shortcutFilter) else { return }
            
            let navTitle = NSMutableAttributedString(string: shortcut.name, attributes:[
                                                        NSAttributedString.Key.foregroundColor: UIColor(hexString: shortcut.color),
                                                        NSAttributedString.Key.font: UIFont(name: "AvenirNext-Bold", size: 21) ?? UIFont.systemFont(ofSize: 21)])
            
            navLabel.attributedText = navTitle
        }
        
        self.navigationItem.titleView = navLabel
    }
    
    private func configureCell(cell: TaskListTableViewCell, taskModel: Task) {
        cell.doneHandler = doneCellAction(_:)
        cell.taskModel = taskModel
    }
    
    private func doneCellAction(_ taskIdentifier: String) {
        viewModel.setDoneForTask(with: taskIdentifier)
    }
    
    private func applyShortcutFilter() {
        viewModel.applyShortcutFilter(shortcutFilter: shortcutFilter)
        viewModel.reloadData()
        setupNavigationBarTitle()
    }
    
    // MARK: Actions
    
    @objc private func addTaskAction(sender: UIView) {
        
    }
    
    @objc private func tapMenuAction(sender: UIBarButtonItem) {
        slideMenu?.toggleMenu()
    }
}

// MARK: UITableViewDataSource

extension TaskListViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        viewModel.tableViewItems.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let dailyModel = viewModel.tableViewItems[section]
        return dailyModel.tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TaskListTableViewCell.className) as! TaskListTableViewCell
        let taskModel = viewModel.tableViewItems[indexPath.section].tasks[indexPath.row]
        configureCell(cell: cell, taskModel: taskModel)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerName = viewModel.tableViewItems[section].dailyName else { return UIView() }
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 50))
  
        let label = UILabel()
        label.frame = CGRect.init(x: 0, y: 5, width: headerView.frame.width, height: headerView.frame.height-20)
        label.text = "  \(headerName)"
        label.font = Font.tableHeader.uiFont//UIFont(name: "HelveticaNeue-Bold", size: 35)// my custom font
        
        label.textColor = #colorLiteral(red: 0.2392156863, green: 0.6235294118, blue: 0.9960784314, alpha: 1)
        label.backgroundColor = UIColor.white
        
        //headerView.backgroundColor = UIColor.white
        headerView.addSubview(label)
        
        let mask = CAGradientLayer()
        mask.startPoint = CGPoint(x: 0.5, y: 0.0)
        mask.endPoint = CGPoint(x: 0.5, y: 1.0)
        mask.colors = [UIColor.white.withAlphaComponent(1.0).cgColor,UIColor.white.withAlphaComponent(0.5).cgColor,UIColor.white.withAlphaComponent(0.0).cgColor]
        mask.locations = [0.0, 0.5, 1.0]
        mask.frame = CGRect(x: 0, y: 35, width: tableView.frame.width, height: 15)
        //gradientView.layer.mask = mask
        headerView.layer.insertSublayer(mask, at: 0)
        
        let topLayer = CAShapeLayer()
        topLayer.backgroundColor = UIColor.white.cgColor
        topLayer.frame = CGRect(x: 0, y: 0, width: tableView.frame.width, height: 5)
        
        headerView.layer.insertSublayer(topLayer, at: 0)
        
        //headerView.addSubview(gradientView)
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
}

// MARK: UITableViewDelegate

extension TaskListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! TaskListTableViewCell
        cell.animateSelection {
            self.viewModel.tableViewDidSelectRow(at: indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let contextItemDelete = UIContextualAction(style: .destructive, title: "") { [weak self] (contextualAction, view, completion) in
            self?.viewModel.deleteTask(at: indexPath)
            completion(true)
        }
        contextItemDelete.backgroundColor = .white
        
        if let removeImage =  UIImage(named: "recycle")?.cgImage {
            contextItemDelete.image = ImageWithoutRender(cgImage: removeImage, scale: UIScreen.main.nativeScale, orientation: .up)
        }
        
        let configuration = UISwipeActionsConfiguration(actions: [contextItemDelete])
        
        return configuration
    }
    
    func tableView(_ tableView: UITableView, willBeginEditingRowAt indexPath: IndexPath) {
        //solve gesture conflicts for slide menu
        slideMenu?.enabled = false
    }
    
    func tableView(_ tableView: UITableView, didEndEditingRowAt indexPath: IndexPath?) {
        //solve gesture conflicts for slide menu
        slideMenu?.enabled = true
    }
}

// MARK: TaskListView

extension TaskListViewController: TaskListView {
    func editTask(taskModel: Task) {
        if let editAction = editTaskAction {
            editAction(taskModel.uid, nil)
        }
    }
    
    func tableViewSectionInsert(at indexSet: IndexSet) {
        tableView.insertSections(indexSet, with: .left)
    }
    
    func tableViewSectionDelete(at indexSet: IndexSet) {
        tableView.deleteSections(indexSet, with: .left)
    }
    
    func tableViewReload() {
        tableView.reloadData()
    }
    
    func tableViewBeginUpdates() {
        tableView.beginUpdates()
    }
    
    func tableViewInsertRow(at newIndexPath: IndexPath) {
        tableView.insertRows(at: [newIndexPath], with: .right)
    }
    
    func tableViewDeleteRow(at indexPath: IndexPath) {
        tableView.deleteRows(at: [indexPath], with: .left)
    }
    
    func tableViewUpdateRow(at indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! TaskListTableViewCell
        let taskModel = viewModel.taskModelForIndexPath(indexPath: indexPath)
        configureCell(cell: cell, taskModel: taskModel)
    }
    
    func tableViewEndUpdates() {
        tableView.endUpdates()
    }
    
}

// MARK: MenuParentControllerType

extension TaskListViewController: MenuParentControllerType {
    func willMenuExpand() {
        tableView.isUserInteractionEnabled = false
    }
    
    func didMenuCollapse() {
        tableView.isUserInteractionEnabled = true
    }
    
    func getView() -> UIView {
        if let navVC = navigationController {
            return navVC.view
        }
        return view
    }
}
