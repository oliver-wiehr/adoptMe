//
//  AnimalType.swift
//  AdoptMe
//
//  Created by Oliver Wiehr on 10/22/22.
//

import Foundation

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
