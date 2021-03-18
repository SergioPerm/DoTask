//
//  CheckTask.swift
//  DoTask
//
//  Created by Сергей Лепинин on 18.03.2021.
//  Copyright © 2021 itotdel. All rights reserved.
//

import UIKit

class CheckTask: UIView {

    init() {
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

}

extension CheckTask {
    private func setup() {
        layer.borderWidth = StyleGuide.CommonViews.CheckTask.Sizes.borderWidth
        layer.borderColor = #colorLiteral(red: 1, green: 0.2130734228, blue: 0.6506573371, alpha: 0.8470588235).cgColor
        layer.cornerRadius = StyleGuide.CommonViews.CheckTask.Sizes.cornerRadius
        layer.backgroundColor = #colorLiteral(red: 1, green: 0.2130734228, blue: 0.6506573371, alpha: 0.1099601066)
    }
}
