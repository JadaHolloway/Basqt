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


struct RecipeDetails: View {
    
    // Input Parameter
    let recipe: Recipe
    let audioPlayer: AudioPlayer
    @State private var textToBeConvertedToSpeech = ""
    @State private var textEntered = false

    @State private var speechSynthesizer = AVSpeechSynthesizer()
    
@State private var isCopied = false
        
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
                        withAnimation {
                            isCopied = true
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            withAnimation {
                                isCopied = false
                            }
                        }
                    }) {
                        HStack {
                            Image(systemName: isCopied ? "checkmark.circle" : "document.on.document")
                            Text(isCopied ? "Copied!" : "Copy Ingredients")
                        }.foregroundColor(isCopied ? .green : .blue)
                    }
                }
                Section(header: Text(recipe.audioFullFilename.isEmpty ? "Read Description" : "Play Voice Memo")) {
                        Button(action: {
                            if !recipe.audioFullFilename.isEmpty {
                            if audioPlayer.isPlaying {
                                audioPlayer.pauseAudioPlayer()
                            } else {
                                audioPlayer.startAudioPlayer()
                            }
                            } else {
                                convertTextToSpeech()
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
                }
                .onAppear() {
                    if !recipe.audioFullFilename.isEmpty {
                        audioPlayer.createAudioPlayer(url: documentDirectory.appendingPathComponent(recipe.audioFullFilename))
                    } else {
                        audioPlayer.stopAudioPlayer()
                        textToBeConvertedToSpeech = recipe.briefDescription
                    }
            }
            .onDisappear() {
                audioPlayer.stopAudioPlayer()
            }
        )   // End of AnyView
    }
    func convertTextToSpeech() {
        
        if speechSynthesizer.isSpeaking {
            speechSynthesizer.stopSpeaking(at: .immediate)
        }
        
        
        let audioSession = AVAudioSession.sharedInstance()
        
        do {
            /*
             Override the Output Audio Port of the audioSession by
             routing audio to the built-in speaker and microphone.
             */
            try
                audioSession.overrideOutputAudioPort(AVAudioSession.PortOverride.speaker)
        } catch {
            print("Unable to override the Output Audio Port!")
        }
        
        // Create an AVSpeechUtterance instance with the text to be spoken
        let speechUtterance = AVSpeechUtterance(string: textToBeConvertedToSpeech)
        
        /*
         Set the speech language to English with U.S. dialect.
         Some of the English language dialects:
         English (Australia):         en-AU
         English (Ireland):           en-IE
         English (South Africa):      en-ZA
         English (United Kingdom):    en-GB
         English (United States):     en-US
         */
        speechUtterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        /*
         Set the speed (rate) at which entered text will be spoken;
         The higher the rate, the faster the speech will be.
         */
        speechUtterance.rate = 0.5
        
        /*
         Calling speechSynthesizer's speak method adds the speechUtterance to a queue;
         utterances are spoken in the order in which they are added to the queue.
         */
        speechSynthesizer.speak(speechUtterance)
    }
}



