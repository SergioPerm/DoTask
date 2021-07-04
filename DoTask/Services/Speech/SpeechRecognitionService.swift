//
//  SpeechRecognitionService.swift
//  DoTask
//
//  Created by Sergio Lechini on 04.07.2021.
//  Copyright © 2021 itotdel. All rights reserved.
//

import Foundation
import Speech

protocol SpeechRecognitionServiceType {
    func recordSpeech(speechTextUpdate: @escaping (_ speechText: String) -> (), audioLevelUpdate: @escaping (_ level: Float) -> ())
    func stopRecord()
    func checkAuthorization(completion: ((_ didAllow: Bool) -> ())?)
}

final class SpeechRecognitionService {
    
    private var audioEngine: AVAudioEngine?
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private var inputNode: AVAudioInputNode?
    
    private var speechSentenses: [String] = []
    
    private var speechTextUpdateHandler: ((String) -> ())?
    private var audioLevelUpdateHandler: ((Float) -> ())?
    
}

private extension SpeechRecognitionService {
    func getFullSpeechText() -> String {
        var fullText = ""
        speechSentenses.forEach({
            fullText += " \($0)"
        })
        
        return fullText
    }
    
    func getVolume(from buffer: AVAudioPCMBuffer, bufferSize: Int) -> Float {
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
}

extension SpeechRecognitionService: SpeechRecognitionServiceType {
    func recordSpeech(speechTextUpdate: @escaping (String) -> (), audioLevelUpdate: @escaping (Float) -> ()) {
        speechTextUpdateHandler = speechTextUpdate
        audioLevelUpdateHandler = audioLevelUpdate
        
        if audioEngine == nil {
            audioEngine = AVAudioEngine()
        }
                
        inputNode = audioEngine?.inputNode
        
        recognitionTask?.cancel()
        
        let localizeService: LocalizeServiceType = AppDI.resolve()
        
        let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: localizeService.currentLocal?.rawValue ?? "en"))
        
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
                DispatchQueue.main.async { [weak self] in
                    if let levelHandler = self?.audioLevelUpdateHandler {
                        levelHandler(level)
                    }
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
            if !bestTranscription.segments.isEmpty {
                confidence = result.bestTranscription.segments[0].confidence
            }
            
            print(confidence)
            if !strongSelf.speechSentenses.isEmpty {
                var currentSentese = strongSelf.speechSentenses.removeLast()
                currentSentese = transcribedString
                strongSelf.speechSentenses.append(currentSentese)
            } else {
                strongSelf.speechSentenses.append(transcribedString)
            }

            let speechText = strongSelf.getFullSpeechText()
            
            print(speechText)
            DispatchQueue.main.async { [weak self] in
                if let speechHandler = self?.speechTextUpdateHandler {
                    speechHandler(speechText.trimmingCharacters(in: .whitespaces))
                }
            }
            
            if error != nil {
                self?.recognitionTask?.finish()
                self?.inputNode?.removeTap(onBus: 0)
                self?.audioEngine?.stop()
                self?.recognitionRequest = nil
            }
        }
    }
        
    func stopRecord() {
        recognitionRequest?.endAudio()
        recognitionTask?.finish()
        recognitionRequest = nil
        recognitionTask = nil
        audioEngine?.inputNode.removeTap(onBus: 0)
        audioEngine?.stop()
        audioEngine = nil
    }
    
    func checkAuthorization(completion: ((_ didAllow: Bool) -> ())? = nil) {
        switch SFSpeechRecognizer.authorizationStatus() {
        case .authorized:
            requestAudioPermission(completion: completion)
        case .denied:
            requestAudioPermission(completion: completion)
        case .notDetermined:
            requestAudioPermission(completion: completion)
        case .restricted:
            if let completion = completion {
                completion(false)
            }
        @unknown default:
            if let completion = completion {
                completion(false)
            }
        }
    }
    
    func requestAudioPermission(completion: ((_ didAllow: Bool) -> ())?) {
        SFSpeechRecognizer.requestAuthorization { [weak self] requestStatus in
            guard let strongSelf = self else { return }
            if requestStatus == .authorized {
                strongSelf.allowMicrophone { allow in
                    DispatchQueue.main.async {
                        if let completion = completion {
                            completion(allow)
                        }
                    }
                }
            } else {
                DispatchQueue.main.async {
                    if let completion = completion {
                        completion(false)
                    }
                }
            }
        }
    }
    
    func allowMicrophone(_ completion: @escaping (_ didAllow: Bool) -> ()) {
        let recordingSession = AVAudioSession.sharedInstance()
        recordingSession.requestRecordPermission() { allowed in
            completion(allowed)
        }
    }
}
