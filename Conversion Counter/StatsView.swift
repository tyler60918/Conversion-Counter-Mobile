//
//  StatsView.swift
//  Conversion Counter
//
//  Created by Tyler Pierce on 11/13/25.
//

import SwiftUI
import SwiftData

struct StatsView: View {
    @Query private var conversions: [Item]
    @Environment(\.modelContext) private var context
    @State private var filterName: String = "All"
    @State private var sortType: String = "Date Sold"
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Statistics")
                .font(.largeTitle)
            HStack(spacing: 30) {
                Menu {
                    Picker("Filter", selection: $filterName) {
                        Text("All").tag("All")
                        Label("Accessories", systemImage: "bag").tag("Accessory")
                        Label("Upgrades", systemImage: "arrow.up.circle").tag("Upgrade")
                        Label("Trade-Ins", systemImage: "arrow.2.squarepath").tag("Trade-In")
                    }
                } label: {
                    Label("Filter", systemImage: "line.3.horizontal.decrease")
                        .font(.title2)
                }
                
                Menu {
                    Picker("Sort", selection: $sortType) {
                        Label("Date Sold", systemImage: "calendar").tag("Date Sold")
                        Label("Type", systemImage: "checkmark.circle").tag("Type")
                    }
                } label: {
                    Label("Sort", systemImage: "arrow.up.arrow.down")
                        .font(.title2)
                }
            }
            Spacer()
            
            let sortedConv = conversions.sorted {
                switch(sortType) {
                case "Date Sold":
                    return $0.date < $1.date
                case "Type":
                    return $0.convType < $1.convType
                default:
                    return false
                }
            }
            
            let filtered = sortedConv.filter { item in
                filterName == "All" || item.convType == filterName
            }
            
            let groupedByDate = Dictionary(grouping: filtered, by: { $0.date })
            
            ForEach(groupedByDate.keys.sorted(), id: \.self) { date in
                Text(date)
                     
                ForEach(groupedByDate[date] ?? []) { item in
                    HStack {
                        Text(item.convType)
                            .foregroundStyle(.primary)
                            .fontWeight(.bold)
                        Spacer()
                        Text(item.itemName)
                            .foregroundStyle(.primary)
                    }
                    .padding(EdgeInsets(top: 5, leading: 20, bottom: 5, trailing: 20))
                }
            }
            Spacer()
        }
    }
}

#Preview {
    StatsView()
        .modelContainer(for: Item.self, inMemory: true)
}
