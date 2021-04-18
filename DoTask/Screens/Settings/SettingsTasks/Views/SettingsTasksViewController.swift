//
//  SettingsTasksViewController.swift
//  DoTask
//
//  Created by Сергей Лепинин on 15.04.2021.
//  Copyright © 2021 itotdel. All rights reserved.
//

import UIKit
import SnapKit

class SettingsTasksViewController: UIViewController, SettingsTasksViewType {

    var settingNewTaskTimeHandler: (() -> Void)? {
        didSet {
            viewModel.inputs.setNewTaskTimeHandler(handler: settingNewTaskTimeHandler)
        }
    }
    
    var settingDefaultShortcutHandler: (() -> Void)? {
        didSet {
            viewModel.inputs.setDefaultShortcutHandler(handler: settingDefaultShortcutHandler)
        }
    }
    
    var settingShowCompletedTasksHandler: (() -> Void)? {
        didSet {
            viewModel.inputs.setShowCompletedTasksHandler(handler: settingShowCompletedTasksHandler)
        }
    }
    
    var settingTransferOverdueHandler: (() -> Void)? {
        didSet {
            viewModel.inputs.setTransferOverdueHandler(handler: settingTransferOverdueHandler)
        }
    }
    
    private let viewModel: SettingsTasksViewModelType

    private let tableView: UITableView = UITableView()
    
    var presentableControllerViewType: PresentableControllerViewType
    var router: RouterType?
    var persistentType: PersistentViewControllerType?
    
    init(viewModel: SettingsTasksViewModelType, router: RouterType?, presentableControllerViewType: PresentableControllerViewType) {
        self.viewModel = viewModel
        self.router = router
        self.presentableControllerViewType = presentableControllerViewType
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        setupConstraints()
        setupNavBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.inputs.reloadData()
        tableView.reloadData()
    }
}

extension SettingsTasksViewController {
    private func setup() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 600
        tableView.backgroundColor = .white
        tableView.sectionFooterHeight = 0
        
        tableView.dataSource = self
        
        tableView.register(SettingsTableViewCell.self, forCellReuseIdentifier: SettingsTableViewCell.className)
        
        view.addSubview(tableView)
    }
    
    private func setupConstraints() {
        tableView.snp.makeConstraints({ make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        })
    }
    
    private func setupNavBar() {
        guard let navBar = self.navigationController?.navigationBar else { return }
        
        navigationItem.rightBarButtonItems = [UIBarButtonItem(customView: UIView(frame: CGRect(x: 0, y: 0, width: 44, height: 44)))]
        
        let navBarTitleFrame = CGRect(x: 0, y: 0, width: UIView.globalSafeAreaFrame.width * StyleGuide.Settings.Sizes.RatioToScreenWidth.settingsNavBarWidth, height: navBar.frame.height)
        let settingsNavBarTitleView = SettingsNavBarTitle(frame: navBarTitleFrame)
        settingsNavBarTitleView.setTitle(localizeString: LocalizableStringResource(stringResource: R.string.localizable.settings_TASK))
        navigationItem.titleView = settingsNavBarTitleView
        
        let backButton = NavigationBackButton()
        backButton.addTarget(self, action: #selector(closeSettings(sender:)), for: .touchUpInside)
        backButton.frame = CGRect(x: 0, y: 0, width: navBar.frame.height, height: navBar.frame.height)
        let barButtonItem = UIBarButtonItem(customView: backButton)
        
        navigationItem.leftBarButtonItem = barButtonItem
    }
    
    @objc private func closeSettings(sender: UIBarButtonItem) {
        router?.pop(vc: self)
    }
}

extension SettingsTasksViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.outputs.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingsTableViewCell.className) as? SettingsTableViewCell else {
            return UITableViewCell()
        }
        
        cell.viewModel = viewModel.outputs.items[indexPath.row]
        
        return cell
    }
}

