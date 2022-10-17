//
//  SampleData.swift
//  AdoptMe
//
//  Created by Oliver Wiehr on 1/3/22.
//

import Foundation

class SampleData {
	static let animals =  [Animal(
		id: 120,
		name: "Spot",
		organizationId: "NJ333",
		type: "Dog",
		description: "Spot is an amazing dog",
		age: "Young",
		gender: "Male",
		size: "Medium",
		coat: nil,
		species: "Dog",
		status: "adoptable",
		publishedAt: nil,
		attributes: nil, breeds:
			Breeds(
				primary:"Akita",
				secondary: nil,
				mixed: false,
				unknown: false
			), colors: nil, contact: nil, environment: nil, photos: [
				Photo(
					small: "https://photos.petfinder.com/photos/pets/42706540/1/?bust=1546042081&width=100",
					medium: "https://photos.petfinder.com/photos/pets/42706540/1/?bust=1546042081&width=300",
					large: "https://photos.petfinder.com/photos/pets/42706540/1/?bust=1546042081&width=600",
					full: "https://photos.petfinder.com/photos/pets/42706540/1/?bust=1546042081"
				)
			],
		tags: nil
	)]
    
    static let location = "77007"
	
	static let organizations = [
		Organization(
			id: "0",
			name: "Houston SPCA",
			email: nil,
			phone: nil,
			address: nil,
			hours: nil,
			url: nil,
			website: nil,
			missionStatement: nil,
			photos: []
		)
	]
	
	static let search = Search(
		animalType: "dog",
		filters: [:]
	)
	
	static let filterOptions = [
		FilterOption(id: "baby", title: "Baby"),
		FilterOption(id: "young", title: "Young"),
		FilterOption(id: "adult", title: "Adult"),
		FilterOption(id: "senior", title: "Senior")
	]
	
	static let filter = Filter(id: "age", title: "Age", options: SampleData.filterOptions)
	
	static let searchResults = [
		SearchResult(animal: SampleData.animals[0], organization: SampleData.organizations[0]),
		SearchResult(animal: SampleData.animals[0], organization: SampleData.organizations[0]),
		SearchResult(animal: SampleData.animals[0], organization: SampleData.organizations[0]),
		SearchResult(animal: SampleData.animals[0], organization: SampleData.organizations[0])
	]
	
	static let favorites = [
		SearchResult(animal: SampleData.animals[0], organization: SampleData.organizations[0]),
		SearchResult(animal: SampleData.animals[0], organization: SampleData.organizations[0])
	]
	
	static let adoptMe: AdoptMe = {
        let adoptMe = AdoptMe(search: SampleData.search, location: SampleData.location)
		adoptMe.searchResults = SampleData.searchResults
		adoptMe.favorites = SampleData.favorites
		return adoptMe
	}()
}
