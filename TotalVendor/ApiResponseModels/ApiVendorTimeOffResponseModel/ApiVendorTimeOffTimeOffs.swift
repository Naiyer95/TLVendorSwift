/* 
Copyright (c) 2022 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
struct ApiVendorTimeOffTimeOffs : Codable {
	let vendorTimeOffID : Int?
	let vendorID : Int?
	let companyID : Int?
	let eventName : String?
	let companyName : String?
	let vendorName : String?
	let fromDateTime : String?
	let toDateTime : String?
	let updateDate : String?
	let active : Bool?

	enum CodingKeys: String, CodingKey {

		case vendorTimeOffID = "VendorTimeOffID"
		case vendorID = "VendorID"
		case companyID = "CompanyID"
		case eventName = "EventName"
		case companyName = "CompanyName"
		case vendorName = "VendorName"
		case fromDateTime = "FromDateTime"
		case toDateTime = "ToDateTime"
		case updateDate = "UpdateDate"
		case active = "Active"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		vendorTimeOffID = try values.decodeIfPresent(Int.self, forKey: .vendorTimeOffID)
		vendorID = try values.decodeIfPresent(Int.self, forKey: .vendorID)
		companyID = try values.decodeIfPresent(Int.self, forKey: .companyID)
		eventName = try values.decodeIfPresent(String.self, forKey: .eventName)
		companyName = try values.decodeIfPresent(String.self, forKey: .companyName)
		vendorName = try values.decodeIfPresent(String.self, forKey: .vendorName)
		fromDateTime = try values.decodeIfPresent(String.self, forKey: .fromDateTime)
		toDateTime = try values.decodeIfPresent(String.self, forKey: .toDateTime)
		updateDate = try values.decodeIfPresent(String.self, forKey: .updateDate)
		active = try values.decodeIfPresent(Bool.self, forKey: .active)
	}

}
