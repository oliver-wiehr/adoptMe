//
//  ViewModel.swift
//  AdoptMe
//
//  Created by Oliver Wiehr on 1/3/22.
//

import Foundation
import SwiftUI

class AdoptMe: ObservableObject {
	
	@Published var searchResults = [SearchResult]()
    
    @Published var favorites = [SearchResult]() {
        didSet {
            Persistence.setFavorites(favorites)
        }
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
            self.searchResults = []
            if let search = search, let animalTypes = animalTypes {
                if let animalType = animalTypes.first(where: { animalType in
                    animalType.name.lowercased() == search.animalType.lowercased()
                }) {
                    self.animalType = animalType
                } else {
                    self.search = nil
                }
                
                self.loadBreeds()
                self.sortFilters()
                Persistence.setCurrentSearch(search)
                self.refresh()
            }
        }
    }
    
    @Published var location: String? {
        didSet {
            if let location = location {
                Persistence.setLocation(location)
            }
        }
    }
    
    @Published var distance: String? {
        didSet {
            if let distance = distance {
                Persistence.setDistance(distance)
            }
        }
    }
    
    @Published var animalTypes: [AnimalType]? {
        didSet {
            if let search = search {
                if let animalType = animalTypes?.first(where: { animalType in
                    animalType.name.lowercased() == search.animalType.lowercased()
                }) {
                    self.animalType = animalType
                } else {
                    self.search = nil
                }
            }
        }
    }
    
    @Published var recentSearches = [Search]() {
        didSet {
            if recentSearches.count > 5 {
                self.recentSearches.remove(at: 4)
            }
            if recentSearches.count > 0 {
                Persistence.addRecentSearch(recentSearches[0])
            }
        }
    }
    private var organizations = [String: Organization]()
	var images = [String: Image]()
	var breeds: [Breed]?
    var animalType: AnimalType?
    var page = 1
    
    init(search: Search?, location: String?, distance: String?) {
        self.favorites = Persistence.getFavorites()
        self.loadAnimalTypes() {
            self.search = search
        }
        self.location = location
        self.distance = distance
        self.recentSearches = Persistence.getRecentSearches()
	}
	
    func loadAnimalTypes(_ completion: @escaping () -> Void) {
		API.fetchAnimalTypes { animalTypesQuery in
			guard let animalTypesQuery = animalTypesQuery else {
				print("network error")
				return
			}
			
			DispatchQueue.main.async {
                self.animalTypes = animalTypesQuery.animalTypes
                completion()
			}
		}
	}
	
	func loadBreeds() {
		guard let search = search else {
			return
		}
		
		API.fetchBreeds(search.animalType) { breedsQuery in
			guard let breedsQuery = breedsQuery else {
				return
			}
			
			self.breeds = breedsQuery.breeds
		}
	}
	
	func sortFilters() {
		guard let search = search else {
			return
		}

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
	
	func refresh() {
        self.loadAnimals()
	}
    
	func loadAnimals() {
		guard let search = search, let location = location else {
			return
		}

        API.fetchAnimals(search, location: location, distance: distance ?? "100", page: page) { animalResult in
            guard let animalResult = animalResult else {
                return
            }
            
            for animal in animalResult.animals {
                self.loadOrganization(animal.organizationId) { organization in
                    DispatchQueue.main.async {
                        guard let organization = organization else { return }
                        self.searchResults.append(SearchResult(animal: animal, organization: organization))
                    }
                }
            }
        }
    }
    
    func loadOrganization(_ organizationId: String, completion: @escaping (Organization?) -> Void) {
        if let organization = self.organizations[organizationId] {
            completion(organization)
            return
        }
        
        API.fetchOrganization(organizationId) { organizationQuery in
            if let orgaization = organizationQuery?.organization {
                self.organizations[organizationId] = orgaization
            }
            
            completion(organizationQuery?.organization)
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
