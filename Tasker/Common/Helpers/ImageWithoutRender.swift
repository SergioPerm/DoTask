//
//  ImageWithoutRender.swift
//  Tasker
//
//  Created by KLuV on 22.01.2021.
//  Copyright © 2021 itotdel. All rights reserved.
//

import UIKit

class ImageWithoutRender: UIImage {
    override func withRenderingMode(_ renderingMode: UIImage.RenderingMode) -> UIImage {
        return self
    }
}
