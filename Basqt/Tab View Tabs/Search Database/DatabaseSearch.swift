//
//  DatabaseSearch.swift
//  Recipes
//
//  Created by Osman Balci, Micki Ross, Jada Holloway, and Jonathan Hernandez Velasquez on 3/4/26.
//  Copyright © 2026 Osman Balci, Micki Ross, Jada Holloway, Jonathan Hernandez Velasquez. All rights reserved.
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
        modelContainer = try ModelContainer(for: Recipe.self, DietaryTags.self)
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
            sortBy: [SortDescriptor(\Recipe.name, order: .forward), SortDescriptor(\Recipe.name, order: .forward)]
        )
        
        // 3️⃣ Execute the Fetch Request
        do {
            databaseSearchResults = try modelContext.fetch(nameFetchDescriptor)
        } catch {
            fatalError("Unable to fetch name data from the database")
        }
    
        
    case "Dietary Tag":
        // 1️⃣ Define the Search Criterion (Predicate)
        let dietaryTagsPredicate = #Predicate<DietaryTags> {
            $0.name == searchQuery
        }
        
        // 2️⃣ Define the Fetch Descriptor
        let dietaryTagsFetchDescriptor = FetchDescriptor<DietaryTags>(
            predicate: dietaryTagsPredicate,
            sortBy: [SortDescriptor(\DietaryTags.name, order: .forward)]
        )
        
        var dietaryTagsResultsArray = [DietaryTags]()
        
        // 3️⃣ Execute the Fetch Request
        do {
            dietaryTagsResultsArray = try modelContext.fetch(dietaryTagsFetchDescriptor)
            
            if dietaryTagsResultsArray.isEmpty {
                // databaseSearchResults will be empty
                return
            }
            // cuisineResultsArray[0] is the found cuisine
            databaseSearchResults = dietaryTagsResultsArray[0].recipe!
            
        } catch {
            fatalError("Unable to fetch cuisine data from the database")
        }
        
    case "Calories":

        let maxCalories = Int(maxNutrientAmount)

        let caloriePredicate = #Predicate<Recipe> {
            $0.calories <= maxCalories
        }

        let calorieFetchDescriptor = FetchDescriptor<Recipe>(
            predicate: caloriePredicate,
            sortBy: [SortDescriptor(\Recipe.calories)]
        )

        do {
            databaseSearchResults = try modelContext.fetch(calorieFetchDescriptor)
        } catch {
            fatalError("Unable to fetch calorie data")
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
