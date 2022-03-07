/* 
Copyright (c) 2021 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
struct ApiVendorAddressDetailDataModel : Codable {
	let vendorAddressID : Int?
	let recordID : String?
	let vendorID : Int?
	let streetAddress : String?
	let aptNumber : String?
	let city : String?
	let stateID : Int?
	let countryID : Int?
	let zipCode : String?
	let isSameBillingAddress : Bool?
	let mailingStreetAddress : String?
	let mailingAptNumber : String?
	let mailingCity : String?
	let mailingStateID : Int?
	let mailingZipCode : String?
	let active : Bool?
	let stateName : String?
	let diffFlag : String?
	let addressfile : String?
	let addressTable : String?

	enum CodingKeys: String, CodingKey {

		case vendorAddressID = "VendorAddressID"
		case recordID = "RecordID"
		case vendorID = "VendorID"
		case streetAddress = "StreetAddress"
		case aptNumber = "AptNumber"
		case city = "City"
		case stateID = "StateID"
		case countryID = "CountryID"
		case zipCode = "ZipCode"
		case isSameBillingAddress = "IsSameBillingAddress"
		case mailingStreetAddress = "MailingStreetAddress"
		case mailingAptNumber = "MailingAptNumber"
		case mailingCity = "MailingCity"
		case mailingStateID = "MailingStateID"
		case mailingZipCode = "MailingZipCode"
		case active = "Active"
		case stateName = "StateName"
		case diffFlag = "DiffFlag"
		case addressfile = "Addressfile"
		case addressTable = "AddressTable"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		vendorAddressID = try values.decodeIfPresent(Int.self, forKey: .vendorAddressID)
		recordID = try values.decodeIfPresent(String.self, forKey: .recordID)
		vendorID = try values.decodeIfPresent(Int.self, forKey: .vendorID)
		streetAddress = try values.decodeIfPresent(String.self, forKey: .streetAddress)
		aptNumber = try values.decodeIfPresent(String.self, forKey: .aptNumber)
		city = try values.decodeIfPresent(String.self, forKey: .city)
		stateID = try values.decodeIfPresent(Int.self, forKey: .stateID)
		countryID = try values.decodeIfPresent(Int.self, forKey: .countryID)
		zipCode = try values.decodeIfPresent(String.self, forKey: .zipCode)
		isSameBillingAddress = try values.decodeIfPresent(Bool.self, forKey: .isSameBillingAddress)
		mailingStreetAddress = try values.decodeIfPresent(String.self, forKey: .mailingStreetAddress)
		mailingAptNumber = try values.decodeIfPresent(String.self, forKey: .mailingAptNumber)
		mailingCity = try values.decodeIfPresent(String.self, forKey: .mailingCity)
		mailingStateID = try values.decodeIfPresent(Int.self, forKey: .mailingStateID)
		mailingZipCode = try values.decodeIfPresent(String.self, forKey: .mailingZipCode)
		active = try values.decodeIfPresent(Bool.self, forKey: .active)
		stateName = try values.decodeIfPresent(String.self, forKey: .stateName)
		diffFlag = try values.decodeIfPresent(String.self, forKey: .diffFlag)
		addressfile = try values.decodeIfPresent(String.self, forKey: .addressfile)
		addressTable = try values.decodeIfPresent(String.self, forKey: .addressTable)
	}

}
