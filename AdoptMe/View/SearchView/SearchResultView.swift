//
//  SearchResultView.swift
//  AdoptMe
//
//  Created by Oliver Wiehr on 10/22/22.
//

import SwiftUI

struct SearchResultView: View {
    @EnvironmentObject var adoptMe: AdoptMe
    
    var animal: Animal
    var organization: Organization
    
    var body: some View {
        HStack {
            if let imageURLString = animal.previewImageURL, let imageURL = URL(string: imageURLString) {
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
                    Text(animal.name).font(.headline)
                        .lineLimit(2)
                    Spacer()
                    Button {
                        if adoptMe.favorites.contains(animal.id) {
                            adoptMe.favorites.removeAll(where: { $0 == animal.id })
                        } else {
                            adoptMe.favorites.insert(animal.id, at: 0)
                        }
                    } label: {
                        Image(systemName: adoptMe.favorites.contains(animal.id) ? "heart.fill" : "heart")
                    }
                    .frame(width: 18.0, height: 18.0)
                }
                Text(animal.age ?? "").font(.subheadline)
                Text(animal.size ?? "").font(.subheadline)
                Text(animal.breeds?.primary ?? "").font(.subheadline)
                Spacer()
                Text(organization.name).font(.headline)
            }.padding(4.0)
        }.padding(12.0)
    }
}
