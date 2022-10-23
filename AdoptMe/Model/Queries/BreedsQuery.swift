//
//  BreedsQuery.swift
//  AdoptMe
//
//  Created by Oliver Wiehr on 10/22/22.
//

import Foundation

struct BreedsQuery: Codable {
    var breeds: [Breed]
    
    enum CodingKeys: String, CodingKey {
        case breeds = "breeds"
    }
}
