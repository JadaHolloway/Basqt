//
//  FlashlightButton.swift
//  Basqt
//
//  Created by Osman Balci, Micki Ross, Jada Holloway, and Jonathan Hernandez Velasquez on 4/28/26.
//  Copyright © 2026 Osman Balci, Micki Ross, Jada Holloway, Jonathan Hernandez Velasquez. All rights reserved.
//

import SwiftUI
import AVFoundation

struct FlashlightButton: View {

    @Binding var lightOn: Bool

    var body: some View {
        Button(action: {
            withAnimation(.spring()) {
                toggleLight()
            }
        }) {
            Image(systemName: (lightOn ? "bolt.fill" : "bolt"))
                .imageScale(.medium)
                .font(Font.title.weight(.regular))
                .foregroundColor(lightOn ? .yellow : .blue)
                .scaleEffect(lightOn ? 1.2 : 1.0)
                .rotationEffect(.degrees(lightOn ? 360 : 0))
        }
    }

    func toggleLight() {
        guard let device = AVCaptureDevice.default(for: .video) else { return }
        lightOn.toggle()
        if device.hasTorch {
            do {
                try device.lockForConfiguration()
                device.torchMode = (lightOn) ? .on : .off
                device.unlockForConfiguration()
            } catch {
                print("Unable to Activate Flashlight!")
            }
        }
    }
}
