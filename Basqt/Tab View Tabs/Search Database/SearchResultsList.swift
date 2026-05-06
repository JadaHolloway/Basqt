//
//  SearchResultsList.swift
//  Recipes
//
//  Created by Osman Balci on 3/4/26.
//  Copyright © 2026 Osman Balci. All rights reserved.
//

import SwiftUI

struct SearchResultsList: View {
    var body: some View {
        List {
            ForEach(databaseSearchResults) { aFoundRecipe in
                NavigationLink(destination: SearchResultDetails(recipe: aFoundRecipe)) {
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
