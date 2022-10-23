//
//  Colors.swift
//  AdoptMe
//
//  Created by Oliver Wiehr on 10/22/22.
//

import Foundation

struct Colors: Codable {
    var primary: String?
    var secondary: String?
    var tertiary: String?
    
    enum CodingKeys: String, CodingKey {
        case primary = "primary"
        case secondary = "secondary"
        case tertiary = "tertiary"
    }
}
