//
//  AnimalsQuery.swift
//  AdoptMe
//
//  Created by Oliver Wiehr on 10/22/22.
//

import Foundation

struct AnimalsQuery: Codable {
    var animals: [Animal]
    var pagination: Pagination
    
    enum CodingKeys: String, CodingKey {
        case animals = "animals"
        case pagination = "pagination"
    }
}
