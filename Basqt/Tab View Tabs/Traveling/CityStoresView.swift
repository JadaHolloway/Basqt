//
//  HomeView.swift
//  Basqt
//
//  Created by Osman Balci and Micki Ross on 5/4/26.
//  Copyright © 2026 Osman Balci, Micki Ross, Jada Holloway, Jonathan Hernandez Velasquez. All rights reserved.
//
import SwiftUI
import MapKit
import CoreLocation
import SwiftData

struct CityStoresView: View {

    @State private var cityName: String = ""
    @State private var searchedCoordinate: CLLocationCoordinate2D?
    @State private var nearbyStores: [StoreStruct] = []

    @State private var selectedMapStyleIndex = 0

    let mapStyles = [
        "Standard",
        "Satelite",
        "Hybrid"
    ]

    @State private var mapPosition: MapCameraPosition = .automatic

    var body: some View {
        NavigationStack {

            VStack(spacing: 12) {

                // MARK: - Map Style Picker Section
                VStack(alignment: .leading, spacing: 8) {

                    Text("Select Map Style")
                        .font(.headline)
                        .padding(.horizontal)

                    Picker("Select Map Style", selection: $selectedMapStyleIndex) {
                        ForEach(0..<mapStyles.count, id: \.self) { index in
                            Text(mapStyles[index])
                        }
                    }
                    .pickerStyle(.segmented)
                    .padding(.horizontal)
                }

                // MARK: - City Search Field
                HStack {
                    Image(systemName: "mappin.and.ellipse")
                        .foregroundColor(.gray)

                    TextField("Enter city (e.g. Blacksburg, VA)", text: $cityName)
                        .textInputAutocapitalization(.words)
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .padding(.horizontal)

                Button("Search Stores") {
                    searchCity()
                }
                .buttonStyle(.borderedProminent)

                // MARK: - Map
                Map(position: $mapPosition) {

                    if let coord = searchedCoordinate {
                        Marker("City Center", coordinate: coord)
                    }

                    ForEach(storeAnnotations) { loc in
                        Annotation(loc.store.name, coordinate: loc.coordinate) {
                            Image(systemName: "storefront.fill")
                                .foregroundColor(.blue)
                        }
                    }
                }
                .mapStyle(selectedMapStyle)
                .frame(height: 250)

                // MARK: - List
                List(storeAnnotations) { loc in
                    VStack(alignment: .leading) {
                        Text(loc.store.name)
                            .font(.headline)

                        Text(distanceString(to: loc.store))
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }
            .navigationTitle("Nearby Grocery Stores in The Area")
        }
    }

    var selectedMapStyle: MapStyle {
        switch selectedMapStyleIndex {
        case 1:
            return .imagery
        case 2:
            return .hybrid
        default:
            return .standard
        }
    }

    var storeAnnotations: [StoreLocation] {
        nearbyStores.map {
            StoreLocation(
                store: $0,
                coordinate: CLLocationCoordinate2D(
                    latitude: $0.latitude,
                    longitude: $0.longitude
                )
            )
        }
    }

    func searchCity() {
        let query = cityName.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !query.isEmpty else { return }

        geocodeCity(query) { coord in
            guard let coord = coord else { return }

            DispatchQueue.main.async {
                self.searchedCoordinate = coord

                mapPosition = .region(
                    MKCoordinateRegion(
                        center: coord,
                        span: MKCoordinateSpan(latitudeDelta: 0.08, longitudeDelta: 0.08)
                    )
                )

                loadStores(latitude: coord.latitude, longitude: coord.longitude)
            }
        }
    }

    func loadStores(latitude: Double, longitude: Double) {
        DispatchQueue.global(qos: .userInitiated).async {
            getNearbyStores(latitude: latitude, longitude: longitude)

            DispatchQueue.main.async {
                self.nearbyStores = nearbyStoresList
            }
        }
    }

    func distanceString(to store: StoreStruct) -> String {
        guard let coord = searchedCoordinate else { return "" }

        let from = CLLocation(latitude: coord.latitude, longitude: coord.longitude)
        let to = CLLocation(latitude: store.latitude, longitude: store.longitude)

        let km = from.distance(from: to) / 1000.0
        let min = Int(km * 2)

        return String(format: "%.1f km · ~%d min drive", km, min)
    }

    // MARK: - Geocoding
    func geocodeCity(_ city: String, completion: @escaping (CLLocationCoordinate2D?) -> Void) {
        let geocoder = CLGeocoder()

        geocoder.geocodeAddressString(city) { placemarks, error in
            guard let location = placemarks?.first?.location else {
                completion(nil)
                return
            }

            completion(location.coordinate)
        }
    }
}
