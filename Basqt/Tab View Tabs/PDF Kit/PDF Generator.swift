//
//  GroceryPDFGenerator.swift
//  Basqt
//
//  Created by Osman Balci, Micki Ross, Jada Holloway, and Jonathan Hernandez Velasquez on 5/6/26.
//  Copyright © 2026 Osman Balci, Micki Ross, Jada Holloway, Jonathan Hernandez Velasquez. All rights reserved.
//

import UIKit
import PDFKit

class GroceryPDFGenerator {
    let groceryList: GroceryList
    
    init(groceryList: GroceryList) {
        self.groceryList = groceryList
    }

    func generatePDFData() -> Data {
        let pdfMetadata = [
            kCGPDFContextCreator: "Basqt App",
            kCGPDFContextTitle: groceryList.name
        ]
        
        let format = UIGraphicsPDFRendererFormat()
        format.documentInfo = pdfMetadata as [String: Any]

        // Standard A4/Letter size
        let pageRect = CGRect(x: 0, y: 0, width: 612, height: 792)
        let renderer = UIGraphicsPDFRenderer(bounds: pageRect, format: format)

        let data = renderer.pdfData { (context) in
            context.beginPage()
            
            // PDFKit drawing logic
            let titleFont = UIFont.boldSystemFont(ofSize: 30)
            let bodyFont = UIFont.systemFont(ofSize: 18)
            let dateFont = UIFont.systemFont(ofSize: 14)
            
            groceryList.name.draw(at: CGPoint(x: 50, y: 50), withAttributes: [.font: titleFont])
            
            let dateText = "Created: \(groceryList.dateCreated)"
            
            dateText.draw(at: CGPoint(x: 50, y: 90), withAttributes: [.font: dateFont, .foregroundColor: UIColor.gray])
            
            var yOffset: CGFloat = 120
            let items = groceryList.items ?? []
            
            if items.isEmpty {
                "No items in this list.".draw(at: CGPoint(x: 50, y: yOffset), withAttributes: [.font: bodyFont, .foregroundColor: UIColor.gray])
            } else {
                for item in items {
                    let status = item.isChecked ? "[x]" : "[ ]"
                    let brand = item.brand.isEmpty ? "" : "(\(item.brand))"
                    let text = "\(status) \(item.quantity)x \(item.name) \(brand)"
                    
                    text.draw(at: CGPoint(x: 50, y: yOffset), withAttributes: [.font: bodyFont])
                    yOffset += 30
                    
                    if yOffset > 740 {
                        context.beginPage()
                        yOffset = 50
                    }
                    
                }
            }
        }
        
        return data
    }
}
