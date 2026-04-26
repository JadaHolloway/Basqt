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
//
//  BasqtApp.swift
//  Basqt
//
//  Created by Osman Balci, Micki Ross, Jada Holloway, and Jonathan Hernandez Velasquez on 4/24/26.
//  Copyright © 2026 Osman Balci, Micki Ross, Jada Holloway, Jonathan Hernandez Velasquez. All rights reserved.
//

import SwiftUI
import SwiftData

@main
struct BasqtApp: App {

    init() {
        /*
         -------------------------------------------------------
         |   Create Basqt Database upon App Launch             |
         |   IF the app is being launched for the first time.  |
         -------------------------------------------------------
         */
        createBasqtDatabase()       // Given in DatabaseCreation.swift

        // Get User's Permission for Current Location upon App Launch
        getPermissionForLocation()  // Given in CurrentLocation.swift
    }

    @AppStorage("darkMode") private var darkMode = false

    var body: some Scene {
        WindowGroup {
            // ContentView is the root view to be shown first upon app launch
            ContentView()
                // Change the color mode of the entire app to Dark or Light
                .preferredColorScheme(darkMode ? .dark : .light)

                /*
                 Inject the Model Container into the environment so that you can access its Model Context
                 in a SwiftUI file by using @Environment(\.modelContext) private var modelContext
                 */
                .modelContainer(for: [Weather.self, FoodProduct.self, OpenStreetStore.self,
                                      GroceryList.self, GroceryItem.self, Recipe.self],
                                isAutosaveEnabled: true,
                                isUndoEnabled: false)
        }
    }
}
