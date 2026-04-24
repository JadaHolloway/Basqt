//
//  AddParkVisitPhoto.swift
//  NationalParks
//
//  Created by Osman Balci on 3/24/26.
//  Copyright © 2026 Osman Balci. All rights reserved.
//

import SwiftUI
import SwiftData

struct AddParkVisitPhoto: View {
    
    // Input Parameter
    let parkVisit: ParkVisit
    
    // Enable this view to be dismissed to go back to the previous view
    @Environment(\.dismiss) private var dismiss
    
    @Environment(\.modelContext) private var modelContext
    
    //------------------------------------
    // Image Picker from Camera or Library
    //------------------------------------
    @State private var showImagePicker = false
    @State private var pickedUIImage: UIImage?
    @State private var pickedImage: Image?
    
    @State private var useCamera = false
    @State private var usePhotoLibrary = true
    
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
        .navigationTitle("Add New Park Visit Photo")
        .toolbarTitleDisplayMode(.inline)
        .toolbar {
            // Place the Save button on right side of the toolbar
            ToolbarItem(placement: .topBarTrailing) {
                Button("Save") {
                    if inputDataValidated() {
                        saveNewParkVisitPhoto()
                        
                        showAlertMessage = true
                        alertTitle = "New Park Visit Photo Saved!"
                        alertMessage = "Your new national park visit photo is successfully saved in the database!"
                    } else {
                        showAlertMessage = true
                        alertTitle = "Missing Input Data!"
                        alertMessage = "You must first take or pick a photo to save it in database."
                    }
                }
            }
        }   // End of toolbar

        .alert(alertTitle, isPresented: $showAlertMessage, actions: {
            Button("OK") {
                if alertTitle == "New Park Visit Photo Saved!" {
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
    
    
    /*
     ---------------------------
     MARK: Input Data Validation
     ---------------------------
     */
    func inputDataValidated() -> Bool {
        
        if pickedImage == nil {
            return false
        }
        
        return true
    }
    
    
    /*
     ****************************************
     MARK: Save New National Park Visit Photo
     ****************************************
     */
    func saveNewParkVisitPhoto() {
        
        // Obtain the current date and time
        let currentDateAndTime = Date()
         
        // Create an instance of DateFormatter
        let dateFormatter = DateFormatter()
         
        // Set the date format to yyyy-MM-dd at HH:mm:ss
        dateFormatter.dateFormat = "yyyy-MM-dd' at 'HH:mm:ss"
         
        // Format dateAndTime under the dateFormatter and convert it to String
        let photoDateAndTimeString = dateFormatter.string(from: currentDateAndTime)
        
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
        
        let newParkVisitPhoto = ParkVisitPhoto(photoFullFilename: photoFullFilename, dateTime: photoDateAndTimeString)
        
        // ❎ Insert it into the database context
        modelContext.insert(newParkVisitPhoto)
        
        parkVisit.parkVisitPhotos?.append(newParkVisitPhoto)

    }   // End of function
}

