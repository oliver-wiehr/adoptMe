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
