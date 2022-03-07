/* 
Copyright (c) 2021 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
struct ApiVendorColorDataModel : Codable {
	let recordID : Int?
	let vendorColorID : Int?
	let vendorID : Int?
	let color1 : String?
	let color2 : String?
	let color3 : String?
	let color4 : String?
	let color5 : String?
	let color6 : String?
	let active : Bool?

	enum CodingKeys: String, CodingKey {

		case recordID = "RecordID"
		case vendorColorID = "VendorColorID"
		case vendorID = "VendorID"
		case color1 = "Color1"
		case color2 = "Color2"
		case color3 = "Color3"
		case color4 = "Color4"
		case color5 = "Color5"
		case color6 = "Color6"
		case active = "Active"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		recordID = try values.decodeIfPresent(Int.self, forKey: .recordID)
		vendorColorID = try values.decodeIfPresent(Int.self, forKey: .vendorColorID)
		vendorID = try values.decodeIfPresent(Int.self, forKey: .vendorID)
		color1 = try values.decodeIfPresent(String.self, forKey: .color1)
		color2 = try values.decodeIfPresent(String.self, forKey: .color2)
		color3 = try values.decodeIfPresent(String.self, forKey: .color3)
		color4 = try values.decodeIfPresent(String.self, forKey: .color4)
		color5 = try values.decodeIfPresent(String.self, forKey: .color5)
		color6 = try values.decodeIfPresent(String.self, forKey: .color6)
		active = try values.decodeIfPresent(Bool.self, forKey: .active)
	}

}
