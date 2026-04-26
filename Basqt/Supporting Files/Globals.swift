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

//-----------------------------------------
// Global Alert Title and Message Variables
//-----------------------------------------
//var alertTitle = ""
//var alertMessage = ""

//----------------------------------------------------
// Open Weather API:  https://openweathermap.org/api
// API Guide:         https://openweathermap.org/guide
//----------------------------------------------------
let myOpenWeatherApiKey = "8132c1fb2fe9d159fe1eb1f392b365e6"

//***************************************************************************
// You are allowed to use Dr. Balci's API key above ONLY for this assignment.
//***************************************************************************
//fileprivate let imageNames = ["photo1", "photo2", "photo3", "photo4", "photo5", "photo6", "photo7", "photo8", "photo9", "photo10", "photo11", "photo12"]
//fileprivate let numberOfImages = 12
fileprivate let imageCaptions = ["Bora Bora – a small South Pacific island northwest of Tahiti in French Polynesia", "Dubai – a city and emirate in the United Arab Emirates known for luxury shopping", "London – capital of England and UK with history stretching back to Roman times", "Machu Picchu – a 15th-century Inca citadel located in southern Peru ", "Maldives – an archipelagic state and country in South Asia, situated in the Indian Ocean", "New York City – the most populous city in the United States", "Paris – France's capital, is a major city and a global center for art, fashion and culture", "Phuket – a rain-forested, mountainous island in Thailand with amazing beaches", "Rome – a historic city and the capital of Italy", "Sydney – one of Australia's largest cities, is best known for its Sydney Opera House", "Tahiti – the highest and largest island in French Polynesia", "Yellowstone – a national park for all to enjoy the unique hydrothermal and geologic features"]
//------------------------------
// Open Weather API HTTP Headers
//------------------------------
let openWeatherApiHeaders = [
    "accept": "application/json",
    "cache-control": "no-cache",
    "connection": "keep-alive",
    "host": "api.openweathermap.org"
]
