//
//  ParkVisitPhotosList.swift
//  NationalParks
//
//  Created by Osman Balci on 3/24/26.
//  Copyright © 2026 Osman Balci. All rights reserved.
//

import SwiftUI
import SwiftData

struct ParkVisitPhotosList: View {
    
    // Input Parameter
    let parkVisit: ParkVisit
    
    @Environment(\.modelContext) private var modelContext
    
    @State private var toBeDeleted: IndexSet?
    @State private var showConfirmation = false
    
    var body: some View {
        VStack {
            Text(parkVisit.parkName)
                .font(.headline)
            List {
                // List park visit photos sorted w.r.t. dateTime attribute
                ForEach(parkVisit.parkVisitPhotos!.sorted(by: { $0.dateTime < $1.dateTime })) { aPhoto in
                    VStack {
                        getImageFromDocumentDirectory(filename: aPhoto.photoFullFilename.components(separatedBy: ".")[0],
                                                      fileExtension: aPhoto.photoFullFilename.components(separatedBy: ".")[1],
                                                      defaultFilename: "ImageUnavailable")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(minWidth: 300, maxWidth: 500, alignment: .center)
                        
                        Text(aPhoto.dateTime)
                            .font(.subheadline)
                    }
                    .alert(isPresented: $showConfirmation) {
                        Alert(title: Text("Delete Confirmation"),
                              message: Text("Are you sure to permanently delete the park visit photo? It cannot be undone."),
                              primaryButton: .destructive(Text("Delete")) {
                            /*
                             'toBeDeleted (IndexSet).first' is an unsafe pointer to the index number of the array
                             element to be deleted. It is nil if the array is empty. Process it as an optional.
                             */
                            if let index = toBeDeleted?.first {
                                
                                let parkVisitPhotoToDelete = parkVisit.parkVisitPhotos![index]
                                
                                // ❎ Delete selected ParkVisitPhoto object from the database
                                modelContext.delete(parkVisitPhotoToDelete)
                                
                                // Delete it from the list of parkVisitPhotos
                                parkVisit.parkVisitPhotos!.remove(at: index)
                                
                                // Delete the photo file in document directory
                                do {
                                    let urlOfFileToDelete = documentDirectory.appendingPathComponent(parkVisitPhotoToDelete.photoFullFilename)
                                    try FileManager.default.removeItem(at: urlOfFileToDelete)
                                } catch {
                                    print("Unable to delete photo file in document directory")
                                }
                            }
                            toBeDeleted = nil
                            
                        }, secondaryButton: .cancel() {
                            toBeDeleted = nil
                        }
                        )   // End of Alert
                    }   // End of .alert
                }   // End of ForEach
                .onDelete(perform: delete)
                
            }   // End of List
            .font(.system(size: 14))
            .navigationTitle("Park Visit Photos")
            .toolbarTitleDisplayMode(.inline)
            .toolbar {
                // Place the Edit button on left side of the toolbar
                ToolbarItem(placement: .topBarLeading) {
                    EditButton()
                }
                // Place the Add button on right side of the toolbar
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink(destination: AddParkVisitPhoto(parkVisit: parkVisit)) {
                        Image(systemName: "photo.badge.plus")
                    }
                }
            }   // End of toolbar
            
        }   // End of VStack
    }   // End of body var
    
    
    func delete(at offsets: IndexSet) {
        
         toBeDeleted = offsets
         showConfirmation = true
     }

}


