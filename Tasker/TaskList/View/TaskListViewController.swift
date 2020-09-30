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
    private let editTaskAction: ((_ taskModel: TaskModel) ->  Void)
        
    init(editTaskAction: @escaping (_ taskModel: TaskModel) ->  Void) {
        self.editTaskAction = editTaskAction
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        for n in 1...10 {
//
//            var taskModel = TaskModel()
//            taskModel.uid = UUID().uuidString
//            taskModel.title = "\(n)"
//            taskModel.taskDate = Date()
//
//            viewModel.addTask(from: taskModel)
//
//        }
        viewModel.clearData()

        
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
        tableView.rowHeight = 40
        tableView.backgroundColor = .green
    }
    
    private func configureCell(cell: TaskListTableViewCell, taskModel: TaskModel) {
        cell.cellLabel.text = taskModel.title
    }
}

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
        cell.cellLabel.text = taskModel.title
        cell.taskIdentifier = taskModel.uid
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 50))
        
        let headerName = viewModel.tableViewItems[section].dailyName
        
        let label = UILabel()
        label.frame = CGRect.init(x: 5, y: 5, width: headerView.frame.width-10, height: headerView.frame.height-10)
        label.text = headerName
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 35)// my custom font
        
        label.textColor = #colorLiteral(red: 0.2369126672, green: 0.6231006994, blue: 1, alpha: 1)
        
        headerView.addSubview(label)
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
}

extension TaskListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.tableViewDidSelectRow(at: indexPath)
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