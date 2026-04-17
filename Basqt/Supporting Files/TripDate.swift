//
//  TripDate.swift
//  TravelAid
//
//  Created by Osman Balci on 4/17/26.
//  Copyright © 2026 Osman Balci. All rights reserved.
//

import SwiftUI

struct TripDate: View {
    
    // Input Parameter
    let visitDate: String   // In the format "yyyy-MM-dd"
    
    var body: some View {
        
        if visitDate.isEmpty { return Text("")}
        
        // Create an instance of DateFormatter
        let dateFormatter = DateFormatter()
         
        // Set the date format to yyyy-MM-dd
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.locale = Locale(identifier: "en_US")
         
        // Convert date String from "yyyy-MM-dd" to Date struct
        let dateStruct = dateFormatter.date(from: visitDate)
         
        // Create a new instance of DateFormatter
        let newDateFormatter = DateFormatter()
         
        newDateFormatter.locale = Locale(identifier: "en_US")
        newDateFormatter.dateStyle = .long      // July 29, 2023
        newDateFormatter.timeStyle = .none
         
        // Obtain newly formatted Date String as "July 29, 2023"
        let dateWithNewFormat = newDateFormatter.string(from: dateStruct!)
        
        return Text(dateWithNewFormat)
    }
}


