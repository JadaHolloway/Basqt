//
//  DatabaseCreation.swift
//  Basqt
//
//  Created by Osman Balci, Micki Ross, Jada Holloway, and Jonathan Hernandez Velasquez on 4/25/26.
//  Copyright © 2026 Osman Balci, Micki Ross, Jada Holloway, Jonathan Hernandez Velasquez. All rights reserved.
//

import SwiftUI
import SwiftData

public func createBasqtDatabase() {
    /*
     ------------------------------------------------
     |   Create Model Container and Model Context   |
     ------------------------------------------------
     */
    var modelContainer: ModelContainer

    do {
        modelContainer = try ModelContainer(for: Weather.self, FoodProduct.self,
                                                OpenStreetStore.self, GroceryList.self,
                                                GroceryItem.self, Recipe.self)
    } catch {
        print(error)
        return
    }

    let modelContext = ModelContext(modelContainer)

    /*
     --------------------------------------------------------------------
     |   Check to see if the database has already been created or not   |∫
     --------------------------------------------------------------------
     */
    let fetchDescriptor = FetchDescriptor<GroceryList>()

    let count = (try? modelContext.fetch(fetchDescriptor).count) ?? 0
    if count > 0 {
        print("Database has already been created!")
        return
    }

    print("Database will be created!")

    /*
     ************************************
     *   GroceryList Object Creation    *
     ************************************
     */
    var groceryListStructList = [GroceryListStruct]()

    groceryListStructList = decodeJsonFileIntoArrayOfStructs(fullFilename: "DBInitialContent-GroceryLists.json", fileLocation: "Main Bundle")

    for aListStruct in groceryListStructList {

        let newList = GroceryList(
            name: aListStruct.name,
            dateCreated: aListStruct.dateCreated,
            isCompleted: aListStruct.isCompleted,
            numberItems: aListStruct.numberItems,
            items: []
        )
        modelContext.insert(newList)

        /*
         ====================================
         |   GroceryItem Object Creation    |
         ====================================
         */
        var listOfItemObjects = [GroceryItem]()

        for anItemStruct in aListStruct.groceryItemStructs {
            let newItem = GroceryItem(
                name: anItemStruct.name,
                brand: anItemStruct.brand,
                quantity: anItemStruct.quantity,
                calories: anItemStruct.calories,
                fat: anItemStruct.fat,
                carbs: anItemStruct.carbs,
                protein: anItemStruct.protein,
                allergens: anItemStruct.allergens,
                notes: anItemStruct.notes,
                isChecked: anItemStruct.isChecked,
                barcode: anItemStruct.barcode
            )
            modelContext.insert(newItem)
            listOfItemObjects.append(newItem)
        }

        newList.items = listOfItemObjects

    }   // End of for loop

    /*
     ****************************
     *   Recipe Object Creation  *
     ****************************
     */
    var recipeStructList = [RecipeStruct]()

    recipeStructList = decodeJsonFileIntoArrayOfStructs(fullFilename: "DBInitialContent-Recipes.json", fileLocation: "Main Bundle")

    for aRecipeStruct in recipeStructList {
        let newRecipe = Recipe(
            name: aRecipeStruct.name,
            briefDescription: aRecipeStruct.briefDescription,
            ingredients: aRecipeStruct.ingredients,
            notes: aRecipeStruct.notes,
            calories: aRecipeStruct.calories,
            dietaryTags: aRecipeStruct.dietaryTags,
            photoFullFilename: aRecipeStruct.photoFullFilename
        )
        modelContext.insert(newRecipe)
    }   // End of for loop

    /*
     *********************************
     *   FoodProduct Object Creation  *
     *********************************
     */
    var foodProductStructList = [FoodProductStruct]()

    foodProductStructList = decodeJsonFileIntoArrayOfStructs(fullFilename: "DBInitialContent-FoodProducts.json", fileLocation: "Main Bundle")

    for aProductStruct in foodProductStructList {
        let newProduct = FoodProduct(
            productName: aProductStruct.productName,
            brands: aProductStruct.brands,
            categories: aProductStruct.categories,
            ingredientsText: aProductStruct.ingredientsText,
            energyKcal: aProductStruct.energyKcal,
            fat: aProductStruct.fat,
            saturatedFat: aProductStruct.saturatedFat,
            carbohydrates: aProductStruct.carbohydrates,
            sugars: aProductStruct.sugars,
            proteins: aProductStruct.proteins,
            salt: aProductStruct.salt
        )
        modelContext.insert(newProduct)
    }   // End of for loop

    /*
     ************************************
     *   FavoriteStore Object Creation   *
     ************************************
     */
    var favoriteStoreStructList = [FavoriteStoreStruct]()

    favoriteStoreStructList = decodeJsonFileIntoArrayOfStructs(fullFilename: "DBInitialContent-FavoriteStores.json", fileLocation: "Main Bundle")

    for aStoreStruct in favoriteStoreStructList {
        let newStore = OpenStreetStore(
            latitude: aStoreStruct.latitude,
            longitude: aStoreStruct.longitude,
            name: aStoreStruct.name,
            shop: aStoreStruct.shop,
            street: aStoreStruct.street,
            city: aStoreStruct.city,
            state: aStoreStruct.state,
            openingHours: aStoreStruct.openingHours
        )
        modelContext.insert(newStore)
    }   // End of for loop

    /*
     =================================
     |   Save All Database Changes   |
     =================================

     NOTE: Database changes are automatically saved and SwiftUI Views are
     automatically refreshed upon State change in the UI or after a certain time period.
     But sometimes, you can manually save the database changes just to be sure.
     */
    do {
        try modelContext.save()
    } catch {
        fatalError("Unable to save database changes")
    }

    print("Database is successfully created!")
}
