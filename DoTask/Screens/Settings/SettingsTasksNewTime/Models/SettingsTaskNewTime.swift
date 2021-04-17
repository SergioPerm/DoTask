//
//  SettingsTaskNewTime.swift
//  DoTask
//
//  Created by Сергей Лепинин on 15.04.2021.
//  Copyright © 2021 itotdel. All rights reserved.
//

import Foundation

struct SettingsTaskNewTime {
    let iconData: Data
    let title: LocalizableStringResource
    let time: SettingService.NewTaskTime
    let select: Bool
}
