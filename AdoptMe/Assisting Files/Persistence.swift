//
//  Persistence.swift
//  AdoptMe
//
//  Created by Oliver Wiehr on 10/22/21.
//

import Foundation

class Persistence {
	
	static func getCurrentSearch() -> Search? {
		if let data = UserDefaults.standard.object(forKey: "currentSearch") as? Data {
			if let currentSearch = try? JSONDecoder().decode(Search.self, from: data) {
				return currentSearch
			}
		}
        
		return nil
	}
	
	static func setCurrentSearch(_ search: Search) {
		if let encoded = try? JSONEncoder().encode(search) {
			UserDefaults.standard.set(encoded, forKey: "currentSearch")
		}
	}
	
	static func getRecentSearches() -> [Search] {
		if let data = UserDefaults.standard.object(forKey: "recentSearches") as? Data {
			if let recentSearches = try? JSONDecoder().decode([Search].self, from: data) {
				return recentSearches
			}
		}
		
		return []
	}
	
	static func addRecentSearch(_ search: Search) {
		var recentSearches = getRecentSearches()
		recentSearches.insert(search, at: 0)
		if recentSearches.count > 5 {
			recentSearches = Array(recentSearches[0..<5])
		}
		
		if let encoded = try? JSONEncoder().encode(recentSearches) {
			UserDefaults.standard.set(encoded, forKey: "recentSearches")
		}
	}
	
	static func setLocation(_ location: String) {
		UserDefaults.standard.set(location, forKey: "location")
	}
	
	static func getLocation() -> String? {
		return UserDefaults.standard.object(forKey: "location") as? String
	}
	
	static func addFavorite(_ id: Int) {
		if var favorites = UserDefaults.standard.object(forKey: "favorites") as? [Int] {
			favorites.append(id)
			UserDefaults.standard.set(favorites, forKey: "favorites")
		} else {
			UserDefaults.standard.set([id], forKey: "favorites")
		}
	}
	
	static func removeFavorite(_ id: Int) {
		if var favorites = UserDefaults.standard.object(forKey: "favorites") as? [Int] {
			favorites.removeAll { favorite in
				id == favorite
			}
			UserDefaults.standard.set(favorites, forKey: "favorites")
		}
	}
	
	static func isFavorite(_ id: Int) -> Bool {
		return getFavorites().contains(id)
	}
	
	static func getFavorites() -> [Int] {
		return UserDefaults.standard.object(forKey: "favorites") as? [Int] ?? []
	}
}
