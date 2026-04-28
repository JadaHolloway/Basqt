//
//  BarcodeScanner.swift
//  Basqt
//
//  Created by Osman Balci, Micki Ross, Jada Holloway, and Jonathan Hernandez Velasquez on 4/28/26.
//  Copyright © 2026 Osman Balci, Micki Ross, Jada Holloway, Jonathan Hernandez Velasquez. All rights reserved.
//

import SwiftUI
import UIKit
import AVKit
import AudioToolbox

struct BarcodeScanner: UIViewControllerRepresentable {

    typealias UIViewControllerType = ScannerViewController

    @Binding var code: String

    class Coordinator: NSObject, AVCaptureMetadataOutputObjectsDelegate {
        var scanner: BarcodeScanner

        init(_ parent: BarcodeScanner) {
            scanner = parent
        }

        func metadataOutput(_ output: AVCaptureMetadataOutput,
                            didOutput metadataObjects: [AVMetadataObject],
                            from connection: AVCaptureConnection) {
            if let metadataObject = metadataObjects.first {
                guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
                guard let barcodeString = readableObject.stringValue else { return }
                scanner.code = barcodeString
                AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
            }
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIViewController(context: UIViewControllerRepresentableContext<BarcodeScanner>) -> BarcodeScanner.UIViewControllerType {
        let scanner = ScannerViewController()
        scanner.delegate = context.coordinator
        return scanner
    }

    func updateUIViewController(_ uiViewController: BarcodeScanner.UIViewControllerType,
                                context: UIViewControllerRepresentableContext<BarcodeScanner>) {}
}
