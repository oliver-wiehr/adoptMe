//
//  SettingsView.swift
//  AdoptMe
//
//  Created by Oliver Wiehr on 1/5/22.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var adoptMe: AdoptMe
    @Binding var show: Bool
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack() {
                    NewSearchView(showSettingsView: $show).padding()
                    RecentSearchesView(showSettingsView: $show).padding()
                    ChangeLocationView(miles: adoptMe.distance == nil ? 100 : Float(adoptMe.distance!) ?? 100, location: $adoptMe.location, distance: $adoptMe.distance).padding()
                    CopyrightView().padding()
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        withAnimation {
                            show = false
                        }
                    } label: {
                        Image(systemName: "xmark")
                    }
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
        }.navigationViewStyle(StackNavigationViewStyle())
    }
}

//struct SettingsView_Previews: PreviewProvider {
//    @State static var showSettingsView = true
//
//    static var previews: some View {
//        SettingsView(show: SettingsView_Previews.$showSettingsView)
//            .environmentObject(SampleData.adoptMe)
//    }
//}
