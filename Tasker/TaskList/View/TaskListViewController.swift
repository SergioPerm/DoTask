//
//  TaskListViewController.swift
//  Tasker
//
//  Created by kluv on 27/09/2020.
//  Copyright © 2020 itotdel. All rights reserved.
//

import UIKit

class TaskListViewController: UIViewController {

    // MARK: - Dependencies
    public let viewModel = TaskListViewModelAssembler.createInstance()
    
    private var tableView: UITableView!
    
    
    private let editTaskAction: ((_ taskModel: TaskModel?) ->  Void)
        
    init(editTaskAction: @escaping (_ taskModel: TaskModel?) ->  Void) {
        self.editTaskAction = editTaskAction
        
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
    }
        
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewModel.viewWillDisappear()
    }
        
}

extension TaskListViewController {
    private func setupView() {
        tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(TaskListTableViewCell.self, forCellReuseIdentifier: TaskListTableViewCell.reuseIdentifier)
        
        view.addSubview(tableView)
        
        tableView.frame = view.frame
        
        tableView.separatorStyle = .none
        tableView.rowHeight = 75
        tableView.backgroundColor = .white
        
        let btn = TaskAddButton {
            self.editTaskAction(nil)
        }
        view.insertSubview(btn, aboveSubview: tableView)
    }
    
    private func configureCell(cell: TaskListTableViewCell, taskModel: TaskModel) {
        cell.doneHandler = doneCellAction(_:)
        cell.taskModel = taskModel
    }
    
    private func doneCellAction(_ taskIdentifier: String) {
        viewModel.setDoneForTask(with: taskIdentifier)
    }
    
    // MARK: Actions
    
    @objc private func addTaskAction(sender: UIView) {
        
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
        let cell = tableView.dequeueReusableCell(withIdentifier: TaskListTableViewCell.reuseIdentifier) as! TaskListTableViewCell
        let taskModel = viewModel.tableViewItems[indexPath.section].tasks[indexPath.row]
        configureCell(cell: cell, taskModel: taskModel)

        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 50))
        
        let headerName = viewModel.tableViewItems[section].dailyName
        
        let label = UILabel()
        label.frame = CGRect.init(x: 5, y: 5, width: headerView.frame.width-10, height: headerView.frame.height-10)
        label.text = headerName
        label.font = Font.tableHeader.uiFont//UIFont(name: "HelveticaNeue-Bold", size: 35)// my custom font
        
        label.textColor = #colorLiteral(red: 0.2392156863, green: 0.6235294118, blue: 0.9960784314, alpha: 1)
        
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
            self.viewModel.tableViewDidSelectRow(at: indexPath)
        }
    }
        
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let contextItemDelete = UIContextualAction(style: .destructive, title: "") { [weak self] (contextualAction, view, completion) in
            self?.viewModel.deleteTask(at: indexPath)
        }
        contextItemDelete.backgroundColor = Color.whiteColor.uiColor
        contextItemDelete.image = UIGraphicsImageRenderer(size: CGSize(width: 30, height: 30)).image { _ in
            UIImage(named: "recycle")?.draw(in: CGRect(x: 0, y: 0, width: 30, height: 30))
        }
        
        let configuration = UISwipeActionsConfiguration(actions: [contextItemDelete])
        
        return configuration
    }
}

// MARK: TaskListView

extension TaskListViewController: TaskListView {
    func editTask(taskModel: TaskModel) {
        editTaskAction(taskModel)
    }
    
    func tableViewSectionInsert(at indexSet: IndexSet) {
        tableView.insertSections(indexSet, with: .left)
    }
    
    func tableViewSectionDelete(at indexSet: IndexSet) {
        tableView.deleteSections(indexSet, with: .right)
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
