//
//  AnimalQuery.swift
//  AdoptMe
//
//  Created by Oliver Wiehr on 10/22/22.
//

import Foundation

struct AnimalQuery: Codable {
    var animal: Animal?
    
    enum CodingKeys: String, CodingKey {
        case animal = "animal"
    }
}
