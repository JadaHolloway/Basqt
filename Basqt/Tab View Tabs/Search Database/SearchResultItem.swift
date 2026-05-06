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
            getImageFromUrl(url: recipe.photoUrl, defaultFilename: "ImageUnavailable")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 80.0)
            
            VStack(alignment: .leading) {
                Text(recipe.name)
                Text(recipe.category)
                Text(recipe.publisher!.name)
            }
            .font(.system(size: 14))
        }
    }
}

