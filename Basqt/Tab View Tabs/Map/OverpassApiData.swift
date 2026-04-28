//
//  OverpassApiData.swift
//  Basqt
//
//  Created by Osman Balci, Micki Ross, Jada Holloway, and Jonathan Hernandez Velasquez on 4/27/26.
//  Copyright © 2026 Osman Balci, Micki Ross, Jada Holloway, Jonathan Hernandez Velasquez. All rights reserved.
//

import Foundation
import CoreLocation

struct StoreStruct: Identifiable {
    var id = UUID()
    var name: String
    var shop: String
    var street: String
    var city: String
    var state: String
    var openingHours: String
    var latitude: Double
    var longitude: Double
}

// Global array accessible in all Swift files
var nearbyStoresList = [StoreStruct]()

/*
 ===================================================================================
 Fetch grocery stores within 5 km of the given coordinate using the Overpass API.
 Overpass API documentation: https://wiki.openstreetmap.org/wiki/Overpass_API
 ===================================================================================
 */
public func getNearbyStores(latitude: Double, longitude: Double) {

    nearbyStoresList = [StoreStruct]()

    /*
     Overpass QL query — finds nodes tagged as supermarket, grocery, or convenience
     stores within 5000 meters of the given lat/lon.
     */
    let overpassQuery = "[out:json];node[\"shop\"~\"supermarket|grocery|convenience\"](around:5000,\(latitude),\(longitude));out;"

    guard let encodedQuery = overpassQuery.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
          let apiUrl = URL(string: "https://overpass-api.de/api/interpreter?data=\(encodedQuery)") else {
        return
    }

    let request = NSMutableURLRequest(url: apiUrl,
                                      cachePolicy: .useProtocolCachePolicy,
                                      timeoutInterval: 15.0)
    request.httpMethod = "GET"

    let semaphore = DispatchSemaphore(value: 0)

    URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in

        guard error == nil else { semaphore.signal(); return }
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else { semaphore.signal(); return }
        guard let jsonData = data else { semaphore.signal(); return }

        do {
            let jsonResponse = try JSONSerialization.jsonObject(with: jsonData,
                                options: JSONSerialization.ReadingOptions.mutableContainers)

            guard let jsonDict = jsonResponse as? [String: Any],
                  let elements = jsonDict["elements"] as? [[String: Any]] else {
                semaphore.signal()
                return
            }

            for element in elements {
                guard let lat      = element["lat"] as? Double,
                      let lon      = element["lon"] as? Double,
                      let tags     = element["tags"] as? [String: Any],
                      let name     = tags["name"] as? String else { continue }

                let shop         = tags["shop"]           as? String ?? ""
                let street       = tags["addr:street"]    as? String ?? ""
                let city         = tags["addr:city"]      as? String ?? ""
                let state        = tags["addr:state"]     as? String ?? ""
                let openingHours = tags["opening_hours"]  as? String ?? ""

                let store = StoreStruct(name: name, shop: shop, street: street,
                                        city: city, state: state,
                                        openingHours: openingHours,
                                        latitude: lat, longitude: lon)
                nearbyStoresList.append(store)
            }

            // Sort by distance from user's location
            let userLocation = CLLocation(latitude: latitude, longitude: longitude)
            nearbyStoresList.sort {
                CLLocation(latitude: $0.latitude, longitude: $0.longitude).distance(from: userLocation) <
                CLLocation(latitude: $1.latitude, longitude: $1.longitude).distance(from: userLocation)
            }

        } catch {
            semaphore.signal()
            return
        }

        semaphore.signal()
    }.resume()

    _ = semaphore.wait(timeout: .now() + 15)
}
