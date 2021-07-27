//
//  PermissionDeniedViewController.swift
//  DoTask
//
//  Created by Sergio Lechini on 03.07.2021.
//  Copyright © 2021 itotdel. All rights reserved.
//

import UIKit
import SnapKit

class PermissionDeniedViewController: UIViewController, PermissionDeniedViewType {
    
    var presentableControllerViewType: PresentableControllerViewType
    var router: RouterType?
    var persistentType: PersistentViewControllerType?
    
    // MARK: UI
        
    private let mainView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.cornerRadius = 20
        
        return view
    }()
    
    private let iconView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    private let titleLabel: LocalizableLabel = {
        let label = LocalizableLabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = FontFactory.AvenirNextBold.of(size: 15)
        label.textColor = R.color.commonColors.blue()
        label.numberOfLines = 0
        label.textAlignment = .center
        
        return label
    }()
    
    private let infoLabel: LocalizableLabel = {
        let label = LocalizableLabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = FontFactory.AvenirNextRegular.of(size: 15)
        label.textColor = R.color.commonColors.blue()
        label.numberOfLines = 0
        label.textAlignment = .center
        
        return label
    }()
    
    private let horizontalBorderView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = R.color.commonColors.pink()?.withAlphaComponent(0.2)
        
        return view
    }()
    
    private let verticalBorderView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = R.color.commonColors.pink()?.withAlphaComponent(0.2)
        
        return view
    }()
    
    private let cancelBtn: LocalizableButton = {
        let btn = LocalizableButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.localizableString = LocalizableStringResource(stringResource: R.string.localizable.canceL)
        btn.titleLabel?.font = FontFactory.HelveticaNeueBold.of(size: 16)
        btn.setTitleColor(R.color.commonColors.blue(), for: .normal)
        
        return btn
    }()
    
    private let settingsBtn: LocalizableButton = {
        let btn = LocalizableButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.localizableString = LocalizableStringResource(stringResource: R.string.localizable.settings_TITLE)
        btn.titleLabel?.font = FontFactory.HelveticaNeueBold.of(size: 16)
        btn.setTitleColor(R.color.commonColors.blue(), for: .normal)
        
        return btn
    }()
        
    // MARK: Init
    
    init(router: RouterType?, presentableControllerViewType: PresentableControllerViewType) {
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
    }
    
    // MARK: PermissionDeniedViewType
    func setLocalizeTitle(title: LocalizableStringResource) {
        titleLabel.localizableString = title
    }
    
    func setLocalizeInfo(info: LocalizableStringResource) {
        infoLabel.localizableString = info
    }
    
    func setIcon(icon: UIImage?) {
        iconView.image = icon
    }
}

private extension PermissionDeniedViewController {
    func setup() {
        view.addSubview(mainView)
        
        mainView.addSubview(iconView)
        mainView.addSubview(titleLabel)
        mainView.addSubview(infoLabel)
        mainView.addSubview(horizontalBorderView)
        mainView.addSubview(verticalBorderView)
        mainView.addSubview(cancelBtn)
        mainView.addSubview(settingsBtn)
        
        cancelBtn.addTarget(self, action: #selector(closeAction(sender:)), for: .touchUpInside)
        settingsBtn.addTarget(self, action: #selector(goToSettings(sender:)), for: .touchUpInside)
    }
    
    func setupConstraints() {
        mainView.snp.makeConstraints({ make in
            make.centerX.centerY.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.75)
            make.height.equalTo(mainView.snp.width).priority(.low)
        })
        
        iconView.snp.makeConstraints({ make in
            make.centerY.equalTo(titleLabel.snp.centerY)
            make.left.equalToSuperview().offset(16)
            make.height.equalTo(titleLabel.snp.height)
            make.width.equalTo(iconView.snp.height)
        })
        
        titleLabel.snp.makeConstraints({ make in
            make.left.equalTo(iconView.snp.right).offset(14)
            make.top.equalToSuperview().offset(20)
            make.height.equalTo(10).priority(.low)
            make.right.equalToSuperview().offset(-16)
        })
        
        infoLabel.snp.makeConstraints({ make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            //make.bottom.equalTo(horizontalBorderView.snp.top).offset(-20)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.height.equalTo(10).priority(.low)
        })
        
        horizontalBorderView.snp.makeConstraints({ make in
            make.height.equalTo(1.0)
            make.left.right.equalToSuperview()
            make.top.equalTo(infoLabel.snp.bottom).offset(20)
        })
        
        verticalBorderView.snp.makeConstraints({ make in
            make.centerX.bottom.equalToSuperview()
            make.width.equalTo(1.0)
            make.height.equalTo(50)
        })
        
        cancelBtn.snp.makeConstraints({ make in
            make.top.equalTo(horizontalBorderView.snp.bottom)
            make.left.bottom.equalToSuperview()
            make.right.equalTo(verticalBorderView.snp.left)
            make.height.equalTo(50)
        })
        
        settingsBtn.snp.makeConstraints({ make in
            make.top.equalTo(horizontalBorderView.snp.bottom)
            make.right.bottom.equalToSuperview()
            make.left.equalTo(verticalBorderView.snp.right)
            make.height.equalTo(50)
        })
    }
}

// MARK: Actions
private extension PermissionDeniedViewController {
    @objc func closeAction(sender: UIButton) {
        router?.pop(vc: self)
    }
    
    @objc func goToSettings(sender: UIButton) {
        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
            return
        }

        if UIApplication.shared.canOpenURL(settingsUrl) {
            UIApplication.shared.open(settingsUrl, completionHandler: { [weak self] (success) in
                guard let strongSelf = self else { return }
                print("Settings opened: \(success)")
                strongSelf.router?.pop(vc: strongSelf)
            })
        }
    }
}
