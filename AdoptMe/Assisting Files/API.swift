//
//  API.swift
//  AdoptMe
//
//  Created by Oliver Wiehr on 10/4/21.
//

import Foundation
import UIKit

enum Mode {
	case test
	case distribution
}

let mode = Mode.test

class API {

	static let key = mode == .test ? "5HbZFdxpTP9huGTt1SAvTJHbsSortZKcaoLSxiwhom8ofJsm5N" : "XkVifQgwUY9FlIPxk2MxuUQPSNnlSTbtynhg72uzBLvlAmmTX9"
	static let secret = mode == .test ? "93zZXu35I6BgYAPOlR24PzqxtTFbUQjSsnFNfGZO" : "Fg05ZNVeyJm3GvrUG2jbslevcjp2QOFp3e3Viffv"
	
	static var tokenExpiration = 0.0
	static var accessToken = ""
    
    static func fetchAnimalTypes() async throws -> AnimalTypesQuery {
		let data = try await performRequest(category: "types", parameters: [:])
        return try JSONDecoder().decode(AnimalTypesQuery.self, from: data)
    }
    
    static func fetchBreeds(_ type: String) async throws -> BreedsQuery {
        let data = try await performRequest(category: "types/\(type)/breeds", parameters: [:])
        return try JSONDecoder().decode(BreedsQuery.self, from: data)
    }
    
    static func fetchAnimals(_ search: Search, location: String, distance: String, page: Int) async throws -> AnimalsQuery {
        var parameters = search.filters.keys.reduce(into: [String: String]()) {
            $0[$1] = search.filters[$1]!.joined(separator: ",")
        }
        
        parameters["type"] = search.animalType
        parameters["page"] = String(page)
        parameters["location"] = location
        parameters["distance"] = distance
        
        let data = try await performRequest(category: "animals", parameters: parameters)
        return try JSONDecoder().decode(AnimalsQuery.self, from: data)
    }
    
    static func fetchAnimal(_ id: Int) async throws -> AnimalQuery {
        let data = try await performRequest(category: "animals/\(id)", parameters: [:])
        return try JSONDecoder().decode(AnimalQuery.self, from: data)
    }
    
    static func fetchOrganizations(location: String, distance: String, page: Int = 1) async throws -> OrganizationsQuery {
        let parameters = [
            "location": location,
            "distance": distance,
            "page": "\(page)",
            "limit": "100"
        ]
        
        let data = try await performRequest(category: "organizations", parameters: parameters)
        return try JSONDecoder().decode(OrganizationsQuery.self, from: data)
    }
    
    static func fetchOrganization(_ id: String) async throws -> OrganizationQuery {
        let data = try await performRequest(category: "organizations/\(id)", parameters: [:])
        return try JSONDecoder().decode(OrganizationQuery.self, from: data)
    }
    
    static private func verifyToken() async throws {
        if Date().timeIntervalSince1970 + 5 < tokenExpiration {
            return
        }
        
        let (token, expiration) = try await fetchAccessToken()
        
        self.accessToken = token
        self.tokenExpiration = Date().timeIntervalSince1970 + Double(expiration)
    }
    
    static private func performRequest(category: String, action: String? = nil, parameters: [String: String] = [:]) async throws -> Data {
        try await verifyToken()
        
        let url = "https://api.petfinder.com/v2/\(category)\(action != nil ? "/\(action!)" : "")"
        
        var components = URLComponents(string: url)!
        components.queryItems = parameters.map { (key, value) in
            URLQueryItem(name: key, value: value)
        }
        
        components.percentEncodedQuery = components.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B")
        var request = URLRequest(url: components.url!)
        
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else { throw APIError.invalidResponse }
        
        return data
    }
    
    static private func fetchAccessToken() async throws -> (token: String, expiration: Int) {
        let url = URL(string: "https://api.petfinder.com/v2/oauth2/token")!
        let parameters: [String: Any] = [
            "grant_type": "client_credentials",
            "client_id": key,
            "client_secret": secret
        ]
        var request = URLRequest(url: url)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = parameters.percentEncoded()
        
        let (data, response) = try await URLSession.shared.data(for: request)
        guard (response as? HTTPURLResponse)?.statusCode == 200,
              let jsonResponse = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
              let token = jsonResponse["access_token"] as? String,
              let expiration = jsonResponse["expires_in"] as? Int
        else {
            throw APIError.badKey
        }
        return (token, expiration)
    }
}

enum APIError: Error {
    case badKey
    case invalidResponse
}
