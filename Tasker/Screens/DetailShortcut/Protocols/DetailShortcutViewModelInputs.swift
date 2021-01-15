//
//  DetailShortcutViewModelInputs.swift
//  Tasker
//
//  Created by KLuV on 05.01.2021.
//  Copyright © 2021 itotdel. All rights reserved.
//

import UIKit

protocol DetailShortcutViewModelInputs {
    func setColor(color: UIColor)
    func setTitle(title: String)
    func toggleshowInMainListSetting()
    func save()
    func delete()
}
