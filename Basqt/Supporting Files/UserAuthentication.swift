//
//  UserAuthentication.swift
//  PhotosVideos
//
//  Created by Osman Balci on 2/10/26.
//  Copyright © 2026 Osman Balci. All rights reserved.
//

import Foundation
import LocalAuthentication

// Enumeration type AuthenticationStatus publicly defines user authentication outcomes
public enum AuthenticationStatus {
    case Success
    case Failure
    case Unavailable
}

/*
 Public function to evaluate user's identity with biometrics like Face ID or Touch ID.
 It returns the authentication result in 'status' as .Success, .Failure or .Unavailable.
 
 It is called as follows:
 
     authenticateUser() { status in
         switch (status) {
         case .Success:
            // Take corresponding action
         case .Failure:
            // Take corresponding action
         case .Unavailable:
            // Take corresponding action
         }
     }
 */
public func authenticateUser(_ callback: @escaping (_ status: AuthenticationStatus) -> Void) {
    /*
     Instantiate an object from the LAContext class in the Local Authentication (LA) framework
     and store its object reference into local constant 'context'.
     
     The object 'context' handles user interaction by interfacing with the
     Secure Enclave, the underlying hardware component that stores the user's biometric data.
     
     The biometric data is not stored within the operating system for security reasons.
     */
    let context = LAContext()
    var error: NSError?
    
    // Check if authentication can proceed for the deviceOwnerAuthenticationWithBiometrics policy
    if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
        
        // Explain why your app needs biometric authentication
        let reason = "To Unlock the App"
        
        // The evaluatePolicy method is executed in a different thread
        context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
            
            // Switch back to the main thread to handle the authentication result
            DispatchQueue.main.async {
                if success {
                    callback(.Success)
                } else {
                    print(authenticationError?.localizedDescription ?? "Failed to Authenticate")
                    callback(.Failure)
                }
            }
        }
    } else {
        // User's device does not support biometric authentication
        callback(.Unavailable)
    }
}

