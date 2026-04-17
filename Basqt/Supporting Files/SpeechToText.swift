//
//  SpeechToText.swift
//  NationalParks
//
//  Created by Osman Balci on 3/24/26.
//  Copyright © 2026 Osman Balci. All rights reserved.
//

import SwiftUI
// Speech framework is used to recognize spoken words in recorded or live audio.
import Speech
import AVFoundation

// Global Constants
let audioEngine = AVAudioEngine()
let request = SFSpeechAudioBufferRecognitionRequest()

/*
 Set up Speech Recognizer object with selected language as English U.S. dialect.
 You can select one of more than 50 languages and dialects for speech recognition.
 Some of the English language dialects:
   English (Australia):         en-AU
   English (Ireland):           en-IE
   English (South Africa):      en-ZA
   English (United Kingdom):    en-GB
   English (United States):     en-US
 */
let speechRecognizer = SFSpeechRecognizer(locale: Locale.init(identifier: "en-US"))!

// Global Variable
var recognitionTask: SFSpeechRecognitionTask?

/*
 Built-in speech transcription system allows conversion of any audio recording into a text stream.
 Add a key to Info.plist called "Privacy - Speech Recognition Usage Description" with String value
 describing what you intend to do with the transcriptions.
 */
public func getPermissionForSpeechRecognition() {
    SFSpeechRecognizer.requestAuthorization { authStatus in
        DispatchQueue.main.async {
            
            if authStatus == .authorized {
                // The value is recorded in the Settings app
            } else {
                // The value is recorded in the Settings app
            }
        }
    }
}


