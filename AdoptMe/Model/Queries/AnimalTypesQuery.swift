//
//  AnimalTypesQuery.swift
//  AdoptMe
//
//  Created by Oliver Wiehr on 10/22/22.
//

import Foundation

struct AnimalTypesQuery: Codable {
    var animalTypes: [AnimalType]
    
    enum CodingKeys: String, CodingKey {
        case animalTypes = "types"
    }
}
