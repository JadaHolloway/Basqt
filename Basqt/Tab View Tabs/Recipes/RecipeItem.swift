//
//  RecipeItem.swift
//  Basqt
//
//  Created by Osman Balci and Micki Ross on 4/26/26.
//  Copyright © 2026 Osman Balci, Micki Ross, Jada Holloway, Jonathan Hernandez Velasquez. All rights reserved.
//

import SwiftUI

struct RecipeItem: View {
    
    // Input Parameter
    let recipe: Recipe
    
    var body: some View {
        HStack {
            //avoid app crash
            let components = recipe.photoFullFilename.components(separatedBy: ".")
            let filename = components.first ?? ""
            let fileExtension = components.count > 1 ? components.last! : ""
            // This function is given in UtilityFunctions.swift
            
            getImageFromDocumentDirectory(filename: filename, fileExtension: fileExtension, defaultFilename: "ImageUnavailable")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100.0, height: 75.0)
            
            VStack(alignment: .leading) {
                Text(recipe.name)
                Text(recipe.dietaryTags)
            }
            // Set font and size for the whole VStack content
            .font(.system(size: 14))
        }
    }
}
