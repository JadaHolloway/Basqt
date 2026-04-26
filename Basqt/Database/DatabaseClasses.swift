//
//  DatabaseClasses.swift
//  Basqt
//
//  Created by Osman Balci, Micki Ross, Jada Holloway, and Jonathan Hernandez Velasquez on 4/25/26.
//  Copyright © 2026 Osman Balci, Micki Ross, Jada Holloway, Jonathan Hernandez Velasquez. All rights reserved.
//

import SwiftUI
import SwiftData

/*
 ==================
 |   WeatherKit   |
 ==================
 */
@Model
class Weather {
    var temp: Double
    var humidity: Int
    var weatherDescription: String
    var rainThreeHour: Double
    var cityName: String
    var latitude: Double
    var longitude: Double
    var country: String

    init(temp: Double, humidity: Int, weatherDescription: String, rainThreeHour: Double,
         cityName: String, latitude: Double, longitude: Double,
         country: String) {
        self.temp = temp
        self.humidity = humidity
        self.weatherDescription = weatherDescription
        self.rainThreeHour = rainThreeHour
        self.cityName = cityName
        self.latitude = latitude
        self.longitude = longitude
        self.country = country
    }
}

/*
 ========================
 |   Food Facts API     |
 ========================
 */
@Model
class FoodProduct {
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

    init(productName: String, brands: String, categories: String,
         ingredientsText: String, energyKcal: Double, fat: Double,
         saturatedFat: Double, carbohydrates: Double, sugars: Double,
         proteins: Double, salt: Double) {
        self.productName = productName
        self.brands = brands
        self.categories = categories
        self.ingredientsText = ingredientsText
        self.energyKcal = energyKcal
        self.fat = fat
        self.saturatedFat = saturatedFat
        self.carbohydrates = carbohydrates
        self.sugars = sugars
        self.proteins = proteins
        self.salt = salt
    }
}

/*
 ============================
 |   OpenStreetMap API      |
 ============================
 */
@Model
class OpenStreetStore {
    var latitude: Double
    var longitude: Double
    var name: String
    var shop: String
    var street: String
    var city: String
    var state: String
    var openingHours: String

    init(latitude: Double, longitude: Double, name: String,
         shop: String, street: String, city: String,
         state: String, openingHours: String) {
        self.latitude = latitude
        self.longitude = longitude
        self.name = name
        self.shop = shop
        self.street = street
        self.city = city
        self.state = state
        self.openingHours = openingHours
    }
}

/*
 ===================
 |   Grocery List  |
 ===================
 */
@Model
class GroceryList {
    var name: String
    var dateCreated: String
    var isCompleted: Bool

    // Relationships
    @Relationship(deleteRule: .cascade) var items: [GroceryItem]?

    init(name: String, dateCreated: String, isCompleted: Bool, items: [GroceryItem]? = nil) {
        self.name = name
        self.dateCreated = dateCreated
        self.isCompleted = isCompleted
        self.items = items
    }
}

/*
 ===================
 |   Grocery Item  |
 ===================
 */
@Model
class GroceryItem {
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

    init(name: String, brand: String, quantity: Int, calories: Int, fat: String, carbs: String,
         protein: String, allergens: String, notes: String, isChecked: Bool, barcode: String) {
        self.name = name
        self.brand = brand
        self.quantity = quantity
        self.calories = calories
        self.fat = fat
        self.carbs = carbs
        self.protein = protein
        self.allergens = allergens
        self.notes = notes
        self.isChecked = isChecked
        self.barcode = barcode
    }
}

/*
 =============
 |   Recipe  |
 =============
 */
@Model
class Recipe {
    var name: String
    var briefDescription: String
    var ingredients: String
    var notes: String
    var calories: Int
    var dietaryTags: String
    var photoFullFilename: String

    init(name: String, briefDescription: String, ingredients: String, notes: String,
         calories: Int, dietaryTags: String, photoFullFilename: String) {
        self.name = name
        self.briefDescription = briefDescription
        self.ingredients = ingredients
        self.notes = notes
        self.calories = calories
        self.dietaryTags = dietaryTags
        self.photoFullFilename = photoFullFilename
    }
}
