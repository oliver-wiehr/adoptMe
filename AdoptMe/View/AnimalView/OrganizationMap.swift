//
//  OrganizationMap.swift
//  AdoptMe
//
//  Created by Oliver Wiehr on 10/22/22.
//

import SwiftUI
import CoreLocation
import MapKit

struct OrganizationMap : View {
    var organization: Organization
    var location: CLLocationCoordinate2D
    @State var region: MKCoordinateRegion
    
    var body: some View {
        Map(coordinateRegion: $region, annotationItems: [organization]) { place in
            MapMarker(coordinate: location, tint: .accentColor)
        }
        .cornerRadius(5.0)
        .aspectRatio(1.0, contentMode: .fit)
        .padding()
        .onTapGesture {
            let path = "http://maps.apple.com/?daddr=\(location.latitude),\(location.longitude)"
            if let url = URL(string: path) {
                UIApplication.shared.open(url)
            }
        }
    }
}
