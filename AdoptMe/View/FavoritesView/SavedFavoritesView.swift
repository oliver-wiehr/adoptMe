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
                ForEach(adoptMe.favorites.indices, id: \.self) { index in
                    let searchResult = adoptMe.favorites[index]
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
