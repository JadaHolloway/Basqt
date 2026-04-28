//
//  GroceryQuizData.swift
//  Basqt
//
//  Created by Osman Balci, Micki Ross, Jada Holloway, and Jonathan Hernandez Velasquez on 4/28/26.
//  Copyright © 2026 Osman Balci, Micki Ross, Jada Holloway, Jonathan Hernandez Velasquez. All rights reserved.
//

import SwiftUI

struct GroceryQuizStruct: Hashable {
    var question: String
    var choices: [String]       // Index 0 = "Select", indices 1–4 are the answer choices
    var correctChoiceIndex: Int // Index within choices[] that is correct (1–4)
}

// Global array of quiz question structs
var groceryQuizList = [GroceryQuizStruct]()

// Global variable
var numberOfQuizQuestions = 0

public func setUpGroceryQuiz() {

    groceryQuizList = [

        GroceryQuizStruct(
            question: "Which fruit has the highest natural sugar content?",
            choices: ["Select", "Apple", "Mango", "Banana", "Grapes"],
            correctChoiceIndex: 2
        ),
        GroceryQuizStruct(
            question: "Which vegetable is highest in protein?",
            choices: ["Select", "Broccoli", "Carrot", "Edamame", "Spinach"],
            correctChoiceIndex: 3
        ),
        GroceryQuizStruct(
            question: "How many calories are in one gram of fat?",
            choices: ["Select", "4", "7", "9", "12"],
            correctChoiceIndex: 3
        ),
        GroceryQuizStruct(
            question: "Which grain is naturally gluten-free?",
            choices: ["Select", "Wheat", "Barley", "Rye", "Quinoa"],
            correctChoiceIndex: 4
        ),
        GroceryQuizStruct(
            question: "Which of these is a complete protein source?",
            choices: ["Select", "Brown rice", "Black beans", "Lentils", "Eggs"],
            correctChoiceIndex: 4
        ),
        GroceryQuizStruct(
            question: "Which vitamin is abundant in citrus fruits?",
            choices: ["Select", "Vitamin A", "Vitamin C", "Vitamin D", "Vitamin K"],
            correctChoiceIndex: 2
        ),
        GroceryQuizStruct(
            question: "What does 'organic' mean on a food label?",
            choices: ["Select", "No added sugar", "Grown without synthetic pesticides", "Non-GMO certified", "Low calorie"],
            correctChoiceIndex: 2
        ),
        GroceryQuizStruct(
            question: "Which oil has the highest smoke point?",
            choices: ["Select", "Olive oil", "Coconut oil", "Avocado oil", "Butter"],
            correctChoiceIndex: 3
        ),
        GroceryQuizStruct(
            question: "What gives red peppers their color?",
            choices: ["Select", "Lycopene", "Capsaicin", "Carotenoids", "Anthocyanins"],
            correctChoiceIndex: 3
        ),
        GroceryQuizStruct(
            question: "Which nutrient is most important for bone health?",
            choices: ["Select", "Iron", "Calcium", "Potassium", "Zinc"],
            correctChoiceIndex: 2
        )

    ]

    numberOfQuizQuestions = groceryQuizList.count
}
