//
//  ScanFocusRegion.swift
//  Basqt
//
//  Created by Osman Balci, Micki Ross, Jada Holloway, and Jonathan Hernandez Velasquez on 4/28/26.
//  Copyright © 2026 Osman Balci, Micki Ross, Jada Holloway, Jonathan Hernandez Velasquez. All rights reserved.
//

import Foundation
import SwiftUI

var scanFocusRegionImage = Image("ImageUnavailable")

public func createScanFocusRegionImage() {

    let viewWidth: CGFloat  = 300
    let viewHeight: CGFloat = 200

    let scanningRegionView = UIImageView(frame: CGRect(x: 0, y: 0, width: viewWidth, height: viewHeight))

    UIGraphicsBeginImageContext(scanningRegionView.frame.size)
    scanningRegionView.image?.draw(in: CGRect(x: 0, y: 0,
                                              width: scanningRegionView.frame.width,
                                              height: scanningRegionView.frame.height))

    // Left bracket
    UIGraphicsGetCurrentContext()?.move(to: CGPoint(x: 30.0, y: 0.0))
    UIGraphicsGetCurrentContext()?.addLine(to: CGPoint(x: 0.0, y: 0.0))
    UIGraphicsGetCurrentContext()?.addLine(to: CGPoint(x: 0.0, y: viewHeight))
    UIGraphicsGetCurrentContext()?.addLine(to: CGPoint(x: 30.0, y: viewHeight))

    // Right bracket
    UIGraphicsGetCurrentContext()?.move(to: CGPoint(x: viewWidth - 30.0, y: 0.0))
    UIGraphicsGetCurrentContext()?.addLine(to: CGPoint(x: viewWidth, y: 0.0))
    UIGraphicsGetCurrentContext()?.addLine(to: CGPoint(x: viewWidth, y: viewHeight))
    UIGraphicsGetCurrentContext()?.addLine(to: CGPoint(x: viewWidth - 30.0, y: viewHeight))

    UIGraphicsGetCurrentContext()?.setLineCap(CGLineCap.butt)
    UIGraphicsGetCurrentContext()?.setLineWidth(5)
    UIGraphicsGetCurrentContext()?.setStrokeColor(UIColor.darkGray.cgColor)
    UIGraphicsGetCurrentContext()?.setBlendMode(CGBlendMode.normal)
    UIGraphicsGetCurrentContext()?.strokePath()
    UIGraphicsGetCurrentContext()?.setAllowsAntialiasing(false)

    // Red focus line
    UIGraphicsGetCurrentContext()?.move(to: CGPoint(x: viewWidth * 0.10, y: viewHeight / 2.0))
    UIGraphicsGetCurrentContext()?.addLine(to: CGPoint(x: viewWidth * 0.9, y: viewHeight / 2.0))
    UIGraphicsGetCurrentContext()?.setLineCap(CGLineCap.butt)
    UIGraphicsGetCurrentContext()?.setLineWidth(1)
    UIGraphicsGetCurrentContext()?.setStrokeColor(UIColor.red.cgColor)
    UIGraphicsGetCurrentContext()?.setBlendMode(CGBlendMode.normal)
    UIGraphicsGetCurrentContext()?.strokePath()

    scanningRegionView.image = UIGraphicsGetImageFromCurrentImageContext()
    scanFocusRegionImage = Image(uiImage: scanningRegionView.image!)
    UIGraphicsEndImageContext()
}
