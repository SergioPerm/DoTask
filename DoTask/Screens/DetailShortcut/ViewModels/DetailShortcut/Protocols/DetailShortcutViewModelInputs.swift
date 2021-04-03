//
//  DetailShortcutViewModelInputs.swift
//  DoTask
//
//  Created by KLuV on 05.01.2021.
//  Copyright © 2021 itotdel. All rights reserved.
//

import UIKit

protocol DetailShortcutViewModelInputs {
    func setShortcutUID(UID: String?)
    func setColor(colorHex: String)
    func setTitle(title: String)
    func toggleshowInMainListSetting()
    func save()
    func delete()
}
