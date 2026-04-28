//
//  LoginView.swift
//  Basqt
//
//  Created by Osman Balci and Micki Ross on 4/24/26.
//  Copyright © 2026 Osman Balci, Micki Ross, Jada Holloway, Jonathan Hernandez Velasquez. All rights reserved.
//

import SwiftUI
import SwiftData

struct LoginView : View {

    // Binding Input Parameter
    @Binding var canLogin: Bool

    @AppStorage("homePagePhotoFileName") private var homePagePhotoFileName = ""

    // State Variables
    @State private var enteredPassword = ""
    @State private var showAlertMessage = false
    
    var body: some View {
        NavigationStack {
            // Background View
            
            ZStack(alignment: .top) {
                Rectangle()
                    .fill(Color(red: 0.14, green: 0.34, blue: 0.14))
                    .frame(height: 530)


                
            // Foreground View
            ScrollView(.vertical, showsIndicators: false) {
                VStack {
                    Image("Welcome")

                    Text("Your Grocery Trip, Optimized.")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()

                    if homePagePhotoFileName.isEmpty {
                        ZStack {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color(.systemGray5))
                                .frame(width: 300, height: 200)
                            VStack(spacing: 8) {
                                Image(systemName: "photo")
                                    .font(.system(size: 40))
                                    .foregroundColor(.gray)
                                Text("Set a home page photo in Settings")
                                    .font(.system(size: 12))
                                    .foregroundColor(.secondary)
                            }
                        }
                        .padding()
                    } else {
                        getImageFromDocumentDirectory(filename: "homePagePhoto", fileExtension: "jpg", defaultFilename: "ImageUnavailable")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(minWidth: 300, maxWidth: 450, alignment: .center)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .padding(.horizontal)
                    }
                    HStack {
                        Image(systemName: "lock.fill")
                            .foregroundColor(.gray)
                        SecureField("Password", text: $enteredPassword)
                    }
                    .padding(.horizontal, 10)
                    .frame(width: 300, height: 42)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                    )
                    .padding()
                    
                    HStack {
                        Button("Login") {
                            /*
                             UserDefaults provides an interface to the user’s defaults database,
                             where you store key-value pairs persistently across launches of your app.
                             */
                            // Retrieve the password from the user’s defaults database under the key "Password"
                            let validPassword = UserDefaults.standard.string(forKey: "Password")
                            
                            /*
                             If the user has not yet set a password, validPassword = nil
                             In this case, allow the user to login.
                             */
                            if validPassword == nil || enteredPassword == validPassword {
                                canLogin = true
                            } else {
                                showAlertMessage = true
                                alertTitle = "Invalid Password!"
                                alertMessage = "Please enter a valid password to unlock the app!"
                            }
                        }
                        .frame(width: 170, height: 50)
                        .tint(Color(red: 0.14, green: 0.34, blue: 0.14))
                        .background(
                            RoundedRectangle(cornerRadius: 15)
                                .fill(Color(red: 0.14, green: 0.34, blue: 0.14))
                        )
                        .buttonStyle(.borderedProminent)
                        .padding()
                        .foregroundColor(.white)
                        
                        if UserDefaults.standard.string(forKey: "SecurityQuestion") != nil {
                            NavigationLink(destination: ResetPassword()) {
                                Text("Forgot Password")
                            }
                            .frame(width: 170, height: 50)
                            .tint(Color(.gray))
                            .background(
                                RoundedRectangle(cornerRadius: 15)
                                    .fill(Color.gray)
                            )
                            .buttonStyle(.borderedProminent)
                            .foregroundColor(.white)
                            .buttonStyle(.bordered)
                            .buttonBorderShape(.capsule)
                        }
                    }   // End of HStack
                    
                    /*
                     *********************************************************
                     *   Biometric Authentication with Face ID or Touch ID   *
                     *********************************************************
                     */
                    
                    // Enable biometric authentication only if a password has already been set
                    if UserDefaults.standard.string(forKey: "Password") != nil {
                        Button("Use Face ID or Touch ID") {
                            // authenticateUser() is given in UserAuthentication
                            authenticateUser() { status in
                                switch (status) {
                                case .Success:
                                    canLogin = true
                                case .Failure:
                                    canLogin = false
                                    showAlertMessage = true
                                    alertTitle = "Unable to Authenticate!"
                                    alertMessage = "Something went wrong and authentication failed."
                                case .Unavailable:
                                    canLogin = false
                                    showAlertMessage = true
                                    alertTitle = "Unable to Use Biometric Authentication!"
                                    alertMessage = "Your device does not support biometric authentication!"
                                }
                            }
                        }
                        .frame(width: 220, height: 50)
                        .tint(Color(.gray))
                        .background(
                            RoundedRectangle(cornerRadius: 15)
                                .fill(Color.gray)
                        )
                        .buttonStyle(.bordered)
                        .buttonBorderShape(.capsule)
                        .buttonStyle(.borderedProminent)
                        .foregroundColor(.white)
                        
                        HStack {
                            Image(systemName: "faceid")
                                .font(.system(size: 40))
                                .padding()
                            Image(systemName: "touchid")
                                .font(.system(size: 40))
                                .padding()
                        }
                    }
                }   // End of VStack
            }   // End of ScrollView
            }   // End of ZStack
            .navigationBarHidden(true)
            
        }   // End of NavigationStack
        .alert(alertTitle, isPresented: $showAlertMessage, actions: {
              Button("OK") {}
            }, message: {
              Text(alertMessage)
            })
        
    }   // End of body var
    
}

