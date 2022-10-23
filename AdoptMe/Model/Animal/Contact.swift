//
//  Contact.swift
//  AdoptMe
//
//  Created by Oliver Wiehr on 10/22/22.
//

import Foundation

struct Contact: Codable {
    var email: String?
    var phone: String?
    
    enum CodingKeys: String, CodingKey {
        case email = "email"
        case phone = "phone"
    }
}
