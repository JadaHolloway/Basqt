//
//  FoodSlide.swift
//  Basqt
//
//  Created by Osman Balci and Micki Ross on 5/5/26.
//  Copyright © 2026 Osman Balci, Micki Ross, Jada Holloway, Jonathan Hernandez Velasquez. All rights reserved.
//

import SwiftUI

struct FoodSlide: View {
    
    // Default selected background color
    @State private var selectedBgColor = Color.gray.opacity(0.1)
    
    @State private var showAlertMessage = false
    //add timer to this?
    var body: some View {
        NavigationStack {
            ZStack {            // Background
                // Color entire background with selected color
                selectedBgColor
                
                // Place color picker at upper right corner
                VStack {        // Foreground
                    HStack {
                        Spacer()
                        ColorPicker("", selection: $selectedBgColor)
                            .padding()
                    }
                    Spacer()
                    
                    TabView {
                        // beachStructList is a global array of Beach structs given in TravelGuideData.swift
                        ForEach(beachStructList) { beach in
                            VStack {
                                Link(destination: URL(string: beach.websiteUrl)!) {
                                    Text(beach.title)
                                        .font(.headline)
                                        .multilineTextAlignment(.center)
                                        .padding()
                                }
                                Image(beach.photoFilename)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                            }
                        }
                    }   // End of TabView
                    .tabViewStyle(PageTabViewStyle())
                    .onAppear() {
                        UIPageControl.appearance().currentPageIndicatorTintColor = .black
                        UIPageControl.appearance().pageIndicatorTintColor = .gray
                    }
                    .navigationTitle("Your Best Foods in the World")
                    .toolbarTitleDisplayMode(.inline)
                    .toolbar {
                        // Place the Information button on right side of the toolbar
                        ToolbarItem(placement: .topBarTrailing) {
                            Button(action: {
                                showAlertMessage = true
                                alertTitle = "Source Reference"
                                alertMessage = "24 Best Island Beaches in the World data and photos are taken from: https://www.cntraveler.com"
                            }) {
                                Image(systemName: "info.circle")
                                    .imageScale(.small)
                                    .font(Font.title.weight(.light))
                            }
                        }
                    }
                    .alert(alertTitle, isPresented: $showAlertMessage, actions: {
                          Button("OK") {}
                        }, message: {
                          Text(alertMessage)
                        })
                    
                }   // End of VStack
            }   // End of ZStack
        }   // End of NavigationStack
    }   // End of body var
}
