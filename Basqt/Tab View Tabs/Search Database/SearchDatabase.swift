//
//  SearchDatabase.swift
//  Recipes
//
//  Created by Osman Balci on 3/4/26.
//  Copyright © 2026 Osman Balci. All rights reserved.
//

import SwiftUI
import SwiftData

struct SearchDatabase: View {
    
    // ❎ Fetch all Cuisine objects from the database
    @Query(FetchDescriptor<Cuisine>(sortBy: [SortDescriptor(\Cuisine.name, order: .forward)])) private var listOfAllCuisinesInDatabase: [Cuisine]
    
    // ❎ Fetch all Publisher objects from the database
    @Query(FetchDescriptor<Publisher>(sortBy: [SortDescriptor(\Publisher.name, order: .forward)])) private var listOfAllPublishersInDatabase: [Publisher]
    
    @State private var selectedPublisherIndex = 5
    @State private var selectedCuisineIndex = 5
    
    let standardNutrients = ["Calories", "Cholesterol", "Dietary Fiber", "Protein", "Saturated Fat", "Sodium", "Sugars", "Total Carbohydrate", "Total Fat"]
    
    @State private var selectedNutrientIndex = 4        // Saturated Fat
    @State private var nutrientAmountTextFieldValue = ""
    @State private var nutrientAmount = 0.0
    
    @State private var searchFieldValue = ""
    @State private var searchCompleted = false
    
    //--------------
    // Alert Message
    //--------------
    @State private var showAlertMessage = false
    
    let searchCategories = ["Recipe Name", "Recipe Category", "Cuisine Name", "Publisher Name", "Ingredient Name", "Nutrient Name"]
    @State private var selectedCategoryIndex = 2
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    HStack {
                        Spacer()
                        Image("SearchDatabase")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 50)
                        Spacer()
                    }
                }
                Section(header: Text("Select Search Category")) {
                    Picker("", selection: $selectedCategoryIndex) {
                        ForEach(0 ..< searchCategories.count, id: \.self) {
                            Text(searchCategories[$0])
                        }
                    }
                }
                if selectedCategoryIndex == 2 {
                    Section(header: Text("Select a Cuisine")) {
                        Picker("", selection: $selectedCuisineIndex) {
                            ForEach(0 ..< listOfAllCuisinesInDatabase.count, id: \.self) {
                                Text(listOfAllCuisinesInDatabase[$0].name).tag($0)
                            }
                        }
                    }
                }
                if selectedCategoryIndex == 3 {
                    Section(header: Text("Select a Publisher")) {
                        Picker("", selection: $selectedPublisherIndex) {
                            ForEach(0 ..< listOfAllPublishersInDatabase.count, id: \.self) {
                                Text(listOfAllPublishersInDatabase[$0].name).tag($0)
                            }
                        }
                    }
                }
                if selectedCategoryIndex == 5 {
                    Section(header: Text("Select a Nutrient")) {
                        Picker("", selection: $selectedNutrientIndex) {
                            ForEach(0 ..< standardNutrients.count, id: \.self) {
                                Text(standardNutrients[$0])
                            }
                        }
                    }
                    Section(header: Text("Search recipes with selected nutrient's amount <= amount given below. Return after entering the value.")) {
                        HStack {
                            TextField("Enter Nutrient Amount", text: $nutrientAmountTextFieldValue)
                                .textFieldStyle(.roundedBorder)
                                .keyboardType(.numbersAndPunctuation)
                                .onSubmit {
                                    if let amount = Double(nutrientAmountTextFieldValue) {
                                        nutrientAmount = amount
                                    } else {
                                        showAlertMessage = true
                                        alertTitle = "Invalid Nutrient Amount!"
                                        alertMessage = "Entered nutrient amount \(nutrientAmountTextFieldValue) is not a number."
                                    }
                                }
                            
                            // Button to clear the text field
                            Button(action: {
                                nutrientAmountTextFieldValue = ""
                                nutrientAmount = 0.0
                            }) {
                                Image(systemName: "clear")
                                    .imageScale(.medium)
                                    .font(Font.title.weight(.regular))
                            }
                        }   // End of HStack
                    }
                }
                if selectedCategoryIndex == 0 || selectedCategoryIndex == 1 || selectedCategoryIndex == 4 {
                    Section(header: Text("\(searchCategories[selectedCategoryIndex])")) {
                        HStack {
                            TextField("Enter Search Query", text: $searchFieldValue)
                                .textFieldStyle(.roundedBorder)
                                .disableAutocorrection(true)
                                .textInputAutocapitalization(.never)
                            
                            // Button to clear the text field
                            Button(action: {
                                searchFieldValue = ""
                            }) {
                                Image(systemName: "clear")
                                    .imageScale(.medium)
                                    .font(Font.title.weight(.regular))
                            }
                            
                        }   // End of HStack
                    }
                }
                Section(header: Text("Search Database")) {
                    HStack {
                        Spacer()
                        Button(searchCompleted ? "Search Completed" : "Search") {
                            if inputDataValidated() {
                                searchDB()
                                searchCompleted = true
                            } else {
                                showAlertMessage = true
                                alertTitle = "Missing Input Data!"
                                alertMessage = "Please enter a database search query!"
                            }
                        }
                        .tint(.blue)
                        .buttonStyle(.bordered)
                        .buttonBorderShape(.capsule)
                        
                        Spacer()
                        
                    }   // End of HStack
                }
                if searchCompleted {
                    Section(header: Text("List Recipes Found")) {
                        NavigationLink(destination: showSearchResults) {
                            HStack {
                                Image(systemName: "list.bullet")
                                    .imageScale(.medium)
                                    .font(Font.title.weight(.regular))
                                Text("List Recipes Found")
                                    .font(.system(size: 16))
                            }
                        }
                    }
                    Section(header: Text("Clear")) {
                        HStack {
                            Spacer()
                            Button("Clear") {
                                searchCompleted = false
                                searchFieldValue = ""
                                nutrientAmountTextFieldValue = ""
                            }
                            .tint(.blue)
                            .buttonStyle(.bordered)
                            .buttonBorderShape(.capsule)
                            
                            Spacer()
                        }
                    }
                }
                
            }   // End of Form
            .font(.system(size: 14))
            .navigationTitle("Search Database")
            .toolbarTitleDisplayMode(.inline)
            .alert(alertTitle, isPresented: $showAlertMessage, actions: {
                Button("OK") {}
            }, message: {
                Text(alertMessage)
            })
            
        }   // End of NavigationStack
    }   // End of body var
    
    /*
     ---------------------
     MARK: Search Database
     ---------------------
     */
    func searchDB() {
        // Remove spaces, if any, at the beginning and at the end of the entered search query string
        let queryTrimmed = searchFieldValue.trimmingCharacters(in: .whitespacesAndNewlines)
        
        /*
         searchCategory, searchQuery, nutrientName, and maxNutrientAmount
         are global search parameters defined in DatabaseSearch.swift
         */
        
        searchCategory = searchCategories[selectedCategoryIndex]
        
        switch selectedCategoryIndex {
        case 0,1:   // Recipe Name or Recipe Category
            searchQuery = queryTrimmed
        case 2:     // Cuisine Name
            searchQuery = listOfAllCuisinesInDatabase[selectedCuisineIndex].name
        case 3:     // Publisher Name
            searchQuery = listOfAllPublishersInDatabase[selectedPublisherIndex].name
        case 4:     // Ingredient Name
            searchQuery = queryTrimmed
        case 5:     // Nutrient Name
            nutrientName = standardNutrients[selectedNutrientIndex]
            maxNutrientAmount = nutrientAmount
        default:
            print("selectedIndex is out of range")
        }
        
        // Public function conductDatabaseSearch is given in DatabaseSearch.swift
        conductDatabaseSearch()
    }
    
    /*
     -------------------------
     MARK: Show Search Results
     -------------------------
     */
    var showSearchResults: some View {
        
        // Global array databaseSearchResults is given in DatabaseSearch.swift
        if databaseSearchResults.isEmpty {
            return AnyView(
                NotFound(message: "Database Search Produced No Results!\n\nThe database did not return any value for the given search query!")
            )
        }
        
        return AnyView(SearchResultsList())
    }
    
    /*
     ---------------------------
     MARK: Input Data Validation
     ---------------------------
     */
    func inputDataValidated() -> Bool {
        
        if selectedCategoryIndex == 0 || selectedCategoryIndex == 1 || selectedCategoryIndex == 4 {
            // Remove spaces, if any, at the beginning and at the end of the entered search query string
            let queryTrimmed = searchFieldValue.trimmingCharacters(in: .whitespacesAndNewlines)
            
            if queryTrimmed.isEmpty {
                return false
            }
        }
        
        if selectedCategoryIndex == 5 && nutrientAmount == 0.0 {
            return false
        }
        
        return true
    }
    
}


#Preview {
    SearchDatabase()
}
