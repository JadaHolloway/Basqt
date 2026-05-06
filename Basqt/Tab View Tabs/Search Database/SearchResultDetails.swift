//
//  SearchResultDetails.swift
//  Recipes
//
//  Created by Osman Balci on 3/4/26.
//  Copyright © 2026 Osman Balci. All rights reserved.
//

import SwiftUI

struct SearchResultDetails: View {
    
    // Input Parameter
    let recipe: Recipe
    
    var body: some View {
        Form {
            Section(header: Text("Recipe Name")) {
                Text(recipe.name)
            }
            Section(header: Text("Recipe Photo")) {
                getImageFromUrl(url: recipe.photoUrl, defaultFilename: "ImageUnavailable")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 300)
            }
            Section(header: Text("Recipe Category")) {
                Text(recipe.category)
            }
            Section(header: Text("Recipe Website")) {
                // Show recipe's webpage in default web browser
                Link(destination: URL(string: recipe.websiteUrl)!) {
                    HStack {
                        Image(systemName: "globe")
                            .imageScale(.medium)
                            .font(Font.title.weight(.regular))
                        Text("Show Recipe Website")
                            .font(.system(size: 16))
                    }
                }
            }
            Section(header: Text("Recipe Publisher Name")) {
                Text(recipe.publisher!.name)
            }
            Section(header: Text("Recipe Publisher Website")) {
                // Show recipe publisher's website externally in default web browser
                Link(destination: URL(string: recipe.publisher!.websiteUrl)!) {
                    HStack {
                        Image(systemName: "house.fill")
                            .imageScale(.medium)
                            .font(Font.title.weight(.regular))
                        Text("Show Publisher Website")
                            .font(.system(size: 16))
                    }
                }
            }
            Section(header: Text("Recipe Cuisine")) {
                Text(recipe.cuisine!.name)
            }
            Section(header: Text("Recipe Nutrition Information")) {
                recipeNutrients
                    .fixedSize()    // Prevent truncation
            }
            Section(header: Text("Recipe ingredients")) {
                recipeIngredients
                    .fixedSize()    // Prevent truncation
            }
            
        }   // End of Form
            .navigationBarTitle(Text("Found Recipe Details"), displayMode: .inline)
            .font(.system(size: 14))
        
    }   // End of body var
    
    /*
     =======================================
     *   ❎ Recipe Nutrition Information   *
     =======================================
     */
    
    var recipeNutrients: Text {
        /*
         recipe.nutrients! is of type NSSet implying that a recipe contains many nutrients.
         recipe.nutrients!.allObjects returns a Swift array of type Any, [Any]
         NSSet -> [Any] contains its objects in undefined order like a Dictionary.
         */
        let arrayOfNutrients = recipe.nutrients!
        
        var listOfNutrients = [String]()
        
        for object in arrayOfNutrients {
            // Typecast Any object in array [Any] as of type Nutrient class
            let aNutrient = object as Nutrient
            
            let name = aNutrient.name
            
            // Round 'amount' of type NSNumber to have 3 decimal places
            let amountNSNumber = aNutrient.amount
            let amount = String(format: "%.3f", amountNSNumber)
            
            let unit = aNutrient.unit
            
            // Line up the values using Tab escape character
            switch name {
            case "Total Carbohydrate":
                if amountNSNumber >= 1000.0 {
                    listOfNutrients.append("\(name): \t\(amount)\t\(unit)")
                } else {
                    listOfNutrients.append("\(name): \t\(amount)\t\t\(unit)")
                }
            case "Dietary Fiber", "Saturated Fat":
                listOfNutrients.append("\(name): \t\t\(amount)\t\t\(unit)")
            case "Calories", "Cholesterol", "Total Fat":
                listOfNutrients.append("\(name): \t\t\t\(amount)\t\t\(unit)")
            case "Sodium":
                if amountNSNumber >= 1000.0 {
                    listOfNutrients.append("\(name): \t\t\t\(amount)\t\(unit)")
                } else {
                    listOfNutrients.append("\(name): \t\t\t\(amount)\t\t\(unit)")
                }
            case "Protein", "Sugars":
                listOfNutrients.append("\(name): \t\t\t\t\(amount)\t\t\(unit)")
            default:
                print("Recipe name out of range!")
            }
        }
        
        // Sort the list since order of objects in NSSet -> [Any] is undefined
        let sortedList = listOfNutrients.sorted()
        
        var sortedListString = ""
        for sortedItem in sortedList {
            sortedListString.append(sortedItem + "\n")
        }
        // Drop the last newline escape character
        return Text(sortedListString.dropLast())
    }
    
    /*
     =============================
     *   ❎ Recipe Ingredients   *
     =============================
     */
    
    var recipeIngredients: Text {
        /*
         recipe.ingredients! is of type NSSet implying that a recipe contains many ingredients.
         recipe.ingredients!.allObjects returns a Swift array of type Any, [Any]
         NSSet -> [Any] contains its objects in undefined order like a Dictionary.
         */
        let arrayOfIngredients = recipe.ingredients!
        
        var listOfIngredients = ""
        
        for object in arrayOfIngredients {
            // Typecast Any object in array [Any] as of type Ingredient class
            let aIngredient = object as Ingredient
            
            let amount = aIngredient.amount
            let unit = aIngredient.unit
            let name = aIngredient.name
            
            if unit.isEmpty {
                listOfIngredients.append("\(amount) \(name)\n")
            } else {
                listOfIngredients.append("\(amount) \(unit) of \(name)\n")
            }
        }
        
        // Drop the last newline escape character
        return Text(listOfIngredients.dropLast())
    }
}
