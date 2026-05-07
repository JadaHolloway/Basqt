//
//  MainView.swift
//  Basqt
//
//  Created by Osman Balci, Micki Ross, Jada Holloway, and Jonathan Hernandez Velasquez on 4/24/26.
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
                ScannerView()
            }
            Tab("Map", systemImage: "map") {
                NearbyStoresView()
            }
            Tab("Search DB", systemImage: "magnifyingglass")
            {
                SearchDatabase()
            }
            Tab("Game", systemImage: "gamecontroller") {
                GameView()
            }
            Tab("Foods with Colors", systemImage: "fork.knife.circle") {
                FoodSlide()
            }
            Tab("Food Grid", systemImage: "square.grid.3x3") {
                FoodsGridQuiz()
            }
            Tab("10 Minute Recipe Videos", systemImage: "video") {
                VideosList()
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
