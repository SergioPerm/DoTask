//
//  SpeechTaskViewModel.swift
//  Tasker
//
//  Created by KLuV on 09.03.2021.
//  Copyright © 2021 itotdel. All rights reserved.
//

import Foundation
import Speech

class SpeechTaskViewModel: SpeechTaskViewModelType, SpeechTaskViewModelInputs, SpeechTaskViewModelOutputs {
    
    private let dataSource: TaskListDataSource
    
    // MARK: Audio
    private var recordQueue: DispatchQueue?
    
    private var audioEngine: AVAudioEngine?
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private var inputNode: AVAudioInputNode?
    
    private var speechSentenses: [String] = []
    
    var inputs: SpeechTaskViewModelInputs { return self }
    var outputs: SpeechTaskViewModelOutputs { return self }
    
    init(dataSource: TaskListDataSource) {
        self.dataSource = dataSource
        self.speechTextChangeEvent = Event<String>()
        self.volumeLevel = Event<Float>()
    }
    
    deinit {
        print("test")
    }
    
    // MARK: Inputs
    
    func startRecording() {
        
        SFSpeechRecognizer.requestAuthorization { requestStatus in
            
            switch requestStatus {
            case .authorized:
                print("ZBS")
            case .denied:
                print("speech denied")
            case .notDetermined:
                print("not determined")
            case .restricted:
                print("restricted")
            @unknown default:
                print("default")
            }
            
        }
        
        
        recordQueue = DispatchQueue(label: "audio.cocurent.queue", qos: .userInteractive, attributes: .concurrent)
        
        recordQueue?.async { [unowned self] in
            self.record()
        }
    }
    
    func saveTask(taskTitle: String) {
        var newTask = Task()
        newTask.title = taskTitle
        newTask.taskDate = Date()

        dataSource.addTask(from: newTask)
        
        stopAudio()
    }
    
    func cancelTask() {
        stopAudio()
    }
    
    // MARK: Outputs
    
    var speechTextChangeEvent: Event<String>
    var volumeLevel: Event<Float>
    
}

extension SpeechTaskViewModel {
    
    private func stopAudio() {
        recordQueue?.sync { [unowned self] in
            self.recognitionRequest?.endAudio()
            self.recognitionTask?.finish()
            self.recognitionRequest = nil
            self.recognitionTask = nil
            self.audioEngine?.inputNode.removeTap(onBus: 0)
            self.audioEngine?.stop()
            self.audioEngine = nil
        }
    }
    
    private func getFullSpeechText() -> String {
        var fullText = ""
        speechSentenses.forEach({
            fullText += " \($0)"
        })
        
        return fullText
    }
    
    private func getVolume(from buffer: AVAudioPCMBuffer, bufferSize: Int) -> Float {
        guard let channelData = buffer.floatChannelData?[0] else {
            return 0
        }

        let channelDataArray = Array(UnsafeBufferPointer(start:channelData, count: bufferSize))

        var outEnvelope = [Float]()
        var envelopeState:Float = 0
        let envConstantAtk:Float = 0.16
        let envConstantDec:Float = 0.003

        for sample in channelDataArray {
            let rectified = abs(sample)

            if envelopeState < rectified {
                envelopeState += envConstantAtk * (rectified - envelopeState)
            } else {
                envelopeState += envConstantDec * (rectified - envelopeState)
            }
            outEnvelope.append(envelopeState)
        }

        // 0.007 is the low pass filter to prevent
        // getting the noise entering from the microphone
        if let maxVolume = outEnvelope.max(),
            maxVolume > Float(0.01) {
            return maxVolume
        } else {
            return 0.0
        }
    }
    
    private func record() {
        
        if audioEngine == nil {
            audioEngine = AVAudioEngine()
        }
        
        inputNode = audioEngine?.inputNode
        
        recognitionTask?.cancel()
        
        let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "ru_RU"))
        
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        
        let audioSession = AVAudioSession.sharedInstance()
        
        do {
            try audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
        } catch {
            print(error.localizedDescription)
        }
        
        do {
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            print(error.localizedDescription)
        }
                
        audioEngine?.inputNode.removeTap(onBus: AVAudioNodeBus(0))
               
        
        let recordingFormat = inputNode?.inputFormat(forBus: 0)
        
        audioEngine?.inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { [weak self] (buffer: AVAudioPCMBuffer, when: AVAudioTime) in
            self?.recognitionRequest?.append(buffer)
            
            let level = self?.getVolume(from: buffer, bufferSize: 1024)

            if let level = level {
                DispatchQueue.main.async {
                    self?.volumeLevel.raise(level)
                }
            }
        }

        audioEngine?.prepare()
        
        do {
            try audioEngine?.start()
        } catch {
            print(error.localizedDescription)
        }
        
        guard let recognitionRequest = recognitionRequest else { fatalError("Unable to create a SFSpeechAudioBufferRecognitionRequest object") }
        recognitionRequest.shouldReportPartialResults = true
        
        if #available(iOS 13, *) {
            if speechRecognizer?.supportsOnDeviceRecognition ?? false{
                recognitionRequest.requiresOnDeviceRecognition = true
            }
        }
                        
        recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest) { [weak self] result, error in
            
            guard let result = result else { return }
            guard let strongSelf = self else { return }
            
            let bestTranscription = result.bestTranscription
            let transcribedString = result.bestTranscription.formattedString
            
            var confidence: Float = 0.0
            if bestTranscription.segments.count > 0 {
                confidence = result.bestTranscription.segments[0].confidence
            }
            
            if !strongSelf.speechSentenses.isEmpty {
                var currentSentese = strongSelf.speechSentenses.removeLast()
                currentSentese = transcribedString
                strongSelf.speechSentenses.append(currentSentese)

                if confidence > 0.1 {
                    strongSelf.speechSentenses.append("")
                }
            } else {
                strongSelf.speechSentenses.append(transcribedString)
            }

            let speechText = strongSelf.getFullSpeechText()
            
            DispatchQueue.main.async {
                self?.speechTextChangeEvent.raise(speechText)
            }
            
            if error != nil {
                self?.recognitionTask?.finish()
                self?.inputNode?.removeTap(onBus: 0)
                self?.audioEngine?.stop()
                self?.recognitionRequest = nil
            }
        }
    }
}
