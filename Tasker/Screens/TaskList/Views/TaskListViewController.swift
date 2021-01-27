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
    private var viewModel: TaskListViewModel {
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
    
    var shortcutFilter: String? {
        didSet {
            applyShortcutFilter()
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
        
        self.viewModel.view = self
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
    }
    
    // MARK: Setup
    
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
    
    private func setupNavigationBarTitle(shortcutData: ShortcutData? = nil) {
        
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
            
    private func applyShortcutFilter() {
        viewModel.inputs.setShortcutFilter(shortcutUID: shortcutFilter)
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
        cell.viewModel = viewModel.periodItems[indexPath.section].tasks[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerName = viewModel.periodItems[section].title
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 50))
  
        let label = UILabel()
        label.frame = CGRect.init(x: 0, y: 5, width: headerView.frame.width, height: headerView.frame.height-20)
        label.text = "  \(headerName)"
        label.font = Font.tableHeader.uiFont
        
        label.textColor = #colorLiteral(red: 0.2392156863, green: 0.6235294118, blue: 0.9960784314, alpha: 1)
        label.backgroundColor = UIColor.white
        
        headerView.addSubview(label)
                        
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
