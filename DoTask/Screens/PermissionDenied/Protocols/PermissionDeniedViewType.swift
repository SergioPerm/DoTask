//
//  PermissionDeniedViewType.swift
//  DoTask
//
//  Created by Sergio Lechini on 03.07.2021.
//  Copyright © 2021 itotdel. All rights reserved.
//

import UIKit

protocol PermissionDeniedViewType: PresentableController {
    func setLocalizeTitle(title: LocalizableStringResource)
    func setLocalizeInfo(info: LocalizableStringResource)
    func setIcon(icon: UIImage?)
}
