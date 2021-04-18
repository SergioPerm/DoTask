//
//  SettingsViewController.swift
//  DoTask
//
//  Created by kluv on 24/11/2020.
//  Copyright © 2020 itotdel. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, SettingsViewType {
    
    //SettingsViewType
    var settingLanguageHandler: (() -> Void)? {
        didSet {
            viewModel.inputs.setLanguageHandler(handler: settingLanguageHandler)
        }
    }
    
    var settingTasksHandler: (() -> Void)? {
        didSet {
            viewModel.inputs.setTasksHandler(handler: settingTasksHandler)
        }
    }
    
    var settingSpotlightHandler: (() -> Void)? {
        didSet {
            viewModel.inputs.setSpotlightHandler(handler: settingSpotlightHandler)
        }
    }
    
    private let viewModel: SettingsViewModelType
    
    private let tableView: UITableView = UITableView()
    
    var presentableControllerViewType: PresentableControllerViewType
    var router: RouterType?
    var persistentType: PersistentViewControllerType?
    
    init(viewModel: SettingsViewModelType, router: RouterType?, presentableControllerViewType: PresentableControllerViewType) {
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

extension SettingsViewController {
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

extension SettingsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.outputs.settingsItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingsTableViewCell.className) as? SettingsTableViewCell else {
            return UITableViewCell()
        }
        
        cell.viewModel = viewModel.outputs.settingsItems[indexPath.row]
        
        return cell
    }
    
}
