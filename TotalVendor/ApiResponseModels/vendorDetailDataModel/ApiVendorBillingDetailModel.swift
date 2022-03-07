/* 
Copyright (c) 2021 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
struct ApiVendorBillingDetailModel : Codable {
	let vendorBillingID : Int?
	let recordID : String?
	let vendorID : Int?
	let oSPerHourFee : String?
	let oSTravelDistance : String?
	let oSIsMileage : Bool?
	let oSMinMillage : String?
	let oSMaxMillage : String?
	let oSMillageRate : String?
	let oSIsTravel : Bool?
	let oSMinTravel : String?
	let oSMaxTravel : String?
	let oSTravellRate : String?
	let oSIsLateCancel : Bool?
	let oSCancellationFee : Float?
	let tRANPerWordFee : Float?
	let tRANNotarizedFee : Float?
	let tRANPerPageFee : Float?
	let tRANSpecializedTerminologyFeePerWord : Float?
	let tRANSpecializedTerminologyFeePerDocument : Float?
	let tRANPriorityFeePerWord : Float?
	let tRANPriorityFeePerDocument : Float?
	let oSPriorityFee : Float?
	let tRANTargetLanguagesRate : Float?
	let oneHourAppointmentFee : Float?
	let active : Bool?
	let telephonicPerMinStandard : String?
	let telephonicPerMinLegal : String?
	let telephonicPriorityFee : Float?
	let telephonicCancelFee : Float?
	let telephonicLateCancel : Bool?
	let vriPerMinStandard : Float?
	let vriSchedulePermintStander : Int?
	let opiPerMinStandard : Float?
	let opiSchedulePermintStander : Float?
	let vRIOrOPIId : String?
	let languageId : String?
	let oSPerHourAfterFee : Float?
	let telephonicPerMinAfterStandard : String?
	let afterHourFee : Float?
	let virtualMPerMinStandard : Float?
	let virtualMPerMinLegal : Float?
	let virtualMPriorityFee : Float?
	let virtualMCancelFee : Float?
	let virtualMLateCancel : Bool?
	let vRIminimumDuration : Float?
	let oPIminimumDuration : Float?
	let isCBA : Bool?
	let isNonCBA : String?
	let cBARate : String?
	let cBAExpireDate : String?

	enum CodingKeys: String, CodingKey {

		case vendorBillingID = "VendorBillingID"
		case recordID = "RecordID"
		case vendorID = "VendorID"
		case oSPerHourFee = "OSPerHourFee"
		case oSTravelDistance = "OSTravelDistance"
		case oSIsMileage = "OSIsMileage"
		case oSMinMillage = "OSMinMillage"
		case oSMaxMillage = "OSMaxMillage"
		case oSMillageRate = "OSMillageRate"
		case oSIsTravel = "OSIsTravel"
		case oSMinTravel = "OSMinTravel"
		case oSMaxTravel = "OSMaxTravel"
		case oSTravellRate = "OSTravellRate"
		case oSIsLateCancel = "OSIsLateCancel"
		case oSCancellationFee = "OSCancellationFee"
		case tRANPerWordFee = "TRANPerWordFee"
		case tRANNotarizedFee = "TRANNotarizedFee"
		case tRANPerPageFee = "TRANPerPageFee"
		case tRANSpecializedTerminologyFeePerWord = "TRANSpecializedTerminologyFeePerWord"
		case tRANSpecializedTerminologyFeePerDocument = "TRANSpecializedTerminologyFeePerDocument"
		case tRANPriorityFeePerWord = "TRANPriorityFeePerWord"
		case tRANPriorityFeePerDocument = "TRANPriorityFeePerDocument"
		case oSPriorityFee = "OSPriorityFee"
		case tRANTargetLanguagesRate = "TRANTargetLanguagesRate"
		case oneHourAppointmentFee = "OneHourAppointmentFee"
		case active = "Active"
		case telephonicPerMinStandard = "TelephonicPerMinStandard"
		case telephonicPerMinLegal = "TelephonicPerMinLegal"
		case telephonicPriorityFee = "TelephonicPriorityFee"
		case telephonicCancelFee = "TelephonicCancelFee"
		case telephonicLateCancel = "TelephonicLateCancel"
		case vriPerMinStandard = "VriPerMinStandard"
		case vriSchedulePermintStander = "VriSchedulePermintStander"
		case opiPerMinStandard = "OpiPerMinStandard"
		case opiSchedulePermintStander = "OpiSchedulePermintStander"
		case vRIOrOPIId = "VRIOrOPIId"
		case languageId = "LanguageId"
		case oSPerHourAfterFee = "OSPerHourAfterFee"
		case telephonicPerMinAfterStandard = "TelephonicPerMinAfterStandard"
		case afterHourFee = "AfterHourFee"
		case virtualMPerMinStandard = "VirtualMPerMinStandard"
		case virtualMPerMinLegal = "VirtualMPerMinLegal"
		case virtualMPriorityFee = "VirtualMPriorityFee"
		case virtualMCancelFee = "VirtualMCancelFee"
		case virtualMLateCancel = "VirtualMLateCancel"
		case vRIminimumDuration = "VRIminimumDuration"
		case oPIminimumDuration = "OPIminimumDuration"
		case isCBA = "IsCBA"
		case isNonCBA = "IsNonCBA"
		case cBARate = "CBARate"
		case cBAExpireDate = "CBAExpireDate"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		vendorBillingID = try values.decodeIfPresent(Int.self, forKey: .vendorBillingID)
		recordID = try values.decodeIfPresent(String.self, forKey: .recordID)
		vendorID = try values.decodeIfPresent(Int.self, forKey: .vendorID)
		oSPerHourFee = try values.decodeIfPresent(String.self, forKey: .oSPerHourFee)
		oSTravelDistance = try values.decodeIfPresent(String.self, forKey: .oSTravelDistance)
		oSIsMileage = try values.decodeIfPresent(Bool.self, forKey: .oSIsMileage)
		oSMinMillage = try values.decodeIfPresent(String.self, forKey: .oSMinMillage)
		oSMaxMillage = try values.decodeIfPresent(String.self, forKey: .oSMaxMillage)
		oSMillageRate = try values.decodeIfPresent(String.self, forKey: .oSMillageRate)
		oSIsTravel = try values.decodeIfPresent(Bool.self, forKey: .oSIsTravel)
		oSMinTravel = try values.decodeIfPresent(String.self, forKey: .oSMinTravel)
		oSMaxTravel = try values.decodeIfPresent(String.self, forKey: .oSMaxTravel)
		oSTravellRate = try values.decodeIfPresent(String.self, forKey: .oSTravellRate)
		oSIsLateCancel = try values.decodeIfPresent(Bool.self, forKey: .oSIsLateCancel)
		oSCancellationFee = try values.decodeIfPresent(Float.self, forKey: .oSCancellationFee)
		tRANPerWordFee = try values.decodeIfPresent(Float.self, forKey: .tRANPerWordFee)
		tRANNotarizedFee = try values.decodeIfPresent(Float.self, forKey: .tRANNotarizedFee)
		tRANPerPageFee = try values.decodeIfPresent(Float.self, forKey: .tRANPerPageFee)
		tRANSpecializedTerminologyFeePerWord = try values.decodeIfPresent(Float.self, forKey: .tRANSpecializedTerminologyFeePerWord)
		tRANSpecializedTerminologyFeePerDocument = try values.decodeIfPresent(Float.self, forKey: .tRANSpecializedTerminologyFeePerDocument)
		tRANPriorityFeePerWord = try values.decodeIfPresent(Float.self, forKey: .tRANPriorityFeePerWord)
		tRANPriorityFeePerDocument = try values.decodeIfPresent(Float.self, forKey: .tRANPriorityFeePerDocument)
		oSPriorityFee = try values.decodeIfPresent(Float.self, forKey: .oSPriorityFee)
		tRANTargetLanguagesRate = try values.decodeIfPresent(Float.self, forKey: .tRANTargetLanguagesRate)
		oneHourAppointmentFee = try values.decodeIfPresent(Float.self, forKey: .oneHourAppointmentFee)
		active = try values.decodeIfPresent(Bool.self, forKey: .active)
		telephonicPerMinStandard = try values.decodeIfPresent(String.self, forKey: .telephonicPerMinStandard)
		telephonicPerMinLegal = try values.decodeIfPresent(String.self, forKey: .telephonicPerMinLegal)
		telephonicPriorityFee = try values.decodeIfPresent(Float.self, forKey: .telephonicPriorityFee)
		telephonicCancelFee = try values.decodeIfPresent(Float.self, forKey: .telephonicCancelFee)
		telephonicLateCancel = try values.decodeIfPresent(Bool.self, forKey: .telephonicLateCancel)
		vriPerMinStandard = try values.decodeIfPresent(Float.self, forKey: .vriPerMinStandard)
		vriSchedulePermintStander = try values.decodeIfPresent(Int.self, forKey: .vriSchedulePermintStander)
		opiPerMinStandard = try values.decodeIfPresent(Float.self, forKey: .opiPerMinStandard)
		opiSchedulePermintStander = try values.decodeIfPresent(Float.self, forKey: .opiSchedulePermintStander)
		vRIOrOPIId = try values.decodeIfPresent(String.self, forKey: .vRIOrOPIId)
		languageId = try values.decodeIfPresent(String.self, forKey: .languageId)
		oSPerHourAfterFee = try values.decodeIfPresent(Float.self, forKey: .oSPerHourAfterFee)
		telephonicPerMinAfterStandard = try values.decodeIfPresent(String.self, forKey: .telephonicPerMinAfterStandard)
		afterHourFee = try values.decodeIfPresent(Float.self, forKey: .afterHourFee)
		virtualMPerMinStandard = try values.decodeIfPresent(Float.self, forKey: .virtualMPerMinStandard)
		virtualMPerMinLegal = try values.decodeIfPresent(Float.self, forKey: .virtualMPerMinLegal)
		virtualMPriorityFee = try values.decodeIfPresent(Float.self, forKey: .virtualMPriorityFee)
		virtualMCancelFee = try values.decodeIfPresent(Float.self, forKey: .virtualMCancelFee)
		virtualMLateCancel = try values.decodeIfPresent(Bool.self, forKey: .virtualMLateCancel)
		vRIminimumDuration = try values.decodeIfPresent(Float.self, forKey: .vRIminimumDuration)
		oPIminimumDuration = try values.decodeIfPresent(Float.self, forKey: .oPIminimumDuration)
		isCBA = try values.decodeIfPresent(Bool.self, forKey: .isCBA)
		isNonCBA = try values.decodeIfPresent(String.self, forKey: .isNonCBA)
		cBARate = try values.decodeIfPresent(String.self, forKey: .cBARate)
		cBAExpireDate = try values.decodeIfPresent(String.self, forKey: .cBAExpireDate)
	}

}
