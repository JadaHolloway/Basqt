//
//  FlagsGridQuiz.swift
//  Countries
//
//  Created by Osman Balci and Micki Ross on 5/5/26.
//  Copyright © 2026 Osman Balci, Micki Ross, Jada Holloway, Jonathan Hernandez Velasquez. All rights reserved.
//
import SwiftUI

// Randomly shuffle quizStructList
fileprivate var shuffledQuizStructList = quizStructList.shuffled()
fileprivate var selectedQuizStruct = shuffledQuizStructList[0]

struct FoodsGridQuiz: View {

    @State private var showAlertMessage = false
    
    // Fit as many images per row as possible with minimum image width of 100 points each.
    // spacing defines spacing between columns
    let columns = [ GridItem(.adaptive(minimum: 100), spacing: 3) ]
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("Guess which country's flag is it?\nTap the flag to find out if your guess is correct.")
                    .font(.system(size: 18, weight: .light, design: .serif))
                    .italic()
                    .multilineTextAlignment(.center)
                ScrollView {
                    // spacing defines spacing between rows
                    LazyVGrid(columns: columns, spacing: 3) {
                        // 🔴 Specifying id: \.self is critically important to prevent photos being listed as out of order
                        ForEach(shuffledQuizStructList, id: \.self) { aQuizStruct in

                            // Country flag image can be obtained as PNG: "https://flagcdn.com/w320/cca2-in-Lowercase.png"
                            getImageFromUrl(url: "https://flagcdn.com/w320/\(aQuizStruct.cca2.lowercased()).png", defaultFilename: "ImageUnavailable")
                                .resizable()
                                .scaledToFit()
                                .onTapGesture {
                                    alertTitle = aQuizStruct.countryCommonName
                                    alertMessage = aQuizStruct.capitalCityName
                                    showAlertMessage = true
                                }
                        }
                    }   // End of LazyVGrid
                    .padding()
                    
                }   // End of ScrollView
                
            }   // End of VStack
            .navigationTitle("Country Flags Grid Quiz")
            .toolbarTitleDisplayMode(.inline)
            .alert(alertTitle, isPresented: $showAlertMessage, actions: {
                Button("OK") {}
            }, message: {
                Text(alertMessage)
            })
        }
    }
}
