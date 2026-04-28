//
//  GameView.swift
//  Basqt
//
//  Created by Osman Balci, Micki Ross, Jada Holloway, and Jonathan Hernandez Velasquez on 4/28/26.
//  Copyright © 2026 Osman Balci, Micki Ross, Jada Holloway, Jonathan Hernandez Velasquez. All rights reserved.
//

import SwiftUI

struct GameView: View {

    @State private var randomIndex = Int.random(in: 0 ..< numberOfQuizQuestions)
    @State private var answerIndex = 0

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Generate a New Question")) {
                    HStack {
                        Spacer()
                        Button("New Question") {
                            answerIndex = 0
                            randomIndex = Int.random(in: 0 ..< numberOfQuizQuestions)
                        }
                        .tint(.blue)
                        .buttonStyle(.bordered)
                        .buttonBorderShape(.capsule)
                        Spacer()
                    }
                }
                Section(header: Text("Question")) {
                    Text(groceryQuizList[randomIndex].question)
                }
                Section(header: Text("Select Your Answer")) {
                    Picker("Answer:", selection: $answerIndex) {
                        ForEach(0 ..< groceryQuizList[randomIndex].choices.count, id: \.self) {
                            Text(groceryQuizList[randomIndex].choices[$0])
                        }
                    }
                }
                if answerIndex != 0 {
                    Section(header: Text("Outcome")) {
                        HStack {
                            Spacer()
                            outcome
                                .multilineTextAlignment(.center)
                            Spacer()
                        }
                    }
                }

            }   // End of Form
            .navigationTitle("Grocery Trivia")
            .toolbarTitleDisplayMode(.inline)
        }   // End of NavigationStack
        .onAppear {
            setUpGroceryQuiz()
            randomIndex = Int.random(in: 0 ..< numberOfQuizQuestions)
        }
    }   // End of body var

    var outcome: Text {
        if answerIndex == groceryQuizList[randomIndex].correctChoiceIndex {
            return Text("Correct! 🎉")
        } else {
            return Text("Wrong!\nCorrect Answer: \(groceryQuizList[randomIndex].choices[groceryQuizList[randomIndex].correctChoiceIndex])")
        }
    }

}

#Preview {
    GameView()
}
