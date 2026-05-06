//
//  SearchResultItem.swift
//  Recipes
//
//  Created by Osman Balci on 3/4/26.
//  Copyright © 2026 Osman Balci. All rights reserved.
//

import SwiftUI

struct SearchResultItem: View {
    
    // Input Parameter
    let recipe: Recipe
    
    var body: some View {
        HStack {
            // This public function is given in UtilityFunctions.swift
            let filename = (recipe.photoFullFilename as NSString).deletingPathExtension
            let fileExtension = (recipe.photoFullFilename as NSString).pathExtension

            if recipe.photoFullFilename.isEmpty {
                Image("ImageUnavailable")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100.0, height: 75.0)

            } else if UIImage(named: filename) != nil {
                Image(filename)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100.0, height: 75.0)
            } else {
                getImageFromDocumentDirectory(filename: filename, fileExtension: fileExtension, defaultFilename: "ImageUnavailable")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100.0, height: 75.0)
            }
            
            VStack(alignment: .leading) {
                Text(recipe.name)
                Text(recipe.dietaryTags?.name ?? "No Tag")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .font(.system(size: 14))
        }
    }
}

