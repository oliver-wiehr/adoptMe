//
//  AdoptMeApp.swift
//  AdoptMe
//
//  Created by Oliver Wiehr on 1/1/22.
//

import SwiftUI

@main
struct AdoptMeApp: App {
    static let initialSearch = Persistence.getCurrentSearch()
    static let initialLocation = Persistence.getLocation()
    static let initalDistance = Persistence.getDistance()
    @State var showWalkthrough = Self.initialSearch == nil || Self.initialLocation == nil
	
    var body: some Scene {
        let adoptMe = AdoptMe(search: Self.initialSearch, location: Self.initialLocation, distance: Self.initalDistance)
        
        WindowGroup {
            SearchView()
                .environmentObject(adoptMe)
                .fullScreenCover(isPresented: $showWalkthrough) { } content: {
                    WalkthroughView(show: $showWalkthrough)
                        .environmentObject(adoptMe)
                }
        }
    }
}
