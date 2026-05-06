//
//  HomeView.swift
//  Basqt
//
//  Created by Osman Balci and Micki Ross on 5/4/26.
//  Copyright © 2026 Osman Balci, Micki Ross, Jada Holloway, Jonathan Hernandez Velasquez. All rights reserved.
//

import SwiftUI
import CoreLocation

struct SearchByCity: View {
    
    //-----------------
    // Search Variables
    //-----------------
    @State private var searchFieldValue = ""
    @State private var searchCompleted = false
    @State private var searchedCoordinate: CLLocationCoordinate2D?
    @State private var searchedCityName = ""
    
    //--------------
    // Progress View
    //--------------
    @State private var showProgressView = false
    
    //--------------
    // Alert Message
    //--------------
    @State private var showAlertMessage = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.gray.opacity(0.1).edgesIgnoringSafeArea(.all)
            Form {
                Section {
                    HStack {
                        Spacer()
                        Image("SearchAPI")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 50)
                        Spacer()
                    }
                }
                Section(header: Text("What city are you traveling to?")) {
                    HStack {
                        TextField("Enter City", text: $searchFieldValue)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .keyboardType(.default)
                            .autocapitalization(.words)
                            .disableAutocorrection(true)
                        
                        // Button to clear the text field
                        Button(action: {
                            searchFieldValue = ""
                            showAlertMessage = false
                            searchCompleted = false
                        }) {
                            Image(systemName: "clear")
                                .imageScale(.medium)
                                .font(Font.title.weight(.regular))
                        }
                    }
                }
                Section(header: Text("Search City to Find Stores near by")) {
                    HStack {
                        Spacer()
                        Button(searchCompleted ? "Search Completed" : "Search") {
                            if inputDataValidated() {
                                
                                showProgressView = true
                                
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                    /*
                                     Execute the following code after 0.1 second of delay
                                     so that they are not executed during the view update.
                                     */
                                    searchApi()
                                    
                                    // API search is completed
                                    showProgressView = false
                                    searchCompleted = true
                                }
                            } else {
                                alertTitle = "Missing Input Data!"
                                alertMessage = "Please enter a national park *full* name to search for!"
                                showAlertMessage = true
                            }
                        }
                        .tint(.blue)
                        .buttonStyle(.bordered)
                        .buttonBorderShape(.capsule)
                        
                        Spacer()
                    }
                }
                
                if showProgressView {
                    Section {
                        ProgressView()
                            // Style defined in ProgressViewStyle.swift
                            .progressViewStyle(DarkBlueShadowProgressViewStyle())
                    }
                }
                
                if searchCompleted {
                    Section(header: Text("Show Grocery Stores Found")) {
                        NavigationLink(destination: showSearchResults) {
                            HStack {
                                Image(systemName: "list.bullet")
                                    .imageScale(.medium)
                                    .font(Font.title.weight(.regular))
                                Text("Show Grocery Stores Found")
                                    .font(.system(size: 16))
                            }
                        }
                    }
                }
                
            }   // End of Form
            .navigationTitle("Search Grocery Store by City")
            .toolbarTitleDisplayMode(.inline)
            .onAppear() {
                searchCompleted = false
            }
            .alert(alertTitle, isPresented: $showAlertMessage, actions: {
                  Button("OK") {}
                }, message: {
                  Text(alertMessage)
                })
                
            }   // End of ZStack
            
        }   // End of NavigationStack
    }   // End of body var
    
    /*
    ------------------
    MARK: Search API
    ------------------
    */
    func searchApi() {

        let cityTrimmed = searchFieldValue.trimmingCharacters(in: .whitespacesAndNewlines)

        CLGeocoder().geocodeAddressString(cityTrimmed) { placemarks, error in

            if error != nil {
                alertTitle = "Search Error"
                alertMessage = "Unable to find that city."
                showAlertMessage = true
                return
            }

            guard let coordinate = placemarks?.first?.location?.coordinate else {

                alertTitle = "City Not Found"
                alertMessage = "Please enter a valid city name."
                showAlertMessage = true
                return
            }

            searchedCoordinate = coordinate
            searchedCityName = cityTrimmed

            searchCompleted = true
        }
    }
    
    /*
    ---------------------------
    MARK: Show Search Results
    ---------------------------
    */
    var showSearchResults: some View {

        if let coordinate = searchedCoordinate {

            return AnyView(
                CityStoresView()
            )
        }

        return AnyView(
            NotFound(
                message:
                    "No city found for '\(searchFieldValue)'.\n\nPlease enter a valid city name."
            )
        )
    }
    
    /*
     -----------------------------
     MARK: Input Data Validation
     -----------------------------
     */
    func inputDataValidated() -> Bool {
        
        // Remove spaces, if any, at the beginning and at the end of the entered search query string
        let queryTrimmed = searchFieldValue.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if queryTrimmed.isEmpty {
            return false
        }
        return true
    }
    
}
