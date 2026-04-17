/*
**********************************************************
*   Statement of Compliance with the Stated Honor Code   *
**********************************************************
I hereby declare on my honor and I affirm that
 
 (1) I have not given or received any unauthorized help on this assignment, and
 (2) All work is my own in this assignment.
 
I am hereby writing my name as my signature to declare that the above statements are true:
   
      Micki Ross
 
**********************************************************
 */
//***********************************************************************
// You are allowed to use Dr. Balci's API key in Globals.swift file ONLY for this assignment. //*******************************************************************
//
//  TravelAidApp.swift
//  TravelAid
//
//  Created by micki ross and osman balci on 4/9/26.
//

import SwiftUI
import SwiftData

@main
struct TravelAidApp: App {

    init() {
        /*
         ------------------------------------------------------------
         |   Create National Park Visits Database upon App Launch   |
         |   IF the app is being launched for the first time.       |
         ------------------------------------------------------------
         */
        createTravelAidDatabase()      // Given in DatabaseCreation.swift
        
        // Get User's Permission for Current Location upon App Launch
        getPermissionForLocation()      // Given in CurrentLocation.swift
    }

    @AppStorage("darkMode") private var darkMode = false
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                // Change the color mode of the entire app to Dark or Light
                .preferredColorScheme(darkMode ? .dark : .light)
            
                /*
                 Inject the Model Container into the environment so that you can access its Model Context
                 in a SwiftUI file by using @Environment(\.modelContext) private var modelContext
                 */
                .modelContainer(for: [Trip.self, TripPhoto.self, TripAudio.self],
                                isAutosaveEnabled: true,
                                isUndoEnabled: false)
        }
    }
}
