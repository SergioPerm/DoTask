//
//  SplashViewController.swift
//  DoTask
//
//  Created by Сергей Лепинин on 28.04.2021.
//  Copyright © 2021 itotdel. All rights reserved.
//

import UIKit
import SnapKit

class SplashViewController: UIViewController, PresentableController {
    
    var presentableControllerViewType: PresentableControllerViewType
    var router: RouterType?
    var persistentType: PersistentViewControllerType?
    
    let viewModel: SplashViewModelType
    
    private let imageDT: UIImageView = {
        let imageView = UIImageView(image: R.image.launch.launchText())
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    private let infoLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = FontFactory.AvenirNextMedium.of(size: StyleGuide.getSizeRelativeToScreenWidth(baseSize: 15))
        label.textColor = .black
        label.textAlignment = .center
        
        return label
    }()
    
    init(viewModel: SplashViewModelType, router: RouterType?, presentableControllerViewType: PresentableControllerViewType) {
        self.viewModel = viewModel
        self.router = router
        self.presentableControllerViewType = presentableControllerViewType
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("No coder in splash screen")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupConstraints()
        bindViewModel()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.inputs.startMaintainceTasks()
    }
    
}

extension SplashViewController {
    private func setup() {
        infoLabel.text = R.string.localizable.splashscreen_TITLE()
        
        view.backgroundColor = .white
        
        view.addSubview(imageDT)
        view.addSubview(infoLabel)
    }
    
    private func setupConstraints() {
        imageDT.snp.makeConstraints({ make in
            make.centerX.equalTo(view.snp.centerX)
            make.centerY.equalTo(view.snp.centerY).offset(-70)
            make.height.equalTo(view.snp.height).multipliedBy(0.2)
        })
        
        infoLabel.snp.makeConstraints({ make in
            make.width.equalTo(view.safeAreaLayoutGuide.snp.width).multipliedBy(0.5)
            make.centerX.equalTo(view.safeAreaLayoutGuide.snp.centerX)
            make.height.equalTo(15)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-146)
        })
    }
    
    private func startAnimation() {
        UIView.animate(withDuration: 0.3, delay: 0.3, options: .curveEaseIn) {
            self.imageDT.frame.origin.y += 200
            self.imageDT.alpha = 0.0
        } completion: { finished in
            self.router?.pop(vc: self)
        }
    }
    
    private func bindViewModel() {
        viewModel.outputs.onFinishMaintainceTasksEvent.subscribe(self) { this, success in
            this.startAnimation()
        }
    }
}
