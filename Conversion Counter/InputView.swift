//
//  InputView.swift
//  Conversion Counter
//
//  Created by Tyler Pierce on 11/13/25.
//

import SwiftUI
import SwiftData

struct InputView: View {
    @Environment(\.modelContext) private var context

    @State private var typeOfConversion = "Conversion Type"
    @State private var itemPurchased = ""
    @State private var date = Date.now.formatted(
        .dateTime
            .year()
            .month(.twoDigits)
            .day(.twoDigits)
    )
    @State private var itemAdded = false
    @State private var toastOpacity = 1.0
    @State private var showError = false
    
    var body: some View {
        ZStack {
            VStack {
                Text("Input Conversion")
                    .font(.largeTitle)
                Picker("Conversion Type", selection: $typeOfConversion) {
                    Text("Conversion Type").tag("Conversion Type")
                    Text("Accessory").tag("Accessory")
                    Text("Trade-In").tag("Trade-In")
                    Text("Upgrade").tag("Upgrade")
                }
                .pickerStyle(.menu)
                TextField("Enter purchased item", text: $itemPurchased)
                    .padding()
                    .multilineTextAlignment(.center)
                    .autocorrectionDisabled(true)
                Button("Add item") {
                    if typeOfConversion == "Conversion Type" || itemPurchased.isEmpty {
                        showError = true
                        toastOpacity = 1.0
                    } else {
                        let newItem = Item(convType: typeOfConversion, itemName: itemPurchased, date: date)
                        context.insert(newItem)
                        print("Sold \(itemPurchased) in category \(typeOfConversion) on \(date)")
                        itemPurchased = ""
                        itemAdded = true
                        toastOpacity = 1.0
                    }
                }
            }
            if showError {
                ToastView(message: "Missing field/invalid selection", width: 400)
                    .opacity(toastOpacity)
                    .transition(.opacity)
                    .task {
                        try? await Task.sleep(nanoseconds: 2_000_000_000)
                        withAnimation(.easeInOut(duration: 0.4)) {
                            toastOpacity = 0
                            showError = false
                        }
                    }
            }
            if itemAdded {
                ToastView(message: "Item added", width: 200)
                    .opacity(toastOpacity)
                    .transition(.opacity)
                    .task {
                        try? await Task.sleep(nanoseconds: 2_000_000_000)
                        withAnimation(.easeInOut(duration: 0.4)) {
                            toastOpacity = 0
                            itemAdded = false
                        }
                    }
            }
        }
    }
}

#Preview {
    InputView()
}
