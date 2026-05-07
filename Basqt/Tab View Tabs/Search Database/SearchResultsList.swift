//
//  SearchResultsList.swift
//  Recipes
//
//  Created by Osman Balci, Micki Ross, Jada Holloway, and Jonathan Hernandez Velasquez on 3/4/26.
//  Copyright © 2026 Osman Balci, Micki Ross, Jada Holloway, Jonathan Hernandez Velasquez. All rights reserved.
//

import SwiftUI

struct SearchResultsList: View {
    var body: some View {
        List {
            ForEach(databaseSearchResults) { aFoundRecipe in
                NavigationLink(destination: SearchRecipeDetails(recipe: aFoundRecipe, audioPlayer: AudioPlayer())) {
                    SearchResultItem(recipe: aFoundRecipe)
                }
            }
        }
        .navigationTitle("Database Search Results")
        .toolbarTitleDisplayMode(.inline)
    }
}


#Preview {
    SearchResultsList()
}
