//
//  ViewModel.swift
//  AdoptMe
//
//  Created by Oliver Wiehr on 1/3/22.
//

import Foundation
import SwiftUI

class AdoptMe: ObservableObject {
	
    @Published var animals = [Int: Animal]()
    @Published var organizations = [String: Organization]()
    
    @Published var images = [String: Image]()
    @Published var loadedBreeds = [String: [Breed]]()
    @Published var animalTypes: [AnimalType]?
    
    var breeds: [Breed]? {
        guard let search else { return nil }
        return loadedBreeds[search.animalType.lowercased()]
    }
    var animalType: AnimalType? {
        guard let search else { return nil }
        return animalTypes?.first(where: { $0.name.lowercased() == search.animalType.lowercased() })
    }
    
    var page = 1
    
	@Published var searchResults = [Int]()
    @Published var favorites = [Int]() {
        didSet { Persistence.setFavorites(favorites) }
    }
	
	@Published var filters = [
		Filter(id: "sortBy", title: "Sort By", options: [
			FilterOption(id: "recent", title: "Most Recent"),
			FilterOption(id: "distance", title: "Nearest"),
			FilterOption(id: "random", title: "Random")
		]),
		Filter(id: "age", title: "Age", options: [
			FilterOption(id: "baby", title: "Baby"),
			FilterOption(id: "young", title: "Young"),
			FilterOption(id: "adult", title: "Adult"),
			FilterOption(id: "senior", title: "Senior")
		]),
		Filter(id: "gender", title: "Gender", options: []),
		Filter(id: "goodWith", title: "Good With", options: [
			FilterOption(id: "dogs", title: "Dogs"),
			FilterOption(id: "cats", title: "Cats"),
			FilterOption(id: "children", title: "Children")
		]),
		Filter(id: "breed", title: "Breed", options: []),
		Filter(id: "size", title: "Size", options: [
			FilterOption(id: "small", title: "Small"),
			FilterOption(id: "medium", title: "Medium"),
			FilterOption(id: "large", title: "Large"),
			FilterOption(id: "xlarge", title: "XLarge")
		]),
		Filter(id: "color", title: "Color", options: []),
		Filter(id: "coat", title: "Coat", options: []),
		Filter(id: "specialNeeds", title: "Special Needs", options: [
			FilterOption(id: "true", title: "Special Needs")
		])
    ]
    
    @Published var search: Search? {
        didSet {
            guard let search else { return }
            Persistence.setCurrentSearch(search)
            Task {
                try await self.refresh()
            }
        }
    }
    
    @Published var location: String? {
        didSet {
            guard let location else { return }
            Persistence.setLocation(location)
        }
    }
    
    @Published var distance: String? {
        didSet {
            guard let distance else { return }
            Persistence.setDistance(distance)
        }
    }
    
    
    @Published var recentSearches = [Search]() {
        didSet {
            if recentSearches.count > 5 { self.recentSearches.remove(at: 4) }
            if recentSearches.count > 0 { Persistence.addRecentSearch(recentSearches[0]) }
        }
    }
    
    init(search: Search?, location: String?, distance: String?) {
        Task {
            try await self.loadAnimalTypes()
        }
        self.location = location
        self.distance = distance
        self.favorites = Persistence.getFavorites()
        self.recentSearches = Persistence.getRecentSearches()
        self.search = search
    }
    
    func loadAnimalTypes() async throws {
        let animalTypesQuery = try await API.fetchAnimalTypes()
        DispatchQueue.main.async {
            self.animalTypes = animalTypesQuery.animalTypes
        }
    }
    
    func loadOrganization(_ organizationId: String) async throws {
        guard self.organizations[organizationId] == nil else { return }
        
        let organizationQuery = try await API.fetchOrganization(organizationId)
        guard let organization = organizationQuery.organization else { return }
        DispatchQueue.main.async {
            self.organizations[organizationId] = organization
        }
    }
    
    func loadBreeds(_ animalType: String) async throws {
        guard loadedBreeds[animalType] == nil else { return }
		
		let breedsQuery = try await API.fetchBreeds(animalType)
        DispatchQueue.main.async {
            self.loadedBreeds[animalType] = breedsQuery.breeds
        }
	}
	
	func sortFilters() {
		guard let search else { return }

		self.filters.sort { filter1, filter2 in
			let filter1Selected = search.filters.keys.contains(filter1.id)
			let filter2Selected = search.filters.keys.contains(filter2.id)
			
			if filter1Selected == filter2Selected {
				return filter2.title > filter1.title
			} else {
				return filter1Selected
			}
		}
	}
	
	func refresh() async throws {
        DispatchQueue.main.async {
            self.searchResults = []
        }
        self.page = 1
        guard let search else { return }
        try await self.loadBreeds(search.animalType.lowercased())
        try await self.loadAnimals()
    }
    
    var last_page_loaded = Date().timeIntervalSince1970
    func loadNextPageIfNeeded(_ currentId: Int) {
        guard let currentIndex = searchResults.firstIndex(of: currentId),
              currentIndex >= searchResults.count - 2,
        last_page_loaded < Date().timeIntervalSince1970 - 5 else { return }
        last_page_loaded = Date().timeIntervalSince1970
        self.page += 1
        print("loading page \(page)")
        Task {
            try await self.loadAnimals()
        }
    }
    
	func loadAnimals() async throws {
        guard let search, let location else { return }
        
        let animalsQuery = try await API.fetchAnimals(search, location: location, distance: distance ?? "100", page: page)
        for animal in animalsQuery.animals {
            try await loadOrganization(animal.organizationId)
            DispatchQueue.main.async {
                self.animals[animal.id] = animal
                if !self.searchResults.contains(animal.id) {
                    self.searchResults.append(animal.id)
                }
            }
        }
    }

	func isSelected(_ filterOption: String, filter: String) -> Bool {
		guard let search = search else {
			return false
		}

		return search.filters.keys.contains(filter)
		&& search.filters[filter]!.contains(filterOption)
	}
	
	func isSelected(_ filter: String) -> Bool {
		guard let search = search else {
			return false
		}

		return search.filters.keys.contains(filter)
	}
	
	func toggleFilterOption(_ filterOption: String, filter: String) {
        if isSelected(filterOption, filter: filter) {
            self.search?.filters[filter]?.removeAll(where: { selectedFilterOption in
                filterOption == selectedFilterOption
            })
            if self.search?.filters[filter]?.count == 0 {
                self.search?.filters.removeValue(forKey: filter)
            }
        } else if isSelected(filter) {
            self.search?.filters[filter]?.append(filterOption)
		} else {
			self.search?.filters[filter] = [filterOption]
		}
	}
    
    func callPhone(_ phone: String) {
        if let url = URL(string: "tel://\(phone.filter("0123456789".contains))"), UIApplication.shared.canOpenURL(url) {
          UIApplication.shared.open(url)
        } else {
            print("can't call phone \("tel://\(phone.filter("0123456789".contains))")")
        }
    }
    
    func writeEmail(_ email: String) {
        if let url = URL(string: "mailto:\(email)"), UIApplication.shared.canOpenURL(url) {
          UIApplication.shared.open(url)
        }
    }
}
