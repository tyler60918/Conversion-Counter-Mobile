//
//  InputView.swift
//  Conversion Counter
//
//  Created by Tyler Pierce on 11/13/25.
//

import SwiftUI

struct InputView: View {
    @State private var typeOfConversion: String = "Accessory"
    
    var body: some View {
        VStack {
            Text("Input Conversion")
                .font(.largeTitle)
            Picker("Select a conversion type", selection: $typeOfConversion) {
                Text("Accessory")
                Text("Trade-In")
                Text("Upgrade")
            }
            .pickerStyle(.wheel)
            TextField("Enter purchased item", text: .constant(""))
                .padding()

        }
    }
}

#Preview {
    InputView()
}
