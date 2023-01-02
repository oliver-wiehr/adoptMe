//
//  MapView.swift
//  AdoptMe
//
//  Created by Oliver Wiehr on 1/1/23.
//

import SwiftUI
import MapKit

struct MapView: View {
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.334_900,
                                       longitude: -122.009_020),
        latitudinalMeters: 7500,
        longitudinalMeters: 7500
    )
    
    var body: some View {
        ZStack {
            Map(coordinateRegion: $region)
                .cornerRadius(10)
                .aspectRatio(1, contentMode: .fill)
            Circle()
                .foregroundColor(.accentColor)
                .opacity(0.25)
                .padding(20)
            Map(coordinateRegion: $region)
                .cornerRadius(10)
                .aspectRatio(1, contentMode: .fill)
                .opacity(0.1)
        }
    }
}

//struct LocationView_Previews: PreviewProvider {
//    static var previews: some View {
//        LocationView()
//    }
//}
