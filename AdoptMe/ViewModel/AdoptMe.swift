//
//  ViewModel.swift
//  AdoptMe
//
//  Created by Oliver Wiehr on 1/3/22.
//

import Foundation
import SwiftUI

struct SearchResult: Identifiable {
	var id: Int
	var animal: Animal
	var organization: Organization
}

class AdoptMe: ObservableObject {
	
	@Published var searchResults = [SearchResult]()
	@Published var favorites = [SearchResult]()
	
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
		Filter(id: "distance", title: "Distance", options: []),
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
                    self.colors = animalType.colors
                    self.coats = animalType.coats
                    self.genders = animalType.genders
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
                if search != nil {
                    refresh()
                }
            }
        }
    }
    
    @Published var animalTypes: [AnimalType]? {
        didSet {
            if let search = search {
                if let animalType = animalTypes?.first(where: { animalType in
                    animalType.name.lowercased() == search.animalType.lowercased()
                }) {
                    self.colors = animalType.colors
                    self.coats = animalType.coats
                    self.genders = animalType.genders
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
    
	var organizations = [Organization]()
	var images = [String: Image]()
	var breeds: [Breed]?
	var colors: [String]?
	var coats: [String]?
	var genders: [String]?
	var page = 1
	
    init(search: Search?, location: String?) {
        loadAnimalTypes() {
            self.location = location
            self.search = search
        }
        self.recentSearches = Persistence.getRecentSearches()
	}
	
	func loadOrganizations(_ completion: @escaping () -> Void) {
		guard let search = search, let location = location else {
			completion()
			return
		}

        API.fetchOrganizations(location: location, distance: search.distance) { organizationsQuery in
			guard let organizationsQuery = organizationsQuery, let organizations = organizationsQuery.organizations else {
				print("network error")
				completion()
				return
			}
            
            self.organizations = organizations
            
            var pagesFetched = 1
            if organizationsQuery.pagination.totalPages > 1 {
                for page in 2...organizationsQuery.pagination.totalPages {
                    API.fetchOrganizations(location: location, distance: search.distance, page: page) { nextQuery in
                        guard let nextQuery = nextQuery, let organizations = nextQuery.organizations else {
                            print("network error")
                            return
                        }
                        
                        self.organizations.append(contentsOf: organizations)
                        
                        pagesFetched += 1
                        if pagesFetched == organizationsQuery.pagination.totalPages {
                            completion()
                        }
                    }
                }
            }
		}
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
		self.loadOrganizations() {
			self.loadAnimals()
		}
	}
    
	func loadAnimals() {
		guard let search = search, let location = location else {
			return
		}

		API.fetchAnimals(search, location: location, page: page) { animalResult in
			guard let animalResult = animalResult else {
				return
			}
			
			DispatchQueue.main.async {
				self.searchResults = {
					var searchResults = [SearchResult]()
					var id = 0
					for animal in animalResult.animals {
						if let organization = self.organizations.first(where: { organization in
							organization.id == animal.organizationId
						}) {
							searchResults.append(SearchResult(id: id, animal: animal, organization: organization))
							id += 1
                        }
					}
					
					return searchResults
				}()
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
}
