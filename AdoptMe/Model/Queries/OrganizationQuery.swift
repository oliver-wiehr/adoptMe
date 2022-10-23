//
//  OrganizationQuery.swift
//  AdoptMe
//
//  Created by Oliver Wiehr on 10/22/22.
//

import Foundation

struct OrganizationQuery: Codable {
    var organization: Organization?
    
    enum CodingKeys: String, CodingKey {
        case organization = "organization"
    }
}
