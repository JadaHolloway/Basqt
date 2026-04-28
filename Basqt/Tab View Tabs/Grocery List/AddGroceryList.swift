//
//  AddGroceryList.swift
//  Basqt
//
//  Created by Osman Balci, Micki Ross, Jada Holloway, and Jonathan Hernandez Velasquez on 4/28/26.
//  Copyright © 2026 Osman Balci, Micki Ross, Jada Holloway, Jonathan Hernandez Velasquez. All rights reserved.
//

import SwiftUI
import SwiftData

struct AddGroceryList: View {

    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @State private var listName = ""
    @State private var showAlertMessage = false

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("List Name")) {
                    HStack {
                        TextField("e.g. Weekly Groceries", text: $listName)
                            .disableAutocorrection(true)
                        Button(action: { listName = "" }) {
                            Image(systemName: "clear")
                                .imageScale(.medium)
                                .font(Font.title.weight(.regular))
                        }
                    }
                }
                Section {
                    HStack {
                        Spacer()
                        Button("Create List") {
                            if listName.isEmpty {
                                showAlertMessage = true
                                alertTitle = "Missing Name!"
                                alertMessage = "Please enter a name for the grocery list."
                            } else {
                                let today = Date().formatted(date: .long, time: .omitted)
                                let newList = GroceryList(
                                    name: listName,
                                    dateCreated: today,
                                    isCompleted: false,
                                    numberItems: "0",
                                    items: []
                                )
                                modelContext.insert(newList)
                                dismiss()
                            }
                        }
                        .tint(.blue)
                        .buttonStyle(.bordered)
                        .buttonBorderShape(.capsule)
                        Spacer()
                    }
                }
            }   // End of Form
            .font(.system(size: 14))
            .navigationTitle("New Grocery List")
            .toolbarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") { dismiss() }
                }
            }
            .alert(alertTitle, isPresented: $showAlertMessage, actions: {
                Button("OK") {}
            }, message: {
                Text(alertMessage)
            })
        }   // End of NavigationStack
    }
}

#Preview {
    AddGroceryList()
}
