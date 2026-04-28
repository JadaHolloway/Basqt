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
    @Environment(\.modelContext) private var modelContext
    @Query var lists: [GroceryList]
    @State private var showAddList = false

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 20) {
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

                Text("YOUR GROCERY LISTS")
                    .font(.system(size: 17))
                    .fontWeight(.bold)
                    .foregroundColor(.gray)
                    .padding(.leading, 10)
                    .padding(.top, 10)

                List {
                    if lists.isEmpty {
                        Text("No grocery lists yet — tap + to create one")
                            .foregroundColor(.secondary)
                            .font(.subheadline)
                    } else {
                        ForEach(lists) { list in
                            NavigationLink(destination: GroceryListDetail(groceryList: list)) {
                                VStack(alignment: .leading, spacing: 3) {
                                    Text(list.name)
                                        .font(.headline)
                                    Text("\(list.items?.count ?? 0) items")
                                        .foregroundColor(.gray)
                                        .font(.subheadline)
                                }
                                .padding(.vertical, 4)
                            }
                        }
                        .onDelete(perform: deleteList)
                    }
                }
                .listStyle(.insetGrouped)

                Spacer()
            }   // End of VStack
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: { showAddList = true }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showAddList) {
                AddGroceryList()
            }
        }   // End of NavigationStack
    }

    func deleteList(at offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(lists[index])
        }
    }
}
