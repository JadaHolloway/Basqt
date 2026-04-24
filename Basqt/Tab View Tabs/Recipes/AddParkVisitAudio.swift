//
//  AddParkVisitAudio.swift
//  NationalParks
//
//  Created by Osman Balci on 3/24/26.
//  Copyright © 2026 Osman Balci. All rights reserved.
//

import SwiftUI
import SwiftData
import AVFoundation

fileprivate var audioSession = AVAudioSession()
fileprivate var audioRecorder: AVAudioRecorder!
fileprivate var temporaryVoiceRecordingFilename = ""

struct AddParkVisitAudio: View {
    
    // Input Parameter
    let parkVisit: ParkVisit
    
    // Enable this view to be dismissed to go back to the previous view
    @Environment(\.dismiss) private var dismiss
    
    @Environment(\.modelContext) private var modelContext
    
    //---------------------------------------------------
    // National Park Visit Notes Taken by Voice Recording
    //---------------------------------------------------
    @State private var recordingVoice = false
    
    //--------------
    // Alert Message
    //--------------
    @State private var showAlertMessage = false
    
    var body: some View {

        Form {
            Section(header: Text("Take Notes by Recording Your Voice")) {
                HStack {
                    Spacer()
                    Button(action: {
                        Task {
                            await voiceRecordingMicrophoneTapped()
                        }
                    }) {
                        voiceRecordingMicrophoneLabel
                    }
                    Spacer()
                }
            }
        }   // End of Form
        .font(.system(size: 14))
        .textFieldStyle(RoundedBorderTextFieldStyle())
        .navigationTitle("Add New Park Visit Audio")
        .toolbarTitleDisplayMode(.inline)
        .toolbar {
            // Place the Save button on right side of the toolbar
            ToolbarItem(placement: .topBarTrailing) {
                Button("Save") {
                    if inputDataValidated() {
                        saveNewParkVisitAudio()
                        
                        showAlertMessage = true
                        alertTitle = "New Park Visit Audio Saved!"
                        alertMessage = "Your new park visit audio is successfully saved in the database!"
                    } else {
                        showAlertMessage = true
                        alertTitle = "Missing Input Data!"
                        alertMessage = "You must first record your voice to save it in database."
                    }
                }
            }
        }   // End of toolbar
    
        .alert(alertTitle, isPresented: $showAlertMessage, actions: {
            Button("OK") {
                if alertTitle == "New Park Visit Audio Saved!" {
                    // Dismiss this view and go back to the previous view
                    dismiss()
                }
            }
        }, message: {
            Text(alertMessage)
        })
  
    }   // end of body var
    
    /*
     ---------------------------
     MARK: Input Data Validation
     ---------------------------
     */
    func inputDataValidated() -> Bool {
        
        if temporaryVoiceRecordingFilename.isEmpty {
            return false
        }
        
        return true
    }
    
    /*
     ***************************************************************
     *              Take Notes by Recording Your Voice             *
     ***************************************************************
     */
    
    /*
     --------------------------------------
     MARK: Voice Recording Microphone Label
     --------------------------------------
     */
    var voiceRecordingMicrophoneLabel: some View {
        VStack {
            Image(systemName: recordingVoice ? "mic.fill" : "mic.slash.fill")
                .imageScale(.large)
                .font(Font.title.weight(.medium))
                .foregroundColor(.blue)
            Text(recordingVoice ? "Recording your voice... Tap to Stop!" : "Start Recording!")
                .multilineTextAlignment(.center)
        }
    }
    
    /*
     ---------------------------------------
     MARK: Voice Recording Microphone Tapped
     ---------------------------------------
     */
    func voiceRecordingMicrophoneTapped() async {
        if audioRecorder == nil {
            recordingVoice = true
            Task {
                await startRecording()
            }
        } else {
            recordingVoice = false
            finishRecording()
        }
    }
    
    /*
     ---------------------------------
     MARK: Start Voice Notes Recording
     ---------------------------------
     */
    func startRecording() async {

        // Create a shared audio session instance
        audioSession = AVAudioSession.sharedInstance()
        
        //---------------------------
        // Enable Built-In Microphone
        //---------------------------
        
        // Find the built-in microphone.
        guard let availableInputs = audioSession.availableInputs,
              let builtInMicrophone = availableInputs.first(where: { $0.portType == .builtInMic })
        else {
            print("The device must have a built-in microphone.")
            return
        }
        
        do {
            try audioSession.setPreferredInput(builtInMicrophone)
        } catch {
            fatalError("Unable to Find the Built-In Microphone!")
        }
        
        //--------------------------------------------------
        // Set Audio Session Category and Request Permission
        //--------------------------------------------------
        
        do {
            try audioSession.setCategory(.playAndRecord, mode: .default)
            
            // Activate the audio session
            try audioSession.setActive(true)
        } catch {
            print("Setting category or getting permission failed!")
        }

        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        temporaryVoiceRecordingFilename = "voiceRecording.m4a"
        let audioFilenameUrl = documentDirectory.appendingPathComponent(temporaryVoiceRecordingFilename)
        
        Task {
            // Request permission to record user's voice
            if await AVAudioApplication.requestRecordPermission() {
                // The user grants access. Present recording interface.
                do {
                    audioRecorder = try AVAudioRecorder(url: audioFilenameUrl, settings: settings)
                    audioRecorder.record()
                } catch {
                    finishRecording()
                }
            } else {
                /*
                 The user earlier denied use of microphone. Present a message
                 indicating that the user can change the microphone use permission
                 in the Privacy & Security section of the Settings app.
                 */
                showAlertMessage = true
                alertTitle = "Voice Recording Unallowed"
                alertMessage = "Allow recording of your voice in Privacy & Security section of the Settings app."
            }
        }
    }
    
    /*
     ----------------------------------
     MARK: Finish Voice Notes Recording
     ----------------------------------
     */
    func finishRecording() {
        audioRecorder.stop()
        audioRecorder = nil
        recordingVoice = false
    }
    
    /*
     ****************************************
     MARK: Save New National Park Visit Audio
     ****************************************
     */
    func saveNewParkVisitAudio() {
        
        // Obtain the current date and time
        let currentDateAndTime = Date()
         
        // Create an instance of DateFormatter
        let dateFormatter = DateFormatter()
         
        // Set the date format to yyyy-MM-dd at HH:mm:ss
        dateFormatter.dateFormat = "yyyy-MM-dd' at 'HH:mm:ss"
         
        // Format dateAndTime under the dateFormatter and convert it to String
        let audioDateAndTimeString = dateFormatter.string(from: currentDateAndTime)
        
        //----------------------------------------------------------------
        // Rename the temporary voice recording file in document directory
        //----------------------------------------------------------------
        
        let audioFullFilename = UUID().uuidString + ".m4a"
        
        let temporaryFile = documentDirectory.appendingPathComponent(temporaryVoiceRecordingFilename)
        let finalFile = documentDirectory.appendingPathComponent(audioFullFilename)
        
        do {
            try FileManager.default.moveItem(at: temporaryFile, to: finalFile)
        } catch {
            fatalError("Unable to rename the temporary voice recording file in document directory")
        }
        
        let newParkVisitAudio = ParkVisitAudio(audioFullFilename: audioFullFilename, dateTime: audioDateAndTimeString)
        
        // ❎ Insert it into the database context
        modelContext.insert(newParkVisitAudio)
        
        parkVisit.parkVisitAudios?.append(newParkVisitAudio)

    }   // End of function
    
}

