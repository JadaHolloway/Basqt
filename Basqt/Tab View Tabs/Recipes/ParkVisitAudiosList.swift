//
//  ParkVisitAudiosList.swift
//  NationalParks
//
//  Created by Osman Balci on 3/24/26.
//  Copyright © 2026 Osman Balci. All rights reserved.
//

import SwiftUI
import SwiftData

struct ParkVisitAudiosList: View {
    
    // Input Parameter
    let parkVisit: ParkVisit
    
    @Environment(\.modelContext) private var modelContext
    
    /*
     ----------------------------------------
     |   Publish-Subscribe Design Pattern   |
     ----------------------------------------
     Subscribe to state changes of the audioPlayer object instantiated from the
     @Observable class AudioPlayer. Whenever the audioPlayer object state changes
     refresh (update) this View, which means recompute the body var.
     */
    let audioPlayer: AudioPlayer
    
    @State private var toBeDeleted: IndexSet?
    @State private var showConfirmation = false
    
    var body: some View {
        VStack {
            Text(parkVisit.parkName)
                .font(.headline)
            List {
                // List voice recordings sorted w.r.t. dateTime attribute
                ForEach(parkVisit.parkVisitAudios!.sorted(by: { $0.dateTime < $1.dateTime })) { anAudio in
                    VStack {
                        Button(action: {
                            if audioPlayer.isPlaying {
                                audioPlayer.pauseAudioPlayer()
                            } else {
                                audioPlayer.stopAudioPlayer()
                                audioPlayer.createAudioPlayer(url: documentDirectory.appendingPathComponent(anAudio.audioFullFilename))
                                audioPlayer.startAudioPlayer()
                            }
                        }) {
                            HStack {
                                Image(systemName: audioPlayer.isPlaying ? "pause.fill" : "play.fill")
                                    .imageScale(.medium)
                                    .font(Font.title.weight(.regular))
                                Text("Play Voice Notes")
                                    .font(.system(size: 16))
                            }
                            .foregroundColor(.blue)
                        }
                        
                        Text(anAudio.dateTime)
                        
                    }   // End of VStack
                    .alert(isPresented: $showConfirmation) {
                        Alert(title: Text("Delete Confirmation"),
                              message: Text("Are you sure to permanently delete the park visit voice notes? It cannot be undone."),
                              primaryButton: .destructive(Text("Delete")) {
                            /*
                             'toBeDeleted (IndexSet).first' is an unsafe pointer to the index number of the array
                             element to be deleted. It is nil if the array is empty. Process it as an optional.
                             */
                            if let index = toBeDeleted?.first {
                                
                                let parkVisitAudioToDelete = parkVisit.parkVisitAudios![index]
                                
                                // ❎ Delete selected ParkVisitAudio object from the database
                                modelContext.delete(parkVisitAudioToDelete)
                                
                                // Delete it from the list of parkVisitAudios
                                parkVisit.parkVisitAudios!.remove(at: index)
                                
                                // Delete the audio file in document directory
                                do {
                                    let urlOfFileToDelete = documentDirectory.appendingPathComponent(parkVisitAudioToDelete.audioFullFilename)
                                    try FileManager.default.removeItem(at: urlOfFileToDelete)
                                } catch {
                                    print("Unable to delete audio file in document directory")
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
            .navigationTitle("Park Visit Voice Notes")
            .toolbarTitleDisplayMode(.inline)
            .toolbar {
                // Place the Edit button on left side of the toolbar
                ToolbarItem(placement: .topBarLeading) {
                    EditButton()
                }
                // Place the Add button on right side of the toolbar
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink(destination: AddParkVisitAudio(parkVisit: parkVisit)) {
                        Image(systemName: "mic.fill.badge.plus")
                    }
                }
            }   // End of toolbar
            
        }   // End of VStack
        .onDisappear() {
            audioPlayer.stopAudioPlayer()
        }
        
    }   // End of body var
    
    
    func delete(at offsets: IndexSet) {
        
         toBeDeleted = offsets
         showConfirmation = true
     }

}



