//
//  SaveAccessory.swift
//  DoTask
//
//  Created by Сергей Лепинин on 24.03.2021.
//  Copyright © 2021 itotdel. All rights reserved.
//

import UIKit

class SaveAccessory: UIView {

    private let saveImage: UIImageView = {
        let image = UIImageView(image: R.image.detailTask.saveTask()?.maskWithColor(color: R.color.commonColors.blue()!))
        image.contentMode = .scaleAspectFit
         
        return image
    }()
    
    init() {
        super.init(frame: CGRect.zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateFrame()
    }

}

extension SaveAccessory {
    private func setup() {
        addSubview(saveImage)
    }
    
    private func updateFrame() {
        let sideSize = frame.height/1.7
        saveImage.frame = CGRect(x: frame.width/2 - sideSize/2, y: frame.height/2 - sideSize/2, width: sideSize, height: sideSize)
    }
}
