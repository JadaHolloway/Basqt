//
//  RecipesDetails.swift
//  Basqt
//
//  Created by Osman Balci and Micki Ross on 4/26/26.
//  Copyright © 2026 Osman Balci, Micki Ross, Jada Holloway, Jonathan Hernandez Velasquez. All rights reserved.
//

import SwiftUI
//import MapKit
import AVFoundation


struct SearchRecipeDetails: View {
    
    // Input Parameter
    let recipe: Recipe
    let audioPlayer: AudioPlayer

    
    var body: some View {
        
        return AnyView(
            Form {
                Section(header: Text("Recipe Name")) {
                    Text(recipe.name)
                }
                
                Section(header: Text("Recipe Image"))
                {
                    let filename = (recipe.photoFullFilename as NSString).deletingPathExtension
                    let fileExtension = (recipe.photoFullFilename as NSString).pathExtension
                    
                    if recipe.photoFullFilename.isEmpty {
                        Image("ImageUnavailable")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 300)
                    } else if recipe.photoFullFilename.hasPrefix("http") {
                        getImageFromUrl(url: recipe.photoFullFilename, defaultFilename: "ImageUnavailable")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 300)
                    } else if UIImage(named: filename) != nil {
                        Image(filename)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 300)
                    } else {
                        getImageFromDocumentDirectory(filename: filename, fileExtension: fileExtension, defaultFilename: "ImageUnavailable")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 300)
                    }
                }
                Section(header: Text("Description")) {
                    Text(recipe.briefDescription)
                }
                Section(header: Text("Calories")) {
                    Text(" \(recipe.calories) kcal")
                }
                Section(header: Text("Dietary Tags")) {
                    if let tag = recipe.dietaryTags {
                        Text(tag.name)
                    } else {
                        Text("No dietary tag")
                    }
                }
                Section(header: Text("Ingredients")) {
                    Text(recipe.ingredients)
                    Button(action: {
                        UIPasteboard.general.string = recipe.ingredients
                    }) {
                        HStack {
                            Image(systemName: "document.on.clipboard")
                            Text("Copy Ingredients")
                        }.foregroundColor(.blue)
                    }
                }
                Section(header: Text("Play Voice Memo")) {
                    Button(action: {
                        if audioPlayer.isPlaying {
                            audioPlayer.pauseAudioPlayer()
                        } else {
                            audioPlayer.startAudioPlayer()
                        }
                    }) {
                        HStack {
                            Image(systemName: audioPlayer.isPlaying ? "pause.fill" : "play.fill")
                                .imageScale(.medium)
                                .font(Font.title.weight(.regular))
                            Text("Play Voice Memo")
                                .font(.system(size: 16))
                        }
                        .foregroundColor(.blue)
                    }
                }
                Section(header: Text("Notes")) {
                    if recipe.notes.isEmpty {
                        Text("No notes added.")
                    } else {
                        Text(recipe.notes)
                    }
                }
            }   // End of Form
                .font(.system(size: 14))
                .navigationTitle("Recipe Details")
                .toolbarTitleDisplayMode(.inline).toolbar {
                    ToolbarItem() {
                        Button(action: {
                            print("PDF Export for \(recipe.name)")
                        }) {
                            //Image(systemName: doc.text)
                            //add icon navigate to PDF Kit
                        }
                    }
                }
                .onAppear() {
                audioPlayer.createAudioPlayer(url: documentDirectory.appendingPathComponent(recipe.audioFullFilename))
            }
            .onDisappear() {
                audioPlayer.stopAudioPlayer()
            }
        )   // End of AnyView
    }
}



