//
//  Filter.swift
//  AdoptMe
//
//  Created by Oliver Wiehr on 10/22/22.
//

import Foundation

struct Filter: Identifiable, Codable {
    var id: String
    var title: String
    var options: [FilterOption]
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case title = "title"
        case options = "options"
    }
}
