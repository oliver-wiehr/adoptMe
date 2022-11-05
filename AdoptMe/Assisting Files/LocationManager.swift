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
    @Published var location = "" { didSet { locationRequested = false } }
    
    private var locationRequested = false
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func requestLocation() {
        self.locationRequested = true
        switch locationManager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.requestLocation()
        default:
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        isLoadingLocation = false
        print(error.localizedDescription)
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch locationManager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.requestLocation()
        default:
            return
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            geoCoder.reverseGeocodeLocation(location) { placemarks, error in
                if let placemark = placemarks?.first, let postalCode = placemark.postalCode {
                    if self.locationRequested {
                        self.location = postalCode
                    }
                }
                
                self.isLoadingLocation = false
            }
        } else {
            isLoadingLocation = false
        }
    }
}
