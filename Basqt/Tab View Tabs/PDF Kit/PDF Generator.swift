//
//  Test.swift
//  Basqt
//
//  Created by Osman Balci and Micki Ross on 4/24/26.
//  Copyright © 2026 Osman Balci, Micki Ross, Jada Holloway, Jonathan Hernandez Velasquez. All rights reserved.
//

import UIKit
import PDFKit

class GroceryPDFGenerator {
    let items: [String]
    
    init(items: [String]) {
        self.items = items
    }

    func generatePDFData() -> Data {
        let pdfMetadata = [
            //kCGPDFStandardCharacterEncoding: "UTF-8",
            kCGPDFContextCreator: "Grocery App",
            kCGPDFContextTitle: "Weekly List"
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
            
            let titleAttributes: [NSAttributedString.Key: Any] = [.font: titleFont]
            "Grocery List".draw(at: CGPoint(x: 50, y: 50), withAttributes: titleAttributes)
            
            var yOffset: CGFloat = 120
            for item in items {
                let text = "• \(item)"
                text.draw(at: CGPoint(x: 50, y: yOffset), withAttributes: [.font: bodyFont])
                yOffset += 30
            }
        }
        
        return data
    }
}
