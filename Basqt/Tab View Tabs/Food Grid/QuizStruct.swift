//
//  QuizStruct.swift
//  Basqt
//
//  Created by lending on 5/5/26.
//

import Foundation

struct QuizStruct: Hashable {
    let barcode: String          // Open Food Facts uses barcode to get image
    let productName: String
}

// Barcode is used to build the image URL:
// https://images.openfoodfacts.org/images/products/{barcode}/front_en.display.jpg
let quizStructList: [QuizStruct] = [
    QuizStruct(barcode: "049000028911", productName: "Coca-Cola"),
    QuizStruct(barcode: "016000275645", productName: "Cheerios"),
    QuizStruct(barcode: "038000845017", productName: "Corn Flakes"),
    QuizStruct(barcode: "044000032364", productName: "Oreo"),
    QuizStruct(barcode: "028400090315", productName: "Lay's Classic"),
    QuizStruct(barcode: "021130126026", productName: "Tropicana Orange Juice"),
    QuizStruct(barcode: "070038638101", productName: "Nature Valley Granola Bar"),
    QuizStruct(barcode: "040000387503", productName: "Snickers"),
    QuizStruct(barcode: "011110038364", productName: "Peanut Butter"),
    QuizStruct(barcode: "013562000128", productName: "Wheat Thins")
]
