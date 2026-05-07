//
//  QuizStruct.swift
//  Basqt
//
//  Created by Osman Balci, Micki Ross, Jada Holloway, and Jonathan Hernandez Velasquez on 5/5/26.
//

import Foundation

struct QuizStruct: Hashable {
    let imageName: String       // Asset name matching photoFullFilename
    let productName: String
    let briefDescription: String
}

let quizStructList: [QuizStruct] = [
    QuizStruct(imageName: "Spicy Chicken Stir-fry",         productName: "Spicy Chicken Stir-fry",          briefDescription: "Gluten-Free"),
    QuizStruct(imageName: "Avocado Black Bean Tacos",       productName: "Avocado Black Bean Tacos",        briefDescription: "Vegan, Gluten-Free"),
    QuizStruct(imageName: "Lemon Garlic Salmon",            productName: "Lemon Garlic Salmon",             briefDescription: "Gluten-Free, High-Protein"),
    QuizStruct(imageName: "Overnight Oats with Berries",    productName: "Overnight Oats with Berries",     briefDescription: "Vegan, Dairy-Free"),
    QuizStruct(imageName: "Greek Chicken Bowl",             productName: "Greek Chicken Bowl",              briefDescription: "Gluten-Free, High-Protein"),
    QuizStruct(imageName: "Vegan Lentil Soup",              productName: "Vegan Lentil Soup",               briefDescription: "Vegan, Gluten-Free, Dairy-Free"),
    QuizStruct(imageName: "Pesto Zucchini Noodles",         productName: "Pesto Zucchini Noodles",          briefDescription: "Vegetarian, Gluten-Free, Low-Carb"),
    QuizStruct(imageName: "Egg Fried Rice",                 productName: "Egg Fried Rice",                  briefDescription: "Vegetarian, Dairy-Free"),
    QuizStruct(imageName: "Turkey and Spinach Stuffed Peppers", productName: "Turkey and Spinach Stuffed Peppers", briefDescription: "Gluten-Free, High-Protein"),
    QuizStruct(imageName: "Banana Peanut Butter Smoothie",  productName: "Banana Peanut Butter Smoothie",   briefDescription: "Vegetarian, High-Protein"),
    QuizStruct(imageName: "Shrimp and Mango Salad",         productName: "Shrimp and Mango Salad",          briefDescription: "Gluten-Free, Dairy-Free"),
    QuizStruct(imageName: "Butternut Squash Curry",         productName: "Butternut Squash Curry",          briefDescription: "Vegan, Gluten-Free"),
    QuizStruct(imageName: "Tuna Nicoise Salad",             productName: "Tuna Nicoise Salad",              briefDescription: "Gluten-Free, High-Protein"),
    QuizStruct(imageName: "Miso Glazed Cod",                productName: "Miso Glazed Cod",                 briefDescription: "Gluten-Free, High-Protein"),
    QuizStruct(imageName: "Caprese Pasta",                  productName: "Caprese Pasta",                   briefDescription: "Vegetarian"),
    QuizStruct(imageName: "Korean Beef Bibimbap",           productName: "Korean Beef Bibimbap",            briefDescription: "Dairy-Free, High-Protein"),
    QuizStruct(imageName: "Chia Seed Pudding with Mango",   productName: "Chia Seed Pudding with Mango",    briefDescription: "Vegan, Gluten-Free"),
    QuizStruct(imageName: "Sweet Potato and Black Bean Burrito", productName: "Sweet Potato and Black Bean Burrito", briefDescription: "Vegetarian, High-Fiber")
]
