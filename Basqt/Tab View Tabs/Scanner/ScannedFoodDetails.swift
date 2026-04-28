//
//  ScannedFoodDetails.swift
//  Basqt
//
//  Created by Osman Balci, Micki Ross, Jada Holloway, and Jonathan Hernandez Velasquez on 4/28/26.
//  Copyright © 2026 Osman Balci, Micki Ross, Jada Holloway, Jonathan Hernandez Velasquez. All rights reserved.
//

import SwiftUI
import SwiftData

struct ScannedFoodDetails: View {

    @Binding var barcode: String
    @Environment(\.modelContext) private var modelContext
    @Query(FetchDescriptor<GroceryList>()) private var groceryLists: [GroceryList]

    @State private var selectedListIndex = 0
    @State private var showAlertMessage = false

    var body: some View {
        Form {
            Section(header: Text("Food Name")) {
                Text(foodItem.foodName)
            }
            Section(header: Text("Brand Owner")) {
                Text(foodItem.brandOwner.isEmpty ? "Not available" : foodItem.brandOwner)
            }
            Section(header: Text("Categories")) {
                Text(foodItem.categories.isEmpty ? "Not available" : foodItem.categories)
            }
            Section(header: Text("Ingredients")) {
                Text(foodItem.ingredients.isEmpty ? "Not available" : foodItem.ingredients)
            }
            Section(header: Text("Packaging Photo")) {
                getImageFromUrl(url: foodItem.imagePackagingUrl, defaultFilename: "ImageUnavailable")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(minWidth: 300, maxWidth: 500, alignment: .center)
            }
            Section(header: Text("Nutrition Photo")) {
                getImageFromUrl(url: foodItem.imageNutritionUrl, defaultFilename: "ImageUnavailable")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(minWidth: 300, maxWidth: 500, alignment: .center)
            }

            if !groceryLists.isEmpty {
                Section(header: Text("Add to Grocery List")) {
                    Picker("Select List:", selection: $selectedListIndex) {
                        ForEach(0 ..< groceryLists.count, id: \.self) {
                            Text(groceryLists[$0].name)
                        }
                    }
                    HStack {
                        Spacer()
                        Button("Add to List") {
                            addToGroceryList()
                        }
                        .tint(.blue)
                        .buttonStyle(.bordered)
                        .buttonBorderShape(.capsule)
                        Spacer()
                    }
                }
            }

            Section(header: Text("Save to Food Products")) {
                HStack {
                    Spacer()
                    Button("Save Food Product") {
                        saveToFoodProducts()
                    }
                    .tint(.blue)
                    .buttonStyle(.bordered)
                    .buttonBorderShape(.capsule)
                    Spacer()
                }
            }
        }   // End of Form
        .font(.system(size: 14))
        .navigationTitle("Food Details")
        .toolbarTitleDisplayMode(.inline)
        .alert(alertTitle, isPresented: $showAlertMessage, actions: {
            Button("OK") {}
        }, message: {
            Text(alertMessage)
        })
    }

    func addToGroceryList() {
        let targetList = groceryLists[selectedListIndex]
        let newItem = GroceryItem(
            name: foodItem.foodName,
            brand: foodItem.brandOwner,
            quantity: 1,
            calories: 0,
            fat: "",
            carbs: "",
            protein: "",
            allergens: "",
            notes: "",
            isChecked: false,
            barcode: barcode
        )
        modelContext.insert(newItem)
        if targetList.items == nil {
            targetList.items = [newItem]
        } else {
            targetList.items!.append(newItem)
        }

        showAlertMessage = true
        alertTitle = "Added!"
        alertMessage = "\(foodItem.foodName) has been added to \"\(targetList.name)\"."
    }

    func saveToFoodProducts() {
        let newProduct = FoodProduct(
            productName: foodItem.foodName,
            brands: foodItem.brandOwner,
            categories: foodItem.categories,
            ingredientsText: foodItem.ingredients,
            energyKcal: 0.0,
            fat: 0.0,
            saturatedFat: 0.0,
            carbohydrates: 0.0,
            sugars: 0.0,
            proteins: 0.0,
            salt: 0.0
        )
        modelContext.insert(newProduct)

        showAlertMessage = true
        alertTitle = "Saved!"
        alertMessage = "\(foodItem.foodName) has been saved to your Food Products database."
    }
}

#Preview {
    ScannedFoodDetails(barcode: .constant("016000439894"))
}
