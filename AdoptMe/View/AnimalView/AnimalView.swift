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
    @SwiftUI.Environment(\.presentationMode) var presentation
	
	var body: some View {
		NavigationView {
			ScrollView {
				VStack(alignment: .leading) {
                    if animal.photos.count > 0 {
                        AnimalImageView(photos: animal.photos)
                    }
					AnimalInfoView(breeds: animal.breeds, age: animal.age, gender: animal.gender)
					AnimalAboutView(description: animal.description)
                    AnimalHealthView(attributes: animal.attributes)
					AnimalOrganizationView(organization: organization)
					Spacer()
				}
			}
            .navigationTitle(animal.name)
			.navigationBarTitleDisplayMode(.inline)
			.toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        self.presentation.wrappedValue.dismiss()
                    } label: {
                        Image(systemName: "chevron.left")
                    }
                }
				ToolbarItem(placement: .navigationBarTrailing) {
					Button {
                        if adoptMe.favorites.contains(animal.id) {
                            adoptMe.favorites.removeAll(where: { $0 == animal.id })
                        } else {
                            adoptMe.favorites.insert(animal.id, at: 0)
                        }
					} label: {
						Image(systemName: adoptMe.favorites.contains(where: { $0 == animal.id }) ? "heart.fill" : "heart")
					}
				}
			}
		}.navigationViewStyle(StackNavigationViewStyle())
            .navigationBarBackButtonHidden(true)
	}
}

//struct AnimalView_Previews: PreviewProvider {
//    static var previews: some View {
//        AnimalView(animal: SampleData.animals[0], organization: SampleData.organizations[0]).preferredColorScheme(.dark)
//            .environmentObject(SampleData.adoptMe)
//        AnimalView(animal: SampleData.animals[0], organization: SampleData.organizations[0]).previewDevice("iPhone SE (2nd generation)")
//            .environmentObject(SampleData.adoptMe)
//    }
//}
