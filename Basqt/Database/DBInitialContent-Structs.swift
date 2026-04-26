//
//  DBInitialContent-Structs.swift
//  Basqt
//
//  Created by Osman Balci, Micki Ross, Jada Holloway, and Jonathan Hernandez Velasquez on 4/25/26.
//  Copyright © 2026 Osman Balci, Micki Ross, Jada Holloway, Jonathan Hernandez Velasquez. All rights reserved.
//

import SwiftUI

struct GroceryItemStruct: Decodable {
    var name: String
    var brand: String
    var quantity: Int
    var calories: Int
    var fat: String
    var carbs: String
    var protein: String
    var allergens: String
    var notes: String
    var isChecked: Bool
    var barcode: String
}

/*
 {
     "name": "Organic Whole Milk",
     "brand": "Horizon",
     "quantity": 1,
     "calories": 150,
     "fat": "8g",
     "carbs": "12g",
     "protein": "8g",
     "allergens": "Dairy",
     "notes": "",
     "isChecked": false,
     "barcode": ""
 }
 */

struct GroceryListStruct: Decodable {
    var name: String
    var dateCreated: String
    var isCompleted: Bool
    var groceryItemStructs: [GroceryItemStruct]
}

/*
 {
     "name": "Weekly Groceries",
     "dateCreated": "April 25, 2026",
     "isCompleted": false,
     "groceryItemStructs": [ ... ]
 }
 */

struct RecipeStruct: Decodable {
    var name: String
    var briefDescription: String
    var ingredients: String
    var notes: String
    var calories: Int
    var dietaryTags: String
    var photoFullFilename: String
}

/*
 {
     "name": "Spicy Chicken Stir-fry",
     "briefDescription": "A quick and flavorful stir-fry with chicken and vegetables.",
     "ingredients": "Chicken breast — 200g\nBell peppers — 2\nSoy sauce — 2 tbsp",
     "notes": "No notes added.",
     "calories": 300,
     "dietaryTags": "Gluten-Free",
     "photoFullFilename": ""
 }
 */

struct FoodProductStruct: Decodable {
    var productName: String
    var brands: String
    var categories: String
    var ingredientsText: String
    var energyKcal: Double
    var fat: Double
    var saturatedFat: Double
    var carbohydrates: Double
    var sugars: Double
    var proteins: Double
    var salt: Double
}

/*
 {
     "productName": "Honey Nut Cheerios",
     "brands": "General Mills",
     "categories": "Cereals, Whole Grain",
     "ingredientsText": "Whole grain oats, sugar, honey...",
     "energyKcal": 180.0,
     "fat": 2.5,
     "saturatedFat": 0.5,
     "carbohydrates": 35.0,
     "sugars": 12.0,
     "proteins": 4.0,
     "salt": 0.27
 }
 */

struct FavoriteStoreStruct: Decodable {
    var latitude: Double
    var longitude: Double
    var name: String
    var shop: String
    var street: String
    var city: String
    var state: String
    var openingHours: String
}

/*
 {
     "latitude": 37.2296,
     "longitude": -80.4139,
     "name": "Kroger",
     "shop": "supermarket",
     "street": "1322 S Main St",
     "city": "Blacksburg",
     "state": "VA",
     "openingHours": "06:00-23:00"
 }
 */

