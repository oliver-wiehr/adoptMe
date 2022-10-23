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

struct FilterView_Previews: PreviewProvider {
	static var previews: some View {
        FilterView(filter: SampleData.filter, selectionAction: { filterAction in })
            .environmentObject(SampleData.adoptMe)
	}
}
