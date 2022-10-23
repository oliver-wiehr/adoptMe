//
//  Attributes.swift
//  AdoptMe
//
//  Created by Oliver Wiehr on 10/22/22.
//

import Foundation

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
