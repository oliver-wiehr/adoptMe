//
//  FilterSelectionView.swift
//  AdoptMe
//
//  Created by Oliver Wiehr on 10/22/22.
//

import SwiftUI

struct FilterSelectionView: View {
    @EnvironmentObject var adoptMe: AdoptMe
    var filter: Filter
    @State var previousFilters: [String: [String]]?
    @State var showFilterView = false {
        didSet {
            if showFilterView {
                previousFilters = adoptMe.search?.filters
            }
        }
    }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 5)
                .foregroundColor(adoptMe.isSelected(filter.id) ? .accentColor : .gray)
            Text(filter.title)
                .lineLimit(1)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
        }.onTapGesture {
            showFilterView = true
        }.sheet(isPresented: $showFilterView) {
            adoptMe.sortFilters()
            if self.previousFilters != adoptMe.search?.filters {
                adoptMe.loadAnimals()
            }
        } content: {
            let selectionAction: (_ filterAction: String) -> Void = { filterOptionId in
                adoptMe.toggleFilterOption(filterOptionId, filter: filter.id)
                if let currentSearch = adoptMe.search {
                    Persistence.setCurrentSearch(currentSearch)
                }
            }
            switch filter.id {
            case "breed":
                FilterView(filter: Filter(id: filter.id, title: filter.title, options: adoptMe.breeds?.map {
                    FilterOption(id: $0.name, title: $0.name)
                } ?? []), selectionAction: selectionAction)
            case "color":
                FilterView(filter: Filter(id: filter.id, title: filter.title, options: adoptMe.animalType?.colors.map {
                    FilterOption(id: $0, title: $0)
                } ?? []), selectionAction: selectionAction)
            case "coat":
                FilterView(filter: Filter(id: filter.id, title: filter.title, options: adoptMe.animalType?.coats.map {
                    FilterOption(id: $0, title: $0)
                } ?? []), selectionAction: selectionAction)
            case "gender":
                FilterView(filter: Filter(id: filter.id, title: filter.title, options: adoptMe.animalType?.genders.map {
                    FilterOption(id: $0, title: $0)
                } ?? []), selectionAction: selectionAction)
            default:
                FilterView(filter: filter, selectionAction: selectionAction)
            }
        }
    }
}
