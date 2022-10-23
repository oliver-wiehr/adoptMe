//
//  WalkthroughAnimalTypesView.swift
//  AdoptMe
//
//  Created by Oliver Wiehr on 10/22/22.
//

import SwiftUI

struct WalkthroughAnimalTypesView: View {
    @Binding var animalType: String
    @Binding var showWalkthrough: Bool
    
    var body: some View {
        VStack {
            Spacer()
            VStack {
                VStack {
                    WalkthroughAnimalTypeView(selectedAnimalType: $animalType, showWalkthrough: $showWalkthrough, animalType: "Dog")
                    WalkthroughAnimalTypeView(selectedAnimalType: $animalType, showWalkthrough: $showWalkthrough, animalType: "Cat")
                    WalkthroughAnimalTypeView(selectedAnimalType: $animalType, showWalkthrough: $showWalkthrough, animalType: nil)
                }
            }
            .transition(.slide)
            .frame(width: 300, height: 200, alignment: .top)
            Spacer()
        }
    }
}
