//
//  OnBoardingSpeechViewModel.swift
//  DoTask
//
//  Created by Sergio Lechini on 14.06.2021.
//  Copyright © 2021 itotdel. All rights reserved.
//

import Foundation
import Speech

protocol OnBoardingSpeechViewModelInputs {
    func allowSpeech()
}

protocol OnBoardingSpeechViewModelOutputs {
    var lottieAnimationName: String { get }
    var mainText: LocalizableStringResource { get }
    var hideAllowBtnAfterCheckEvent: Event<Void> { get }
}

protocol OnBoardingSpeechViewModelType: AnyObject {
    var inputs: OnBoardingSpeechViewModelInputs { get }
    var outputs: OnBoardingSpeechViewModelOutputs { get }
}

final class OnBoardingSpeechViewModel: OnBoardingSpeechViewModelType, OnBoardingSpeechViewModelInputs, OnBoardingSpeechViewModelOutputs, OnBoardingScreenType {
    
    var inputs: OnBoardingSpeechViewModelInputs { return self }
    var outputs: OnBoardingSpeechViewModelOutputs { return self }
        
    private var onDoNotAllowSpeech: (()->())?
    
    init(lottieAnimationName: String, mainText: LocalizableStringResource, onDoNotAllowNotifyHandler: (()->())?) {
        self.lottieAnimationName = lottieAnimationName
        self.mainText = mainText
        self.hideAllowBtnAfterCheckEvent = Event<Void>()
        self.onDoNotAllowSpeech = onDoNotAllowNotifyHandler
    }
    
    // MARK: Inputs
    
    func allowSpeech() {
        SFSpeechRecognizer.requestAuthorization { [weak self] requestStatus in
            guard let strongSelf = self else { return }
            if requestStatus == .authorized {
                strongSelf.checkPermission()
            } else {
                DispatchQueue.main.async {
                    if let action = strongSelf.onDoNotAllowSpeech {
                        action()
                    }
                }
            }
        }
    }
        
    // MARK: Outputs
    
    var lottieAnimationName: String
    var mainText: LocalizableStringResource
    
    var hideAllowBtnAfterCheckEvent: Event<Void>
}

private extension OnBoardingSpeechViewModel {
    func checkPermission() {
        switch AVAudioSession.sharedInstance().recordPermission {
        case .undetermined:
            allowMicrophone()
        case .denied:
            allowMicrophone()
            
        case .granted:
            DispatchQueue.main.async {
                self.hideAllowBtnAfterCheckEvent.raise()
            }
        @unknown default:
            DispatchQueue.main.async {
                self.hideAllowBtnAfterCheckEvent.raise()
            }
        }
    }
    
    func allowMicrophone() {
        let recordingSession = AVAudioSession.sharedInstance()
        recordingSession.requestRecordPermission() { [unowned self] allowed in
            DispatchQueue.main.async {
                if allowed {
                    self.hideAllowBtnAfterCheckEvent.raise()
                } else {
                    if let action = self.onDoNotAllowSpeech {
                        action()
                    }
                }
            }
        }
    }
}
