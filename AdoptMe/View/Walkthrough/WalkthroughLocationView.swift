//
//  WalkthroughLocationView.swift
//  AdoptMe
//
//  Created by Oliver Wiehr on 10/22/22.
//

import SwiftUI

struct WalkthroughLocationView: View {
    @EnvironmentObject var locationManager: LocationManager
    
    var body: some View {
        VStack {
            Spacer()
            VStack {
                Spacer()
                ZStack {
                 RoundedRectangle(cornerRadius: 5)
                     .foregroundColor(.gray)
                    HStack {
                        TextField("Zip Code", text: $locationManager.location)
                        if locationManager.isLoadingLocation {
                            ProgressView()
                        } else {
                            Button {
                                locationManager.requestLocation()
                            } label: {
                                Image(systemName: "location.circle")
                            }
                        }
                    }
                    .padding(6)
                }.frame(maxHeight: 40)
                Spacer()
            }
            .transition(.slide)
            .frame(width: 300, height: 200, alignment: .top)
            Spacer()
        }
    }
}
