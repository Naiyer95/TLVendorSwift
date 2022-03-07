/* 
Copyright (c) 2022 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
struct ApiAdditionalReimbursementResponseModel : Codable {
	let aDDITIONREMBERSMENT : [ADDITIONREMBERSMENT]?

	enum CodingKeys: String, CodingKey {

		case aDDITIONREMBERSMENT = "ADDITIONREMBERSMENT"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		aDDITIONREMBERSMENT = try values.decodeIfPresent([ADDITIONREMBERSMENT].self, forKey: .aDDITIONREMBERSMENT)
	}

}

struct ADDITIONREMBERSMENT : Codable {
    let additionRembersment : String?
    let additionRembersmentLable : String?
    let rembersmentFile : String?
    let appointmentID : Int?
    let tAdditionalresStatus : Int?
    let rembersmentId : Int?

    enum CodingKeys: String, CodingKey {

        case additionRembersment = "AdditionRembersment"
        case additionRembersmentLable = "AdditionRembersmentLable"
        case rembersmentFile = "RembersmentFile"
        case appointmentID = "AppointmentID"
        case tAdditionalresStatus = "TAdditionalresStatus"
        case rembersmentId = "RembersmentId"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        additionRembersment = try values.decodeIfPresent(String.self, forKey: .additionRembersment)
        additionRembersmentLable = try values.decodeIfPresent(String.self, forKey: .additionRembersmentLable)
        rembersmentFile = try values.decodeIfPresent(String.self, forKey: .rembersmentFile)
        appointmentID = try values.decodeIfPresent(Int.self, forKey: .appointmentID)
        tAdditionalresStatus = try values.decodeIfPresent(Int.self, forKey: .tAdditionalresStatus)
        rembersmentId = try values.decodeIfPresent(Int.self, forKey: .rembersmentId)
    }

}
