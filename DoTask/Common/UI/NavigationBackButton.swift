//
//  NavigationBackButton.swift
//  DoTask
//
//  Created by Сергей Лепинин on 16.04.2021.
//  Copyright © 2021 itotdel. All rights reserved.
//

import UIKit

class NavigationBackButton: UIButton {

    init() {
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension NavigationBackButton {
    private func setup() {
        let imageInset = StyleGuide.Settings.Sizes.insetImageNavBarBtn
        
        imageEdgeInsets = imageInset
        setImage(R.image.settings.backButton(), for: .normal)
        contentMode = .scaleAspectFit
    }
}
