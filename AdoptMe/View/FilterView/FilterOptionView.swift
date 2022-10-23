//
//  FilterOptionView.swift
//  AdoptMe
//
//  Created by Oliver Wiehr on 10/22/22.
//

import SwiftUI

struct FilterOptionView: View {
    @EnvironmentObject var adoptMe: AdoptMe
    var filter: Filter
    var filterOption: FilterOption
    var selectionAction: (_ filterOptionId: String) -> Void
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 5).foregroundColor(adoptMe.isSelected(filterOption.id, filter: filter.id) ? .accentColor : .gray)
            Text(filterOption.title).font(.headline).padding()
        }.padding(.horizontal)
            .onTapGesture {
                selectionAction(filterOption.id)
            }
    }
}
