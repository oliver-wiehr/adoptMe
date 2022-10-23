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
	
	static var organizations = [String: Organization]()
	static func loadOrganization(_ id: String, completion: @escaping (Organization?) -> Void) {
		if let organization = organizations[id] {
			completion(organization)
			return
		}
		
		API.fetchOrganization(id) { organizationQuery in
			if let organizationQuery = organizationQuery, let organization = organizationQuery.organization {
				self.organizations[id] = organization
				completion(organization)
				return
			}
			
			completion(nil)
		}
	}
	
	static func fetchAnimalTypes(completion: @escaping (AnimalTypesQuery?) -> Void) {
		performRequest(category: "types", parameters: [:]) { data in
			guard let data = data else {
				print("animal type query failed")
				completion(nil)
				return
			}
			
			do {
				let animalTypesQuery = try JSONDecoder().decode(AnimalTypesQuery.self, from: data)
				completion(animalTypesQuery)
			} catch {
				print(error)
				completion(nil)
			}
		}
	}
	
	static func fetchBreeds(_ type: String, completion: @escaping (BreedsQuery?) -> Void) {
		performRequest(category: "types/\(type)/breeds", parameters: [:]) { data in
			guard let data = data else {
				print("breeds query failed")
				completion(nil)
				return
			}
			
			do {
				let breedsQuery = try JSONDecoder().decode(BreedsQuery.self, from: data)
				completion(breedsQuery)
			} catch {
				print(error)
				completion(nil)
			}
		}
	}
	
    static func fetchAnimals(_ search: Search, location: String, distance: String, page: Int, completion: @escaping (AnimalsQuery?) -> Void) {
		var parameters = [String: String]()
		
		for key in search.filters.keys {
			parameters[key] = search.filters[key]!.joined(separator: ",")
		}
		
		parameters["type"] = search.animalType
		parameters["page"] = String(page)
		parameters["location"] = location
        parameters["distance"] = distance
		
		performRequest(category: "animals", parameters: parameters) { data in
			guard let data = data else {
				print("animal query failed")
				completion(nil)
				return
			}
			
			do {
				let animalQuery = try JSONDecoder().decode(AnimalsQuery.self, from: data)
				completion(animalQuery)
			} catch {
				print(error)
				completion(nil)
			}
		}
	}
	
	static func fetchAnimal(_ id: Int, completion: @escaping (AnimalQuery?) -> Void) {
		performRequest(category: "animals/\(id)", parameters: [:]) { data in
			guard let data = data else {
				print("query failed")
				completion(nil)
				return
			}
			
			do {
				let animalQuery = try JSONDecoder().decode(AnimalQuery.self, from: data)
				completion(animalQuery)
			} catch {
				if let json = try? JSONSerialization.jsonObject(with: data, options: []) {
					print(json)
				}
				print(error)
				completion(nil)
			}
		}
	}
	
    static func fetchOrganizations(location: String, distance: String, page: Int = 1, completion: @escaping (OrganizationsQuery?) -> Void) {
		let parameters = [
			"location": location,
			"distance": distance,
            "page": "\(page)",
			"limit": "100"
		]
		
		performRequest(category: "organizations", parameters: parameters) { data in
			guard let data = data else {
				print("animal query failed")
				completion(nil)
				return
			}
			
			do {
				let organizationsQuery = try JSONDecoder().decode(OrganizationsQuery.self, from: data)
				completion(organizationsQuery)
			} catch {
				print(error)
				completion(nil)
			}
		}
	}
	
	static func fetchOrganization(_ id: String, completion: @escaping (OrganizationQuery?) -> Void) {
		performRequest(category: "organizations/\(id)", parameters: [:]) { data in
			guard let data = data else {
				print("query failed")
				completion(nil)
				return
			}
			
			do {
				let organizationQuery = try JSONDecoder().decode(OrganizationQuery.self, from: data)
				completion(organizationQuery)
			} catch {
				if let json = try? JSONSerialization.jsonObject(with: data, options: []) {
					print(json)
				}
				print(error)
				completion(nil)
			}
		}
	}
	
	static private func verifyToken(completion: @escaping (_ success: Bool) -> Void) {
		if Date().timeIntervalSince1970 + 5 < tokenExpiration {
			completion(true)
		}
		
		fetchAccessToken { token, expiration in
			guard let token = token, let expiration = expiration else {
				completion(false)
				return
			}
			
			accessToken = token
			tokenExpiration = Date().timeIntervalSince1970 + Double(expiration)
			completion(true)
		}
	}
	
	static private func performRequest(category: String, action: String? = nil, parameters: [String: String] = [:], completion: @escaping (_ result: Data?) -> Void) {
		verifyToken { success in
			guard success else {
				completion(nil)
				print("invalid token")
				return
			}
			
			let url = "https://api.petfinder.com/v2/\(category)\(action != nil ? "/\(action!)" : "")"
			
			var components = URLComponents(string: url)!
			components.queryItems = parameters.map { (key, value) in
				URLQueryItem(name: key, value: value)
			}
			
			components.percentEncodedQuery = components.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B")
			var request = URLRequest(url: components.url!)
			
			request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
			
			let task = URLSession.shared.dataTask(with: request) { data, response, error in
				guard
					let data = data,
					let response = response as? HTTPURLResponse,
					200 ..< 300 ~= response.statusCode,
					error == nil
				else {
					if let urlString = request.url?.absoluteString, let response = response as? HTTPURLResponse {
						print(urlString)
						print(response.statusCode)
					}
					completion(nil)
					return
				}
				
				completion(data)
			}
			
			task.resume()
		}
		
	}
	
	static private func fetchAccessToken(completion: @escaping (_ token: String?, _ expiration: Int?) -> Void) {
		let url = URL(string: "https://api.petfinder.com/v2/oauth2/token")!
		var request = URLRequest(url: url)
		request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
		request.httpMethod = "POST"
		let parameters: [String: Any] = [
			"grant_type": "client_credentials",
			"client_id": key,
			"client_secret": secret
		]
		request.httpBody = parameters.percentEncoded()
		
		let task = URLSession.shared.dataTask(with: request) { data, response, error in
			guard let data = data,
				  let response = response as? HTTPURLResponse,
				  error == nil else {
					  print("error", error ?? "Unknown error")
					  completion(nil, nil)
					  return
				  }
			
			guard (200 ... 299) ~= response.statusCode else {
				print("statusCode should be 2xx, but is \(response.statusCode)")
				print("response = \(response)")
				completion(nil, nil)
				return
			}
			
			if let response = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
				completion(response["access_token"] as? String, response["expires_in"] as? Int)
				return
			}
			
			completion(nil, nil)
		}
		
		task.resume()
	}
}
