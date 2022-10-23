//
//  Environment.swift
//  AdoptMe
//
//  Created by Oliver Wiehr on 10/22/22.
//

import Foundation

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
