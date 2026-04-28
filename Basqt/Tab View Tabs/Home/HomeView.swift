//
//  HomeView.swift
//  Basqt
//
//  Created by lending on 4/27/26.
//  Copyright © 2026 Micki, Jada, Jonathan. All rights reserved.
//


import SwiftUI
import SwiftData

struct HomeView: View {
    @Query var lists: [GroceryList]
    var body: some View {
        VStack(alignment: .leading, spacing: 20)
        {
            Text("   Home")
                .font(.largeTitle)
                .bold()
                .padding(.top, 20)
            
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(red: 0.14, green: 0.34, blue: 0.14).opacity(0.9))
                .frame(height: 120)
                .overlay(
                    Text("72° F")
                        .font(.system(size: 50, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.leading, 10)
                        .padding(.top, 10),
                    alignment: .topLeading
                )
                .padding(.horizontal, 20)
            
            Text("YOUR ACTIVE LIST")
                .font(.system(size: 17))
                .fontWeight(.bold)
                .foregroundColor(.gray)
                .padding(.leading, 10)
                .padding(.top, 10)
            
            RoundedRectangle(cornerRadius: 20)
                .fill(.white)
                .frame(height: 70)
                .shadow(radius:3)
                .overlay(
                    HStack {
                        VStack(alignment: .leading) {
                            if let list = lists.first {
                                Text(list.name)
                                    .font(.headline)
                                
                                Text("\(list.items?.count ?? 0) items")
                                    .foregroundColor(.gray)
                                    .font(.subheadline)
                            }
                            
                        }
                    }
)
            Spacer()
        }
    }
}
