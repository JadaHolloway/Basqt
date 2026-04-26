//
//  RecipeList.swift
//  Basqt
//
//  Created by Osman Balci and Micki Ross on 4/26/26.
//  Copyright © 2026 Osman Balci, Micki Ross, Jada Holloway, Jonathan Hernandez Velasquez. All rights reserved.
//


import SwiftUI
import SwiftData

struct RecipeList: View {
    
    @Environment(\.modelContext) private var modelContext
    @Query(FetchDescriptor<ParkVisit>(sortBy: [SortDescriptor(\ParkVisit.parkName, order: .forward)])) private var listOfAllParkVisitsInDatabase: [ParkVisit]
    
    @State private var toBeDeleted: IndexSet?
    @State private var showConfirmation = false
    
    // Search Bar: 1 of 4 --> searchText contains the search query entered by the user
    @State private var searchText = ""
    
    var body: some View {
        NavigationStack {
            List {
                // Search Bar: 2 of 4 --> Use filteredParkVisits
                ForEach(filteredParkVisits) { aParkVisit in
                    NavigationLink(destination: ParkVisitDetails(parkVisit: aParkVisit, audioPlayer: AudioPlayer())) {
                        ParkVisitItem(parkVisit: aParkVisit)
                            .alert(isPresented: $showConfirmation) {
                                Alert(title: Text("Delete Confirmation"),
                                      message: Text("Are you sure to permanently delete the park visit? It cannot be undone."),
                                      primaryButton: .destructive(Text("Delete")) {
                                    /*
                                    'toBeDeleted (IndexSet).first' is an unsafe pointer to the index number of the array
                                     element to be deleted. It is nil if the array is empty. Process it as an optional.
                                    */
                                    if let index = toBeDeleted?.first {
                                       
                                        let parkVisitToDelete = listOfAllParkVisitsInDatabase[index]
                                        
                                        // ❎ Delete selected ParkVisit object from the database
                                        modelContext.delete(parkVisitToDelete)
                                    }
                                    toBeDeleted = nil
                                }, secondaryButton: .cancel() {
                                    toBeDeleted = nil
                                }
                            )
                        }   // End of alert
                    }
                }
                .onDelete(perform: delete)
                
            }   // End of List
            .font(.system(size: 14))
            .navigationTitle("National Parks Visited")
            .toolbarTitleDisplayMode(.inline)
            .toolbar {
                // Place the Edit button on left side of the toolbar
                ToolbarItem(placement: .topBarLeading) {
                    EditButton()
                }
                
                // Place the Add (+) button on right side of the toolbar
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink(destination: AddParkVisit()) {
                        Image(systemName: "plus")
                    }
                }
            }   // End of toolbar
            
        }   // End of NavigationStack
        // Search Bar: 3 of 4 --> Attach 'searchable' modifier to the NavigationStack
        .searchable(text: $searchText, prompt: "Search a Park Visited")
        
    }   // End of body var
    
    // Search Bar: 4 of 4 --> Compute filtered results
    var filteredParkVisits: [ParkVisit] {
        if searchText.isEmpty {
            listOfAllParkVisitsInDatabase
        } else {
            listOfAllParkVisitsInDatabase.filter {
                $0.parkName.localizedStandardContains(searchText) ||
                $0.states.localizedStandardContains(searchText) ||
                $0.rating.localizedStandardContains(searchText) ||
                $0.speechToTextNotes.localizedStandardContains(searchText)
            }
        }
    }
    
    func delete(at offsets: IndexSet) {
        
         toBeDeleted = offsets
         showConfirmation = true
     }
    
}
