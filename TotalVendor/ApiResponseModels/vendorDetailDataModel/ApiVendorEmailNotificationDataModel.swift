/* 
Copyright (c) 2021 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
struct ApiVendorEmailNotificationDataModel : Codable {
	let emailNotificationID : Int?
	let recordID : String?
	let vendorID : Int?
	let cancelledEmailNotification : Bool?
	let schedulAppointmentEmail : Bool?
	let textMessage : Bool?
	let cancelTextMessage : Bool?
	let scheduleTextMessage : Bool?
	let textMessageForHour : Bool?
	let emailForEdit : Bool?
	let emailForInboxFolder : Bool?
	let textMessageForProivder : String?
	let textMessageForInboxFolder : Bool?
	let active : Bool?
	let diffFlag : String?
	let vendorEmailNotificationTable : String?

	enum CodingKeys: String, CodingKey {

		case emailNotificationID = "EmailNotificationID"
		case recordID = "RecordID"
		case vendorID = "VendorID"
		case cancelledEmailNotification = "CancelledEmailNotification"
		case schedulAppointmentEmail = "SchedulAppointmentEmail"
		case textMessage = "TextMessage"
		case cancelTextMessage = "CancelTextMessage"
		case scheduleTextMessage = "ScheduleTextMessage"
		case textMessageForHour = "TextMessageForHour"
		case emailForEdit = "EmailForEdit"
		case emailForInboxFolder = "EmailForInboxFolder"
		case textMessageForProivder = "TextMessageForProivder"
		case textMessageForInboxFolder = "TextMessageForInboxFolder"
		case active = "Active"
		case diffFlag = "DiffFlag"
		case vendorEmailNotificationTable = "VendorEmailNotificationTable"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		emailNotificationID = try values.decodeIfPresent(Int.self, forKey: .emailNotificationID)
		recordID = try values.decodeIfPresent(String.self, forKey: .recordID)
		vendorID = try values.decodeIfPresent(Int.self, forKey: .vendorID)
		cancelledEmailNotification = try values.decodeIfPresent(Bool.self, forKey: .cancelledEmailNotification)
		schedulAppointmentEmail = try values.decodeIfPresent(Bool.self, forKey: .schedulAppointmentEmail)
		textMessage = try values.decodeIfPresent(Bool.self, forKey: .textMessage)
		cancelTextMessage = try values.decodeIfPresent(Bool.self, forKey: .cancelTextMessage)
		scheduleTextMessage = try values.decodeIfPresent(Bool.self, forKey: .scheduleTextMessage)
		textMessageForHour = try values.decodeIfPresent(Bool.self, forKey: .textMessageForHour)
		emailForEdit = try values.decodeIfPresent(Bool.self, forKey: .emailForEdit)
		emailForInboxFolder = try values.decodeIfPresent(Bool.self, forKey: .emailForInboxFolder)
		textMessageForProivder = try values.decodeIfPresent(String.self, forKey: .textMessageForProivder)
		textMessageForInboxFolder = try values.decodeIfPresent(Bool.self, forKey: .textMessageForInboxFolder)
		active = try values.decodeIfPresent(Bool.self, forKey: .active)
		diffFlag = try values.decodeIfPresent(String.self, forKey: .diffFlag)
		vendorEmailNotificationTable = try values.decodeIfPresent(String.self, forKey: .vendorEmailNotificationTable)
	}

}
