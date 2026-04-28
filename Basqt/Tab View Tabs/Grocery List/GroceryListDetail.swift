//
//  GroceryListDetail.swift
//  Basqt
//
//  Created by Osman Balci, Micki Ross, Jada Holloway, and Jonathan Hernandez Velasquez on 4/28/26.
//  Copyright © 2026 Osman Balci, Micki Ross, Jada Holloway, Jonathan Hernandez Velasquez. All rights reserved.
//

import SwiftUI
import SwiftData

struct GroceryListDetail: View {

    @Environment(\.modelContext) private var modelContext
    var groceryList: GroceryList
    @State private var showAddItem = false

    var body: some View {
        let items = groceryList.items ?? []

        return List {
            if items.isEmpty {
                Section {
                    Text("No items in this list yet.")
                        .foregroundColor(.secondary)
                        .font(.system(size: 14))
                }
            } else {
                Section(header: Text("\(items.filter { $0.isChecked }.count) of \(items.count) checked")) {
                    ForEach(items) { item in
                        HStack(spacing: 12) {
                            Button(action: { item.isChecked.toggle() }) {
                                Image(systemName: item.isChecked ? "checkmark.circle.fill" : "circle")
                                    .foregroundColor(item.isChecked ? .green : .gray)
                                    .font(.system(size: 22))
                            }
                            .buttonStyle(.plain)

                            NavigationLink(destination: GroceryItemDetail(item: item)) {
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(item.name)
                                        .font(.system(size: 15, weight: .medium))
                                        .strikethrough(item.isChecked, color: .gray)
                                        .foregroundColor(item.isChecked ? .secondary : .primary)
                                    if !item.brand.isEmpty {
                                        Text(item.brand)
                                            .font(.system(size: 12))
                                            .foregroundColor(.secondary)
                                    }
                                }
                            }

                            Spacer()

                            if item.quantity > 1 {
                                Text("×\(item.quantity)")
                                    .font(.system(size: 13))
                                    .foregroundColor(.secondary)
                            }
                        }
                        .padding(.vertical, 4)
                    }
                    .onDelete(perform: deleteItem)
                }
            }
        }
        .listStyle(.insetGrouped)
        .navigationTitle(groceryList.name)
        .toolbarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                EditButton()
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: { showAddItem = true }) {
                    Image(systemName: "plus")
                }
            }
        }
        .sheet(isPresented: $showAddItem) {
            AddGroceryItem(groceryList: groceryList)
        }
    }

    func deleteItem(at offsets: IndexSet) {
        guard let items = groceryList.items else { return }
        for index in offsets {
            modelContext.delete(items[index])
        }
    }
}

#Preview {
    NavigationStack {
        GroceryListDetail(groceryList: GroceryList(name: "Weekly Groceries", dateCreated: "April 28, 2026", isCompleted: false, numberItems: "0"))
    }
}
