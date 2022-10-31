//
//  SearchView.swift
//  AdoptMe
//
//  Created by Oliver Wiehr on 1/1/22.
//

import SwiftUI

struct SearchView: View {
	@EnvironmentObject var adoptMe: AdoptMe
	@State var showSettingsView = false
	@State var showFavoritesView = false
	
	var body: some View {
		if showSettingsView {
			SettingsView(show: $showSettingsView).transition(.leftSlide)
		} else if showFavoritesView {
			FavoritesView(show: $showFavoritesView).transition(.rightSlide)
		} else {
			NavigationView {
				VStack {
					FiltersSelectionView()
					SearchResultsView()
				}
				.toolbar {
					ToolbarItem(placement: .navigationBarLeading) {
						Button {
							withAnimation {
								showSettingsView = true
							}
						} label: {
							Image(systemName: "slider.horizontal.3")
						}
					}
					ToolbarItem(placement: .navigationBarTrailing) {
						Button {
							withAnimation {
								showFavoritesView = true
							}
						} label: {
							Image(systemName: "heart.fill")
						}
					}
				}
                .navigationTitle("AdoptMe")
                .navigationBarTitleDisplayMode(.inline)
			}.navigationViewStyle(StackNavigationViewStyle())
        }
    }
}

//struct SearchView_Previews: PreviewProvider {
//
//    static var previews: some View {
//		SearchView()
//            .environmentObject(SampleData.adoptMe)
//    }
//}
