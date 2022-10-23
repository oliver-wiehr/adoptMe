//
//  Breed.swift
//  AdoptMe
//
//  Created by Oliver Wiehr on 10/22/22.
//

import Foundation

struct Breed: Codable {
    var name: String
    
    enum CodingKeys: String, CodingKey {
        case name = "name"
    }
}
