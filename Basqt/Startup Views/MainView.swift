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
            Tab("Home", systemImage: "house") {
                HomeView()
            }
            Tab("Recipes", systemImage: "list.clipboard") {
                RecipeList()
            }
            Tab("Scanner", systemImage: "barcode.viewfinder") {
            }
            Tab("Map", systemImage: "map") {
                NearbyStoresView()
            }
            Tab("Game", systemImage: "gamecontroller") {
                GameView()
            }
            Tab("Profile", systemImage: "person.circle") {
                Settings()
            }
        }   // End of TabView
        .tabViewStyle(.sidebarAdaptable)
    }
}

#Preview {
    MainView()
}
