//
//  ZipCodes.swift
//  AdoptMe
//
//  Created by Oliver Wiehr on 11/30/21.
//

import Foundation

struct ZipCodes {
	static func validate(_ zip: String) -> Bool {
		guard let file = Bundle.main.url(forResource: "zipcodes", withExtension: "json"),
			  let data = try? Data(contentsOf: file),
			  let json = try? JSONSerialization.jsonObject(with: data, options: []),
			  let object = json as? [String: [Int]],
			  let zipArray = object["zip"],
			  let zipCode = Int(zip)
		else {
			return false
		}
		
		return zipArray.contains(zipCode)
	}
}








