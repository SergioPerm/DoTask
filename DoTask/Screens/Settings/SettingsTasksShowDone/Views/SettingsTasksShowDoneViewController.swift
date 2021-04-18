//
//  SettingsTasksShowDoneViewController.swift
//  DoTask
//
//  Created by Сергей Лепинин on 18.04.2021.
//  Copyright © 2021 itotdel. All rights reserved.
//

import UIKit
import SnapKit

class SettingsTasksShowDoneViewController: UIViewController, SettingsTasksShowDoneViewType {

    private let viewModel: SettingsTasksShowDoneViewModelType

    var presentableControllerViewType: PresentableControllerViewType
    var router: RouterType?
    var persistentType: PersistentViewControllerType?
    
    private let switchView: SettingsTasksShowDoneSwitch = {
        let view = SettingsTasksShowDoneSwitch()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let infoView: SettingsTasksShowDoneInfo = {
        let view = SettingsTasksShowDoneInfo()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    init(viewModel: SettingsTasksShowDoneViewModelType, router: RouterType?, presentableControllerViewType: PresentableControllerViewType) {
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
        bindViewModel()
    }
}

extension SettingsTasksShowDoneViewController {
    private func bindViewModel() {
        switchView.showDone = viewModel.outputs.showDone
        switchView.changeSettingHandler = { [weak self] in
            self?.viewModel.inputs.changeShowDoneSetting()
        }
    }
    
    private func setup() {
        view.backgroundColor = .white
        view.addSubview(switchView)
        view.addSubview(infoView)
    }
    
    private func setupConstraints() {
        let rowHeight = StyleGuide.Settings.Sizes.cellHeight
        
        switchView.snp.makeConstraints({ make in
            make.left.right.equalToSuperview()
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.height.equalTo(rowHeight)
        })
        
        infoView.snp.makeConstraints({ make in
            make.left.right.equalToSuperview()
            make.top.equalTo(switchView.snp.bottom)
            make.height.equalTo(rowHeight)
        })
    }
    
    private func setupNavbar() {
        guard let navBar = self.navigationController?.navigationBar else { return }
        
        navigationItem.rightBarButtonItems = [UIBarButtonItem(customView: UIView(frame: CGRect(x: 0, y: 0, width: 44, height: 44)))]
        
        let navBarTitleFrame = CGRect(x: 0, y: 0, width: UIView.globalSafeAreaFrame.width * StyleGuide.Settings.Sizes.RatioToScreenWidth.settingsNavBarWidth, height: navBar.frame.height)
        let settingsNavBarTitleView = SettingsNavBarTitle(frame: navBarTitleFrame)
        settingsNavBarTitleView.setTitle(localizeString: LocalizableStringResource(stringResource: R.string.localizable.settings_DONE_TITLE))
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

