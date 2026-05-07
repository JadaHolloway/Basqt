//
//  FlagsGridQuiz.swift
//  Basqt
//
//  Created by Osman Balci, Micki Ross, Jada Holloway, and Jonathan Hernandez Velasquez on 5/5/26.
//  Copyright © 2026 Osman Balci, Micki Ross, Jada Holloway, Jonathan Hernandez Velasquez. All rights reserved.
//

import SwiftUI

// Randomly shuffle quizStructList
fileprivate var shuffledQuizStructList = quizStructList.shuffled()
fileprivate var selectedQuizStruct = shuffledQuizStructList[0]

struct FoodsGridQuiz: View {

    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var showAlertMessage = false
    @State private var targetQuizStruct = shuffledQuizStructList[0]
    @State private var questionIndex = 0

    // Fit as many images per row as possible with minimum image width of 100 points each.
    // spacing defines spacing between columns
    let columns = [ GridItem(.adaptive(minimum: 100), spacing: 3) ]

    var body: some View {
        NavigationStack {
            VStack {
                Text("Find the recipe:")
                    .font(.system(size: 16, weight: .light, design: .serif))
                    .italic()

                Text(targetQuizStruct.productName)
                    .font(.system(size: 22, weight: .bold, design: .serif))
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 2)

                ScrollView {
                    // spacing defines spacing between rows
                    LazyVGrid(columns: columns, spacing: 3) {
                        ForEach(shuffledQuizStructList, id: \.self) { aQuizStruct in

                            // Food image from Open Food Facts:
                            Image(aQuizStruct.imageName)
                                .resizable()
                                .scaledToFit()
                                .onTapGesture {
                                    if aQuizStruct.imageName == targetQuizStruct.imageName {
                                        alertTitle = " Correct!"
                                        alertMessage = "\(aQuizStruct.productName)\n\(aQuizStruct.briefDescription)"
                                    } else {
                                        alertTitle = " Wrong!"
                                        alertMessage = "That is \(aQuizStruct.productName).\nYou were looking for \(targetQuizStruct.productName)."
                                    }
                                    showAlertMessage = true
                                }
                        }
                    }   // End of LazyVGrid
                    .padding()

                }   // End of ScrollView

            }   // End of VStack
            .navigationTitle("Recipe Grid Quiz")
            .toolbarTitleDisplayMode(.inline)
            .alert(alertTitle, isPresented: $showAlertMessage, actions: {
                Button("Next Question") {
                    // Advance to next product, wrapping around
                    questionIndex = (questionIndex + 1) % shuffledQuizStructList.count
                    targetQuizStruct = shuffledQuizStructList[questionIndex]
                }
            }, message: {
                Text(alertMessage)
            })
        }
    }
}

