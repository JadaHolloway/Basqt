//
//  ParkVisitItem.swift
//  NationalParks
//
//  Created by Osman Balci on 3/24/26.
//  Copyright © 2026 Osman Balci. All rights reserved.
//

import SwiftUI

struct ParkVisitItem: View {
    
    // Input Parameter
    let parkVisit: ParkVisit
    
    var body: some View {
        HStack {
            // This function is given in UtilityFunctions.swift
            getImageFromDocumentDirectory(filename: parkVisit.parkVisitPhotos![0].photoFullFilename.components(separatedBy: ".")[0],
                                          fileExtension: parkVisit.parkVisitPhotos![0].photoFullFilename.components(separatedBy: ".")[1],
                                          defaultFilename: "ImageUnavailable")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100.0, height: 75.0)
            
            VStack(alignment: .leading) {
                Text(parkVisit.parkName)
                
                // ParkVisitDate() is given in ParkVisitDate.swift
                ParkVisitDate(visitDate: parkVisit.date)
                
                Text(parkVisit.rating)
            }
            // Set font and size for the whole VStack content
            .font(.system(size: 14))
        }
    }
}
