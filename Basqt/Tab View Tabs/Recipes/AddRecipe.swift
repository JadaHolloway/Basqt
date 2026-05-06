//
//  AddRecipe.swift
//  Basqt
//
//  Created by Osman Balci and Micki Ross on 4/26/26.
//  Copyright © 2026 Osman Balci, Micki Ross, Jada Holloway, Jonathan Hernandez Velasquez. All rights reserved.
//

import SwiftUI
import SwiftData
import AVFoundation
import Speech

fileprivate var audioSession = AVAudioSession()
fileprivate var audioRecorder: AVAudioRecorder!
fileprivate var temporaryVoiceRecordingFilename = ""

struct AddRecipe: View {

    // Enable this view to be dismissed to go back to the previous view
    @Environment(\.dismiss) private var dismiss
    
    @Environment(\.modelContext) private var modelContext
    let audioFullFilename = UUID().uuidString + ".m4a"
    
    //---------------------------
    // National Park Visit Object
    //---------------------------
    @State private var recipeName = ""
    @State private var briefDesctiption = ""
    @State private var ingredients = ""
    @State private var dietaryTags = ""
    @State private var caloriesText = ""
    @State private var voiceMemoTitle = ""
    @State private var recordingVoice = false

    
    //------------------------------------
    // Image Picker from Camera or Library
    //------------------------------------
    @State private var showImagePicker = false
    @State private var pickedUIImage: UIImage?
    @State private var pickedImage: Image?
    
    @State private var useCamera = false
    @State private var usePhotoLibrary = true
    
    //-------------------------------------------------------------
    // National Park Visit Notes Taken by Speech to Text Conversion
    //-------------------------------------------------------------
    @State private var recordingVoiceToText = false
    @State private var speechConvertedToText = ""
    
    //--------------
    // Alert Message
    //--------------
    @State private var showAlertMessage = false

    var body: some View {
      
        let camera = Binding(
            get: { useCamera },
            set: {
                useCamera = $0
                if $0 == true {
                    usePhotoLibrary = false
                }
            }
        )
        let photoLibrary = Binding(
            get: { usePhotoLibrary },
            set: {
                usePhotoLibrary = $0
                if $0 == true {
                    useCamera = false
                }
            }
        )
        
        Form {
            Section(header: Text("Recipe Name")) {
                TextField("Enter Recipe Name", text: $recipeName)
            }
            Section(header: Text("Recipe Description")) {
                TextField("Enter Brief Description", text: $briefDesctiption)
            }
            Section(header: Text("Calories")) {
                TextField("Enter Total Calories", text: $caloriesText)
            }
            Section(header: Text("Dietary Tags")) {
                TextField("Enter Dietary Tags", text: $dietaryTags)
            }
            Section(header: Text("Ingredients")) {
                TextField("Enter Ingredients", text: $ingredients)
            }
            
            
            Section(header: Text("Take Notes by Converting Your Speech to Text")
                .fixedSize(horizontal: false, vertical: true)   // Allow lines to wrap around
                .padding(.bottom, 8)
            ) {
                HStack {
                    Spacer()
                    Button(action: {
                        speechConvertedToText = ""
                        speechToTextMicrophoneTapped()
                    }) {
                        speechToTextMicrophoneLabel
                    }
                    Spacer()
                }
            }
            if !speechConvertedToText.isEmpty {
                Section(header: Text("Speech Converted to Text")) {
                    Text(speechConvertedToText)
                        .multilineTextAlignment(.leading)
                        // vertical=true enables the text to wrap around on multiple lines
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
            Section(header: Text("Take or Pick Photo")) {
                VStack {
                    Toggle("Use Camera", isOn: camera)
                    Toggle("Use Photo Library", isOn: photoLibrary)
                    
                    Button("Get Photo") {
                        showImagePicker = true
                    }
                    .tint(.blue)
                    .buttonStyle(.bordered)
                    .buttonBorderShape(.capsule)
                }
            }
            if pickedImage != nil {
                Section(header: Text("Taken or Picked Photo")) {
                    pickedImage?
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100.0, height: 100.0)
                }
            }
            
        }   // End of Form
        .font(.system(size: 14))
        .textFieldStyle(RoundedBorderTextFieldStyle())
        .navigationTitle("Add New Recipe")
        .toolbarTitleDisplayMode(.inline)
        .toolbar {
            // Place the Save button on right side of the toolbar
            ToolbarItem(placement: .topBarTrailing) {
                Button("Save") {
                    if inputDataValidated() {
                        saveNewRecipe()
                        
                        showAlertMessage = true
                        alertTitle = "New Recipe Saved!"
                        alertMessage = "Your new recipe is successfully saved in the database!"
                    } else {
                        showAlertMessage = true
                        alertTitle = "Missing Input Data!"
                        alertMessage = "Required Data: Recipe name, ingredients, and calories."
                            //not sure if this is true
                    }
                }
            }
        }   // End of toolbar
    
        .onDisappear() {
            speechConvertedToText = ""
        }
    
        .alert(alertTitle, isPresented: $showAlertMessage, actions: {
            Button("OK") {
                if alertTitle == "New Recipe Saved!" {
                    // Dismiss this view and go back to the previous view
                    dismiss()
                }
            }
        }, message: {
            Text(alertMessage)
        })
    
        .onChange(of: pickedUIImage) {
            guard let uiImagePicked = pickedUIImage else { return }
            
            // Convert UIImage to SwiftUI Image
            pickedImage = Image(uiImage: uiImagePicked)
        }
        
        .sheet(isPresented: $showImagePicker) {
            
            ImagePicker(uiImage: $pickedUIImage, sourceType: useCamera ? .camera : .photoLibrary, imageWidth: 200.0, imageHeight: 200.0)
        }
        
    }   // End of body var
    
    func inputDataValidated() -> Bool {
        
        if recipeName.isEmpty || ingredients.isEmpty || caloriesText.isEmpty {
            return false
        }
        
        return true
    }
    var speechToTextMicrophoneLabel: some View {
        VStack {
            Image(systemName: recordingVoiceToText ? "mic.fill" : "mic.slash.fill")
                .imageScale(.large)
                .font(Font.title.weight(.medium))
                .foregroundColor(.blue)
            Text(recordingVoiceToText ? "Recording your voice... Tap to Stop!" : "Convert Speech to Text!")
                .multilineTextAlignment(.center)
        }
    }
    func speechToTextMicrophoneTapped() {
        if recordingVoiceToText {
            cancelSpeechToTextRecording()
            recordingVoiceToText = false
        } else {
            recordingVoiceToText = true
            recordAndRecognizeSpeech()
        }
    }
  
    func cancelSpeechToTextRecording() {
        request.endAudio()
        audioEngine.inputNode.removeTap(onBus: 0)
        audioEngine.stop()
        recognitionTask?.finish()
    }
    func recordAndRecognizeSpeech() {
        let request = SFSpeechAudioBufferRecognitionRequest()
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
        
        //--------------------
        // Set up Audio Buffer
        //--------------------
        let node = audioEngine.inputNode
        let recordingFormat = node.outputFormat(forBus: 0)
        node.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, _ in
            request.append(buffer)
        }
        
        //---------------------
        // Prepare Audio Engine
        //---------------------
        audioEngine.prepare()
        
        //-------------------
        // Start Audio Engine
        //-------------------
        do {
            try audioEngine.start()
        } catch {
            print("Unable to start Audio Engine!")
            return
        }
        
        SFSpeechRecognizer.requestAuthorization { authStatus in
            DispatchQueue.main.async {
                
                if authStatus == .authorized {
                    //-------------------------------
                    // Convert recorded voice to text
                    //-------------------------------
                    recognitionTask = speechRecognizer.recognitionTask(with: request, resultHandler: { result, error in
                        
                        if result != nil {  // check to see if result is empty (i.e. no speech found)
                            if let resultObtained = result {
                                let bestString = resultObtained.bestTranscription.formattedString
                                speechConvertedToText = bestString
                                
                            } else if let error = error {
                                print("Transcription failed, but will continue listening and try to transcribe. See \(error)")
                            }
                        }
                    })
                } else {
                    /*
                     The user earlier denied speech recognition. Present a message
                     indicating that the user can change speech recognition permission
                     in the Privacy & Security section of the Settings app.
                     */
                    showAlertMessage = true
                    alertTitle = "Speech Recognition Unallowed"
                    alertMessage = "Allow speech recognition in Privacy & Security section of the Settings app."
                }
            }
        }
    }
    

    func saveNewRecipe() {

        //--------------------------------------------------
        // Store Taken or Picked Photo to Document Directory
        //--------------------------------------------------
        
        let photoFullFilename = UUID().uuidString + ".jpg"
        
        if let photoData = pickedUIImage {
            if let jpegData = photoData.jpegData(compressionQuality: 1.0) {
                let fileUrl = documentDirectory.appendingPathComponent(photoFullFilename)
                try? jpegData.write(to: fileUrl)
            }
        } else {
            fatalError("Picked or taken photo is not available!")
        }
        /*let newAudioFullFilename = UUID().uuidString + ".m4a"
        let temporaryFile = documentDirectory.appendingPathComponent(temporaryVoiceRecordingFilename)
        let finalFile = documentDirectory.appendingPathComponent(newAudioFullFilename)
        do {
            try FileManager.default.moveItem(at: temporaryFile, to: finalFile)
        } catch {
            fatalError("Unable to rename the temporary voice recording file in document directory")
        }*/
        
        let newRecipe = Recipe(name: recipeName, briefDescription: briefDesctiption, ingredients: ingredients, notes: speechConvertedToText, calories: Int(caloriesText) ?? 0, dietaryTags: dietaryTags, photoFullFilename: photoFullFilename, audioFullFilename: audioFullFilename)//newaudiofilename
        
        // ❎ Insert it into the database context
        modelContext.insert(newRecipe)
    }   // End of func saveNewParkVisit()
}

