//
//  GameView.swift
//  Basqt
//
//  Created by Osman Balci, Micki Ross, Jada Holloway, and Jonathan Hernandez Velasquez on 4/27/26.
//  Copyright © 2026 Osman Balci, Micki Ross, Jada Holloway, Jonathan Hernandez Velasquez. All rights reserved.
//

import SwiftUI

struct TriviaQuestion {
    let question: String
    let choices: [String]
    let correctIndex: Int
}

private let questions: [TriviaQuestion] = [
    TriviaQuestion(
        question: "Which fruit has the highest natural sugar content?",
        choices: ["Apple", "Mango", "Banana", "Grapes"],
        correctIndex: 1
    ),
    TriviaQuestion(
        question: "Which vegetable is highest in protein?",
        choices: ["Broccoli", "Carrot", "Edamame", "Spinach"],
        correctIndex: 2
    ),
    TriviaQuestion(
        question: "What nutrient is most abundant in whole milk?",
        choices: ["Protein", "Fat", "Calcium", "Carbohydrates"],
        correctIndex: 2
    ),
    TriviaQuestion(
        question: "Which grain is gluten-free?",
        choices: ["Wheat", "Barley", "Rye", "Quinoa"],
        correctIndex: 3
    ),
    TriviaQuestion(
        question: "How many calories are in one gram of fat?",
        choices: ["4", "7", "9", "12"],
        correctIndex: 2
    ),
    TriviaQuestion(
        question: "Which of these is considered a complete protein?",
        choices: ["Brown rice", "Black beans", "Lentils", "Eggs"],
        correctIndex: 3
    ),
    TriviaQuestion(
        question: "Which vitamin is found in citrus fruits?",
        choices: ["Vitamin A", "Vitamin C", "Vitamin D", "Vitamin K"],
        correctIndex: 1
    ),
    TriviaQuestion(
        question: "What does 'organic' mean on a food label?",
        choices: [
            "No added sugar",
            "Grown without synthetic pesticides",
            "Non-GMO certified",
            "Low calorie"
        ],
        correctIndex: 1
    ),
    TriviaQuestion(
        question: "Which oil has the highest smoke point?",
        choices: ["Olive oil", "Coconut oil", "Avocado oil", "Butter"],
        correctIndex: 2
    ),
    TriviaQuestion(
        question: "What gives red peppers their color?",
        choices: ["Lycopene", "Capsaicin", "Carotenoids", "Anthocyanins"],
        correctIndex: 2
    )
]

struct GameView: View {

    @State private var currentIndex = 0
    @State private var score = 0
    @State private var selectedAnswer: Int? = nil
    @State private var gameOver = false
    @State private var shuffledQuestions: [TriviaQuestion] = []

    var body: some View {
        NavigationStack {
            if gameOver {
                resultView
            } else if shuffledQuestions.isEmpty {
                ProgressView()
            } else {
                questionView
            }
        }
        .onAppear {
            startGame()
        }
    }

    // MARK: - Question View

    var questionView: some View {
        let q = shuffledQuestions[currentIndex]
        return VStack(spacing: 0) {
            // Progress bar
            ProgressView(value: Double(currentIndex), total: Double(shuffledQuestions.count))
                .padding(.horizontal)
                .padding(.top, 8)

            Text("Question \(currentIndex + 1) of \(shuffledQuestions.count)")
                .font(.system(size: 12))
                .foregroundColor(.secondary)
                .padding(.top, 6)

            Spacer()

            Text(q.question)
                .font(.system(size: 18, weight: .semibold))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 24)

            Spacer()

            VStack(spacing: 12) {
                ForEach(0..<q.choices.count, id: \.self) { i in
                    Button(action: { answerTapped(i) }) {
                        Text(q.choices[i])
                            .font(.system(size: 15, weight: .medium))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(choiceBackground(for: i, correct: q.correctIndex))
                            .foregroundColor(choiceForeground(for: i, correct: q.correctIndex))
                            .cornerRadius(12)
                    }
                    .disabled(selectedAnswer != nil)
                }
            }
            .padding(.horizontal, 24)

            Spacer()

            if selectedAnswer != nil {
                Button(currentIndex + 1 < shuffledQuestions.count ? "Next Question" : "See Results") {
                    advance()
                }
                .font(.system(size: 15, weight: .semibold))
                .tint(.blue)
                .buttonStyle(.bordered)
                .buttonBorderShape(.capsule)
                .padding(.bottom, 24)
            }
        }
        .navigationTitle("Grocery Trivia")
        .toolbarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Text("Score: \(score)")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.blue)
            }
        }
    }

    // MARK: - Result View

    var resultView: some View {
        VStack(spacing: 20) {
            Image(systemName: score >= 7 ? "star.fill" : score >= 5 ? "hand.thumbsup.fill" : "cart.fill")
                .font(.system(size: 60))
                .foregroundColor(score >= 7 ? .yellow : score >= 5 ? .green : .blue)

            Text(score >= 7 ? "Grocery Pro!" : score >= 5 ? "Good Job!" : "Keep Practicing!")
                .font(.system(size: 24, weight: .bold))

            Text("\(score) out of \(shuffledQuestions.count) correct")
                .font(.system(size: 16))
                .foregroundColor(.secondary)

            Button("Play Again") {
                startGame()
            }
            .tint(.blue)
            .buttonStyle(.bordered)
            .buttonBorderShape(.capsule)
            .font(.system(size: 15, weight: .semibold))
        }
        .navigationTitle("Results")
        .toolbarTitleDisplayMode(.inline)
    }

    // MARK: - Helper Functions

    func startGame() {
        shuffledQuestions = questions.shuffled()
        currentIndex = 0
        score = 0
        selectedAnswer = nil
        gameOver = false
    }

    func answerTapped(_ index: Int) {
        selectedAnswer = index
        if index == shuffledQuestions[currentIndex].correctIndex {
            score += 1
        }
    }

    func advance() {
        if currentIndex + 1 < shuffledQuestions.count {
            currentIndex += 1
            selectedAnswer = nil
        } else {
            gameOver = true
        }
    }

    func choiceBackground(for index: Int, correct: Int) -> Color {
        guard let selected = selectedAnswer else { return Color(.systemGray6) }
        if index == correct { return .green.opacity(0.85) }
        if index == selected { return .red.opacity(0.75) }
        return Color(.systemGray6)
    }

    func choiceForeground(for index: Int, correct: Int) -> Color {
        guard let selected = selectedAnswer else { return .primary }
        if index == correct || index == selected { return .white }
        return .primary
    }

}

#Preview {
    GameView()
}
