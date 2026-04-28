//
//  ScannerView.swift
//  Basqt
//
//  Created by Osman Balci, Micki Ross, Jada Holloway, and Jonathan Hernandez Velasquez on 4/28/26.
//  Copyright © 2026 Osman Balci, Micki Ross, Jada Holloway, Jonathan Hernandez Velasquez. All rights reserved.
//

import SwiftUI
import AVFoundation

struct ScannerView: View {

    @State var barcode = ""
    @State var lightOn = false

    var body: some View {
        NavigationStack {
            VStack {
                if barcode.isEmpty {
                    ZStack {
                        BarcodeScanner(code: $barcode)
                        FlashlightButtonView(lightOn: $lightOn)
                        scanFocusRegionImage
                    }
                } else {
                    scannedFoodResult
                }
            }
            .navigationTitle("Scanner")
            .toolbarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    if barcode.isEmpty {
                        NavigationLink(destination: EnterBarcodeUPC()) {
                            Image(systemName: "keyboard")
                        }
                    } else {
                        Button("Scan Again") {
                            barcode = ""
                            lightOn = false
                        }
                    }
                }
            }
            .onDisappear {
                lightOn = false
            }
        }   // End of NavigationStack
    }

    var scannedFoodResult: some View {
        getDataFromApi(upc: barcode)

        if foodItem.foodName.isEmpty {
            return AnyView(
                NotFound(message: "No data found for UPC \(barcode).\n\nThe Open Food Facts API did not return a result for this item.")
            )
        }
        return AnyView(ScannedFoodDetails(barcode: $barcode))
    }
}

#Preview {
    ScannerView()
}
