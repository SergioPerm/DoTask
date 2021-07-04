//
//  AppDI.swift
//  DoTask
//
//  Created by Сергей Лепинин on 01.04.2021.
//  Copyright © 2021 itotdel. All rights reserved.
//

import Foundation
import DITranquillity

class AppDI {
    
    private static let container: DIContainer = DIContainer()
        
    static func reg() {
        AppDependency.load(container: container)
        StorageDependency.load(container: container)
        NotificationDependency.load(container: container)
        SplashDependency.load(container: container)
        SlideMenuDependency.load(container: container)
        TaskListDependency.load(container: container)
        DetailTaskDependency.load(container: container)
        DetailShortcutDependency.load(container: container)
        TaskDiaryDependency.load(container: container)
        ShortcutListDependency.load(container: container)
        SettingsDependency.load(container: container)
        TimePickerDependency.load(container: container)
        DatePickerDependency.load(container: container)
        SpeechTaskDependency.load(container: container)
        OnBoardingDependency.load(container: container)
        PermissionDeniedDependency.load(container: container)
        
        container.initializeSingletonObjects()
    }
    
    static func resolve<T>() -> T {
        return container.resolve()
    }
    
    static func resolve<T, Tag>(withTag: Tag.Type) -> T {
        return container.resolve(tag: withTag)
    }
    
}
