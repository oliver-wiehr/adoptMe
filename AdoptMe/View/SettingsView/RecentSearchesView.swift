//
//  RecentSearchesView.swift
//  AdoptMe
//
//  Created by Oliver Wiehr on 10/22/22.
//

import SwiftUI

struct RecentSearchesView: View {
    @EnvironmentObject var adoptMe: AdoptMe
    @Binding var showSettingsView: Bool
    
    var body: some View {
        VStack {
            Text("Recent Searches")
                .font(.title3)
            ForEach($adoptMe.recentSearches.indices, id: \.self) { index in
                RecentSearchView(search: adoptMe.recentSearches[index])
                    .onTapGesture {
                        adoptMe.search = adoptMe.recentSearches[index]
                        withAnimation {
                            showSettingsView = false
                        }
                    }
            }
        }
    }
}
