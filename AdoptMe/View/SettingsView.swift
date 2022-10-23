//
//  SettingsView.swift
//  AdoptMe
//
//  Created by Oliver Wiehr on 1/5/22.
//

import SwiftUI

struct SettingsView: View {
	@EnvironmentObject var adoptMe: AdoptMe
	@Binding var show: Bool
	
	var body: some View {
		NavigationView {
			ScrollView {
				VStack() {
					NewSearchView(showSettingsView: $show).padding()
                    RecentSearchesView(showSettingsView: $show).padding()
                    ChangeLocationView(location: $adoptMe.location).padding()
					CopyRightView().padding()
				}
			}
			.toolbar {
				ToolbarItem(placement: .navigationBarTrailing) {
					Button {
						withAnimation {
							show = false
						}
					} label: {
						Image(systemName: "xmark")
					}
				}
			}
			.navigationTitle(Text("Settings"))
			.navigationBarTitleDisplayMode(.inline)
		}.navigationViewStyle(StackNavigationViewStyle())
	}
}

struct NewSearchView: View {
	@EnvironmentObject var adoptMe: AdoptMe
	@Binding var showSettingsView: Bool
	
	var body: some View {
		VStack {
			Text("New Search")
				.font(.title3)
			HStack {
				AnimalTypeView(showSettingsView: $showSettingsView, animalType: "Dog")
				AnimalTypeView(showSettingsView: $showSettingsView, animalType: "Cat")
				AnimalTypeView(showSettingsView: $showSettingsView, animalType: nil)
			}
		}
	}
}

struct AnimalTypeView: View {
	@EnvironmentObject var adoptMe: AdoptMe
	@Binding var showSettingsView: Bool
	var animalType: String?
	
	@State var showSheet = false
	
	var body: some View {
		ZStack {
            if let animalType = animalType {
                Image(animalType.lowercased())
                    .resizable()
                    .aspectRatio(0.75, contentMode: .fill)
                    .cornerRadius(5)
            } else {
                RoundedRectangle(cornerRadius: 5)
                    .aspectRatio(0.75, contentMode: .fill)
                    .foregroundColor(.gray)
            }
			Text(animalType ?? "Other")
		}.onTapGesture {
			if let animalType = animalType {
                if let previousSearch = adoptMe.search {
                    adoptMe.recentSearches.insert(previousSearch, at: 0)
                }
                adoptMe.search = Search(animalType: animalType, filters: [:])
				withAnimation {
					showSettingsView = false
				}
			} else {
				showSheet = true
			}
		}.popover(isPresented: $showSheet) {
            FilterView(filter: Filter(id: "animalTypes", title: "Animal Types", options: adoptMe.animalTypes?.map {
                FilterOption(id: $0.name, title: $0.name)
            } ?? []), selectionAction: { filterOptionId in
                if let previousSearch = adoptMe.search {
                    adoptMe.recentSearches.insert(previousSearch, at: 0)
                }
                adoptMe.search = Search(animalType: filterOptionId, filters: [:])
                withAnimation {
                    showSheet = false
                    showSettingsView = false
                }
            })
		}
		
	}
}

struct RecentSearchView: View {
    var search: Search
    
	var body: some View {
		ZStack {
			RoundedRectangle(cornerRadius: 5)
				.foregroundColor(.gray)
			HStack(alignment: .top) {
				VStack(alignment: .leading) {
                    Text(search.animalType.capitalized).font(.headline)
                    Text("\(search.filters.count) filters")
				}
				Spacer()
                if let animalType = search.animalType, ["dog", "cat"].contains(animalType.lowercased()) {
                    Image(animalType.lowercased())
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 100, height: 100)
                        .clipped()
                        .cornerRadius(5)
                } else {
                    RoundedRectangle(cornerRadius: 5)
                        .aspectRatio(1.0, contentMode: .fit)
                        .foregroundColor(.black)
                        .frame(width: 100, height: 100)
                }
			}.padding()
		}
        .frame(height: 134)
	}
}

struct RecentSearchesView: View {
    @EnvironmentObject var adoptMe: AdoptMe
    @Binding var showSettingsView: Bool
    
	var body: some View {
		VStack {
			Text("Recent Searches")
				.font(.title3)
            ForEach($adoptMe.recentSearches.indices, id: \.self) { index in
                RecentSearchView(search: adoptMe.recentSearches[index])
                    .onTapGesture {
                        adoptMe.search = adoptMe.recentSearches[index]
                        withAnimation {
                            showSettingsView = false
                        }
                    }
            }
		}
	}
}

struct ChangeLocationView: View {
    @Binding var location: String?
    
    @EnvironmentObject var adoptMe: AdoptMe
    @ObservedObject var locationManager = LocationManager()
	
	var body: some View {
		VStack {
			Text("Change Location")
				.font(.title3)
			Text(location ?? "").padding(.bottom, 6)
			ZStack {
				RoundedRectangle(cornerRadius: 5)
					.foregroundColor(.gray)
                HStack {
                    TextField("Zip Code", text: $locationManager.location)
                    if locationManager.isLoadingLocation {
                        ProgressView()
                    } else {
                        Button {
                            locationManager.requestLocation()
                        } label: {
                            Image(systemName: "location.circle")
                        }
                    }
                }
                .padding(6)
            }
            .frame(maxWidth: 250)
            Button {
                adoptMe.searchResults = []
                adoptMe.location = locationManager.location
                locationManager.location = ""
			} label: {
				Text("Set")
			}
            .disabled(!ZipCodes.validate(locationManager.location))
		}
	}
}

struct CopyRightView: View {
	var body: some View {
		VStack {
			Text("© by Oliver Wiehr")
			Text("Icons by Icons8 ⋅ Data by Petfinder")
		}
	}
}

struct SettingsView_Previews: PreviewProvider {
	@State static var showSettingsView = true
	
	static var previews: some View {
		SettingsView(show: SettingsView_Previews.$showSettingsView)
            .environmentObject(SampleData.adoptMe)
	}
}
