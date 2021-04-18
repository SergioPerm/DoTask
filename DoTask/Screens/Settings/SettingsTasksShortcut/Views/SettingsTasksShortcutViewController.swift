//
//  SettingsTasksShortcutViewController.swift
//  DoTask
//
//  Created by Сергей Лепинин on 16.04.2021.
//  Copyright © 2021 itotdel. All rights reserved.
//

import UIKit
import SnapKit

class SettingsTasksShortcutViewController: UIViewController, SettingsTasksShortcutViewType {

    private let viewModel: SettingsTasksShortcutViewModelType

    private let tableView: UITableView = UITableView()
        
    var presentableControllerViewType: PresentableControllerViewType
    var router: RouterType?
    var persistentType: PersistentViewControllerType?
    
    init(viewModel: SettingsTasksShortcutViewModelType, router: RouterType?, presentableControllerViewType: PresentableControllerViewType) {
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
        setupNavbar()
    }

}

extension SettingsTasksShortcutViewController {
    private func setup() {        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 600
        tableView.backgroundColor = .white
        tableView.sectionFooterHeight = 0
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(SettingsTasksShortcutTableViewCell.self, forCellReuseIdentifier: SettingsTasksShortcutTableViewCell.className)
        
        view.addSubview(tableView)
    }
    
    private func setupConstraints() {
        tableView.snp.makeConstraints({ make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        })
    }
    
    private func setupNavbar() {
        guard let navBar = self.navigationController?.navigationBar else { return }
        
        navigationItem.rightBarButtonItems = [UIBarButtonItem(customView: UIView(frame: CGRect(x: 0, y: 0, width: 44, height: 44)))]
        
        let navBarTitleFrame = CGRect(x: 0, y: 0, width: UIView.globalSafeAreaFrame.width * StyleGuide.Settings.Sizes.RatioToScreenWidth.settingsNavBarWidth, height: navBar.frame.height)
        let settingsNavBarTitleView = SettingsNavBarTitle(frame: navBarTitleFrame)
        settingsNavBarTitleView.setTitle(localizeString: LocalizableStringResource(stringResource: R.string.localizable.settings_SHORTCUT_TITLE))
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

extension SettingsTasksShortcutViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.inputs.setSelected(index: indexPath.row)
    }
}

extension SettingsTasksShortcutViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.outputs.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingsTasksShortcutTableViewCell.className) as? SettingsTasksShortcutTableViewCell else {
            return UITableViewCell()
        }
        
        cell.viewModel = viewModel.outputs.items[indexPath.row]
        
        return cell
    }
}

