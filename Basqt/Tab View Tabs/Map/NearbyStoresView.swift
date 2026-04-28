//
//  NearbyStoresView.swift
//  Basqt
//
//  Created by Osman Balci, Micki Ross, Jada Holloway, and Jonathan Hernandez Velasquez on 4/27/26.
//  Copyright © 2026 Osman Balci, Micki Ross, Jada Holloway, Jonathan Hernandez Velasquez. All rights reserved.
//

import SwiftUI
import MapKit
import SwiftData
import CoreLocation

struct StoreLocation: Identifiable {
    var id = UUID()
    var store: StoreStruct
    var coordinate: CLLocationCoordinate2D
}

struct NearbyStoresView: View {

    @Environment(\.modelContext) private var modelContext
    @Query(FetchDescriptor<OpenStreetStore>()) private var listOfFavoriteStores: [OpenStreetStore]

    @State private var searchText = ""
    @State private var nearbyStores = [StoreStruct]()
    @State private var userLocation = getUsersCurrentLocation()   // Given in CurrentLocation.swift

    @State private var mapCameraPosition: MapCameraPosition = .region(
        MKCoordinateRegion(
            center: getUsersCurrentLocation(),
            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        )
    )

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {

                // Search bar
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    TextField("Search nearby stores...", text: $searchText)
                        .font(.system(size: 14))
                }
                .padding(10)
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .padding(.horizontal, 14)
                .padding(.top, 8)
                .padding(.bottom, 6)

                // Map with store pins
                Map(position: $mapCameraPosition) {
                    Marker("You", coordinate: userLocation)
                        .tint(.blue)
                    ForEach(storeAnnotations) { loc in
                        Annotation(loc.store.name, coordinate: loc.coordinate) {
                            Image(systemName: "mappin.circle.fill")
                                .font(.title2)
                                .foregroundColor(Color(red: 0.18, green: 0.35, blue: 0.15))
                        }
                    }
                }
                .mapStyle(.standard)
                .frame(height: 210)

                // Store list
                List {
                    Section(header: Text("Stores Within 5 KM")) {
                        if storeAnnotations.isEmpty {
                            Text("Loading nearby stores...")
                                .font(.system(size: 13))
                                .foregroundColor(.secondary)
                        } else {
                            ForEach(storeAnnotations) { loc in
                                storeRow(for: loc.store)
                            }
                        }
                    }
                }
                .listStyle(.insetGrouped)

            }   // End of VStack
            .navigationTitle("Nearby Stores")
            .toolbarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: FavoritesView()) {
                        Image(systemName: "heart")
                    }
                }
            }
            .onAppear {
                loadNearbyStores()
            }
        }   // End of NavigationStack
    }

    // MARK: - Computed Properties

    var storeAnnotations: [StoreLocation] {
        let filtered = searchText.isEmpty ? nearbyStores : nearbyStores.filter {
            $0.name.localizedCaseInsensitiveContains(searchText)
        }
        return filtered.map {
            StoreLocation(store: $0,
                          coordinate: CLLocationCoordinate2D(latitude: $0.latitude, longitude: $0.longitude))
        }
    }

    // MARK: - Helper Functions

    func loadNearbyStores() {
        let lat = userLocation.latitude
        let lon = userLocation.longitude
        DispatchQueue.global(qos: .userInitiated).async {
            getNearbyStores(latitude: lat, longitude: lon)  // Given in OverpassApiData.swift
            DispatchQueue.main.async {
                nearbyStores = nearbyStoresList
            }
        }
    }

    func distanceString(to store: StoreStruct) -> String {
        let from = CLLocation(latitude: userLocation.latitude, longitude: userLocation.longitude)
        let to   = CLLocation(latitude: store.latitude, longitude: store.longitude)
        let km   = from.distance(from: to) / 1000.0
        let min  = Int(km * 2)   // ~30 km/h city driving
        return String(format: "%.1f km · ~%d min drive", km, min)
    }

    func isFavorite(_ store: StoreStruct) -> Bool {
        listOfFavoriteStores.contains { $0.name == store.name && $0.latitude == store.latitude }
    }

    func toggleFavorite(_ store: StoreStruct) {
        if let existing = listOfFavoriteStores.first(where: { $0.name == store.name && $0.latitude == store.latitude }) {
            modelContext.delete(existing)
        } else {
            let newFavorite = OpenStreetStore(
                latitude: store.latitude,
                longitude: store.longitude,
                name: store.name,
                shop: store.shop,
                street: store.street,
                city: store.city,
                state: store.state,
                openingHours: store.openingHours
            )
            modelContext.insert(newFavorite)
        }
    }

    func openDirections(to store: StoreStruct) {
        let coordinate = CLLocationCoordinate2D(latitude: store.latitude, longitude: store.longitude)
        let mapItem = MKMapItem(location: CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude), address: nil)
        mapItem.name = store.name
        mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving])
    }

    // MARK: - Store Row

    @ViewBuilder
    func storeRow(for store: StoreStruct) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 3) {
                Text(store.name)
                    .font(.system(size: 14, weight: .semibold))
                Text(distanceString(to: store))
                    .font(.system(size: 12))
                    .foregroundColor(.secondary)
            }
            Spacer()
            Button(action: { toggleFavorite(store) }) {
                Image(systemName: isFavorite(store) ? "heart.fill" : "heart")
                    .foregroundColor(isFavorite(store) ? .red : .gray)
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

}

#Preview {
    NearbyStoresView()
}
