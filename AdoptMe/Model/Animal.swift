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

struct Attributes: Codable {
	var spayedNeutered: Bool?
	var houseTrained: Bool?
	var declawed: Bool?
	var specialNeeds: Bool?
	var shotsCurrent: Bool?
    
    var description: String? {
        var elements = [String]()
        if spayedNeutered == true {
            elements.append("I am spayed/neutered")
        }
        if houseTrained == true {
            elements.append("I am house trained")
        }
        if declawed == true {
            elements.append("I am declawed")
        }
        if specialNeeds == true {
            elements.append("I have special needs")
        }
        if shotsCurrent == true {
            elements.append("I have all my shots current")
        }
        
        if elements.count == 0 {
            return nil
        }
        
        let lastElement = elements.removeLast()
        if elements.count == 0 {
            return "\(lastElement)."
        }
        
        return "\(elements.joined(separator: ", ")) and \(lastElement)."
    }
	
	enum CodingKeys: String, CodingKey {
		case spayedNeutered = "spayed_neutered"
		case houseTrained = "house_trained"
		case declawed = "declawed"
		case specialNeeds = "special_needs"
		case shotsCurrent = "shots_current"
	}
}

struct Breed: Codable {
	var name: String
	
	enum CodingKeys: String, CodingKey {
		case name = "name"
	}
}

struct Breeds: Codable {
	var primary: String
	var secondary: String?
	var mixed: Bool
	var unknown: Bool
	
	enum CodingKeys: String, CodingKey {
		case primary = "primary"
		case secondary = "secondary"
		case mixed = "mixed"
		case unknown = "unknown"
	}
}

struct Colors: Codable {
	var primary: String?
	var secondary: String?
	var tertiary: String?
	
	enum CodingKeys: String, CodingKey {
		case primary = "primary"
		case secondary = "secondary"
		case tertiary = "tertiary"
	}
}

struct Contact: Codable {
	var email: String?
	var phone: String?
	
	enum CodingKeys: String, CodingKey {
		case email = "email"
		case phone = "phone"
	}
}

struct Environment: Codable {
	var children: Bool?
	var dogs: Bool?
	var cats: Bool?
	
	enum CodingKeys: String, CodingKey {
		case children = "children"
		case dogs = "dogs"
		case cats = "cats"
	}
}

struct Photo: Codable {
	var small: String?
	var medium: String?
	var large: String?
	var full: String?
    
    var mediumSize: String? {
        return medium ?? large ?? full ?? small
    }
    
    var largeSize: String? {
        return large ?? full ?? medium ?? small
    }
	
	enum CodingKeys: String, CodingKey {
		case small = "small"
		case medium = "medium"
		case large = "large"
		case full = "full"
	}
}
