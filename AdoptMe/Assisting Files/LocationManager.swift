//
//  LocationManager.swift
//  AdoptMe
//
//  Created by Oliver Wiehr on 10/22/22.
//

import Foundation
import CoreLocation

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    let locationManager = CLLocationManager()
    let geoCoder = CLGeocoder()
    
    @Published var isLoadingLocation = false
    @Published var location = ""
    
    override init() {
        super.init()
        locationManager.delegate = self
    }
    
    func requestLocation() {
        isLoadingLocation = true
        locationManager.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        isLoadingLocation = false
        print(error.localizedDescription)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            geoCoder.reverseGeocodeLocation(location) { placemarks, error in
                if let placemark = placemarks?.first, let postalCode = placemark.postalCode {
                    self.location = postalCode
                }
                
                self.isLoadingLocation = false
            }
        } else {
            isLoadingLocation = false
        }
    }
}
