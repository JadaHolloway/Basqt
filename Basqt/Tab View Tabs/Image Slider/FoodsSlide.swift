//
//  FoodSlide.swift
//  Basqt
//
//  Created by Osman Balci and Micki Ross on 5/5/26.
//  Copyright © 2026 Osman Balci, Micki Ross, Jada Holloway, Jonathan Hernandez Velasquez. All rights reserved.
//

import SwiftUI
import SwiftData
import Combine

struct FoodSlide: View {
    @Query private var recipes: [Recipe]
    // Default selected background color
    @State private var selectedBgColor = Color.gray.opacity(0.1)

    @State private var showAlertMessage = false
    @State private var selectedTab = 0
    @State private var timer = Timer.publish(every: 3, on: .main, in: .common).autoconnect()


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
                    if recipes.isEmpty {
                        Text("No recipes are available.")
                        Spacer()
                    } else {
                        TabView(selection: $selectedTab) {

                            ForEach(0..<recipes.count, id: \.self) { index in
                                let recipe = recipes[index]
                                VStack {
                                    NavigationLink(destination: RecipeDetails(recipe: recipe, audioPlayer: AudioPlayer())) {
                                        Text(recipe.name)
                                            .font(.headline)
                                            .multilineTextAlignment(.center)
                                            .padding()
                                    }
                                    if recipe.photoFullFilename.isEmpty {
                                        Image(systemName: "photo")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .foregroundColor(.gray)
                                            .padding()
                                    } else {
                                        Image(recipe.photoFullFilename)
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                    }
                                }
                                .tag(index)
                            }
                        }   // End of TabView
                        .tabViewStyle(PageTabViewStyle())

                        .onReceive(timer) { _ in
                            withAnimation {
                                selectedTab = (selectedTab + 1) % recipes.count
                            }
                        }
                    }

                }
            }
            .onAppear() {
                UIPageControl.appearance().currentPageIndicatorTintColor = .black
                UIPageControl.appearance().pageIndicatorTintColor = .gray
            }
            .navigationTitle("Your Best Foods in the World")
            .toolbarTitleDisplayMode(.inline)
            .toolbar {

                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        showAlertMessage = true
                        alertTitle = "Recipe Slider"
                        alertMessage = "Swipe manually or let the timer show you the best recipes in your Basqt"
                    }) {
                        Image(systemName: "info.circle")
                            .imageScale(.small)
                            .font(Font.title.weight(.light))
                    }
                }
            }
            .alert(alertTitle, isPresented: $showAlertMessage) {
                Button("OK") {}
            } message: {
                Text(alertMessage)
            }
        }
    }
}
