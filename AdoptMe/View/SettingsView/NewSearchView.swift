//
//  NewSearchView.swift
//  AdoptMe
//
//  Created by Oliver Wiehr on 10/22/22.
//

import SwiftUI

struct NewSearchView: View {
    @EnvironmentObject var adoptMe: AdoptMe
    @Binding var showSettingsView: Bool
    
    var body: some View {
        VStack {
            Text("New Search")
                .font(.title3)
            HStack {
                AnimalTypeView(showSettingsView: $showSettingsView, animalType: "Dog")
                AnimalTypeView(showSettingsView: $showSettingsView, animalType: "Cat")
                AnimalTypeView(showSettingsView: $showSettingsView, animalType: nil)
            }
        }
    }
}
