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
    
    // MARK: ViewModel
    private var viewModel: TaskListViewModelType {
        didSet {
            bindViewModel()
        }
    }
    
    // MARK: Properties
    
    private var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        
        return tableView
    }()
    
    var slideMenu: SlideMenuViewType?
    private var withSlideMenu: Bool
    
    var editTaskAction: ((_ taskUID: String?, _ shortcutUID: String?) ->  Void)?
        
    var filter: TaskListFilter? {
        didSet {
            applyFilters()
        }
    }
    
    // MARK: Initializers
    
    init(viewModel: TaskListViewModel, router: RouterType?, presentableControllerViewType: PresentableControllerViewType, persistentType: PersistentViewControllerType? = nil) {
        self.viewModel = viewModel
        self.router = router
        self.presentableControllerViewType = presentableControllerViewType
        self.withSlideMenu = true
        self.persistentType = persistentType
        
        super.init(nibName: nil, bundle: nil)
        
        viewModel.view = self
        bindViewModel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
}

extension TaskListViewController {
    
    // MARK: Bind ViewModel
    
    private func bindViewModel() {
        viewModel.outputs.shortcutFilter.bind { shortcutData in
            self.setupNavigationBarTitle(shortcutData: shortcutData)
        }
        
        viewModel.outputs.taskDiaryMode.bind { isTaskDiaryMode in
            self.setupNavigationBarTitle()
        }
    }
    
    // MARK: Setup
    
    private func setupView() {
        
        if let navBar = self.navigationController?.navigationBar {
            navBar.setFlatNavBar()
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
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(TaskListTableViewCell.self, forCellReuseIdentifier: TaskListTableViewCell.className)
        
        view.addSubview(tableView)
        
        tableView.frame = view.frame
        
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 600
        tableView.backgroundColor = .white
        tableView.showsVerticalScrollIndicator = false
        
        let btn = TaskAddButton {
            if let editAction = self.editTaskAction {
                editAction(nil, self.filter?.shortcutFilter)
            }
        }
        
        view.insertSubview(btn, aboveSubview: tableView)
    }
    
    private func setupNavigationBarTitle(shortcutData: ShortcutData? = nil) {
        
        var isMainTaskList = false
        if let shortcutFilter = filter?.shortcutFilter {
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
            
            guard let shortcutData = shortcutData else { return }
            guard let hexColor = shortcutData.colorHex, let shortcutTitle = shortcutData.title else { return }
            
            let shortcutColor = UIColor(hexString: hexColor)
            
            let navTitle = NSMutableAttributedString(string: shortcutTitle, attributes:[
                                                        NSAttributedString.Key.foregroundColor: shortcutColor,
                                                        NSAttributedString.Key.font: UIFont(name: "AvenirNext-Bold", size: 21) ?? UIFont.systemFont(ofSize: 21)])
            
            navLabel.attributedText = navTitle
        }
        
        self.navigationItem.titleView = navLabel
    }
                
    private func applyFilters() {
        guard let filter = filter else {
            return
        }
    
        viewModel.inputs.setFilter(filter: filter)
        tableView.reloadData()
    }
    
    // MARK: Actions
        
    @objc private func tapMenuAction(sender: UIBarButtonItem) {
        slideMenu?.toggleMenu()
    }
}

// MARK: UITableViewDataSource

extension TaskListViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        viewModel.outputs.periodItems.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.outputs.periodItems[section].tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TaskListTableViewCell.className) as! TaskListTableViewCell
        cell.viewModel = viewModel.outputs.periodItems[indexPath.section].tasks[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerName = viewModel.outputs.periodItems[section].title
        
        let headerFrame = CGRect(x: 0, y: 0, width: tableView.frame.width, height: StyleGuide.TaskList.Sizes.headerHeight)
        let headerView = TaskListTableHeaderView(title: headerName, frame: headerFrame)
                        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return StyleGuide.TaskList.Sizes.headerHeight
    }
    
}

// MARK: UITableViewDelegate

extension TaskListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! TaskListTableViewCell
        cell.animateSelection {
            self.viewModel.inputs.editTask(indexPath: indexPath)
        }
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
    func editTask(taskUID: String) {
        if let editAction = editTaskAction {
            editAction(taskUID, nil)
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
