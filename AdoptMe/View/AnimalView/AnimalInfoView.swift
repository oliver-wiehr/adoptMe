//
//  AnimalInfoView.swift
//  AdoptMe
//
//  Created by Oliver Wiehr on 10/22/22.
//

import SwiftUI

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
