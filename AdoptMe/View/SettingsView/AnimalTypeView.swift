//
//  AnimalTypeView.swift
//  AdoptMe
//
//  Created by Oliver Wiehr on 10/22/22.
//

import SwiftUI

struct AnimalTypeView: View {
    @EnvironmentObject var adoptMe: AdoptMe
    @Binding var showSettingsView: Bool
    var animalType: String?
    
    @State var showSheet = false
    
    var body: some View {
        ZStack {
            if let animalType = animalType {
                Image(animalType.lowercased())
                    .resizable()
                    .aspectRatio(0.75, contentMode: .fill)
                    .cornerRadius(5)
            } else {
                RoundedRectangle(cornerRadius: 5)
                    .aspectRatio(0.75, contentMode: .fill)
                    .foregroundColor(.gray)
            }
            Text(animalType ?? "Other")
        }.onTapGesture {
            if let animalType = animalType {
                if let previousSearch = adoptMe.search {
                    adoptMe.recentSearches.insert(previousSearch, at: 0)
                }
                adoptMe.search = Search(animalType: animalType, filters: [:])
                withAnimation {
                    showSettingsView = false
                }
            } else {
                showSheet = true
            }
        }.popover(isPresented: $showSheet) {
            FilterView(filter: Filter(id: "animalTypes", title: "Animal Types", options: adoptMe.animalTypes?.map {
                FilterOption(id: $0.name, title: $0.name)
            } ?? []), selectionAction: { filterOptionId in
                if let previousSearch = adoptMe.search {
                    adoptMe.recentSearches.insert(previousSearch, at: 0)
                }
                adoptMe.search = Search(animalType: filterOptionId, filters: [:])
                withAnimation {
                    showSheet = false
                    showSettingsView = false
                }
            })
        }
        
    }
}
