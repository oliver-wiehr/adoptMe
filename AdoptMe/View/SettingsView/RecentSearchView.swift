//
//  RecentSearchView.swift
//  AdoptMe
//
//  Created by Oliver Wiehr on 10/22/22.
//

import SwiftUI

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
