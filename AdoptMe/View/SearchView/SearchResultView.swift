//
//  SearchResultView.swift
//  AdoptMe
//
//  Created by Oliver Wiehr on 10/22/22.
//

import SwiftUI

struct SearchResultView: View {
    @EnvironmentObject var adoptMe: AdoptMe
    
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
                        if adoptMe.favorites.contains(where: { $0.animal.id == searchResult.animal.id }) {
                            adoptMe.favorites.removeAll(where: { $0.animal.id == searchResult.animal.id })
                        } else {
                            adoptMe.favorites.insert(searchResult, at: 0)
                        }
                    } label: {
                        Image(systemName: adoptMe.favorites.contains(where: { $0.animal.id == searchResult.animal.id }) ? "heart.fill" : "heart")
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
