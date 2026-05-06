//
//  DatabaseSearch.swift
//  Recipes
//
//  Created by Osman Balci on 3/4/26.
//  Copyright © 2026 Osman Balci. All rights reserved.
//

import SwiftUI
import SwiftData

// Global variable to hold database search results
var databaseSearchResults = [Recipe]()

// Global Search Parameters
var searchCategory = ""
var searchQuery = ""
var nutrientName = ""
var maxNutrientAmount = 0.0

public func conductDatabaseSearch() {
    /*
     ------------------------------------------------
     |   Create Model Container and Model Context   |
     ------------------------------------------------
     */
    var modelContainer: ModelContainer

    do {
        // Create a database container to manage database objects Recipe, Cuisine, Publisher, Ingredient, and Nutrient
        modelContainer = try ModelContainer(for: Recipe.self, Cuisine.self, Publisher.self, Ingredient.self, Nutrient.self)
    } catch {
        fatalError("Unable to create ModelContainer")
    }
    
    // Create the context (workspace) where database objects will be managed
    let modelContext = ModelContext(modelContainer)
    
    // Initialize the global variable to hold the database search results
    databaseSearchResults = [Recipe]()
    
    /*
     Use 'localizedStandardContains' to perform CASE INSENSITIVE Search
     
        "This is the most appropriate method for doing user-level string searches,
        similar to how searches are done generally in the system.
        The search is locale-aware, case and diacritic insensitive." [Apple]
     
     Use 'contains' to perform CASE SENSITIVE Search
     */
    
    switch searchCategory {
    case "Recipe Name":
        // 1️⃣ Define the Search Criterion (Predicate)
        let namePredicate = #Predicate<Recipe> {
            $0.name.localizedStandardContains(searchQuery)
        }
        
        // 2️⃣ Define the Fetch Descriptor
        let nameFetchDescriptor = FetchDescriptor<Recipe>(
            predicate: namePredicate,
            sortBy: [SortDescriptor(\Recipe.category, order: .forward), SortDescriptor(\Recipe.name, order: .forward)]
        )
        
        // 3️⃣ Execute the Fetch Request
        do {
            databaseSearchResults = try modelContext.fetch(nameFetchDescriptor)
        } catch {
            fatalError("Unable to fetch name data from the database")
        }
        
    case "Recipe Category":
        // 1️⃣ Define the Search Criterion (Predicate)
        let categoryPredicate = #Predicate<Recipe> {
            $0.category.localizedStandardContains(searchQuery)
        }
        
        // 2️⃣ Define the Fetch Descriptor
        let categoryFetchDescriptor = FetchDescriptor<Recipe>(
            predicate: categoryPredicate,
            sortBy: [SortDescriptor(\Recipe.category, order: .forward), SortDescriptor(\Recipe.name, order: .forward)]
        )
        
        // 3️⃣ Execute the Fetch Request
        do {
            databaseSearchResults = try modelContext.fetch(categoryFetchDescriptor)
        } catch {
            fatalError("Unable to fetch category data from the database")
        }
        
    case "Cuisine Name":
        // 1️⃣ Define the Search Criterion (Predicate)
        let cuisinePredicate = #Predicate<Cuisine> {
            $0.name == searchQuery
        }
        
        // 2️⃣ Define the Fetch Descriptor
        let cuisineFetchDescriptor = FetchDescriptor<Cuisine>(
            predicate: cuisinePredicate,
            sortBy: [SortDescriptor(\Cuisine.name, order: .forward)]
        )
        
        var cuisineResultsArray = [Cuisine]()
        
        // 3️⃣ Execute the Fetch Request
        do {
            cuisineResultsArray = try modelContext.fetch(cuisineFetchDescriptor)
            
            if cuisineResultsArray.isEmpty {
                // databaseSearchResults will be empty
                return
            }
            // cuisineResultsArray[0] is the found cuisine
            databaseSearchResults = cuisineResultsArray[0].recipes!
            
        } catch {
            fatalError("Unable to fetch cuisine data from the database")
        }
        
    case "Publisher Name":
        // 1️⃣ Define the Search Criterion (Predicate)
        let publisherPredicate = #Predicate<Publisher> {
            $0.name == searchQuery
        }
        
        // 2️⃣ Define the Fetch Descriptor
        let publisherFetchDescriptor = FetchDescriptor<Publisher>(
            predicate: publisherPredicate,
            sortBy: [SortDescriptor(\Publisher.name, order: .forward)]
        )
        
        var publisherResultsArray = [Publisher]()
        
        // 3️⃣ Execute the Fetch Request
        do {
            publisherResultsArray = try modelContext.fetch(publisherFetchDescriptor)
            
            if publisherResultsArray.isEmpty {
                // databaseSearchResults will be empty
                return
            }
            // publisherResultsArray[0] is the found publisher
            databaseSearchResults = publisherResultsArray[0].recipes!
            
        } catch {
            fatalError("Unable to fetch publisher data from the database")
        }
    case "Ingredient Name":
        // 1️⃣ Define the Search Criterion (Predicate)
        let ingredientPredicate = #Predicate<Ingredient> {
            $0.name.localizedStandardContains(searchQuery)
        }
        
        // 2️⃣ Define the Fetch Descriptor
        let ingredientFetchDescriptor = FetchDescriptor<Ingredient>(
            predicate: ingredientPredicate,
            sortBy: [SortDescriptor(\Ingredient.name, order: .forward)]
        )
        
        var foundIngredients = [Ingredient]()
        var foundRecipes = [Recipe]()
        
        // 3️⃣ Execute the Fetch Request
        do {
            foundIngredients = try modelContext.fetch(ingredientFetchDescriptor)
            
            if foundIngredients.isEmpty {
                // databaseSearchResults will be empty
                return
            }
            
            // For each found ingredient, append its recipes to foundRecipes
            for anIngredient in foundIngredients {
                for aRecipe in anIngredient.recipes! {
                    foundRecipes.append(aRecipe)
                }
            }
            
            /*
             A search query, e.g., chicken, may be contained in N ingredients of a recipe.
             For example, 'chicken' is contained in the following 3 ingredients of the same recipe:
             
             Ingredient 1: ½ pound of raw boneless chicken meat
             Ingredient 2: ¼ pound of chicken skin and fat
             Ingredient 3: 8 cups of store-bought or homemade chicken broth
             
             Each ingredient with name containing the same search query will
             return the same recipe N times. Therefore, duplicate recipes must be removed.
             */
            
            databaseSearchResults = foundRecipes.removeDuplicates()
            
        } catch {
            fatalError("Unable to fetch ingredient data from the database")
        }
        
    case "Nutrient Name":
        // 1️⃣ Define the Search Criterion (Predicate)
        let ingredientPredicate = #Predicate<Nutrient> {
            $0.name.localizedStandardContains(nutrientName) &&
            $0.amount <= maxNutrientAmount
        }
        
        // 2️⃣ Define the Fetch Descriptor
        let nutrientFetchDescriptor = FetchDescriptor<Nutrient>(
            predicate: ingredientPredicate,
            sortBy: [SortDescriptor(\Nutrient.name, order: .forward)]
        )
        
        var foundNutrients = [Nutrient]()
        var foundRecipes = [Recipe]()
        
        // 3️⃣ Execute the Fetch Request
        do {
            foundNutrients = try modelContext.fetch(nutrientFetchDescriptor)
            
            if foundNutrients.isEmpty {
                // databaseSearchResults will be empty
                return
            }

            // For each found nutrient, append its recipes to foundNutrients
            for aNutrient in foundNutrients {
                for aRecipe in aNutrient.recipes! {
                    foundRecipes.append(aRecipe)
                }
            }
            
            databaseSearchResults = foundRecipes
            
        } catch {
            fatalError("Unable to fetch nutrient data from the database")
        }
        
    default:
        print("Search category is out of range!")
    }
}


extension Array where Element: Equatable {
    func removeDuplicates() -> [Element] {
        var result = [Element]()
        
        for value in self {
            if result.contains(value) == false {
                result.append(value)
            }
        }
        return result
    }
}
