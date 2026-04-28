//
//  EnterBarcodeUPC.swift
//  Basqt
//
//  Created by Osman Balci, Micki Ross, Jada Holloway, and Jonathan Hernandez Velasquez on 4/28/26.
//  Copyright © 2026 Osman Balci, Micki Ross, Jada Holloway, Jonathan Hernandez Velasquez. All rights reserved.
//

import SwiftUI

struct EnterBarcodeUPC: View {

    @State private var upcTextFieldValue = ""
    @State private var upcEntered = ""

    var body: some View {
        VStack(spacing: 16) {

            Text("The Universal Product Code (UPC) is a barcode symbology that consists of 12 digits uniquely assigned to each trade item.")
                .font(.system(size: 14))
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
                .padding(.horizontal)

            Text("Enter the UPC number of a food product to look up its nutrition information.")
                .font(.system(size: 14, weight: .semibold))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.blue.opacity(0.5), lineWidth: 1.5)
                        .background(Color.blue.opacity(0.05).clipShape(RoundedRectangle(cornerRadius: 12)))
                )
                .padding(.horizontal)

            HStack {
                Text("UPC:")
                    .font(.system(size: 14, weight: .medium))
                TextField("Enter 12-digit UPC", text: $upcTextFieldValue, onCommit: {
                    upcEntered = upcTextFieldValue
                })
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.numberPad)
                .disableAutocorrection(true)

                Button(action: {
                    upcTextFieldValue = ""
                    upcEntered = ""
                }) {
                    Image(systemName: "clear")
                        .imageScale(.medium)
                        .font(Font.title.weight(.regular))
                }
            }
            .padding(.horizontal)

            Button(action: { upcEntered = upcTextFieldValue }) {
                HStack {
                    Image(systemName: "magnifyingglass")
                    Text("Look Up Food Item")
                        .font(.system(size: 15, weight: .semibold))
                }
            }
            .tint(.blue)
            .buttonStyle(.bordered)
            .buttonBorderShape(.capsule)
            .disabled(upcTextFieldValue.isEmpty)

            if !upcEntered.isEmpty {
                NavigationLink(destination: foundFoodItemDetails) {
                    HStack {
                        Image(systemName: "list.bullet")
                            .imageScale(.large)
                        Text("Show Food Item Details")
                            .font(.system(size: 15))
                    }
                }
                .padding(.top, 4)
            }

            Spacer()
        }
        .padding(.top, 24)
        .navigationTitle("UPC Lookup")
        .toolbarTitleDisplayMode(.inline)
    }

    var foundFoodItemDetails: some View {
        getDataFromApi(upc: upcEntered)

        if foodItem.foodName.isEmpty {
            return AnyView(
                NotFound(message: "No data found for UPC \(upcEntered).\n\nThe Open Food Facts API did not return a result for this item.")
            )
        }
        return AnyView(ScannedFoodDetails(barcode: $upcEntered))
    }
}

#Preview {
    NavigationStack {
        EnterBarcodeUPC()
    }
}
