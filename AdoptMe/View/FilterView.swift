//
//  FilterView.swift
//  AdoptMe
//
//  Created by Oliver Wiehr on 1/8/22.
//

import SwiftUI

protocol FilterDataProtocol {
	func setOptions()
}

struct FilterView: View {
	@EnvironmentObject var adoptMe: AdoptMe
	var filter: Filter
    var selectionAction: (_ filterOptionId: String) -> Void
	
	var body: some View {
		VStack {
			Text(filter.title)
				.font(.title)
				.padding()
			ScrollView {
				VStack {
					ForEach(filter.options) { filterOption in
						FilterOptionView(
							filter: filter,
							filterOption: filterOption,
                            selectionAction: selectionAction
						)
					}
				}
			}
		}
	}
}

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

struct FilterView_Previews: PreviewProvider {
	static var previews: some View {
        FilterView(filter: SampleData.filter, selectionAction: { filterAction in })
            .environmentObject(SampleData.adoptMe)
	}
}
