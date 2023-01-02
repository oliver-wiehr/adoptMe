//
//  TopBar.swift
//  AdoptMe
//
//  Created by Oliver Wiehr on 1/1/23.
//

import Foundation
import SwiftUI

struct TopBar: View {
    @EnvironmentObject var adoptMe: AdoptMe
    @Binding var showFavorites: Bool
    @Binding var showSettings: Bool
    
    var body: some View {
        HStack {
            Menu {
                ForEach(adoptMe.animalTypes ?? [], id: \.name) { animalType in
                    Button(animalType.name) {
                        print(animalType.name)
                    }
                }
            } label: {
                HStack {
                    Image(systemName: "pawprint.fill")
                    Text("Dogs")
                        .font(.title2)
                        .fontWeight(.medium)
                    Image(systemName: "chevron.down")
                }
            }
            .tint(.primary)
            
            Spacer()
            
            Button {
                showSettings = true
            } label: {
                Image(systemName: "line.3.horizontal.decrease")
                    .resizable()
                    .frame(width: 18, height: 14)
                    .tint(.primary)
                    .padding(.trailing, 10)
            }
            Button {
                withAnimation {
                    showFavorites = true
                }
            } label: {
                Image(systemName: "heart")
                    .resizable()
                    .frame(width: 18, height: 18)
                    .tint(.primary)
            }
        }
        .padding(EdgeInsets(top: 12, leading: 30, bottom: 12, trailing: 30))
//        .background(Color.background.shadow(color: .gray.opacity(0.3), radius: 2).mask(Rectangle().padding(.bottom, -20)))
    }
}

//struct TopBar_Previews: PreviewProvider {
//    static var previews: some View {
//        TopBar()
//            .previewLayout(.fixed(width: 390, height: 40))
//    }
//}
