//
//  AnimalView.swift
//  AdoptMe
//
//  Created by Oliver Wiehr on 1/3/22.
//

import SwiftUI
import MapKit

struct AnimalView: View {
	@EnvironmentObject var adoptMe: AdoptMe
	var animal: Animal
	var organization: Organization
	
	var body: some View {
		NavigationView {
			ScrollView {
				VStack(alignment: .leading) {
					AnimalImageView(photos: animal.photos)
					AnimalInfoView(breeds: animal.breeds, age: animal.age, gender: animal.gender)
					AnimalAboutView(description: animal.description)
					if let attributes = animal.attributes {
						AnimalHealthView(attributes: attributes)
					}
					AnimalOrganizationView(organization: organization)
					Spacer()
				}
			}
			.navigationTitle(Text(animal.name))
			.navigationBarTitleDisplayMode(.inline)
			.toolbar {
				ToolbarItem(placement: .navigationBarTrailing) {
					Button {
                        if adoptMe.favorites.contains(where: { $0.animal.id == animal.id }) {
                            adoptMe.favorites.removeAll(where: { $0.animal.id == animal.id })
                        } else {
                            adoptMe.favorites.insert(SearchResult(animal: animal, organization: organization), at: 0)
                        }
					} label: {
						Image(systemName: adoptMe.favorites.contains(where: { $0.animal.id == animal.id }) ? "heart.fill" : "heart")
					}
				}
			}
		}.navigationViewStyle(StackNavigationViewStyle())
	}
}

struct AnimalImageView: View {
	var photos: [Photo]
	
	var body: some View {
		TabView {
            ForEach(photos, id: \.largeSize!) { photo in
                if let imageURL = URL(string: photo.largeSize!) {
                    AsyncImage(url: imageURL) { image in
                        image.resizable()
                            .aspectRatio(contentMode: .fill)
                    } placeholder: {
                        ProgressView()
                    }
                }

            }
        }
			.tabViewStyle(.page)
            .aspectRatio(1.0, contentMode: .fill)
	}
}

struct AnimalInfoView: View {
	var breeds: Breeds?
	var age: String?
	var gender: String?
	
	var body: some View {
		VStack(alignment: .leading) {
			HStack {
				Image("paw").renderingMode(.template)
				Text(breeds?.primary ?? "")
			}
			HStack {
				Image("ruler").renderingMode(.template)
				Text(age ?? "")
			}
			HStack {
				Image("male").renderingMode(.template)
				Text(gender ?? "")
			}
		}.padding()
	}
}

struct AnimalAboutView: View {
	var description: String?
	
	var body: some View {
		VStack(alignment: .leading) {
			Text("About Me")
				.font(.title2)
			Text(description ?? "Contact my shelter to find out more about me.")
		}.padding()
	}
}

struct AnimalHealthView: View {
	var attributes: Attributes
	
	var body: some View {
		VStack(alignment: .leading) {
			Text("Health")
				.font(.title2)
			Text("")
		}.padding()
	}
}

struct AnimalOrganizationView: View {
    @EnvironmentObject var adoptMe: AdoptMe
    var organization: Organization
    
    var body: some View {
        VStack {
            HStack {
                
                if let photo = organization.photos.first, let imageURL = URL(string: photo.largeSize!) {
                    AsyncImage(url: imageURL) { image in
                        image.resizable()
                            .aspectRatio(contentMode: .fill)
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(width: 50.0, height: 50.0)
                    .cornerRadius(/*@START_MENU_TOKEN@*/5.0/*@END_MENU_TOKEN@*/)
                }
                VStack {
                    Text(organization.name)
                    Text(organization.address?.city ?? "")
                }
            }
            HStack {
                Button {
                    adoptMe.callPhone(organization.phone!)
                } label: {
                    Image(systemName: "phone.fill")
                }
                .disabled(organization.phone == nil)
                Spacer()
                Button {
                    adoptMe.writeEmail(organization.email!)
                } label: {
                    Image(systemName: "envelope.fill")
                }
                .disabled(organization.email == nil)
            }
            .frame(maxWidth: 100)
            .padding()
            
            if let location = organization.address?.coordinate {
                OrganizationMap(
                    organization: organization,
                    region: MKCoordinateRegion(center: location, latitudinalMeters: 7500, longitudinalMeters: 7500)
                )
            }
        }
    }
}

struct OrganizationMap : View {
    var organization: Organization
    @State var region: MKCoordinateRegion
    
    var body: some View {
        Map(coordinateRegion: $region, annotationItems: [organization]) { place in
            MapMarker(coordinate: organization.address!.coordinate!, tint: .accentColor)
        }
        .cornerRadius(5.0)
        .aspectRatio(1.0, contentMode: .fit)
        .padding()
    }
}

struct AnimalView_Previews: PreviewProvider {
    static var previews: some View {
        AnimalView(animal: SampleData.animals[0], organization: SampleData.organizations[0]).preferredColorScheme(.dark)
            .environmentObject(SampleData.adoptMe)
        AnimalView(animal: SampleData.animals[0], organization: SampleData.organizations[0]).previewDevice("iPhone SE (2nd generation)")
            .environmentObject(SampleData.adoptMe)
    }
}
