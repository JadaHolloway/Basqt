//
//  Settings.swift
//  Basqt
//
//  Created by Osman Balci and Micki Ross on 4/24/26.
//  Copyright © 2026 Osman Balci, Micki Ross, Jada Holloway, Jonathan Hernandez Velasquez. All rights reserved.
//

import SwiftUI
import UIKit

struct Settings: View {

    @AppStorage("darkMode") private var darkMode = false
    @AppStorage("homePagePhotoFileName") private var homePagePhotoFileName = ""

    @State private var pickedUIImage: UIImage? = nil
    @State private var showImagePicker = false
    @State private var useCamera = false

    @State private var showEnteredValues = false
    @State private var passwordEntered = ""
    @State private var passwordVerified = ""
    @State private var showAlertMessage = false
    
    let securityQuestions = ["In what city or town did your mother and father meet?", "In what city or town were you born?", "What did you want to be when you grew up?", "What do you remember most from your childhood?", "What is the name of the boy or girl that you first kissed?", "What is the name of the first school you attended?", "What is the name of your favorite childhood friend?", "What is the name of your first pet?", "What is your mother's maiden name?", "What was your favorite place to visit as a child?"]
    
    @State private var selectedSecurityQuestionIndex = 4
    @State private var answerToSelectedSecurityQuestion = ""
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Dark Mode Setting")) {
                    Toggle("Dark Mode", isOn: $darkMode)
                }
                Section(header: Text("Show / Hide Entered Values")) {
                    Toggle("Show Entered Values", isOn: $showEnteredValues)
                }
                Section(header: Text("Select a Security Question")) {
                    Picker("Selected:", selection: $selectedSecurityQuestionIndex) {
                        ForEach(0 ..< securityQuestions.count, id: \.self) {
                            Text(securityQuestions[$0])
                        }
                    }
                }
                Section(header: Text("Enter Answer to Selected Security Question")) {
                    HStack {
                        if showEnteredValues {
                            TextField("Enter Answer", text: $answerToSelectedSecurityQuestion)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .disableAutocorrection(true)
                        } else {
                            SecureField("Enter Answer", text: $answerToSelectedSecurityQuestion)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .disableAutocorrection(true)
                        }
                        // Button to clear the text field
                        Button(action: {
                            answerToSelectedSecurityQuestion = ""
                        }) {
                            Image(systemName: "clear")
                                .imageScale(.medium)
                                .font(Font.title.weight(.regular))
                        }
                        .padding()
                    }
                }
                Section(header: Text("Enter Password")) {
                    HStack {
                        if showEnteredValues {
                            TextField("Enter Password", text: $passwordEntered)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .disableAutocorrection(true)
                        } else {
                            SecureField("Enter Password", text: $passwordEntered)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .disableAutocorrection(true)
                        }
                        // Button to clear the text field
                        Button(action: {
                            passwordEntered = ""
                        }) {
                            Image(systemName: "clear")
                                .imageScale(.medium)
                                .font(Font.title.weight(.regular))
                        }
                        .padding()
                    }   // End of HStack
                }
                Section(header: Text("Verify Password")) {
                    HStack {
                        if showEnteredValues {
                            TextField("Verify Password", text: $passwordVerified)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .disableAutocorrection(true)
                        } else {
                            SecureField("Verify Password", text: $passwordVerified)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .disableAutocorrection(true)
                        }
                        // Button to clear the text field
                        Button(action: {
                            passwordVerified = ""
                        }) {
                            Image(systemName: "clear")
                                .imageScale(.medium)
                                .font(Font.title.weight(.regular))
                        }
                        .padding()
                    }   // End of HStack
                }
                Section(header: Text("Set Password")) {
                    HStack {
                        Spacer()
                        Button("Set Password") {
                            if !passwordEntered.isEmpty && !answerToSelectedSecurityQuestion.isEmpty {
                                if passwordEntered == passwordVerified {
                                    /*
                                     UserDefaults provides an interface to the user’s defaults database,
                                     where you store key-value pairs persistently across launches of your app.
                                     */
                                    // Store the password in the user’s defaults database
                                    UserDefaults.standard.set(passwordEntered, forKey: "Password")
                                    
                                    // Store the selected security question index in the user’s defaults database
                                    UserDefaults.standard.set(securityQuestions[selectedSecurityQuestionIndex], forKey: "SecurityQuestion")
                                    
                                    // Store the answer to the selected security question in the user’s defaults database
                                    UserDefaults.standard.set(answerToSelectedSecurityQuestion, forKey: "SecurityAnswer")
                                    
                                    passwordEntered = ""
                                    passwordVerified = ""
                                    answerToSelectedSecurityQuestion = ""
                                    
                                    showAlertMessage = true
                                    alertTitle = "Password Set!"
                                    alertMessage = "Password you entered is set to unlock the app!"
                                } else {
                                    showAlertMessage = true
                                    alertTitle = "Unmatched Password!"
                                    alertMessage = "Two entries of the password must match!"
                                }
                            } else {
                                showAlertMessage = true
                                alertTitle = "Missing Input!"
                                alertMessage = "Please select and answer a security question and enter your password!"
                            }
                        }   // End of Button
                        .tint(.blue)
                        .buttonStyle(.bordered)
                        .buttonBorderShape(.capsule)
                        
                        Spacer()
                    }   // End of HStack
                }
                Section(header: Text("Remove Password")) {
                    HStack {
                        Spacer()
                        Button("Remove Password") {
                            // Set password to nil in the user’s defaults database
                            UserDefaults.standard.set(nil, forKey: "Password")
                            
                            // Set security question to nil in the user’s defaults database
                            UserDefaults.standard.set(nil, forKey: "SecurityQuestion")
                            
                            showAlertMessage = true
                            alertTitle = "Password Removed!"
                            alertMessage = "You can now unclock the app without a password!"
                        }
                        .tint(.blue)
                        .buttonStyle(.bordered)
                        .buttonBorderShape(.capsule)
                        
                        Spacer()
                    }
                }
                Section(header: Text("Home Page Image")) {
                    if homePagePhotoFileName.isEmpty {
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color(.systemGray5))
                                .frame(height: 160)
                            VStack(spacing: 6) {
                                Image(systemName: "photo")
                                    .font(.system(size: 36))
                                    .foregroundColor(.gray)
                                Text("No photo set")
                                    .font(.system(size: 12))
                                    .foregroundColor(.secondary)
                            }
                        }
                    } else {
                        getImageFromDocumentDirectory(filename: "homePagePhoto", fileExtension: "jpg", defaultFilename: "ImageUnavailable")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(height: 160)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                    HStack {
                        Spacer()
                        Button("Camera") {
                            useCamera = true
                            showImagePicker = true
                        }
                        .tint(.blue)
                        .buttonStyle(.bordered)
                        .buttonBorderShape(.capsule)
                        Spacer()
                        Button("Photo Library") {
                            useCamera = false
                            showImagePicker = true
                        }
                        .tint(.blue)
                        .buttonStyle(.bordered)
                        .buttonBorderShape(.capsule)
                        Spacer()
                    }
                }

            }   // End of Form
            // Set font and size for the whole Form content
            .font(.system(size: 14))
            .navigationTitle("Settings")
            .toolbarTitleDisplayMode(.inline)
            .alert(alertTitle, isPresented: $showAlertMessage, actions: {
                Button("OK") {}
            }, message: {
                Text(alertMessage)
            })
            
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(uiImage: $pickedUIImage,
                        sourceType: useCamera ? .camera : .photoLibrary,
                        imageWidth: 500.0, imageHeight: 500.0)
        }
        .onChange(of: pickedUIImage) {
            if let uiImage = pickedUIImage,
               let jpegData = uiImage.jpegData(compressionQuality: 1.0) {
                let fileUrl = documentDirectory.appendingPathComponent("homePagePhoto.jpg")
                try? jpegData.write(to: fileUrl)
                homePagePhotoFileName = "homePagePhoto.jpg"
            }
        }
        }   // End of NavigationStack

    }   // End of body var
    
}

#Preview {
    Settings()
}


