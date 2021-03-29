//
//  TaskDiaryViewController.swift
//  DoTask
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
        
        if #available(iOS 13.0, *) {
            super.init(rootViewController: vc)
        } else {
            super.init(nibName: nil, bundle: nil)
            self.viewControllers = [vc]
        }
        
        view.backgroundColor = .white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class TaskDiaryViewController: UIViewController {
    
    // MARK: ViewModel
    private var viewModel: TaskDiaryViewModelType
    
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
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.layoutSubviews()
    }
    
}

extension TaskDiaryViewController {
    
    private func setupView() {
        
        view.backgroundColor = .white
        
        guard let navBar = self.navigationController?.navigationBar else { return }
        navBar.setFlatNavBar()
        
        let font = FontFactory.AvenirNextBoldItalic.of(size: StyleGuide.getSizeRelativeToScreenWidth(baseSize: 27))
        
        let navTitle = NSMutableAttributedString(string: "Dia", attributes:[
                                                    NSAttributedString.Key.foregroundColor: R.color.commonColors.blue()!,
                                                    NSAttributedString.Key.font: font])
        
        navTitle.append(NSMutableAttributedString(string: "ry", attributes:[
                                                    NSAttributedString.Key.font: font,
                                                    NSAttributedString.Key.foregroundColor: R.color.commonColors.pink()!]))
        
        let navLabel = UILabel()
        navLabel.attributedText = navTitle
        
        self.navigationItem.titleView = navLabel
                
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(TaskDiaryTableViewCell.self, forCellReuseIdentifier: TaskDiaryTableViewCell.className)
        
        view.addSubview(tableView)
        
        tableView.frame = view.frame
        
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 600
        tableView.backgroundColor = .white
        tableView.layer.backgroundColor = R.color.diaryTask.background()!.cgColor
        tableView.showsVerticalScrollIndicator = false
        
        let rotateButton = UIButton(type: .custom)
        
        let imageInset = StyleGuide.TaskList.NavBar.Sizes.insetImageNavBarBtn
        
        rotateButton.imageEdgeInsets = UIEdgeInsets(top: imageInset, left: imageInset, bottom: imageInset, right: imageInset)
        rotateButton.setImage(R.image.diaryTask.rotating(), for: .normal)
        rotateButton.addTarget(self, action: #selector(closeDiary(sender:)), for: .touchUpInside)
        rotateButton.frame = CGRect(x: 0, y: 0, width: navBar.frame.height, height: navBar.frame.height)
        
        let barButtonItem = UIBarButtonItem(customView: rotateButton)
        
        navigationItem.leftBarButtonItem = barButtonItem
        
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

