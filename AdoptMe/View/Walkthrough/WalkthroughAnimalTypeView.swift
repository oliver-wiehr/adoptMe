//
//  WalkthroughAnimalTypeView.swift
//  AdoptMe
//
//  Created by Oliver Wiehr on 10/22/22.
//

import SwiftUI

struct WalkthroughAnimalTypeView: View {
    @Binding var selectedAnimalType: String
    @Binding var showWalkthrough: Bool
    var animalType: String?
    
    @State var showSheet = false
    
    @EnvironmentObject var adoptMe: AdoptMe
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 5)
                .foregroundColor(.gray)
            Text(animalType ?? "Other")
        }.onTapGesture {
            if let animalType = animalType {
                adoptMe.search = Search(animalType: animalType, filters: [:])
                withAnimation {
                    showWalkthrough = false
                }
            } else {
                showSheet = true
            }
        }.popover(isPresented: $showSheet) {
            FilterView(filter: Filter(id: "animalTypes", title: "Animal Types", options: adoptMe.animalTypes?.map {
                FilterOption(id: $0.name, title: $0.name)
            } ?? []), selectionAction: { filterOptionId in
                withAnimation {
                    showSheet = false
                }
                adoptMe.search = Search(animalType: filterOptionId, filters: [:])
                withAnimation {
                    showWalkthrough = false
                }
            })
        }
        
    }
}
