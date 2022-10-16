//
//  Organization.swift
//  AdoptMe
//
//  Created by Oliver Wiehr on 10/20/21.
//

import Foundation

struct Organization: Codable {
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

struct Address: Codable {
	var address1: String?
	var address2: String?
	var city: String?
	var state: String?
	var postcode: String?
	var country: String?
	
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
