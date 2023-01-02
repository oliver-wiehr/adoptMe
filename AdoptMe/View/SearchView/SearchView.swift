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
    
    @State private var xOffset: CGFloat = 0
    @State private var initiateTransition: Bool?
    
    var body: some View {
        ZStack {
            NavigationView {
                VStack {
                    TopBar(showFavorites: $showFavoritesView, showSettings: $showSettingsView)
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
                .navigationBarHidden(true)
                .navigationBarTitleDisplayMode(.inline)
            }.navigationViewStyle(StackNavigationViewStyle())
                .offset(x: xOffset)
                .navigationBarHidden(true)
            FavoritesView(show: $showFavoritesView)
                .offset(x: UIScreen.main.bounds.size.width + xOffset)
        }
        .gesture(
            DragGesture()
                .onChanged({ gesture in
                    updateDragGesture(gesture.translation)
                })
                .onEnded({ gesture in
                    completeDragGesture()
                })
        )
        .onChange(of: showFavoritesView) { newValue in
            withAnimation {
                if newValue {
                    xOffset = -UIScreen.main.bounds.size.width
                } else {
                    xOffset = 0
                }
            }
        }
        .popover(isPresented: $showSettingsView) {
            SettingsView(show: $showSettingsView).transition(.leftSlide)
        }
    }
    
    func updateDragGesture(_ translation: CGSize) {
        if initiateTransition == nil {
            if abs(translation.height) > 10 {
                initiateTransition = false
            } else if (!showFavoritesView && translation.width < -10)
                        || (showFavoritesView && translation.width > 10) {
                initiateTransition = true
            }
        }
        
        if initiateTransition == true {
            if !showFavoritesView {
                xOffset = translation.width
            } else {
                xOffset = -UIScreen.main.bounds.size.width + translation.width
            }
        }
    }
    
    func completeDragGesture() {
        initiateTransition = nil
        if xOffset < -UIScreen.main.bounds.size.width / 2 {
            withAnimation {
                xOffset = -UIScreen.main.bounds.size.width
            }
            showFavoritesView = true
        } else {
            withAnimation {
                xOffset = 0
            }
            showFavoritesView = false
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
