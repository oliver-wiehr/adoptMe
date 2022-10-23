//
//  Photo.swift
//  AdoptMe
//
//  Created by Oliver Wiehr on 10/22/22.
//

import Foundation

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

