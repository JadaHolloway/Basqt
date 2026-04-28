//
//  GroceryItemDetail.swift
//  Basqt
//
//  Created by Osman Balci, Micki Ross, Jada Holloway, and Jonathan Hernandez Velasquez on 4/28/26.
//  Copyright © 2026 Osman Balci, Micki Ross, Jada Holloway, Jonathan Hernandez Velasquez. All rights reserved.
//

import SwiftUI
import SwiftData

struct GroceryItemDetail: View {

    var item: GroceryItem

    var body: some View {
        Form {
            Section(header: Text("Item Name")) {
                Text(item.name)
            }
            if !item.brand.isEmpty {
                Section(header: Text("Brand")) {
                    Text(item.brand)
                }
            }
            Section(header: Text("Quantity")) {
                Text("\(item.quantity)")
            }
            if !item.allergens.isEmpty {
                Section(header: Text("Allergens")) {
                    Text(item.allergens)
                }
            }
            if !item.barcode.isEmpty {
                Section(header: Text("Barcode (UPC)")) {
                    Text(item.barcode)
                }
            }
            if !item.notes.isEmpty {
                Section(header: Text("Notes")) {
                    Text(item.notes)
                }
            }
            Section(header: Text("Status")) {
                HStack {
                    Text("Checked off")
                    Spacer()
                    Image(systemName: item.isChecked ? "checkmark.circle.fill" : "circle")
                        .foregroundColor(item.isChecked ? .green : .gray)
                }
            }
        }   // End of Form
        .font(.system(size: 14))
        .navigationTitle(item.name)
        .toolbarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        GroceryItemDetail(item: GroceryItem(name: "Organic Whole Milk", brand: "Horizon",
                                            quantity: 1, calories: 150,
                                            fat: "8g", carbs: "12g", protein: "8g",
                                            allergens: "Dairy", notes: "", isChecked: false, barcode: ""))
    }
}
