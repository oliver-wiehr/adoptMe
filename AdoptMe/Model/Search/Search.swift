//
//  Search.swift
//  AdoptMe
//
//  Created by Oliver Wiehr on 11/28/21.
//

import Foundation

struct Search: Codable {
	var animalType: String
	var filters: [String: [String]]
	
	enum CodingKeys: String, CodingKey {
		case animalType = "animalType"
		case filters = "filters"
	}
}
