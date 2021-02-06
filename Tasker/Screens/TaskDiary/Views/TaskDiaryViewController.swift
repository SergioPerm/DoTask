//
//  TaskDiaryViewController.swift
//  Tasker
//
//  Created by KLuV on 04.02.2021.
//  Copyright © 2021 itotdel. All rights reserved.
//

import UIKit

class TaskDiaryNavigationController: UINavigationController, PresentableController, TaskDiaryViewPresentable {
    var presentableControllerViewType: PresentableControllerViewType
    var router: RouterType?
    var persistentType: PersistentViewControllerType?
    
    var editTaskAction: ((String?, String?) -> Void)? {
        didSet {
            vc.editTaskAction = editTaskAction
        }
    }
    
    private let vc: TaskDiaryViewController
    
    init(viewModel: TaskDiaryViewModel, router: RouterType?, presentableControllerViewType: PresentableControllerViewType, persistentType: PersistentViewControllerType?) {
        self.router = router
        self.presentableControllerViewType = presentableControllerViewType
        self.persistentType = persistentType
        
        self.vc = TaskDiaryViewController(viewModel: viewModel)
        
        super.init(rootViewController: vc)
        
        view.backgroundColor = .white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class TaskDiaryViewController: UIViewController {
    
    // MARK: ViewModel
    private var viewModel: TaskDiaryViewModelType {
        didSet {
            bindViewModel()
        }
    }
    
    // MARK: Properties
    
    private var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        
        return tableView
    }()
    
    var editTaskAction: ((_ taskUID: String?, _ shortcutUID: String?) ->  Void)?
    
    init(viewModel: TaskDiaryViewModel) {
        self.viewModel = viewModel
        
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

extension TaskDiaryViewController {
    private func bindViewModel() {
        
    }
    
    private func setupView() {
        
        view.backgroundColor = .white
        
        if let navBar = self.navigationController?.navigationBar {
            navBar.setFlatNavBar()
        }
        
        let navTitle = NSMutableAttributedString(string: "Dia", attributes:[
                                                    NSAttributedString.Key.foregroundColor: Color.blueColor.uiColor,
                                                    NSAttributedString.Key.font: Font.mainTitle.uiFont])
        
        navTitle.append(NSMutableAttributedString(string: "ry", attributes:[
                                                    NSAttributedString.Key.font: Font.mainTitle2.uiFont,
                                                    NSAttributedString.Key.foregroundColor: Color.pinkColor.uiColor]))
        
        let navLabel = UILabel()
        navLabel.attributedText = navTitle
        
        self.navigationItem.titleView = navLabel
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .undo, target: self, action: #selector(closeDiary(sender:)))
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(TaskDiaryTableViewCell.self, forCellReuseIdentifier: TaskDiaryTableViewCell.className)
        
        view.addSubview(tableView)
        
        tableView.frame = view.frame
        
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 600
        tableView.backgroundColor = .white
        tableView.layer.backgroundColor = UIColor.white.cgColor
        tableView.showsVerticalScrollIndicator = false
        
    }
    
    @objc private func closeDiary(sender: UIBarButtonItem) {
        if let navController = navigationController as? TaskDiaryNavigationController {
            navController.router?.pop(vc: navController)
        }
    }
}

extension TaskDiaryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! TaskDiaryTableViewCell
        cell.animateSelection {
            self.viewModel.inputs.editTask(indexPath: indexPath)
        }
    }
}

extension TaskDiaryViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.outputs.periodItems.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.outputs.periodItems[section].tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TaskDiaryTableViewCell.className) as! TaskDiaryTableViewCell
        cell.viewModel = viewModel.outputs.periodItems[indexPath.section].tasks[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerName = viewModel.outputs.periodItems[section].title
        
        let headerFrame = CGRect(x: 0, y: 0, width: tableView.frame.width, height: StyleGuide.TaskList.Sizes.headerHeight)
        let headerView = TaskDiaryTableHeaderView(title: headerName, frame: headerFrame)
                        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return StyleGuide.TaskList.Sizes.headerHeight
    }
}

extension TaskDiaryViewController: TaskDiaryViewType {
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

