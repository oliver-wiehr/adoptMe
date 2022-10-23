//
//  FiltersSelectionView.swift
//  AdoptMe
//
//  Created by Oliver Wiehr on 10/22/22.
//

import SwiftUI

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
