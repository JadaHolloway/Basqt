//
//  RecipesDetails.swift
//  Basqt
//
//  Created by Osman Balci and Micki Ross on 4/26/26.
//  Copyright © 2026 Osman Balci, Micki Ross, Jada Holloway, Jonathan Hernandez Velasquez. All rights reserved.
//

import SwiftUI
//import MapKit
import AVFoundation


struct RecipeDetails: View {
    
    // Input Parameter
    let recipe: Recipe
    var body: some View {
        
        return AnyView(
            Form {
                Section(header: Text("Recipe Name")) {
                    Text(recipe.name)
                }
                if !recipe.photoFullFilename.isEmpty {
                    Section(header: Text("Recipe Photo")) {
                        Image(recipe.photoFullFilename)
                            .resizable().scaledToFit()
                    }
                }
                Section(header: Text("Description")) {
                    Text(recipe.briefDescription)
                }
                Section(header: Text("Calories")) {
                    Text(" \(recipe.calories) kcal")
                }
                Section(header: Text("Dietary Tags")) {
                    Text(recipe.dietaryTags)
                }
                Section(header: Text("Ingredients")) {
                    Text(recipe.ingredients)
                }
                Section(header: Text("Notes")) {
                    if recipe.notes.isEmpty {
                        Text("No notes added.")
                    } else {
                        Text(recipe.notes)
                    }
                }
            }   // End of Form
                .font(.system(size: 14))
                .navigationTitle("Recipe Details")
                .toolbarTitleDisplayMode(.inline).toolbar {
                    ToolbarItem() {
                        Button(action: {
                            print("PDF Export for \(recipe.name)")
                        }) {
                            //Image(systemName: doc.text)
                            //add icon navigate to PDF Kit
                        }
                    }
                }
        )   // End of AnyView
    }
}


