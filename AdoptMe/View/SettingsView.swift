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
					RecentSearchesView().padding()
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
					.frame(height: 134)
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
			RoundedRectangle(cornerRadius: 5)
				.foregroundColor(.gray)
			Text(animalType ?? "Other")
		}.onTapGesture {
			if let animalType = animalType {
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
	var body: some View {
		ZStack {
			RoundedRectangle(cornerRadius: 5)
				.foregroundColor(.gray)
			HStack(alignment: .top) {
				VStack(alignment: .leading) {
					Text("Dog").font(.headline)
					Text("5 filters")
				}
				Spacer()
				RoundedRectangle(cornerRadius: 5)
					.aspectRatio(1.0, contentMode: .fit)
					.foregroundColor(.black)
			}.padding()
		}
	}
}

struct RecentSearchesView: View {
	var body: some View {
		VStack {
			Text("Recent Searches")
				.font(.title3)
			RecentSearchView()
				.frame(height: 134)
		}
	}
}

struct ChangeLocationView: View {
	@State private var zipCode: String = ""
    @Binding var location: String?
    
    @EnvironmentObject var adoptMe: AdoptMe
	
	var body: some View {
		VStack {
			Text("Change Location")
				.font(.title3)
			Text(location ?? "").padding(.bottom, 6)
			ZStack {
				RoundedRectangle(cornerRadius: 5)
					.foregroundColor(.gray)
				TextField("Zip Code", text: $zipCode)
					.padding(6)
			}
			.frame(maxWidth: 200)
			Button {
                adoptMe.searchResults = []
                adoptMe.location = zipCode
                zipCode = ""
			} label: {
				Text("Set")
			}
            .disabled(!ZipCodes.validate(zipCode))
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
