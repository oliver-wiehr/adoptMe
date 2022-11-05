//
//  SearchResultsView.swift
//  AdoptMe
//
//  Created by Oliver Wiehr on 10/22/22.
//

import SwiftUI

struct SearchResultsView: View {
    @EnvironmentObject var adoptMe: AdoptMe
    
    var body: some View {
        if adoptMe.searchResults.count == 0 {
            VStack {
                Spacer()
                ProgressView()
                Spacer()
            }
            .layoutPriority(1)
        } else {
            ScrollView {
                LazyVStack {
                    ForEach(adoptMe.searchResults, id: \.self) { animalId in
                        if let animal = adoptMe.animals[animalId], let organization = adoptMe.organizations[animal.organizationId] {
                            NavigationLink {
                                AnimalView(
                                    animal: animal,
                                    organization: organization
                                )
                            } label: {
                                SearchResultView(animal: animal, organization: organization)
                                    .onAppear { adoptMe.loadNextPageIfNeeded(animalId) }
                            }.buttonStyle(.plain)
                        }
                    }
                }
            }.layoutPriority(1)
        }
    }
}
