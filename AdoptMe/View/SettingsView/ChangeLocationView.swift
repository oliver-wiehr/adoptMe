//
//  ChangeLocationView.swift
//  AdoptMe
//
//  Created by Oliver Wiehr on 10/22/22.
//

import SwiftUI

struct ChangeLocationView: View {
    @State var miles: Float
    
    @Binding var location: String?
    @Binding var distance: String?
    
    @EnvironmentObject var adoptMe: AdoptMe
    @ObservedObject var locationManager = LocationManager()
    
    var body: some View {
        VStack {
            Text("Change Location")
                .font(.title3)
            Text(location ?? "").padding(.bottom, 6)
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
            }
            .frame(maxWidth: 250)
            Text("Distance")
                .font(.title3)
            Text("\(Int(miles)) miles")
            Slider(value: $miles, in: 10...500, step: 1) { value in
                print(value)
            }
            Button {
                if ZipCodes.validate(locationManager.location) {
                    adoptMe.location = locationManager.location
                }
                adoptMe.distance = String(Int(miles))
                Task {
                    try await adoptMe.refresh()
                }
                locationManager.location = ""
            } label: { Text("Set") }
            .disabled(!ZipCodes.validate(locationManager.location) && Int(distance ?? "100") == Int(miles))
        }
    }
}
