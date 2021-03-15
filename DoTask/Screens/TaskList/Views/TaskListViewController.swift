//
//  TaskListViewController.swift
//  DoTask
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
    
    private var taskListCellFactory: TaskListCellFactoryType? {
        didSet {
            taskListCellFactory?.cellTypes.forEach({ $0.register(tableView)})
        }
    }
    
    private var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        return tableView
    }()
    
    private var calendarView: CalendarCollectionView = {
        let calendarView = CalendarCollectionView(date: Date())
        calendarView.translatesAutoresizingMaskIntoConstraints = false
        
        return calendarView
    }()
    
    private var navBarTitle: TaskListNavBarTitle?
    
    private var calendarTopConstraint: NSLayoutConstraint = NSLayoutConstraint()
    private var calendarTopConstraintMargin: CGFloat = 0
    
    var slideMenu: SlideMenuViewType?
    private var withSlideMenu: Bool
    
    var editTaskAction: ((_ taskUID: String?, _ shortcutUID: String?, _ taskDate: Date?) ->  Void)?
    //var openCalendarTaskListAction: ((_ menu: SlideMenuViewType?) -> Void)?
    var speechTaskAction: ((_ recognizer: UILongPressGestureRecognizer, _ shortcutUID: String?, _ taskDate: Date?) ->  Void)?
        
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
        viewModel.outputs.shortcutFilter.bind { [weak self] shortcut in
            self?.navBarTitle?.setShortcut(shortcut: shortcut)
        }
        
        viewModel.outputs.taskListMode.bind { [weak self] mode in
            guard let strongSelf = self else { return }
                        
            if mode == .calendar {
                strongSelf.calendarTopConstraint.constant = strongSelf.calendarTopConstraintMargin
                strongSelf.calendarView.scrollToDate()
            } else {

                strongSelf.calendarTopConstraint.constant = -strongSelf.calendarView.frame.height
            }
                      
            strongSelf.navBarTitle?.setTaskListMode(taskListMode: mode)
            
            if strongSelf.isViewLoaded {
                UIView.animate(withDuration: 0.3,
                               delay: 0.0,
                               usingSpringWithDamping: 0.7,
                               initialSpringVelocity: 5,
                               options: .curveEaseInOut) {
                    strongSelf.view.layoutIfNeeded()
                } completion: { (finished) in
                    
                }
            }
        }
        
        viewModel.outputs.calendarMonth.bind { [weak self] monthName in
            if let monthName = monthName {
                self?.navBarTitle?.showMonth(monthName: monthName)
            }
        }
    }
    
    // MARK: Setup
    
    private func setupView() {
        
        calendarView.viewModel = viewModel.outputs.calendarViewModel
        view.addSubview(calendarView)
        
        // TableView
        tableView.dataSource = self
        tableView.delegate = self
        //tableView.register(TaskListTableViewCell.self, forCellReuseIdentifier: TaskListTableViewCell.className)
        
        view.addSubview(tableView)
        
        tableView.frame = view.frame
        
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 600
        tableView.backgroundColor = .white
        tableView.showsVerticalScrollIndicator = false
        tableView.sectionFooterHeight = 0

        
        taskListCellFactory = TaskListCellFactory()
  
        let addBtn = TaskAddButton {
            if let editAction = self.editTaskAction {
                if self.viewModel.outputs.taskListMode.value == .calendar {
                    editAction(nil, self.filter?.shortcutFilter, self.viewModel.outputs.calendarSelectedDate)
                } else {
                    editAction(nil, self.filter?.shortcutFilter, Date())
                }
            }
        } onLongTapAction: { recognizer in
            if let speechAction = self.speechTaskAction {
                speechAction(recognizer, nil, nil)
            }
        }
        
        view.insertSubview(addBtn, aboveSubview: tableView)

        setupConstraints()
        setupNavigationBar()
        
        navBarTitle?.showMainTitle()
    }
    
    private func setupNavigationBar() {
        
        guard let navBar = self.navigationController?.navigationBar else { return }
        navBar.setFlatNavBar()
        
        //Menu btn
        let menuBtn = BarButtonItem()
        menuBtn.setImage(UIImage(named: "menu")?.maskWithColor(color: StyleGuide.MainColors.blue), for: .normal)
        menuBtn.imageEdgeInsets = UIEdgeInsets(top: 9, left: 9, bottom: 9, right: 9)
        menuBtn.addTarget(self, action: #selector(tapMenuAction(sender:)), for: .touchUpInside)
        menuBtn.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
        
        let menuBarItem = UIBarButtonItem(customView: menuBtn)
        
        self.navigationItem.leftBarButtonItem = menuBarItem
        
        //Calendar btn
        let calendarButton = BarButtonItem()
        calendarButton.setImage(UIImage(named: "calendarFill")?.maskWithColor(color: StyleGuide.MainColors.blue), for: .normal)
        calendarButton.imageEdgeInsets = UIEdgeInsets(top: 9, left: 9, bottom: 9, right: 9)
        calendarButton.addTarget(self, action: #selector(openCalendarViewAction(sender:)), for: .touchUpInside)
        calendarButton.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
        
        let barButtonItem = UIBarButtonItem(customView: calendarButton)
        
        navigationItem.rightBarButtonItem = barButtonItem
        
        let navBarTitleFrame = CGRect(x: 0, y: 0, width: UIView.globalSafeAreaFrame.width * 0.7, height: navBar.frame.height)
        let taskListNavBarTitleView = TaskListNavBarTitleView(frame: navBarTitleFrame, taskListMode: .list)
        navigationItem.titleView = taskListNavBarTitleView
        
        navBarTitle = taskListNavBarTitleView
        
    }
    
    // MARK: Constraints
    
    private func setupConstraints() {
        
        let navBarHeight = self.navigationController?.navigationBar.frame.height ?? 0
        
        calendarTopConstraintMargin = UIView.globalSafeAreaFrame.origin.y + navBarHeight
        
        calendarTopConstraint = calendarView.topAnchor.constraint(equalTo: view.topAnchor, constant: -calendarView.frame.height)
        
        var constraints: [NSLayoutConstraint] = [
            calendarTopConstraint,
            calendarView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            calendarView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            calendarView.bottomAnchor.constraint(equalTo: tableView.topAnchor),
            calendarView.heightAnchor.constraint(equalToConstant: calendarView.frame.height)
        ]
        
        constraints.append(contentsOf: [
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate(constraints)
        
    }
                            
    // MARK: Actions
        
    @objc private func tapMenuAction(sender: UIBarButtonItem) {
        slideMenu?.toggleMenu()
    }
    
    @objc private func openCalendarViewAction(sender: UIBarButtonItem) {
        openCalendar()
    }
    
    private func openCalendar() {
        if viewModel.outputs.taskListMode.value == .list {
            viewModel.inputs.setMode(mode: .calendar)
        } else {
            viewModel.inputs.setMode(mode: .list)
        }
        tableView.reloadData()
    }
    
    private func applyFilters() {
        guard let filter = filter else {
            return
        }
        
        viewModel.inputs.setFilter(filter: filter)
        tableView.reloadData()
    }
}

// MARK: UITableViewDataSource

extension TaskListViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        viewModel.outputs.periodItems.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.outputs.periodItems[section].outputs.tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cellFactory = taskListCellFactory else {
            return UITableViewCell()
        }
        
        let cellViewModel = viewModel.outputs.periodItems[indexPath.section].outputs.tasks[indexPath.row]
        
        return cellFactory.generateCell(viewModel: cellViewModel, tableView: tableView, for: indexPath)
    }
                                                                               
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        var headerFrame = CGRect(x: 0, y: 0, width: tableView.frame.width, height: StyleGuide.TaskList.Sizes.headerHeight)

        let periodViewModel = viewModel.outputs.periodItems[section]
        if periodViewModel.outputs.isEmpty && viewModel.outputs.taskListMode.value == .list {
            headerFrame.size.height = 30
        }
        
        let headerView = TaskListTableHeaderView(frame: headerFrame)
        headerView.viewModel = viewModel.outputs.periodItems[section]
                        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let periodViewModel = viewModel.outputs.periodItems[section]
        
        if periodViewModel.outputs.isEmpty && viewModel.outputs.taskListMode.value == .list {
            return 30
        }
        
        return StyleGuide.TaskList.Sizes.headerHeight
    }
    
}

// MARK: UITableViewDelegate

extension TaskListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? TaskListTableViewCell {
            cell.animateSelection {
                self.viewModel.inputs.editTask(indexPath: indexPath)
            }
        }
    }
}

// MARK: TaskListView

extension TaskListViewController: TaskListView {
    func editTask(taskUID: String) {
        if let editAction = editTaskAction {
            editAction(taskUID, nil, nil)
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
        tableView.reloadData()
    }
    
    func getView() -> UIView {
        if let navVC = navigationController {
            return navVC.view
        }
        return view
    }
}
