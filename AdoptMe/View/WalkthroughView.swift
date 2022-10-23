//
//  WalkthroughView.swift
//  AdoptMe
//
//  Created by Oliver Wiehr on 2/23/22.
//

import SwiftUI

struct WalkthroughView: View {
	@EnvironmentObject var adoptMe: AdoptMe
	@Binding var show: Bool
	@State var page = 0
	@State var location = ""
    @State var animalType = ""
    
    var body: some View {
        VStack {
            Image("logo").resizable().scaledToFit().frame(width: page == 0 ? 250 : 180)
            switch page {
            case 0:
                Spacer()
                Text("What are you looking for?")
                    .font(.title2)
                    .multilineTextAlignment(.center)
                    .transition(.opacity)
                Spacer()
            case 1:
                Text("Where are you looking?")
                    .font(.title2)
                    .multilineTextAlignment(.center)
                    .transition(.opacity)
                WalkthroughLocationView(location: $location).transition(.backslide)
            default:
                Text("What are you looking for?")
                    .font(.title2)
                    .multilineTextAlignment(.center)
                    .transition(.opacity)
                WalkthroughAnimalTypesView(animalType: $animalType, showWalkthrough: $show).transition(.backslide)
            }
            if page < 2 {
                Button {
                    if page == 1 {
                        adoptMe.location = location
                    }
                    if page < 2 {
                        withAnimation {
                            page += 1
                        }
                    }
                } label: {
                    switch page {
                    case 0:
                        Text("Let's go!")
                    case 1:
                        Text("Next")
                    default:
                        Text("")
                    }
                }
                .disabled({
                    if page == 1 {
                        return !ZipCodes.validate(location)
                    }
                    return false
                }())
                .padding()
            }
        }.frame(height: 450)
    }
}

struct WalkthroughLocationView: View {
    @Binding var location: String
	
	var body: some View {
		VStack {
			Spacer()
			VStack {
				Spacer()
				ZStack {
				 RoundedRectangle(cornerRadius: 5)
					 .foregroundColor(.gray)
					TextField("Zip Code", text: $location)
					 .padding(6)
				}.frame(maxHeight: 40)
				Spacer()
			}
			.transition(.slide)
			.frame(width: 300, height: 200, alignment: .top)
			Spacer()
		}
	}
}

struct WalkthroughAnimalTypesView: View {
    @Binding var animalType: String
	@Binding var showWalkthrough: Bool
	
	var body: some View {
		VStack {
			Spacer()
			VStack {
				VStack {
                    WalkthroughAnimalTypeView(selectedAnimalType: $animalType, showWalkthrough: $showWalkthrough, animalType: "Dog")
                    WalkthroughAnimalTypeView(selectedAnimalType: $animalType, showWalkthrough: $showWalkthrough, animalType: "Cat")
                    WalkthroughAnimalTypeView(selectedAnimalType: $animalType, showWalkthrough: $showWalkthrough, animalType: nil)
				}
			}
			.transition(.slide)
			.frame(width: 300, height: 200, alignment: .top)
			Spacer()
		}
	}
}

struct WalkthroughAnimalTypeView: View {
	@Binding var selectedAnimalType: String
    @Binding var showWalkthrough: Bool
	var animalType: String?
	
	@State var showSheet = false
    
    @EnvironmentObject var adoptMe: AdoptMe
	
	var body: some View {
		ZStack {
			RoundedRectangle(cornerRadius: 5)
                .foregroundColor(.gray)
			Text(animalType ?? "Other")
		}.onTapGesture {
			if let animalType = animalType {
                adoptMe.search = Search(animalType: animalType, filters: [:])
                withAnimation {
                    showWalkthrough = false
                }
			} else {
				showSheet = true
			}
		}.popover(isPresented: $showSheet) {
            FilterView(filter: Filter(id: "animalTypes", title: "Animal Types", options: adoptMe.animalTypes?.map {
                FilterOption(id: $0.name, title: $0.name)
            } ?? []), selectionAction: { filterOptionId in
                withAnimation {
                    showSheet = false
                }
                adoptMe.search = Search(animalType: filterOptionId, filters: [:])
                withAnimation {
                    showWalkthrough = false
                }
            })
		}
		
	}
}
