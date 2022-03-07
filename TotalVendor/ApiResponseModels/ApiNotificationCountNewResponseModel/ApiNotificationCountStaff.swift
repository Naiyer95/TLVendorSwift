/* 
Copyright (c) 2022 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
struct ApiNotificationCountStaff : Codable {
	let nID : String?
	let userId : String?
	let redornot : String?
	let approvelStatus : String?
	let active : String?
	let notification : String?
	let message : String?
	let notificationType : String?
	let notificationCounts : Int?
	let flga : String?
	let notimessage : String?
	let flag : String?
	let uniqueID : String?
	let createDate : String?
	let createUser : String?
	let appointmentID : String?
	let fromEmail : String?
	let vendorEmail : String?
	let phoneNumber : String?
	let senderID : String?
	let interpreterBookedName : String?
	let userType : String?
	let appStatus : String?
	let appStatusID : String?
	let subStatus : String?
	let updateDate : String?
	let userGroupID : String?
	let userFullName : String?
	let dense_rank : String?
	let profileImage : String?
	let vendorId : String?

	enum CodingKeys: String, CodingKey {

		case nID = "nID"
		case userId = "userId"
		case redornot = "redornot"
		case approvelStatus = "ApprovelStatus"
		case active = "Active"
		case notification = "notification"
		case message = "message"
		case notificationType = "notificationType"
		case notificationCounts = "NotificationCounts"
		case flga = "flga"
		case notimessage = "notimessage"
		case flag = "flag"
		case uniqueID = "UniqueID"
		case createDate = "CreateDate"
		case createUser = "CreateUser"
		case appointmentID = "AppointmentID"
		case fromEmail = "FromEmail"
		case vendorEmail = "VendorEmail"
		case phoneNumber = "PhoneNumber"
		case senderID = "SenderID"
		case interpreterBookedName = "InterpreterBookedName"
		case userType = "UserType"
		case appStatus = "AppStatus"
		case appStatusID = "AppStatusID"
		case subStatus = "SubStatus"
		case updateDate = "UpdateDate"
		case userGroupID = "UserGroupID"
		case userFullName = "UserFullName"
		case dense_rank = "dense_rank"
		case profileImage = "ProfileImage"
		case vendorId = "VendorId"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		nID = try values.decodeIfPresent(String.self, forKey: .nID)
		userId = try values.decodeIfPresent(String.self, forKey: .userId)
		redornot = try values.decodeIfPresent(String.self, forKey: .redornot)
		approvelStatus = try values.decodeIfPresent(String.self, forKey: .approvelStatus)
		active = try values.decodeIfPresent(String.self, forKey: .active)
		notification = try values.decodeIfPresent(String.self, forKey: .notification)
		message = try values.decodeIfPresent(String.self, forKey: .message)
		notificationType = try values.decodeIfPresent(String.self, forKey: .notificationType)
		notificationCounts = try values.decodeIfPresent(Int.self, forKey: .notificationCounts)
		flga = try values.decodeIfPresent(String.self, forKey: .flga)
		notimessage = try values.decodeIfPresent(String.self, forKey: .notimessage)
		flag = try values.decodeIfPresent(String.self, forKey: .flag)
		uniqueID = try values.decodeIfPresent(String.self, forKey: .uniqueID)
		createDate = try values.decodeIfPresent(String.self, forKey: .createDate)
		createUser = try values.decodeIfPresent(String.self, forKey: .createUser)
		appointmentID = try values.decodeIfPresent(String.self, forKey: .appointmentID)
		fromEmail = try values.decodeIfPresent(String.self, forKey: .fromEmail)
		vendorEmail = try values.decodeIfPresent(String.self, forKey: .vendorEmail)
		phoneNumber = try values.decodeIfPresent(String.self, forKey: .phoneNumber)
		senderID = try values.decodeIfPresent(String.self, forKey: .senderID)
		interpreterBookedName = try values.decodeIfPresent(String.self, forKey: .interpreterBookedName)
		userType = try values.decodeIfPresent(String.self, forKey: .userType)
		appStatus = try values.decodeIfPresent(String.self, forKey: .appStatus)
		appStatusID = try values.decodeIfPresent(String.self, forKey: .appStatusID)
		subStatus = try values.decodeIfPresent(String.self, forKey: .subStatus)
		updateDate = try values.decodeIfPresent(String.self, forKey: .updateDate)
		userGroupID = try values.decodeIfPresent(String.self, forKey: .userGroupID)
		userFullName = try values.decodeIfPresent(String.self, forKey: .userFullName)
		dense_rank = try values.decodeIfPresent(String.self, forKey: .dense_rank)
		profileImage = try values.decodeIfPresent(String.self, forKey: .profileImage)
		vendorId = try values.decodeIfPresent(String.self, forKey: .vendorId)
	}

}
