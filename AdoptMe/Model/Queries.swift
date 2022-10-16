//
//  Queries.swift
//  AdoptMe
//
//  Created by Oliver Wiehr on 1/5/22.
//

import Foundation

struct AnimalQuery: Codable {
	var animal: Animal?
	
	enum CodingKeys: String, CodingKey {
		case animal = "animal"
	}
}

struct AnimalsQuery: Codable {
	var animals: [Animal]
	var pagination: Pagination
	
	enum CodingKeys: String, CodingKey {
		case animals = "animals"
		case pagination = "pagination"
	}
}

struct AnimalTypesQuery: Codable {
	var animalTypes: [AnimalType]
	
	enum CodingKeys: String, CodingKey {
		case animalTypes = "types"
	}
}

struct BreedsQuery: Codable {
	var breeds: [Breed]
	
	enum CodingKeys: String, CodingKey {
		case breeds = "breeds"
	}
}

struct OrganizationQuery: Codable {
	var organization: Organization?
	
	enum CodingKeys: String, CodingKey {
		case organization = "organization"
	}
}

struct OrganizationsQuery: Codable {
	var organizations: [Organization]?
    var pagination: Pagination
	
	enum CodingKeys: String, CodingKey {
		case organizations = "organizations"
        case pagination = "pagination"
	}
}
