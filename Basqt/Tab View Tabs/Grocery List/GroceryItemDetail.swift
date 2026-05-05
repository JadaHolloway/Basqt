//
//  GroceryItemDetail.swift
//  Basqt
//
//  Created by Osman Balci, Micki Ross, Jada Holloway, and Jonathan Hernandez Velasquez on 4/28/26.
//  Copyright © 2026 Osman Balci, Micki Ross, Jada Holloway, Jonathan Hernandez Velasquez. All rights reserved.
//

import SwiftUI
import SwiftData
import Translation
struct GroceryItemDetail: View {

    var item: GroceryItem
    @State private var showTranslation = false
    @State private var textToTranslate = ""

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
                .translationPresentation(isPresented: $showTranslation, text: textToTranslate)
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button(action: {
                            var parts: [String] = []
                            parts.append("Item: \(item.name)")
                            textToTranslate = parts.joined(separator: "\n")
                            showTranslation = true
                        }) {
                            Image(systemName: "translate")
                        }
                    }
                }
            }
        }
