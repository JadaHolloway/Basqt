//
//  FlashlightButtonView.swift
//  Basqt
//
//  Created by Osman Balci, Micki Ross, Jada Holloway, and Jonathan Hernandez Velasquez on 4/28/26.
//  Copyright © 2026 Osman Balci, Micki Ross, Jada Holloway, Jonathan Hernandez Velasquez. All rights reserved.
//

import SwiftUI

struct FlashlightButtonView: View {

    @Binding var lightOn: Bool

    var body: some View {
        VStack {
            HStack {
                Spacer()
                FlashlightButton(lightOn: $lightOn)
                    .padding()
            }
            Spacer()
        }
    }
}
