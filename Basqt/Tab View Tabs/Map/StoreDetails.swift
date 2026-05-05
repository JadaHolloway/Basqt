//
//  StoreDetails.swift
//  Basqt
//
//  Created by Osman Balci, Micki Ross, Jada Holloway, and Jonathan Hernandez Velasquez on 4/27/26.
//  Copyright © 2026 Osman Balci, Micki Ross, Jada Holloway, Jonathan Hernandez Velasquez. All rights reserved.
//


import SwiftUI
//import MapKit
import AVFoundation


struct StoreDetails: View {
    
    // Input Parameter
    let store: OpenStreetStore
    var body: some View {
        
        return AnyView(
            Form {
                Section(header: Text("Store Name")) {
                    Text(store.name)
                }
                Section(header: Text("Store Location")) {
                    Text("\(store.street)\n\(store.city), \(store.state)")
                }
                if !store.openingHours.isEmpty {
                    Section(header: Text("Hours")) {
                        Text(store.openingHours)
                    }
                }
                Section(header: Text("Contact")) {
                    if !store.phoneNumber.isEmpty {
                        HStack {
                            Image(systemName: "phone.fill")
                                .foregroundColor(.green)
                            Link(store.phoneNumber, destination: URL(string: "tel:\(store.phoneNumber)")!)
                        }
                    }
                    if !store.websiteURL.isEmpty {
                        HStack {
                            Image(systemName: "globe")
                                .foregroundColor(.blue)
                            Link("Visit Website", destination: URL(string: store.websiteURL)!)
                        }
                    }
                }
            }   // End of Form
                .font(.system(size: 14))
                .navigationTitle("Store Details")
                .toolbarTitleDisplayMode(.inline).toolbar {
                }
        )   // End of AnyView
    }
}


