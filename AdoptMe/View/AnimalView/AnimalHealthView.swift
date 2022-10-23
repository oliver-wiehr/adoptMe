//
//  AnimalHealthView.swift
//  AdoptMe
//
//  Created by Oliver Wiehr on 10/22/22.
//

import SwiftUI

struct AnimalHealthView: View {
    var attributes: Attributes?
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Health")
                .font(.title2)
            Text(attributes?.description ?? "Contact my shelter to find out more about my health.")
        }.padding()
    }
}
