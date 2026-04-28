//
//  OpenFoodFactsApiData.swift
//  Basqt
//
//  Created by Osman Balci, Micki Ross, Jada Holloway, and Jonathan Hernandez Velasquez on 4/28/26.
//  Copyright © 2026 Osman Balci, Micki Ross, Jada Holloway, Jonathan Hernandez Velasquez. All rights reserved.
//

import Foundation

struct FoodStruct: Hashable {
    var foodName: String
    var brandOwner: String
    var categories: String
    var ingredients: String
    var imagePackagingUrl: String
    var imageNutritionUrl: String
}

var foodItem = FoodStruct(foodName: "", brandOwner: "", categories: "",
                          ingredients: "", imagePackagingUrl: "", imageNutritionUrl: "")

fileprivate var previousUPC = ""

public func getDataFromApi(upc: String) {

    if upc == previousUPC { return }
    previousUPC = upc

    foodItem = FoodStruct(foodName: "", brandOwner: "", categories: "",
                          ingredients: "", imagePackagingUrl: "", imageNutritionUrl: "")

    guard let apiQueryUrlStruct = URL(string: "https://world.openfoodfacts.net/api/v2/product/\(upc)") else { return }

    let headers = [
        "accept": "application/json",
        "cache-control": "no-cache",
        "host": "world.openfoodfacts.net"
    ]

    let request = NSMutableURLRequest(url: apiQueryUrlStruct,
                                      cachePolicy: .useProtocolCachePolicy,
                                      timeoutInterval: 10.0)
    request.httpMethod = "GET"
    request.allHTTPHeaderFields = headers

    let semaphore = DispatchSemaphore(value: 0)

    URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in

        guard error == nil else { semaphore.signal(); return }
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else { semaphore.signal(); return }
        guard let jsonDataFromApi = data else { semaphore.signal(); return }

        do {
            let jsonResponse = try JSONSerialization.jsonObject(with: jsonDataFromApi,
                                options: JSONSerialization.ReadingOptions.mutableContainers)

            guard let jsonDataDictionary = jsonResponse as? [String: Any],
                  let foodJsonObject    = jsonDataDictionary["product"] as? [String: Any],
                  let foodName          = foodJsonObject["product_name"] as? String
            else { semaphore.signal(); return }

            let brandOwner       = foodJsonObject["brand_owner"]         as? String ?? ""
            let categories       = foodJsonObject["categories"]          as? String ?? ""
            let ingredients      = foodJsonObject["ingredients_text_en"] as? String ?? ""
            let imagePackagingUrl = foodJsonObject["image_packaging_url"] as? String ?? ""
            let imageNutritionUrl = foodJsonObject["image_nutrition_url"] as? String ?? ""

            foodItem = FoodStruct(foodName: foodName, brandOwner: brandOwner,
                                  categories: categories, ingredients: ingredients,
                                  imagePackagingUrl: imagePackagingUrl,
                                  imageNutritionUrl: imageNutritionUrl)
        } catch {
            semaphore.signal()
            return
        }

        semaphore.signal()
    }.resume()

    _ = semaphore.wait(timeout: .now() + 10)
}
