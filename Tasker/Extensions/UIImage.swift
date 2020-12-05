//
//  UIImage.swift
//  Tasker
//
//  Created by kluv on 03/10/2020.
//  Copyright © 2020 itotdel. All rights reserved.
//

import UIKit

extension UIImage {
    
    static func grayscale(image: UIImage) -> UIImage? {
        let context = CIContext(options: nil)
        if let filter = CIFilter(name: "CIPhotoEffectNoir") {
            filter.setValue(CIImage(image: image), forKey: kCIInputImageKey)
            if let output = filter.outputImage {
                if let cgImage = context.createCGImage(output, from: output.extent) {
                    return UIImage(cgImage: cgImage)
                }
            }
        }
        return nil
    }
    
}
