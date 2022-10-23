//
//  AnimalImageView.swift
//  AdoptMe
//
//  Created by Oliver Wiehr on 10/22/22.
//

import SwiftUI

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
