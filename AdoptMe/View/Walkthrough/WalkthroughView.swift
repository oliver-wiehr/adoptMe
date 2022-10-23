//
//  WalkthroughView.swift
//  AdoptMe
//
//  Created by Oliver Wiehr on 2/23/22.
//

import SwiftUI

struct WalkthroughView: View {
	@EnvironmentObject var adoptMe: AdoptMe
	@Binding var show: Bool
	@State var page = 0
    @ObservedObject var locationManager = LocationManager()
    @State var animalType = ""
    
    var body: some View {
        VStack {
            Image("logo").resizable().scaledToFit().frame(width: page == 0 ? 250 : 180)
            switch page {
            case 0:
                Spacer()
                Text("What are you looking for?")
                    .font(.title2)
                    .multilineTextAlignment(.center)
                    .transition(.opacity)
                Spacer()
            case 1:
                Text("Where are you looking?")
                    .font(.title2)
                    .multilineTextAlignment(.center)
                    .transition(.opacity)
                WalkthroughLocationView().transition(.backslide)
                    .environmentObject(locationManager)
            default:
                Text("What are you looking for?")
                    .font(.title2)
                    .multilineTextAlignment(.center)
                    .transition(.opacity)
                WalkthroughAnimalTypesView(animalType: $animalType, showWalkthrough: $show).transition(.backslide)
            }
            if page < 2 {
                Button {
                    if page == 1 {
                        adoptMe.location = locationManager.location
                    }
                    if page < 2 {
                        withAnimation {
                            page += 1
                        }
                    }
                } label: {
                    switch page {
                    case 0:
                        Text("Let's go!")
                    case 1:
                        Text("Next")
                    default:
                        Text("")
                    }
                }
                .disabled({
                    if page == 1 {
                        return !ZipCodes.validate(locationManager.location)
                    }
                    return false
                }())
                .padding()
            }
        }.frame(height: 450)
    }
}
