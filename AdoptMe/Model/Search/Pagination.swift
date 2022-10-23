//
//  Pagination.swift
//  AdoptMe
//
//  Created by Oliver Wiehr on 10/22/22.
//

import Foundation

struct Pagination: Codable {
    var countPerPage: Int
    var totalCount: Int
    var currentPage: Int
    var totalPages: Int
    
    enum CodingKeys: String, CodingKey {
        case countPerPage = "count_per_page"
        case totalCount = "total_count"
        case currentPage = "current_page"
        case totalPages = "total_pages"
    }
}
