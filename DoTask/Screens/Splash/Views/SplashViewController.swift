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
    
    init(router: RouterType?, presentableControllerViewType: PresentableControllerViewType) {
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
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startAnimation()
    }
    
}

extension SplashViewController {
    private func setup() {
        infoLabel.text = "It's splash screen!"
        
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
            self.imageDT.transform = CGAffineTransform(scaleX: 4.0, y: 4.0)
            self.imageDT.alpha = 0.0
        } completion: { finished in
            self.router?.pop(vc: self)
        }
        
    }
}
