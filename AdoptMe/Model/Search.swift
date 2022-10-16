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
    
    var distance: String {
        return filters["distance"]?[0] ?? "100"
    }
	
	enum CodingKeys: String, CodingKey {
		case animalType = "animalType"
		case filters = "filters"
	}
}

struct AnimalType: Codable {
	let name: String
	let coats: [String]
	let colors: [String]
	let genders: [String]
	
	enum CodingKeys: String, CodingKey {
		case name = "name"
		case coats = "coats"
		case colors = "colors"
		case genders = "genders"
	}
}

struct Filter: Identifiable, Codable {
	var id: String
	var title: String
	var options: [FilterOption]
	
	enum CodingKeys: String, CodingKey {
		case id = "id"
		case title = "title"
		case options = "options"
	}
}

struct FilterOption: Identifiable, Codable {
	let id: String
	let title: String
	
	enum CodingKeys: String, CodingKey {
		case id = "id"
		case title = "title"
	}
}

struct Pagination: Codable {
	var countPerPage: Int
	var totalCount: Int
	var currentPage: Int
	var totalPages: Int
	
	enum CodingKeys: String, CodingKey {
		case countPerPage = "count_per_page"
		case totalCount = "total_count"
		case currentPage = "current_page"
		case totalPages = "total_pages"
	}
}
