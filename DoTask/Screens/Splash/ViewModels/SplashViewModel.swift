//
//  SplashViewModel.swift
//  DoTask
//
//  Created by Sergio Lechini on 25.05.2021.
//  Copyright © 2021 itotdel. All rights reserved.
//

import Foundation

protocol SplashViewModelInputs {
    func startMaintainceTasks()
}

protocol SplashViewModelOutputs {
    var onFinishMaintainceTasksEvent: Event<Bool> { get }
}

protocol SplashViewModelType {
    var inputs: SplashViewModelInputs { get }
    var outputs: SplashViewModelOutputs { get }
}

class SplashViewModel: SplashViewModelType, SplashViewModelInputs, SplashViewModelOutputs {
    
    var inputs: SplashViewModelInputs { return self }
    var outputs: SplashViewModelOutputs { return self }
    
    private let dataSource: TasksMaintainceDataSource
    
    private let settingsService: SettingService = AppDI.resolve()
    private var currentSettings: SettingService.Settings
    
    init(dataSource: TasksMaintainceDataSource) {
        self.dataSource = dataSource
        self.onFinishMaintainceTasksEvent = Event<Bool>()
        self.currentSettings = settingsService.getSettings()
    }
    
    // MARK: Inputs
    func startMaintainceTasks() {
        if currentSettings.task.transferOverdueTasksToToday {
            dataSource.transferOverdueTasks()
        }
        
        onFinishMaintainceTasksEvent.raise(true)
    }
    
    // MARK: Outputs
    
    var onFinishMaintainceTasksEvent: Event<Bool>
}
