//
//  SpeechTaskViewModel.swift
//  DoTask
//
//  Created by KLuV on 09.03.2021.
//  Copyright © 2021 itotdel. All rights reserved.
//

import Foundation
//import Speech

protocol SpeechTaskViewModelInputs {
    func startRecording()
    func stopRecording()
    func saveTask(taskTitle: String)
    func cancelTask()
    func setShortcut(uid: String)
    func setTaskDate(date: Date?)
    
    func setSpeechPermissionDontAllowHandler(handler: (() -> ())?)
}

protocol SpeechTaskViewModelOutputs {
    var speechTextChangeEvent: Event<String> { get }
    var volumeLevel: Event<Float> { get }
    var closeEvent: Event<Void> { get }
}

protocol SpeechTaskViewModelType {
    var inputs: SpeechTaskViewModelInputs { get }
    var outputs: SpeechTaskViewModelOutputs { get }
}

final class SpeechTaskViewModel: NSObject, SpeechTaskViewModelType, SpeechTaskViewModelInputs, SpeechTaskViewModelOutputs {
    
    private let dataSource: TaskListDataSource
    private let spotlightService: SpotlightTasksService
    
    private var shortcutUID: String?
    
    private var onDoNotAllowSpeech: (()->())?
    
    private var localizeService: LocalizeServiceType
    private let speechService: SpeechRecognitionServiceType
    
    private var taskDate: Date?
    
    var inputs: SpeechTaskViewModelInputs { return self }
    var outputs: SpeechTaskViewModelOutputs { return self }
    
    init(dataSource: TaskListDataSource, localizeService: LocalizeServiceType, spotlightService: SpotlightTasksService, speechService: SpeechRecognitionServiceType) {
        self.dataSource = dataSource
        self.spotlightService = spotlightService
        self.localizeService = localizeService
        self.speechService = speechService
        self.speechTextChangeEvent = Event<String>()
        self.volumeLevel = Event<Float>()
        self.closeEvent = Event<Void>()
    }
        
    // MARK: Inputs
    
    func startRecording() {
        
        speechService.checkAuthorization { [weak self] didAllow in
            if didAllow {
                self?.speechService.recordSpeech { speechText in
                    self?.speechTextChangeEvent.raise(speechText)
                } audioLevelUpdate: { audioLevel in
                    self?.volumeLevel.raise(audioLevel)
                }

            }
        }
    }
    
    func stopRecording() {
        speechService.stopRecord()
    }
    
    func saveTask(taskTitle: String) {
        if !taskTitle.trimmingCharacters(in: .whitespaces).isEmpty {
            var newTask = Task()
            newTask.title = taskTitle
            newTask.taskDate = taskDate ?? Date()
            
            if let shortcutUID = shortcutUID {
                newTask.shortcut = dataSource.shortcutModelByIdentifier(identifier: shortcutUID)
            }
            
            dataSource.addTask(from: newTask)
            spotlightService.addTask(task: newTask)
        }
        
        speechService.stopRecord()
    }
    
    func setShortcut(uid: String) {
        shortcutUID = uid
    }
    
    func cancelTask() {
        speechService.stopRecord()
    }
    
    func setSpeechPermissionDontAllowHandler(handler: (() -> ())?) {
        onDoNotAllowSpeech = handler
    }
    
    func setTaskDate(date: Date?) {
        taskDate = date
    }
    
    // MARK: Outputs
    
    var speechTextChangeEvent: Event<String>
    var volumeLevel: Event<Float>
    var closeEvent: Event<Void>
    
}

