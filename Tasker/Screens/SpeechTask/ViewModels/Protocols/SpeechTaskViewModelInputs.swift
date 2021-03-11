//
//  SpeechTaskViewModelInputs.swift
//  Tasker
//
//  Created by KLuV on 09.03.2021.
//  Copyright © 2021 itotdel. All rights reserved.
//

import Foundation

protocol SpeechTaskViewModelInputs {
    func startRecording()
    func saveTask(taskTitle: String)
    func cancelTask()
}
