//
//  AnimalAboutView.swift
//  AdoptMe
//
//  Created by Oliver Wiehr on 10/22/22.
//

import SwiftUI

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
