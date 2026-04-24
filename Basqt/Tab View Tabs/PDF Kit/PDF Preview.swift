//
//  PDF Preview.swift
//  Basqt
//
//  Created by Osman Balci and Micki Ross on 4/24/26.
//  Copyright © 2026 Osman Balci, Micki Ross, Jada Holloway, Jonathan Hernandez Velasquez. All rights reserved.
//


import SwiftUI
import PDFKit

struct PDFPreviewView: UIViewRepresentable {
    let data: Data

    func makeUIView(context: Context) -> PDFView {
        let view = PDFView()
        // Here is your PDFKit 'PDFDocument' usage:
        view.document = PDFDocument(data: data)
        view.autoScales = true
        return view
    }

    func updateUIView(_ uiView: PDFView, context: Context) {}
}
