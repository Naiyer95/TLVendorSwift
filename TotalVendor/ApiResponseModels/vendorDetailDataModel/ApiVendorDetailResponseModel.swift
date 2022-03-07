/* 
Copyright (c) 2021 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
struct ApiVendorDetailResponseModel : Codable {
	let vendorDetails : String?
	let address : [ApiVendorAddressDetailDataModel]?
	let vendorLanguage : [ApiVendorLanguageDataModel]?
	let vendorDetail : [ApiVendorDetailDataModel]?
	let vendorBilling : [ApiVendorBillingDetailModel]?
	let speciality : [ApiVendorSpecialityDataModel]?
	let phone : [ApiVendorPhoneDataModel]?
	let color : [ApiVendorColorDataModel]?
	let newColors : [ApiVendorNewColorsDataModel]?
	let emailNotification : [ApiVendorEmailNotificationDataModel]?
	let interpretationType : [ApiVendorInterpretationTypeDataModel]?
	let tMPhone : [String]?
	let tMVendorDetailInfo : [String]?

	enum CodingKeys: String, CodingKey {

		case vendorDetails = "VendorDetails"
		case address = "Address"
		case vendorLanguage = "VendorLanguage"
		case vendorDetail = "VendorDetail"
		case vendorBilling = "VendorBilling"
		case speciality = "Speciality"
		case phone = "Phone"
		case color = "Color"
		case newColors = "NewColors"
		case emailNotification = "EmailNotification"
		case interpretationType = "InterpretationType"
		case tMPhone = "TMPhone"
		case tMVendorDetailInfo = "TMVendorDetailInfo"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		vendorDetails = try values.decodeIfPresent(String.self, forKey: .vendorDetails)
		address = try values.decodeIfPresent([ApiVendorAddressDetailDataModel].self, forKey: .address)
		vendorLanguage = try values.decodeIfPresent([ApiVendorLanguageDataModel].self, forKey: .vendorLanguage)
		vendorDetail = try values.decodeIfPresent([ApiVendorDetailDataModel].self, forKey: .vendorDetail)
		vendorBilling = try values.decodeIfPresent([ApiVendorBillingDetailModel].self, forKey: .vendorBilling)
		speciality = try values.decodeIfPresent([ApiVendorSpecialityDataModel].self, forKey: .speciality)
		phone = try values.decodeIfPresent([ApiVendorPhoneDataModel].self, forKey: .phone)
		color = try values.decodeIfPresent([ApiVendorColorDataModel].self, forKey: .color)
		newColors = try values.decodeIfPresent([ApiVendorNewColorsDataModel].self, forKey: .newColors)
		emailNotification = try values.decodeIfPresent([ApiVendorEmailNotificationDataModel].self, forKey: .emailNotification)
		interpretationType = try values.decodeIfPresent([ApiVendorInterpretationTypeDataModel].self, forKey: .interpretationType)
		tMPhone = try values.decodeIfPresent([String].self, forKey: .tMPhone)
		tMVendorDetailInfo = try values.decodeIfPresent([String].self, forKey: .tMVendorDetailInfo)
	}

}
