//
//  FavoritesView.swift
//  Basqt
//
//  Created by Osman Balci, Micki Ross, Jada Holloway, and Jonathan Hernandez Velasquez on 4/27/26.
//  Copyright © 2026 Osman Balci, Micki Ross, Jada Holloway, Jonathan Hernandez Velasquez. All rights reserved.
//

import SwiftUI
import MapKit
import SwiftData
import CoreLocation

struct FavoritesView: View {

    @Environment(\.modelContext) private var modelContext
    @Query(FetchDescriptor<OpenStreetStore>()) private var listOfFavoriteStores: [OpenStreetStore]

    var body: some View {
        if listOfFavoriteStores.isEmpty {
            ContentUnavailableView(
                "No Favorites",
                systemImage: "heart.slash",
                description: Text("Tap the heart next to a store to save it here.")
            )
        } else {
            List {
                ForEach(listOfFavoriteStores) { store in
                    HStack {
                        VStack(alignment: .leading, spacing: 3) {
                            Text(store.name)
                                .font(.system(size: 14, weight: .semibold))
                            Text(addressLine(for: store))
                                .font(.system(size: 12))
                                .foregroundColor(.secondary)
                        }
                        Spacer()
                        Button(action: { modelContext.delete(store) }) {
                            Image(systemName: "heart.fill")
                                .foregroundColor(.red)
                        }
                        .buttonStyle(.plain)
                        .padding(.trailing, 10)
                        Button(action: { openDirections(to: store) }) {
                            Text("Directions")
                                .font(.system(size: 12, weight: .semibold))
                                .foregroundColor(.white)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 6)
                                .background(Color.blue)
                                .cornerRadius(8)
                        }
                        .buttonStyle(.plain)
                    }
                    .padding(.vertical, 4)
                }
                .onDelete(perform: deleteFavorite)
            }
            .listStyle(.insetGrouped)
            .navigationTitle("Favorites")
            .toolbarTitleDisplayMode(.inline)
        }
    }

    // MARK: - Helper Functions

    func addressLine(for store: OpenStreetStore) -> String {
        let parts = [store.street, store.city, store.state].filter { !$0.isEmpty }
        return parts.joined(separator: ", ")
    }

    func openDirections(to store: OpenStreetStore) {
        let coordinate = CLLocationCoordinate2D(latitude: store.latitude, longitude: store.longitude)
        let mapItem = MKMapItem(location: CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude), address: nil)
        mapItem.name = store.name
        mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving])
    }

    func deleteFavorite(at offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(listOfFavoriteStores[index])
        }
    }

}

#Preview {
    FavoritesView()
}
