//
//  SavedFavoritesView.swift
//  AdoptMe
//
//  Created by Oliver Wiehr on 10/22/22.
//

import SwiftUI

struct SavedFavoritesView: View {
    @ObservedObject var adoptMe: AdoptMe
    
    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(adoptMe.favorites, id: \.self) { animalId in
                    if let animal = adoptMe.animals[animalId],
                       let organization = adoptMe.organizations[animal.organizationId] {
                        NavigationLink {
                            AnimalView(
                                animal: animal,
                                organization: organization
                            )
                        } label: {
                            SearchResultView(animal: animal, organization: organization)
                        }.buttonStyle(.plain)
                    }
                }
            }
        }.layoutPriority(1)
    }
}
