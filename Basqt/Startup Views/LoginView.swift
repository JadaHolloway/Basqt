//
//  LoginView.swift
//  Basqt
//
//  Created by Osman Balci and Micki Ross on 4/24/26.
//  Copyright © 2026 Osman Balci, Micki Ross, Jada Holloway, Jonathan Hernandez Velasquez. All rights reserved.
//

import SwiftUI
import SwiftData
internal import Combine

struct LoginView : View {
    
    // Binding Input Parameter
    @Binding var canLogin: Bool
    //need to change
    @Query(FetchDescriptor<Recipe>(sortBy: [SortDescriptor(\Recipe.name, order: .forward)])) private var listOfRecipesInDatabase: [Recipe]
    
    // State Variables
    @State private var enteredPassword = ""
    @State private var showAlertMessage = false
    
    @State private var index = 0
    /*
     Create a timer publisher that fires 'every' 3 seconds and updates the view.
     It runs 'on' the '.main' runloop so that it can update the view.
     It runs 'in' the '.common' mode so that it can run alongside other
     common events such as when the ScrollView is being scrolled.
     */
    @State private var timer = Timer.publish(every: 3, on: .main, in: .common).autoconnect()
    
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
                    if !listOfRecipesInDatabase.isEmpty {
                        let components = listOfRecipesInDatabase[index].photoFullFilename.components(separatedBy: ".")
                        let filename = components.first ?? ""
                        let fileExtension = components.count > 1 ? components.last! : ""
                        getImageFromDocumentDirectory(filename: filename,fileExtension: fileExtension, defaultFilename: "ImageUnavailable")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(minWidth: 300, maxWidth: 450, alignment: .center)
                            .padding(.horizontal)
                        
                        // Subscribe to the timer publisher
                            .onReceive(timer) { _ in
                                index += 1
                                if index > listOfRecipesInDatabase.count - 1 {
                                    index = 0
                                }
                            }
                        
                        Text(listOfRecipesInDatabase[index].name)
                            .font(.system(size: 14, weight: .light, design: .serif))
                            .padding(.bottom)
                            .foregroundColor(.white)

                            
                    } else
                    {
                        Text("No recipes saved yet.")
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
            .onAppear() {
                startTimer()
            }
            .onDisappear() {
                stopTimer()
            }
                
            }   // End of ZStack
            .navigationBarHidden(true)
            
        }   // End of NavigationStack
        .alert(alertTitle, isPresented: $showAlertMessage, actions: {
              Button("OK") {}
            }, message: {
              Text(alertMessage)
            })
        
    }   // End of body var
    
    func startTimer() {
        timer = Timer.publish(every: 3, on: .main, in: .common).autoconnect()
    }
    
    func stopTimer() {
        timer.upstream.connect().cancel()
    }
    
}

