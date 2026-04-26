//
//  MainView.swift
//  Basqt
//
//  Created by Osman Balci and Micki Ross on 4/24/26.
//  Copyright © 2026 Osman Balci, Micki Ross, Jada Holloway, Jonathan Hernandez Velasquez. All rights reserved.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        TabView {
            //change these icons
            Tab("Home", systemImage: "photo") {
                RecipeList()
            }
            Tab("Grocery List", systemImage: "square.grid.3x3") {
                //PhotosGrid()
            }
            Tab("Recipes", systemImage: "mappin.and.ellipse") {
                //Maps()
            }
            Tab("Search", systemImage: "video") {
                //VideosList()
            }
            Tab("Map", systemImage: "video") {
                //VideosList()
            }
            Tab("Settings", systemImage: "gear") {
                Settings()
            }
        }   // End of TabView
        .tabViewStyle(.sidebarAdaptable)
    }
}

#Preview {
    MainView()
}
