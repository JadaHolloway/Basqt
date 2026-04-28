//
//  AddGroceryItem.swift
//  Basqt
//
//  Created by Osman Balci, Micki Ross, Jada Holloway, and Jonathan Hernandez Velasquez on 4/28/26.
//  Copyright © 2026 Osman Balci, Micki Ross, Jada Holloway, Jonathan Hernandez Velasquez. All rights reserved.
//

import SwiftUI
import SwiftData

struct AddGroceryItem: View {

    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    var groceryList: GroceryList

    @State private var name = ""
    @State private var brand = ""
    @State private var quantity = 1
    @State private var notes = ""
    @State private var showAlertMessage = false

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Item Name")) {
                    HStack {
                        TextField("e.g. Whole Milk", text: $name)
                            .disableAutocorrection(true)
                        Button(action: { name = "" }) {
                            Image(systemName: "clear")
                                .imageScale(.medium)
                                .font(Font.title.weight(.regular))
                        }
                    }
                }
                Section(header: Text("Brand (Optional)")) {
                    HStack {
                        TextField("e.g. Horizon", text: $brand)
                            .disableAutocorrection(true)
                        Button(action: { brand = "" }) {
                            Image(systemName: "clear")
                                .imageScale(.medium)
                                .font(Font.title.weight(.regular))
                        }
                    }
                }
                Section(header: Text("Quantity")) {
                    Stepper("\(quantity)", value: $quantity, in: 1...99)
                }
                Section(header: Text("Notes (Optional)")) {
                    HStack {
                        TextField("e.g. Get organic", text: $notes)
                        Button(action: { notes = "" }) {
                            Image(systemName: "clear")
                                .imageScale(.medium)
                                .font(Font.title.weight(.regular))
                        }
                    }
                }
                Section {
                    HStack {
                        Spacer()
                        Button("Add Item") {
                            if name.isEmpty {
                                showAlertMessage = true
                                alertTitle = "Missing Name!"
                                alertMessage = "Please enter an item name."
                            } else {
                                saveItem()
                                dismiss()
                            }
                        }
                        .tint(.blue)
                        .buttonStyle(.bordered)
                        .buttonBorderShape(.capsule)
                        Spacer()
                    }
                }
            }   // End of Form
            .font(.system(size: 14))
            .navigationTitle("Add Item")
            .toolbarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") { dismiss() }
                }
            }
            .alert(alertTitle, isPresented: $showAlertMessage, actions: {
                Button("OK") {}
            }, message: {
                Text(alertMessage)
            })
        }   // End of NavigationStack
    }

    func saveItem() {
        let newItem = GroceryItem(
            name: name,
            brand: brand,
            quantity: quantity,
            calories: 0,
            fat: "",
            carbs: "",
            protein: "",
            allergens: "",
            notes: notes,
            isChecked: false,
            barcode: ""
        )
        modelContext.insert(newItem)

        if groceryList.items == nil {
            groceryList.items = [newItem]
        } else {
            groceryList.items!.append(newItem)
        }
    }
}

#Preview {
    AddGroceryItem(groceryList: GroceryList(name: "Weekly Groceries", dateCreated: "April 28, 2026", isCompleted: false, numberItems: "0"))
}
