//
//  WeatherCardView.swift
//  Basqt
//
//  Created by Osman Balci, Micki Ross, Jada Holloway, and Jonathan Hernandez Velasquez on 5/4/26.
//  Copyright © 2026 Osman Balci, Micki Ross, Jada Holloway, Jonathan Hernandez Velasquez. All rights reserved.
//

import SwiftUI
import SwiftData
import CoreLocation

struct WeatherCardView: View {

    @State private var temperature: Double = 0
    @State private var condition: String = ""
    @State private var cityName: String = ""

    var body: some View {
        RoundedRectangle(cornerRadius: 20)
            .fill(cardGradient)
            .frame(height: 120)
            .overlay(
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                            Text("\(Int(temperature))° F")
                                .font(.system(size: 44, weight: .bold))
                                .foregroundColor(.white)
                            Text(cityName)
                                .font(.system(size: 13, weight: .medium))
                                .foregroundColor(.white.opacity(0.85))
                            Text(condition)
                                .font(.system(size: 12))
                                .foregroundColor(.white.opacity(0.75))
                    }
                    .padding(.leading, 18)
                    .padding(.top, 10)

                    Spacer()

                    VStack {
                        Image(systemName: weatherIcon)
                            .font(.system(size: 48))
                            .foregroundColor(.white.opacity(0.9))
                            .shadow(radius: 4)
                    }
                    .padding(.trailing, 18)
                    .padding(.top, 10)
                }
            )
            .padding(.horizontal, 20)
            .onAppear {
                fetchWeather()
            }
    }

    var cardGradient: LinearGradient {
        let condition = self.condition.lowercased()
        if condition.contains("rain") || condition.contains("drizzle") {
            return LinearGradient(colors: [Color(red: 0.25, green: 0.35, blue: 0.55),
                                           Color(red: 0.15, green: 0.25, blue: 0.45)],
                                  startPoint: .topLeading, endPoint: .bottomTrailing)
        } else if condition.contains("snow") {
            return LinearGradient(colors: [Color(red: 0.6, green: 0.75, blue: 0.9),
                                           Color(red: 0.45, green: 0.6, blue: 0.8)],
                                  startPoint: .topLeading, endPoint: .bottomTrailing)
        } else if condition.contains("cloud") {
            return LinearGradient(colors: [Color(red: 0.4, green: 0.45, blue: 0.55),
                                           Color(red: 0.3, green: 0.35, blue: 0.45)],
                                  startPoint: .topLeading, endPoint: .bottomTrailing)
        } else if condition.contains("thunder") {
            return LinearGradient(colors: [Color(red: 0.2, green: 0.2, blue: 0.35),
                                           Color(red: 0.1, green: 0.1, blue: 0.25)],
                                  startPoint: .topLeading, endPoint: .bottomTrailing)
        } else {
            return LinearGradient(colors: [Color(red: 0.18, green: 0.42, blue: 0.18),
                                           Color(red: 0.10, green: 0.28, blue: 0.10)],
                                  startPoint: .topLeading, endPoint: .bottomTrailing)
        }
    }

    // MARK: - SF Symbol icon based on condition
    var weatherIcon: String {
        let c = condition.lowercased()
        if c.contains("thunder")            { return "cloud.bolt.fill" }
        if c.contains("snow")               { return "snowflake" }
        if c.contains("rain") || c.contains("drizzle") { return "cloud.rain.fill" }
        if c.contains("fog") || c.contains("mist")     { return "cloud.fog.fill" }
        if c.contains("cloud")              { return "cloud.fill" }
        return "sun.max.fill"   // clear
    }

    func fetchWeather() {
        let location = getUsersCurrentLocation()
        let lat = location.latitude
        let lon = location.longitude

        let apiKey = "8132c1fb2fe9d159fe1eb1f392b365e6"
        let urlString = "https://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&units=imperial&appid=\(apiKey)"

        guard let url = URL(string: urlString) else { return }

        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data,
                  let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any]
            else { return }

            let main     = json["main"]    as? [String: Any]
            let weather  = (json["weather"] as? [[String: Any]])?.first
            let tempF    = main?["temp"]     as? Double ?? 0
            let desc     = weather?["description"] as? String ?? ""
            let city     = json["name"] as? String ?? ""

            DispatchQueue.main.async {
                self.temperature = tempF
                self.condition   = desc.capitalized
                self.cityName    = city
            }
        }.resume()
    }
}
