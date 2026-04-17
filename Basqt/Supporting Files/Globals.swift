//
//  Globals.swift
//  NationalParks
//
//  Created by Osman Balci on 3/24/26.
//  Copyright © 2026 Osman Balci. All rights reserved.
//

import Foundation

//-------------------------------
// Global Constants and Variables
//-------------------------------

/*
 The National Park Service (NPS) application programming interface (API) provides authoritative
 NPS data that you can use in your apps, maps, and websites. To access that data, you need an API key.
 
 Obtain your own API key at https://www.nps.gov/subjects/developer/get-started.htm
 See API documentation at   https://www.nps.gov/subjects/developer/api-documentation.htm
 */
let myApiKey = "epvZtKBTQF6taEgfoP5lqTXPQNpZ23Hc7inRgb83"

// Global National Park Service API HTTP Headers
let npsApiHeaders = [
    "x-api-key": myApiKey,
    "accept": "application/json",
    "cache-control": "no-cache",
    "connection": "keep-alive",
    "host": "developer.nps.gov"
]

let usStates = ["Alabama (AL)", "Alaska (AK)", "Arizona (AZ)", "Arkansas (AR)", "California (CA)", "Colorado (CO)", "Connecticut (CT)", "Delaware (DE)", "Florida (FL)", "Georgia (GA)", "Hawaii (HI)", "Idaho (ID)", "Illinois (IL)", "Indiana (IN)", "Iowa (IA)", "Kansas (KS)", "Kentucky (KY)", "Louisiana (LA)", "Maine (ME)", "Maryland (MD)", "Massachusetts (MA)", "Michigan (MI)", "Minnesota (MN)", "Mississippi (MS)", "Missouri (MO)", "Montana (MT)", "Nebraska (NE)", "Nevada (NV)", "New Hampshire (NH)", "New Jersey (NJ)", "New Mexico (NM)", "New York (NY)", "North Carolina (NC)", "North Dakota (ND)", "Ohio (OH)", "Oklahoma (OK)", "Oregon (OR)", "Pennsylvania (PA)", "Rhode Island (RI)", "South Carolina (SC)", "South Dakota (SD)", "Tennessee (TN)", "Texas (TX)", "Utah (UT)", "Vermont (VT)", "Virginia (VA)", "Washington (WA)", "West Virginia (WV)", "Wisconsin (WI)", "Wyoming (WY)"]

//-----------------------------------
// National Park Visit Rating Choices
//-----------------------------------
let ratingChoices = ["Outstanding", "Excellent", "Great", "Very Good", "Good", "Satisfactory", "Fair", "Poor"]

//-----------------------------------------
// Global Alert Title and Message Variables
//-----------------------------------------
var alertTitle = ""
var alertMessage = ""

