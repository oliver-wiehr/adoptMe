//
//  SearchView.swift
//  AdoptMe
//
//  Created by Oliver Wiehr on 1/1/22.
//

import SwiftUI

struct SearchView: View {
	@EnvironmentObject var adoptMe: AdoptMe
	@State var showSettingsView = false
	@State var showFavoritesView = false
	
	var body: some View {
		if showSettingsView {
			SettingsView(show: $showSettingsView).transition(.leftSlide)
		} else if showFavoritesView {
			FavoritesView(show: $showFavoritesView).transition(.rightSlide)
		} else {
			NavigationView {
				VStack {
					FiltersSelectionView()
					SearchResultsView()
				}
				.navigationTitle("AdoptMe")
				.navigationBarTitleDisplayMode(.inline)
				.toolbar {
					ToolbarItem(placement: .navigationBarLeading) {
						Button {
							withAnimation {
								showSettingsView = true
							}
						} label: {
							Image(systemName: "slider.horizontal.3")
						}
					}
					ToolbarItem(placement: .navigationBarTrailing) {
						Button {
							withAnimation {
								showFavoritesView = true
							}
						} label: {
							Image(systemName: "heart.fill")
						}
					}
				}
			}.navigationViewStyle(StackNavigationViewStyle())
		}
	}
   }

struct SearchResultView: View {
	var searchResult: SearchResult
	
	var body: some View {
		HStack {
            if let imageURLString = searchResult.animal.previewImageURL, let imageURL = URL(string: imageURLString) {
                AsyncImage(url: imageURL, content: { image in
                    image.resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 180, height: 180)
                        .cornerRadius(5)
                }, placeholder: {
                    ProgressView()
                        .frame(width: 180, height: 180)
                })
            } else {
                RoundedRectangle(cornerSize: CGSize(width: 5, height: 5))
                    .foregroundColor(.gray)
                    .frame(width: 180, height: 180)
            }
			VStack(alignment: .leading) {
				HStack {
					Text(searchResult.animal.name).font(.headline)
					Spacer()
					Button {
						
					} label: {
						Image(systemName: "heart")
					}
					.frame(width: 18.0, height: 18.0)
				}
				Text(searchResult.animal.age ?? "").font(.subheadline)
				Text(searchResult.animal.size ?? "").font(.subheadline)
				Text(searchResult.animal.breeds?.primary ?? "").font(.subheadline)
				Spacer()
				Text(searchResult.organization.name).font(.headline)
            }.padding(4.0)
        }.padding(12.0)
    }
}

struct SearchResultsView: View {
    @EnvironmentObject var adoptMe: AdoptMe
    
    var body: some View {
        if adoptMe.searchResults.count == 0 {
            VStack {
                Spacer()
                ProgressView()
                Spacer()
            }
            .layoutPriority(1)
        } else {
            ScrollView {
                LazyVStack {
                    ForEach(adoptMe.searchResults) { searchResult in
                        NavigationLink {
                            AnimalView(
                                animal: searchResult.animal,
                                organization: searchResult.organization
                            )
                        } label: {
                            SearchResultView(searchResult: searchResult)
                        }.buttonStyle(.plain)
                    }
                }
            }.layoutPriority(1)
        }
    }
}

struct FiltersSelectionView: View {
	@EnvironmentObject var adoptMe: AdoptMe
	
	var body: some View {
		ScrollView(.horizontal, showsIndicators: false) {
			HStack {
				ForEach(adoptMe.filters) { filter in
					FilterSelectionView(
						filter: filter
					)
				}
			}.padding(.horizontal, 9)
		}
	}
}

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
			case "colors":
				FilterView(filter: Filter(id: filter.id, title: filter.title, options: adoptMe.colors?.map {
					FilterOption(id: $0, title: $0)
                } ?? []), selectionAction: selectionAction)
			case "coats":
				FilterView(filter: Filter(id: filter.id, title: filter.title, options: adoptMe.coats?.map {
					FilterOption(id: $0, title: $0)
                } ?? []), selectionAction: selectionAction)
			case "genders":
				FilterView(filter: Filter(id: filter.id, title: filter.title, options: adoptMe.genders?.map {
					FilterOption(id: $0, title: $0)
                } ?? []), selectionAction: selectionAction)
			default:
                FilterView(filter: filter, selectionAction: selectionAction)
			}
		}
	}
}

struct SearchView_Previews: PreviewProvider {

    static var previews: some View {
		SearchView()
            .environmentObject(SampleData.adoptMe)
    }
}
