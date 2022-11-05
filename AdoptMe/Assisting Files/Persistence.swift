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
        if let data = UserDefaults.standard.object(forKey: "recentSearches") as? Data,
           let recentSearches = try? JSONDecoder().decode([Search].self, from: data) {
            return recentSearches
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
    
    static func setDistance(_ distance: String) {
        UserDefaults.standard.set(distance, forKey: "distance")
    }
    
    static func getDistance() -> String? {
        return UserDefaults.standard.object(forKey: "distance") as? String
    }
    
    static func setFavorites(_ favorites: [Int]) {
        if let encoded = try? JSONEncoder().encode(favorites) {
            UserDefaults.standard.set(encoded, forKey: "favorites")
        }
    }
    
    static func getFavorites() -> [Int] {
        if let data = UserDefaults.standard.object(forKey: "favorites") as? Data,
           let favorites = try? JSONDecoder().decode([Int].self, from: data) {
            return favorites
        }
        
        return []
    }
}
