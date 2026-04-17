//
//  ContentView.swift
//  TravelAid
//
//  Created by Osman Balci and micki ross on 4/9/26.
//  Copyright © 2026 Osman Balci and micki ross. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            Tab("Home", systemImage: "house") {
                Home()
            }
            Tab("Trips", systemImage: "list.bullet") {
                //ListofTrips()
            }
            Tab("Trips on Map", systemImage: "mappin.and.ellipse") {
                //SearchDatabase()
            }
            Tab("Search DB", systemImage: "magnifyingglass") {
                //SearchByName()
            }
            Tab("Search API Weather", systemImage: "cloud.sun.rain") {
                //SearchByLocation()
            }
            Tab("Settings", systemImage: "gear") {
                Settings()
            }
        }   // End of TabView
        .tabViewStyle(.sidebarAdaptable)
    }
}

#Preview {
    ContentView()
}

