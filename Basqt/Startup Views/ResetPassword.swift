//
//  ResetPassword.swift
//  Basqt
//
//  Created by Osman Balci and Micki Ross on 4/24/26.
//  Copyright © 2026 Osman Balci, Micki Ross, Jada Holloway, Jonathan Hernandez Velasquez. All rights reserved.
//

import SwiftUI

struct ResetPassword: View {
    
    @State private var showEnteredValues = false
    @State private var answerTextFieldValue = ""
    @State private var answerEntered = ""
    
    var body: some View {
        Form {
            Section(header: Text("Show / Hide Entered Values")) {
                Toggle(isOn: $showEnteredValues) {
                    Text("Show Entered Values")
                }
            }
            Section(header: Text("Security Question")) {
                Text(UserDefaults.standard.string(forKey: "SecurityQuestion")!)
            }
            Section(header: Text("Enter Answer to the Security Question You Selected")) {
                HStack {
                    if showEnteredValues {
                        TextField("Enter Answer", text: $answerTextFieldValue,
                            onCommit: {
                                // Record entered value after Return key is pressed
                                answerEntered = answerTextFieldValue
                            }
                        )
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(width: 260, height: 36)
                    } else {
                        SecureField("Enter Answer", text: $answerTextFieldValue,
                            onCommit: {
                                // Record entered value after Return key is pressed
                                answerEntered = answerTextFieldValue
                            }
                        )
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(width: 260, height: 36)
                    }
                    // Button to clear the text field
                    Button(action: {
                        answerTextFieldValue = ""
                        answerEntered = ""
                    }) {
                        Image(systemName: "clear")
                            .imageScale(.medium)
                            .font(Font.title.weight(.regular))
                    }
                    .padding()
                }
            }
            
            if answerEntered == UserDefaults.standard.string(forKey: "SecurityAnswer")! {
                Section(header: Text("Go to Settings to Reset Password")) {
                    NavigationLink(destination: Settings()) {
                        HStack {
                            Image(systemName: "gear")
                                .imageScale(.medium)
                                .font(Font.title.weight(.regular))
                            Text("Show Settings")
                                .font(.system(size: 16))
                        }
                        .frame(minWidth: 300, maxWidth: 500, alignment: .leading)
                    }
                }
            } else {
                if !answerEntered.isEmpty {
                    Section(header: Text("Incorrect Answer")) {
                        Text("Answer to the Security Question is Incorrect!")
                    }
                }
            }
            
        }   // End of Form
        .navigationTitle("Password Reset")
        .toolbarTitleDisplayMode(.inline)
        
    }   // End of body var
}

#Preview {
    ResetPassword()
}
