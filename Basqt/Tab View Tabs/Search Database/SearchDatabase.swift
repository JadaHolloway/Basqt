//
//  HomeView.swift
//  Basqt
//
//  Created by Osman Balci and Micki Ross on 5/4/26.
//  Copyright © 2026 Osman Balci, Micki Ross, Jada Holloway, Jonathan Hernandez Velasquez. All rights reserved.
//
import SwiftUI
import SwiftData

struct SearchDatabase: View {
    
    @Query(FetchDescriptor<Recipe>(sortBy: [SortDescriptor(\Recipe.name, order: .forward)]))
    private var listOfAllRecipesInDatabase: [Recipe]
    
    @Query(FetchDescriptor<DietaryTags>(sortBy: [SortDescriptor(\DietaryTags.name, order: .forward)]))
    private var listOfAllDietaryTagsInDatabase: [DietaryTags]
    
    let standardNutrients = ["Calories"]
    
    @State private var selectedDietaryTagIndex = 0
    @State private var searchFieldValue = ""
    @State private var nutrientAmountTextFieldValue = ""
    @State private var nutrientAmount: Double = 0
    
    @State private var selectedCategoryIndex = 0
    @State private var searchCompleted = false
    
    @State private var showAlertMessage = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    
    let searchCategories = ["Recipe Name", "Dietary Tag", "Calories"]
    
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
                
                // CATEGORY PICKER
                Section(header: Text("Select Search Category")) {
                    Picker("", selection: $selectedCategoryIndex) {
                        ForEach(0..<searchCategories.count, id: \.self) {
                            Text(searchCategories[$0])
                        }
                    }
                }
                
                // NAME SEARCH
                if selectedCategoryIndex == 0 {
                    Section(header: Text("Recipe Name")) {
                        TextField("Enter search text", text: $searchFieldValue)
                            .textFieldStyle(.roundedBorder)
                    }
                }
                
                // DIETARY TAG SEARCH
                if selectedCategoryIndex == 1 {
                    Section(header: Text("Select Dietary Tag")) {
                        Picker("", selection: $selectedDietaryTagIndex) {
                            ForEach(0..<listOfAllDietaryTagsInDatabase.count, id: \.self) { index in
                                Text(listOfAllDietaryTagsInDatabase[index].name)
                            }
                        }
                    }
                }
                
                // CALORIES SEARCH
                if selectedCategoryIndex == 2 {
                    Section(header: Text("Maximum Calories")) {
                        TextField("Enter calories", text: $nutrientAmountTextFieldValue)
                            .textFieldStyle(.roundedBorder)
                            .keyboardType(.numberPad)
                    }
                }
                
                // SEARCH BUTTON
                Section(header: Text("Search Database")) {
                    HStack {
                        Spacer()
                        Button(searchCompleted ? "Search Completed" : "Search") {
                            
                            if inputDataValidated() {
                                
                                if selectedCategoryIndex == 2 {
                                    nutrientAmount = Double(nutrientAmountTextFieldValue) ?? 0
                                }
                                
                                conductSearch()
                                searchCompleted = true
                                
                            } else {
                                alertTitle = "Missing Input Data"
                                alertMessage = "Please enter a valid search query."
                                showAlertMessage = true
                            }
                        }
                        .tint(.blue)
                        .buttonStyle(.bordered)
                        .buttonBorderShape(.capsule)
                        
                        Spacer()
                    }
                    
                }
                
                // RESULTS
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
            }
            .font(.system(size: 14))
            .navigationTitle("Search Database")
            .toolbarTitleDisplayMode(.inline)
            .alert(alertTitle, isPresented: $showAlertMessage) {
                Button("OK") {}
            } message: {
                Text(alertMessage)
            }
        }
    }
    
    // MARK: - SEARCH LOGIC
    func conductSearch() {
        switch selectedCategoryIndex {
            
        case 0:
            databaseSearchResults = listOfAllRecipesInDatabase.filter {
                $0.name.localizedCaseInsensitiveContains(searchFieldValue)
            }
            
        case 1:
            let tag = listOfAllDietaryTagsInDatabase[selectedDietaryTagIndex].name
            databaseSearchResults = listOfAllRecipesInDatabase.filter {
                $0.dietaryTags?.name == tag
            }
            
        case 2:
            databaseSearchResults = listOfAllRecipesInDatabase.filter {
                Double($0.calories) <= nutrientAmount
            }
            
        default:
            databaseSearchResults = []
        }
    }
    
    // MARK: - RESULTS VIEW
    var showSearchResults: some View {
        
        // Global array databaseSearchResults is given in DatabaseSearch.swift
        if databaseSearchResults.isEmpty {
            return AnyView(
                NotFound(message: "Database Search Produced No Results!\n\nThe database did not return any value for the given search query!")
            )
        }
        
        return AnyView(SearchResultsList())
    }
    
    // MARK: - VALIDATION
    func inputDataValidated() -> Bool {
        
        switch selectedCategoryIndex {
        case 0:
            return !searchFieldValue.trimmingCharacters(in: .whitespaces).isEmpty
            
        case 1:
            return true
            
        case 2:
            return !nutrientAmountTextFieldValue.trimmingCharacters(in: .whitespaces).isEmpty
            
        default:
            return false
        }
    }
}
