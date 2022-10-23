//
//  OrganizationsQuery.swift
//  AdoptMe
//
//  Created by Oliver Wiehr on 10/22/22.
//

import Foundation

struct OrganizationsQuery: Codable {
    var organizations: [Organization]?
    var pagination: Pagination
    
    enum CodingKeys: String, CodingKey {
        case organizations = "organizations"
        case pagination = "pagination"
    }
}
