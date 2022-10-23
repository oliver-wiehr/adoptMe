//
//  Animal.swift
//  AdoptMe
//
//  Created by Oliver Wiehr on 10/5/21.
//

import Foundation

struct Animal: Codable, Identifiable {
	
	var id: Int
	var name: String
	var organizationId: String
	var type: String
	
	var description: String?
	var age: String?
	var gender: String?
	var size: String?
	var coat: String?
	var species: String?
	var status: String?
	var publishedAt: String?
	
	var attributes: Attributes?
	var breeds: Breeds?
	var colors: Colors?
	var contact: Contact?
	var environment: Environment?
	var photos = [Photo]()
    
    var previewImageURL: String? {
        if photos.count > 0 {
            return photos[0].mediumSize
        }
        
        return nil
    }
	
	var tags: [String]?
	
	enum CodingKeys: String, CodingKey {
		case id = "id"
		case name = "name"
		case organizationId = "organization_id"
		case type = "type"
		
		case description = "description"
		case age = "age"
		case gender = "gender"
		case size = "size"
		case coat = "coat"
		case species = "species"
		case status = "status"
		case publishedAt = "published_at"
		
		case photos = "photos"
		case breeds = "breeds"
		case colors = "colors"
		case attributes = "attributes"
		case environment = "environment"
		case contact = "contact"
		
		case tags = "tags"
	}
}
