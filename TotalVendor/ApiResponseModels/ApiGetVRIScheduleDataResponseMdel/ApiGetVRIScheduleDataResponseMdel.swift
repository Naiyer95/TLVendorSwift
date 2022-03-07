/* 
Copyright (c) 2021 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
struct ApiGetVRIScheduleDataResponseMdel : Codable {
	let sCHEDULVRIDETAILSBYID : [SCHEDULVRIDETAILSBYID]?

	enum CodingKeys: String, CodingKey {

		case sCHEDULVRIDETAILSBYID = "SCHEDULVRIDETAILSBYID"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		sCHEDULVRIDETAILSBYID = try values.decodeIfPresent([SCHEDULVRIDETAILSBYID].self, forKey: .sCHEDULVRIDETAILSBYID)
	}

}


struct SCHEDULVRIDETAILSBYID : Codable {
    let thirdPartyCompanyId : Int?
    let requestType : String?
    let inviteparticipant : String?
    let userType : String?
    let startDateTimeTemp : String?
    let endDateTimeTemp : String?
    let anticipatedDuration : String?
    let languageID : Int?
    let dateTime : String?
    let createdDate : String?
    let createdBy : String?
    let requestedBy : Int?
    let status : Int?
    let vendorId : Int?
    let vendorEmail : String?
    let decspt : Bool?
    let caseName : String?
    let caseInitial : String?
    let caseNo : String?
    let notes : String?
    let random : String?
    let sourceLanguageID : Int?
    let firstName : String?
    let lastName : String?
    let phNo : String?
    let confMail : String?
    let speciality : String?
    let reasonCall : String?
    let tranlatedFile : String?
    let tranlatedWordCount : String?
    let vendorList : String?
    let appointmentStatusType : String?
    let vendorName : String?
    let customerName : String?
    let tLanguageName : String?
    let sLanguageName : String?
    let id : Int?
    let accepted : String?
    let decliend : String?
    let userId : String?
    let appointmentStatusTypeTemp : String?
    let appointmentID : Int?
    let active : Int?
    let clientID : String?
    let badgeNo : String?
    let globalFilterData : String?

    enum CodingKeys: String, CodingKey {

        case thirdPartyCompanyId = "ThirdPartyCompanyId"
        case requestType = "RequestType"
        case inviteparticipant = "Inviteparticipant"
        case userType = "UserType"
        case startDateTimeTemp = "StartDateTimeTemp"
        case endDateTimeTemp = "EndDateTimeTemp"
        case anticipatedDuration = "AnticipatedDuration"
        case languageID = "LanguageID"
        case dateTime = "DateTime"
        case createdDate = "CreatedDate"
        case createdBy = "CreatedBy"
        case requestedBy = "RequestedBy"
        case status = "Status"
        case vendorId = "VendorId"
        case vendorEmail = "VendorEmail"
        case decspt = "decspt"
        case caseName = "CaseName"
        case caseInitial = "CaseInitial"
        case caseNo = "CaseNo"
        case notes = "Notes"
        case random = "Random"
        case sourceLanguageID = "SourceLanguageID"
        case firstName = "FirstName"
        case lastName = "LastName"
        case phNo = "PhNo"
        case confMail = "ConfMail"
        case speciality = "Speciality"
        case reasonCall = "ReasonCall"
        case tranlatedFile = "TranlatedFile"
        case tranlatedWordCount = "TranlatedWordCount"
        case vendorList = "VendorList"
        case appointmentStatusType = "AppointmentStatusType"
        case vendorName = "VendorName"
        case customerName = "CustomerName"
        case tLanguageName = "TLanguageName"
        case sLanguageName = "SLanguageName"
        case id = "Id"
        case accepted = "Accepted"
        case decliend = "Decliend"
        case userId = "UserId"
        case appointmentStatusTypeTemp = "AppointmentStatusTypeTemp"
        case appointmentID = "AppointmentID"
        case active = "active"
        case clientID = "ClientID"
        case badgeNo = "BadgeNo"
        case globalFilterData = "GlobalFilterData"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        thirdPartyCompanyId = try values.decodeIfPresent(Int.self, forKey: .thirdPartyCompanyId)
        requestType = try values.decodeIfPresent(String.self, forKey: .requestType)
        inviteparticipant = try values.decodeIfPresent(String.self, forKey: .inviteparticipant)
        userType = try values.decodeIfPresent(String.self, forKey: .userType)
        startDateTimeTemp = try values.decodeIfPresent(String.self, forKey: .startDateTimeTemp)
        endDateTimeTemp = try values.decodeIfPresent(String.self, forKey: .endDateTimeTemp)
        anticipatedDuration = try values.decodeIfPresent(String.self, forKey: .anticipatedDuration)
        languageID = try values.decodeIfPresent(Int.self, forKey: .languageID)
        dateTime = try values.decodeIfPresent(String.self, forKey: .dateTime)
        createdDate = try values.decodeIfPresent(String.self, forKey: .createdDate)
        createdBy = try values.decodeIfPresent(String.self, forKey: .createdBy)
        requestedBy = try values.decodeIfPresent(Int.self, forKey: .requestedBy)
        status = try values.decodeIfPresent(Int.self, forKey: .status)
        vendorId = try values.decodeIfPresent(Int.self, forKey: .vendorId)
        vendorEmail = try values.decodeIfPresent(String.self, forKey: .vendorEmail)
        decspt = try values.decodeIfPresent(Bool.self, forKey: .decspt)
        caseName = try values.decodeIfPresent(String.self, forKey: .caseName)
        caseInitial = try values.decodeIfPresent(String.self, forKey: .caseInitial)
        caseNo = try values.decodeIfPresent(String.self, forKey: .caseNo)
        notes = try values.decodeIfPresent(String.self, forKey: .notes)
        random = try values.decodeIfPresent(String.self, forKey: .random)
        sourceLanguageID = try values.decodeIfPresent(Int.self, forKey: .sourceLanguageID)
        firstName = try values.decodeIfPresent(String.self, forKey: .firstName)
        lastName = try values.decodeIfPresent(String.self, forKey: .lastName)
        phNo = try values.decodeIfPresent(String.self, forKey: .phNo)
        confMail = try values.decodeIfPresent(String.self, forKey: .confMail)
        speciality = try values.decodeIfPresent(String.self, forKey: .speciality)
        reasonCall = try values.decodeIfPresent(String.self, forKey: .reasonCall)
        tranlatedFile = try values.decodeIfPresent(String.self, forKey: .tranlatedFile)
        tranlatedWordCount = try values.decodeIfPresent(String.self, forKey: .tranlatedWordCount)
        vendorList = try values.decodeIfPresent(String.self, forKey: .vendorList)
        appointmentStatusType = try values.decodeIfPresent(String.self, forKey: .appointmentStatusType)
        vendorName = try values.decodeIfPresent(String.self, forKey: .vendorName)
        customerName = try values.decodeIfPresent(String.self, forKey: .customerName)
        tLanguageName = try values.decodeIfPresent(String.self, forKey: .tLanguageName)
        sLanguageName = try values.decodeIfPresent(String.self, forKey: .sLanguageName)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        accepted = try values.decodeIfPresent(String.self, forKey: .accepted)
        decliend = try values.decodeIfPresent(String.self, forKey: .decliend)
        userId = try values.decodeIfPresent(String.self, forKey: .userId)
        appointmentStatusTypeTemp = try values.decodeIfPresent(String.self, forKey: .appointmentStatusTypeTemp)
        appointmentID = try values.decodeIfPresent(Int.self, forKey: .appointmentID)
        active = try values.decodeIfPresent(Int.self, forKey: .active)
        clientID = try values.decodeIfPresent(String.self, forKey: .clientID)
        badgeNo = try values.decodeIfPresent(String.self, forKey: .badgeNo)
        globalFilterData = try values.decodeIfPresent(String.self, forKey: .globalFilterData)
    }

}

