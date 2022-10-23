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
                    ForEach(adoptMe.searchResults.indices, id: \.self) { index in
                        let searchResult = adoptMe.searchResults[index]
                        NavigationLink {
                            AnimalView(
                                animal: searchResult.animal,
                                organization: searchResult.organization
                            )
                        } label: {
                            SearchResultView(searchResult: searchResult)
                        }.buttonStyle(.plain)
                    }
                }
            }.layoutPriority(1)
        }
    }
}
