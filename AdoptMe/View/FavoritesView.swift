//
//  FavoritesView.swift
//  AdoptMe
//
//  Created by Oliver Wiehr on 1/5/22.
//

import SwiftUI

struct FavoritesView: View {
	@EnvironmentObject var adoptMe: AdoptMe
	@Binding var show: Bool
	
    var body: some View {
		NavigationView {
			SavedFavoritesView(adoptMe: adoptMe)
				.navigationTitle("Favorites")
				.navigationBarTitleDisplayMode(.inline)
				.toolbar {
					ToolbarItem(placement: .navigationBarLeading) {
						Button {
							withAnimation {
								show = false
							}
						} label: {
							Image(systemName: "chevron.left")
						}
					}
				}
		}.navigationViewStyle(StackNavigationViewStyle())
	}
}

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

struct FavoritesView_Previews: PreviewProvider {
	@State static var showFavoritesView = true
	
    static var previews: some View {
		FavoritesView(show: FavoritesView_Previews.$showFavoritesView)
            .environmentObject(SampleData.adoptMe)
    }
}
