//
//  Breeds.swift
//  AdoptMe
//
//  Created by Oliver Wiehr on 10/22/22.
//

import Foundation

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
