//
//  Organization.swift
//  AdoptMe
//
//  Created by Oliver Wiehr on 10/20/21.
//

import Foundation
import MapKit

struct Organization: Codable, Identifiable {
	var id: String
	var name: String
	var email: String?
	var phone: String?
    var address: Address?
	var hours: Hours?
	var url: String?
	var website: String?
	var missionStatement: String?
	var photos = [Photo]()
	
	enum CodingKeys: String, CodingKey {
		case id = "id"
		case name = "name"
		case email = "email"
		case phone = "phone"
		case address = "address"
		case hours = "hours"
		case url = "url"
		case website = "website"
		case missionStatement = "mission_statement"
		case photos = "photos"
	}
}

final class Address: Codable {
    let geoCoder = CLGeocoder()
    
    var address1: String?
    var address2: String?
    var city: String?
    var state: String?
    var postcode: String?
    var country: String?
    var coordinate: CLLocationCoordinate2D?
    
    var addressString: String {
        return "\(address1 ?? "") \(address2 ?? ""), \(city ?? ""), \(state ?? "") \(postcode ?? ""), \(country ?? "")"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.address1 = try container.decodeIfPresent(String.self, forKey: .address1)
        self.address2 = try container.decodeIfPresent(String.self, forKey: .address2)
        self.city = try container.decodeIfPresent(String.self, forKey: .city)
        self.state = try container.decodeIfPresent(String.self, forKey: .state)
        self.postcode = try container.decodeIfPresent(String.self, forKey: .postcode)
        self.country = try container.decodeIfPresent(String.self, forKey: .country)
        
        geoCoder.geocodeAddressString(addressString) { (placemarks, error) in
            guard let placemarks = placemarks,
                  let location = placemarks.first?.location
            else {
                return
            }

            self.coordinate = location.coordinate
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case address1 = "address1"
        case address2 = "address2"
        case city = "city"
        case state = "state"
        case postcode = "postcode"
        case country = "country"
    }
}

struct Hours: Codable {
    
}
