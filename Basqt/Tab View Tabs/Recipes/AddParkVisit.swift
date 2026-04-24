//
//  AddParkVisit.swift
//  NationalParks
//
//  Created by Osman Balci on 3/24/26.
//  Copyright © 2026 Osman Balci. All rights reserved.
//

import SwiftUI
import SwiftData
import CoreLocation
import Speech
import AVFoundation

fileprivate var audioSession = AVAudioSession()
fileprivate var audioRecorder: AVAudioRecorder!
fileprivate var temporaryVoiceRecordingFilename = ""

struct AddParkVisit: View {

    // Enable this view to be dismissed to go back to the previous view
    @Environment(\.dismiss) private var dismiss
    
    @Environment(\.modelContext) private var modelContext
    
    //---------------------------
    // National Park Visit Object
    //---------------------------
    @State private var dateVisited = Date()
    @State private var fullName = ""
    @State private var selectedRatingIndex = 3  // Default: "Very Good"
    @State private var states = ""
    
    //------------------------------------
    // Image Picker from Camera or Library
    //------------------------------------
    @State private var showImagePicker = false
    @State private var pickedUIImage: UIImage?
    @State private var pickedImage: Image?
    
    @State private var useCamera = false
    @State private var usePhotoLibrary = true
    
    //---------------------------------------------------
    // National Park Visit Notes Taken by Voice Recording
    //---------------------------------------------------
    @State private var recordingVoice = false
    
    //-------------------------------------------------------------
    // National Park Visit Notes Taken by Speech to Text Conversion
    //-------------------------------------------------------------
    @State private var recordingVoiceToText = false
    @State private var speechConvertedToText = ""
    
    //--------------
    // Alert Message
    //--------------
    @State private var showAlertMessage = false
    
    //------------------
    // Date Closed Range
    //------------------
    var dateClosedRange: ClosedRange<Date> {
        // Set minimum date to 20 years earlier than the current year
        let minDate = Calendar.current.date(byAdding: .year, value: -20, to: Date())!
        
        // Set maximum date to 2 years later than the current year
        let maxDate = Calendar.current.date(byAdding: .year, value: 2, to: Date())!
        return minDate...maxDate
    }
    
    var body: some View {
        /*
         Create Binding between 'useCamera' and 'usePhotoLibrary' boolean @State variables so that only one of them can be true.
         get
            A closure that retrieves the binding value. The closure has no parameters.
         set
            A closure that sets the binding value. The closure has the following parameter:
            newValue stored in $0: The new value of 'useCamera' or 'usePhotoLibrary' boolean variable as true or false.
         
         Custom get and set closures are run when a newValue is obtained from the Toggle when it is turned on or off.
         */
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
            Section(header: Text("National Park Full Name")) {
                TextField("Enter national park full name", text: $fullName)
            }
            Section(header: Text("Date Visited National Park")) {
                DatePicker(
                    selection: $dateVisited,
                    in: dateClosedRange,
                    displayedComponents: .date) {
                        Text("Date Visited")
                    }
            }
            Section(header: Text("My Rating of the National Park Visit")) {
                Picker("", selection: $selectedRatingIndex) {
                    // ratingChoices are defined in GlobalConstants.swift
                    ForEach(0 ..< ratingChoices.count, id: \.self) {
                        Text(ratingChoices[$0])
                    }
                }
            }
            Section(header: Text("National Park State Names")) {
                TextField("Enter national park's state names", text: $states)
            }
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
        .navigationTitle("Add New National Park Visit")
        .toolbarTitleDisplayMode(.inline)
        .toolbar {
            // Place the Save button on right side of the toolbar
            ToolbarItem(placement: .topBarTrailing) {
                Button("Save") {
                    if inputDataValidated() {
                        saveNewParkVisit()
                        
                        showAlertMessage = true
                        alertTitle = "New National Park Visit Saved!"
                        alertMessage = "Your new national park visit is successfully saved in the database!"
                    } else {
                        showAlertMessage = true
                        alertTitle = "Missing Input Data!"
                        alertMessage = "Required Data: national park full name, states, and speech converted to text."
                    }
                }
            }
        }   // End of toolbar
    
        .onDisappear() {
            speechConvertedToText = ""
        }
    
        .alert(alertTitle, isPresented: $showAlertMessage, actions: {
            Button("OK") {
                if alertTitle == "New National Park Visit Saved!" {
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
            /*
             For storage and performance efficiency reasons, we scale down the photo image selected from the
             photo library or taken by the camera to a smaller size with imageWidth and imageHeight in points.
             
             For high-resolution displays, 1 point = 3 pixels
             
             We use a square aspect ratio 1:1 for album cover photos with imageWidth = imageHeight = 200.0 points.
             
             You can select imageWidth and imageHeight values for other aspect ratios such as 4:3 or 16:9.
             
             imageWidth = 200.0 points and imageHeight = 200.0 points will produce an image with
             imageWidth = 600.0 pixels and imageHeight = 600.0 pixels which is about 84KB to 164KB in JPG format.
             */
            
            ImagePicker(uiImage: $pickedUIImage, sourceType: useCamera ? .camera : .photoLibrary, imageWidth: 200.0, imageHeight: 200.0)
        }
        
    }   // End of body var
    
    /*
     ---------------------------
     MARK: Input Data Validation
     ---------------------------
     */
    func inputDataValidated() -> Bool {
        
        if fullName.isEmpty || states.isEmpty || speechConvertedToText.isEmpty {
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
     ***************************************************************
     *        Take Notes by Converting Your Speech to Text         *
     ***************************************************************
     */
    
    /*
     -------------------------------------
     MARK: Speech to Text Microphone Label
     -------------------------------------
     */
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
    
    /*
     --------------------------------------
     MARK: Speech to Text Microphone Tapped
     --------------------------------------
     */
    func speechToTextMicrophoneTapped() {
        if recordingVoiceToText {
            cancelSpeechToTextRecording()
            recordingVoiceToText = false
        } else {
            recordingVoiceToText = true
            recordAndRecognizeSpeech()
        }
    }
    
    /*
     -------------------------------------
     MARK: Cancel Speech to Text Recording
     -------------------------------------
     */
    func cancelSpeechToTextRecording() {
        request.endAudio()
        audioEngine.inputNode.removeTap(onBus: 0)
        audioEngine.stop()
        recognitionTask?.finish()
    }
    
    /*
     --------------------------------------------
     MARK: Record Audio and Transcribe it to Text
     --------------------------------------------
     */
    func recordAndRecognizeSpeech() {
        
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
    
    /*
     **********************************
     MARK: Save New National Park Visit
     **********************************
     */
    func saveNewParkVisit() {
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let visitDateString = dateFormatter.string(from: dateVisited)
        
        dateFormatter.dateFormat = "yyyy-MM-dd' at 'HH:mm:ss"
        let visitDateAndTimeString = dateFormatter.string(from: dateVisited)
        
        //--------------------------------------------------------
        // Get Latitude and Longitude of Where Park Visit Occurred
        //--------------------------------------------------------
        
        // Public function getUsersCurrentLocation() is given in CurrentLocation.swift
        let parkVisitLocation = getUsersCurrentLocation()
        
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
        
        /*
         ==================================
         *   Park Visit Object Creation   *
         ==================================
         */

        // ❎ Instantiate an empty ParkVisit object
        let newParkVisit = ParkVisit(
            // Attributes
            parkName: fullName,
            date: visitDateString,
            rating: ratingChoices[selectedRatingIndex],
            states: states,
            speechToTextNotes: speechConvertedToText,
            latitude: parkVisitLocation.latitude,
            longitude: parkVisitLocation.longitude,
            
            // Relationships
            parkVisitPhotos: [ParkVisitPhoto](),
            parkVisitAudios: [ParkVisitAudio]()
        )
        
        // ❎ Insert it into the database context
        modelContext.insert(newParkVisit)
        
        let newPhoto = ParkVisitPhoto(photoFullFilename: photoFullFilename, dateTime: visitDateAndTimeString)
        newParkVisit.parkVisitPhotos?.append(newPhoto)
        
        let newAudio = ParkVisitAudio(audioFullFilename: audioFullFilename, dateTime: visitDateAndTimeString)
        newParkVisit.parkVisitAudios?.append(newAudio)
        
    }   // End of func saveNewParkVisit()
}


#Preview {
    AddParkVisit()
}
