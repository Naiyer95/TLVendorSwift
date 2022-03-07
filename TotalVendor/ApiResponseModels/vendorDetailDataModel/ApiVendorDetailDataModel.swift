/* 
Copyright (c) 2021 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
struct ApiVendorDetailDataModel : Codable {
	let qBID : String?
	let qBEditID : String?
	let auditFlg : Int?
	let vendorID : Int?
	let recordID : String?
	let assignStatus : String?
	let userID : Int?
	let imageData : String?
	let vendorImg : String?
	let companyID : Int?
	let vendorColorCode : String?
	let labelText : String?
	let userName : String?
	let userIdentity : String?
	let password : String?
	let aprFlag : String?
	let vendorFullName : String?
	let acceptAndDeclineStatus : String?
	let contactFirstName : String?
	let appointmentID : String?
	let contactLastName : String?
	let reqFlow : String?
	let emailAddress : String?
	let specialtyID : String?
	let decspt : Bool?
	let sSN : String?
	let gender : String?
	let isActive : Bool?
	let subCompanyName : String?
	let newSubCompanyName : String?
	let notes : String?
	let nikeNameOrNotes : String?
	let groupID : Int?
	let isTransalationServices : Bool?
	let willProvideAllOndemandvri : Bool?
	let willProvideScheduledvri : Bool?
	let willProvideAllOndemandopi : Bool?
	let willProvideScheduledopi : Bool?
	let isTelephoneServices : Bool?
	let isOnsiteInterpretation : Bool?
	let isLocakOutAllAppointments : Bool?
	let willProvideProofReading : Bool?
	let willProvideEmailCFM : Bool?
	let willProvideEMessageCFM : Bool?
	let willProvideCallCFM : Bool?
	let interpreterRanking : String?
	let transalationRanking : String?
	let isContarctor1099 : Bool?
	let color : String?
	let vendorRatingCode : String?
	let address : String?
	let billing : String?
	let vriRate : String?
	let settings : String?
	let phones : String?
	let phone : String?
	let allLanguages : String?
	let languages : String?
	let specialities : String?
	let interpretationType : Int?
	let fromDate : String?
	let toDate : String?
	let active : String?
	let status : String?
	let vendorName : String?
	let email : String?
	let primaryContact : String?
	let company : String?
	let mainPhone : String?
	let workPhone : String?
	let homePhone : String?
	let mobile : String?
	let fax : String?
	let costPerHour : String?
	let travelDistance : String?
	let streetAddress : String?
	let cellPhone : String?
	let aptNumber : String?
	let city : String?
	let stateID : String?
	let stateName : String?
	let zipCode : String?
	let isEmployee : Bool?
	let isPerdim : Bool?
	let is3rdParty : Bool?
	let label1Text : String?
	let label2Text : String?
	let label3Text : String?
	let label4Text : String?
	let label5Text : String?
	let label6Text : String?
	let newColorCode : String?
	let newColors : String?
	let newLabels : String?
	let startDate : String?
	let vendorUniqueID : String?
	let screeningForm : String?
	let hepB : String?
	let varicella : String?
	let measlesOrRubeola : String?
	let mumps : String?
	let rubella : String?
	let tdap : String?
	let mostRecentTBTest : String?
	let mostRecentFluShot : String?
	let confidentiality : String?
	let hIPAA : String?
	let contractor : String?
	let payrollPolicy : String?
	let cORISignedDate : String?
	let cORIRUNDate : String?
	let history : String?
	let expirationDate : String?
	let resume : String?
	let certificates : String?
	let hallmarkTraining : String?
	let maldenHousing : String?
	let sourceLanguage : String?
	let targetLanguage : String?
	let updateBy : String?
	let companyName : String?
	let customerVenueAdress : String?
	let vendorMiles : String?
	let emailNotification : String?
	let badgeNumber : String?
	let dateofBirth : String?
	let countryCode : Int?
	let bookedAppointments : String?
	let notificationType : String?
	let middleName : String?
	let nickName : String?
	let employmentID : Int?
	let isActiveStartDate : String?
	let isActiveEndDate : String?
	let interpreterActiveStartDate : String?
	let interpreterActiveEndDate : String?
	let website : String?
	let vendorCCEmail : String?
	let otherEmail : String?
	let sirName : String?
	let accountNumber : String?
	let creditLimit : String?
	let paymenTerms : String?
	let billingrateLevel : String?
	let nameOnCheck : String?
	let addInfoLanguage : String?
	let addInfoLoction : String?
	let addInfoPerHourCost : String?
	let authCode : String?
	let oSIsMileage : String?
	let birthCountry : String?
	let diffFlag : String?
	let tMPhone : String?
	let vendorDetailUpdateInfo : String?
	let parentTableName : String?
	let tableName : String?
	let columnName : String?
	let columnValue : String?
	let columnList : String?
	let flag : String?
	let reason : String?
	let createdUser : String?
	let createdBy : String?
	let htmlTagId : String?
	let oldValue : String?
	let recMessageNotification : String?
	let recNumber : String?
	let overViewNotes : String?
	let infoId : String?
	let deviceType : String?
	let vendorUpdateInfoList : String?
	let isVirtualMServices : Bool?
	let operationType : String?
	let tabFlag : String?
	let vendorCancelledBy : String?
	let vendorCancelledDate : String?
	let securityClearance : Int?
	let experience : String?

	enum CodingKeys: String, CodingKey {

		case qBID = "QBID"
		case qBEditID = "QBEditID"
		case auditFlg = "AuditFlg"
		case vendorID = "VendorID"
		case recordID = "RecordID"
		case assignStatus = "AssignStatus"
		case userID = "UserID"
		case imageData = "ImageData"
		case vendorImg = "vendorImg"
		case companyID = "CompanyID"
		case vendorColorCode = "VendorColorCode"
		case labelText = "LabelText"
		case userName = "UserName"
		case userIdentity = "UserIdentity"
		case password = "Password"
		case aprFlag = "aprFlag"
		case vendorFullName = "VendorFullName"
		case acceptAndDeclineStatus = "AcceptAndDeclineStatus"
		case contactFirstName = "ContactFirstName"
		case appointmentID = "AppointmentID"
		case contactLastName = "ContactLastName"
		case reqFlow = "ReqFlow"
		case emailAddress = "EmailAddress"
		case specialtyID = "SpecialtyID"
		case decspt = "decspt"
		case sSN = "SSN"
		case gender = "Gender"
		case isActive = "IsActive"
		case subCompanyName = "SubCompanyName"
		case newSubCompanyName = "NewSubCompanyName"
		case notes = "Notes"
		case nikeNameOrNotes = "NikeNameOrNotes"
		case groupID = "GroupID"
		case isTransalationServices = "IsTransalationServices"
		case willProvideAllOndemandvri = "WillProvideAllOndemandvri"
		case willProvideScheduledvri = "WillProvideScheduledvri"
		case willProvideAllOndemandopi = "WillProvideAllOndemandopi"
		case willProvideScheduledopi = "WillProvideScheduledopi"
		case isTelephoneServices = "IsTelephoneServices"
		case isOnsiteInterpretation = "IsOnsiteInterpretation"
		case isLocakOutAllAppointments = "IsLocakOutAllAppointments"
		case willProvideProofReading = "WillProvideProofReading"
		case willProvideEmailCFM = "willProvideEmailCFM"
		case willProvideEMessageCFM = "willProvideEMessageCFM"
		case willProvideCallCFM = "willProvideCallCFM"
		case interpreterRanking = "InterpreterRanking"
		case transalationRanking = "TransalationRanking"
		case isContarctor1099 = "isContarctor1099"
		case color = "Color"
		case vendorRatingCode = "VendorRatingCode"
		case address = "Address"
		case billing = "Billing"
		case vriRate = "VriRate"
		case settings = "Settings"
		case phones = "Phones"
		case phone = "Phone"
		case allLanguages = "AllLanguages"
		case languages = "Languages"
		case specialities = "Specialities"
		case interpretationType = "InterpretationType"
		case fromDate = "FromDate"
		case toDate = "ToDate"
		case active = "Active"
		case status = "Status"
		case vendorName = "VendorName"
		case email = "Email"
		case primaryContact = "PrimaryContact"
		case company = "Company"
		case mainPhone = "MainPhone"
		case workPhone = "WorkPhone"
		case homePhone = "HomePhone"
		case mobile = "Mobile"
		case fax = "Fax"
		case costPerHour = "CostPerHour"
		case travelDistance = "TravelDistance"
		case streetAddress = "StreetAddress"
		case cellPhone = "CellPhone"
		case aptNumber = "AptNumber"
		case city = "City"
		case stateID = "StateID"
		case stateName = "StateName"
		case zipCode = "ZipCode"
		case isEmployee = "IsEmployee"
		case isPerdim = "IsPerdim"
		case is3rdParty = "Is3rdParty"
		case label1Text = "Label1Text"
		case label2Text = "Label2Text"
		case label3Text = "Label3Text"
		case label4Text = "Label4Text"
		case label5Text = "Label5Text"
		case label6Text = "Label6Text"
		case newColorCode = "NewColorCode"
		case newColors = "NewColors"
		case newLabels = "NewLabels"
		case startDate = "StartDate"
		case vendorUniqueID = "VendorUniqueID"
		case screeningForm = "ScreeningForm"
		case hepB = "HepB"
		case varicella = "Varicella"
		case measlesOrRubeola = "MeaslesOrRubeola"
		case mumps = "Mumps"
		case rubella = "Rubella"
		case tdap = "Tdap"
		case mostRecentTBTest = "MostRecentTBTest"
		case mostRecentFluShot = "MostRecentFluShot"
		case confidentiality = "Confidentiality"
		case hIPAA = "HIPAA"
		case contractor = "Contractor"
		case payrollPolicy = "PayrollPolicy"
		case cORISignedDate = "CORISignedDate"
		case cORIRUNDate = "CORIRUNDate"
		case history = "History"
		case expirationDate = "ExpirationDate"
		case resume = "Resume"
		case certificates = "Certificates"
		case hallmarkTraining = "HallmarkTraining"
		case maldenHousing = "MaldenHousing"
		case sourceLanguage = "SourceLanguage"
		case targetLanguage = "TargetLanguage"
		case updateBy = "updateBy"
		case companyName = "CompanyName"
		case customerVenueAdress = "CustomerVenueAdress"
		case vendorMiles = "vendorMiles"
		case emailNotification = "EmailNotification"
		case badgeNumber = "BadgeNumber"
		case dateofBirth = "DateofBirth"
		case countryCode = "CountryCode"
		case bookedAppointments = "BookedAppointments"
		case notificationType = "NotificationType"
		case middleName = "MiddleName"
		case nickName = "NickName"
		case employmentID = "EmploymentID"
		case isActiveStartDate = "IsActiveStartDate"
		case isActiveEndDate = "IsActiveEndDate"
		case interpreterActiveStartDate = "InterpreterActiveStartDate"
		case interpreterActiveEndDate = "InterpreterActiveEndDate"
		case website = "Website"
		case vendorCCEmail = "VendorCCEmail"
		case otherEmail = "OtherEmail"
		case sirName = "SirName"
		case accountNumber = "AccountNumber"
		case creditLimit = "CreditLimit"
		case paymenTerms = "PaymenTerms"
		case billingrateLevel = "BillingrateLevel"
		case nameOnCheck = "NameOnCheck"
		case addInfoLanguage = "AddInfoLanguage"
		case addInfoLoction = "AddInfoLoction"
		case addInfoPerHourCost = "AddInfoPerHourCost"
		case authCode = "AuthCode"
		case oSIsMileage = "OSIsMileage"
		case birthCountry = "BirthCountry"
		case diffFlag = "DiffFlag"
		case tMPhone = "TMPhone"
		case vendorDetailUpdateInfo = "VendorDetailUpdateInfo"
		case parentTableName = "ParentTableName"
		case tableName = "TableName"
		case columnName = "ColumnName"
		case columnValue = "ColumnValue"
		case columnList = "ColumnList"
		case flag = "Flag"
		case reason = "Reason"
		case createdUser = "CreatedUser"
		case createdBy = "CreatedBy"
		case htmlTagId = "HtmlTagId"
		case oldValue = "OldValue"
		case recMessageNotification = "RecMessageNotification"
		case recNumber = "RecNumber"
		case overViewNotes = "OverViewNotes"
		case infoId = "InfoId"
		case deviceType = "DeviceType"
		case vendorUpdateInfoList = "VendorUpdateInfoList"
		case isVirtualMServices = "IsVirtualMServices"
		case operationType = "OperationType"
		case tabFlag = "TabFlag"
		case vendorCancelledBy = "VendorCancelledBy"
		case vendorCancelledDate = "VendorCancelledDate"
		case securityClearance = "SecurityClearance"
		case experience = "Experience"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		qBID = try values.decodeIfPresent(String.self, forKey: .qBID)
		qBEditID = try values.decodeIfPresent(String.self, forKey: .qBEditID)
		auditFlg = try values.decodeIfPresent(Int.self, forKey: .auditFlg)
		vendorID = try values.decodeIfPresent(Int.self, forKey: .vendorID)
		recordID = try values.decodeIfPresent(String.self, forKey: .recordID)
		assignStatus = try values.decodeIfPresent(String.self, forKey: .assignStatus)
		userID = try values.decodeIfPresent(Int.self, forKey: .userID)
		imageData = try values.decodeIfPresent(String.self, forKey: .imageData)
		vendorImg = try values.decodeIfPresent(String.self, forKey: .vendorImg)
		companyID = try values.decodeIfPresent(Int.self, forKey: .companyID)
		vendorColorCode = try values.decodeIfPresent(String.self, forKey: .vendorColorCode)
		labelText = try values.decodeIfPresent(String.self, forKey: .labelText)
		userName = try values.decodeIfPresent(String.self, forKey: .userName)
		userIdentity = try values.decodeIfPresent(String.self, forKey: .userIdentity)
		password = try values.decodeIfPresent(String.self, forKey: .password)
		aprFlag = try values.decodeIfPresent(String.self, forKey: .aprFlag)
		vendorFullName = try values.decodeIfPresent(String.self, forKey: .vendorFullName)
		acceptAndDeclineStatus = try values.decodeIfPresent(String.self, forKey: .acceptAndDeclineStatus)
		contactFirstName = try values.decodeIfPresent(String.self, forKey: .contactFirstName)
		appointmentID = try values.decodeIfPresent(String.self, forKey: .appointmentID)
		contactLastName = try values.decodeIfPresent(String.self, forKey: .contactLastName)
		reqFlow = try values.decodeIfPresent(String.self, forKey: .reqFlow)
		emailAddress = try values.decodeIfPresent(String.self, forKey: .emailAddress)
		specialtyID = try values.decodeIfPresent(String.self, forKey: .specialtyID)
		decspt = try values.decodeIfPresent(Bool.self, forKey: .decspt)
		sSN = try values.decodeIfPresent(String.self, forKey: .sSN)
		gender = try values.decodeIfPresent(String.self, forKey: .gender)
		isActive = try values.decodeIfPresent(Bool.self, forKey: .isActive)
		subCompanyName = try values.decodeIfPresent(String.self, forKey: .subCompanyName)
		newSubCompanyName = try values.decodeIfPresent(String.self, forKey: .newSubCompanyName)
		notes = try values.decodeIfPresent(String.self, forKey: .notes)
		nikeNameOrNotes = try values.decodeIfPresent(String.self, forKey: .nikeNameOrNotes)
		groupID = try values.decodeIfPresent(Int.self, forKey: .groupID)
		isTransalationServices = try values.decodeIfPresent(Bool.self, forKey: .isTransalationServices)
		willProvideAllOndemandvri = try values.decodeIfPresent(Bool.self, forKey: .willProvideAllOndemandvri)
		willProvideScheduledvri = try values.decodeIfPresent(Bool.self, forKey: .willProvideScheduledvri)
		willProvideAllOndemandopi = try values.decodeIfPresent(Bool.self, forKey: .willProvideAllOndemandopi)
		willProvideScheduledopi = try values.decodeIfPresent(Bool.self, forKey: .willProvideScheduledopi)
		isTelephoneServices = try values.decodeIfPresent(Bool.self, forKey: .isTelephoneServices)
		isOnsiteInterpretation = try values.decodeIfPresent(Bool.self, forKey: .isOnsiteInterpretation)
		isLocakOutAllAppointments = try values.decodeIfPresent(Bool.self, forKey: .isLocakOutAllAppointments)
		willProvideProofReading = try values.decodeIfPresent(Bool.self, forKey: .willProvideProofReading)
		willProvideEmailCFM = try values.decodeIfPresent(Bool.self, forKey: .willProvideEmailCFM)
		willProvideEMessageCFM = try values.decodeIfPresent(Bool.self, forKey: .willProvideEMessageCFM)
		willProvideCallCFM = try values.decodeIfPresent(Bool.self, forKey: .willProvideCallCFM)
		interpreterRanking = try values.decodeIfPresent(String.self, forKey: .interpreterRanking)
		transalationRanking = try values.decodeIfPresent(String.self, forKey: .transalationRanking)
		isContarctor1099 = try values.decodeIfPresent(Bool.self, forKey: .isContarctor1099)
		color = try values.decodeIfPresent(String.self, forKey: .color)
		vendorRatingCode = try values.decodeIfPresent(String.self, forKey: .vendorRatingCode)
		address = try values.decodeIfPresent(String.self, forKey: .address)
		billing = try values.decodeIfPresent(String.self, forKey: .billing)
		vriRate = try values.decodeIfPresent(String.self, forKey: .vriRate)
		settings = try values.decodeIfPresent(String.self, forKey: .settings)
		phones = try values.decodeIfPresent(String.self, forKey: .phones)
		phone = try values.decodeIfPresent(String.self, forKey: .phone)
		allLanguages = try values.decodeIfPresent(String.self, forKey: .allLanguages)
		languages = try values.decodeIfPresent(String.self, forKey: .languages)
		specialities = try values.decodeIfPresent(String.self, forKey: .specialities)
		interpretationType = try values.decodeIfPresent(Int.self, forKey: .interpretationType)
		fromDate = try values.decodeIfPresent(String.self, forKey: .fromDate)
		toDate = try values.decodeIfPresent(String.self, forKey: .toDate)
		active = try values.decodeIfPresent(String.self, forKey: .active)
		status = try values.decodeIfPresent(String.self, forKey: .status)
		vendorName = try values.decodeIfPresent(String.self, forKey: .vendorName)
		email = try values.decodeIfPresent(String.self, forKey: .email)
		primaryContact = try values.decodeIfPresent(String.self, forKey: .primaryContact)
		company = try values.decodeIfPresent(String.self, forKey: .company)
		mainPhone = try values.decodeIfPresent(String.self, forKey: .mainPhone)
		workPhone = try values.decodeIfPresent(String.self, forKey: .workPhone)
		homePhone = try values.decodeIfPresent(String.self, forKey: .homePhone)
		mobile = try values.decodeIfPresent(String.self, forKey: .mobile)
		fax = try values.decodeIfPresent(String.self, forKey: .fax)
		costPerHour = try values.decodeIfPresent(String.self, forKey: .costPerHour)
		travelDistance = try values.decodeIfPresent(String.self, forKey: .travelDistance)
		streetAddress = try values.decodeIfPresent(String.self, forKey: .streetAddress)
		cellPhone = try values.decodeIfPresent(String.self, forKey: .cellPhone)
		aptNumber = try values.decodeIfPresent(String.self, forKey: .aptNumber)
		city = try values.decodeIfPresent(String.self, forKey: .city)
		stateID = try values.decodeIfPresent(String.self, forKey: .stateID)
		stateName = try values.decodeIfPresent(String.self, forKey: .stateName)
		zipCode = try values.decodeIfPresent(String.self, forKey: .zipCode)
		isEmployee = try values.decodeIfPresent(Bool.self, forKey: .isEmployee)
		isPerdim = try values.decodeIfPresent(Bool.self, forKey: .isPerdim)
		is3rdParty = try values.decodeIfPresent(Bool.self, forKey: .is3rdParty)
		label1Text = try values.decodeIfPresent(String.self, forKey: .label1Text)
		label2Text = try values.decodeIfPresent(String.self, forKey: .label2Text)
		label3Text = try values.decodeIfPresent(String.self, forKey: .label3Text)
		label4Text = try values.decodeIfPresent(String.self, forKey: .label4Text)
		label5Text = try values.decodeIfPresent(String.self, forKey: .label5Text)
		label6Text = try values.decodeIfPresent(String.self, forKey: .label6Text)
		newColorCode = try values.decodeIfPresent(String.self, forKey: .newColorCode)
		newColors = try values.decodeIfPresent(String.self, forKey: .newColors)
		newLabels = try values.decodeIfPresent(String.self, forKey: .newLabels)
		startDate = try values.decodeIfPresent(String.self, forKey: .startDate)
		vendorUniqueID = try values.decodeIfPresent(String.self, forKey: .vendorUniqueID)
		screeningForm = try values.decodeIfPresent(String.self, forKey: .screeningForm)
		hepB = try values.decodeIfPresent(String.self, forKey: .hepB)
		varicella = try values.decodeIfPresent(String.self, forKey: .varicella)
		measlesOrRubeola = try values.decodeIfPresent(String.self, forKey: .measlesOrRubeola)
		mumps = try values.decodeIfPresent(String.self, forKey: .mumps)
		rubella = try values.decodeIfPresent(String.self, forKey: .rubella)
		tdap = try values.decodeIfPresent(String.self, forKey: .tdap)
		mostRecentTBTest = try values.decodeIfPresent(String.self, forKey: .mostRecentTBTest)
		mostRecentFluShot = try values.decodeIfPresent(String.self, forKey: .mostRecentFluShot)
		confidentiality = try values.decodeIfPresent(String.self, forKey: .confidentiality)
		hIPAA = try values.decodeIfPresent(String.self, forKey: .hIPAA)
		contractor = try values.decodeIfPresent(String.self, forKey: .contractor)
		payrollPolicy = try values.decodeIfPresent(String.self, forKey: .payrollPolicy)
		cORISignedDate = try values.decodeIfPresent(String.self, forKey: .cORISignedDate)
		cORIRUNDate = try values.decodeIfPresent(String.self, forKey: .cORIRUNDate)
		history = try values.decodeIfPresent(String.self, forKey: .history)
		expirationDate = try values.decodeIfPresent(String.self, forKey: .expirationDate)
		resume = try values.decodeIfPresent(String.self, forKey: .resume)
		certificates = try values.decodeIfPresent(String.self, forKey: .certificates)
		hallmarkTraining = try values.decodeIfPresent(String.self, forKey: .hallmarkTraining)
		maldenHousing = try values.decodeIfPresent(String.self, forKey: .maldenHousing)
		sourceLanguage = try values.decodeIfPresent(String.self, forKey: .sourceLanguage)
		targetLanguage = try values.decodeIfPresent(String.self, forKey: .targetLanguage)
		updateBy = try values.decodeIfPresent(String.self, forKey: .updateBy)
		companyName = try values.decodeIfPresent(String.self, forKey: .companyName)
		customerVenueAdress = try values.decodeIfPresent(String.self, forKey: .customerVenueAdress)
		vendorMiles = try values.decodeIfPresent(String.self, forKey: .vendorMiles)
		emailNotification = try values.decodeIfPresent(String.self, forKey: .emailNotification)
		badgeNumber = try values.decodeIfPresent(String.self, forKey: .badgeNumber)
		dateofBirth = try values.decodeIfPresent(String.self, forKey: .dateofBirth)
		countryCode = try values.decodeIfPresent(Int.self, forKey: .countryCode)
		bookedAppointments = try values.decodeIfPresent(String.self, forKey: .bookedAppointments)
		notificationType = try values.decodeIfPresent(String.self, forKey: .notificationType)
		middleName = try values.decodeIfPresent(String.self, forKey: .middleName)
		nickName = try values.decodeIfPresent(String.self, forKey: .nickName)
		employmentID = try values.decodeIfPresent(Int.self, forKey: .employmentID)
		isActiveStartDate = try values.decodeIfPresent(String.self, forKey: .isActiveStartDate)
		isActiveEndDate = try values.decodeIfPresent(String.self, forKey: .isActiveEndDate)
		interpreterActiveStartDate = try values.decodeIfPresent(String.self, forKey: .interpreterActiveStartDate)
		interpreterActiveEndDate = try values.decodeIfPresent(String.self, forKey: .interpreterActiveEndDate)
		website = try values.decodeIfPresent(String.self, forKey: .website)
		vendorCCEmail = try values.decodeIfPresent(String.self, forKey: .vendorCCEmail)
		otherEmail = try values.decodeIfPresent(String.self, forKey: .otherEmail)
		sirName = try values.decodeIfPresent(String.self, forKey: .sirName)
		accountNumber = try values.decodeIfPresent(String.self, forKey: .accountNumber)
		creditLimit = try values.decodeIfPresent(String.self, forKey: .creditLimit)
		paymenTerms = try values.decodeIfPresent(String.self, forKey: .paymenTerms)
		billingrateLevel = try values.decodeIfPresent(String.self, forKey: .billingrateLevel)
		nameOnCheck = try values.decodeIfPresent(String.self, forKey: .nameOnCheck)
		addInfoLanguage = try values.decodeIfPresent(String.self, forKey: .addInfoLanguage)
		addInfoLoction = try values.decodeIfPresent(String.self, forKey: .addInfoLoction)
		addInfoPerHourCost = try values.decodeIfPresent(String.self, forKey: .addInfoPerHourCost)
		authCode = try values.decodeIfPresent(String.self, forKey: .authCode)
		oSIsMileage = try values.decodeIfPresent(String.self, forKey: .oSIsMileage)
		birthCountry = try values.decodeIfPresent(String.self, forKey: .birthCountry)
		diffFlag = try values.decodeIfPresent(String.self, forKey: .diffFlag)
		tMPhone = try values.decodeIfPresent(String.self, forKey: .tMPhone)
		vendorDetailUpdateInfo = try values.decodeIfPresent(String.self, forKey: .vendorDetailUpdateInfo)
		parentTableName = try values.decodeIfPresent(String.self, forKey: .parentTableName)
		tableName = try values.decodeIfPresent(String.self, forKey: .tableName)
		columnName = try values.decodeIfPresent(String.self, forKey: .columnName)
		columnValue = try values.decodeIfPresent(String.self, forKey: .columnValue)
		columnList = try values.decodeIfPresent(String.self, forKey: .columnList)
		flag = try values.decodeIfPresent(String.self, forKey: .flag)
		reason = try values.decodeIfPresent(String.self, forKey: .reason)
		createdUser = try values.decodeIfPresent(String.self, forKey: .createdUser)
		createdBy = try values.decodeIfPresent(String.self, forKey: .createdBy)
		htmlTagId = try values.decodeIfPresent(String.self, forKey: .htmlTagId)
		oldValue = try values.decodeIfPresent(String.self, forKey: .oldValue)
		recMessageNotification = try values.decodeIfPresent(String.self, forKey: .recMessageNotification)
		recNumber = try values.decodeIfPresent(String.self, forKey: .recNumber)
		overViewNotes = try values.decodeIfPresent(String.self, forKey: .overViewNotes)
		infoId = try values.decodeIfPresent(String.self, forKey: .infoId)
		deviceType = try values.decodeIfPresent(String.self, forKey: .deviceType)
		vendorUpdateInfoList = try values.decodeIfPresent(String.self, forKey: .vendorUpdateInfoList)
		isVirtualMServices = try values.decodeIfPresent(Bool.self, forKey: .isVirtualMServices)
		operationType = try values.decodeIfPresent(String.self, forKey: .operationType)
		tabFlag = try values.decodeIfPresent(String.self, forKey: .tabFlag)
		vendorCancelledBy = try values.decodeIfPresent(String.self, forKey: .vendorCancelledBy)
		vendorCancelledDate = try values.decodeIfPresent(String.self, forKey: .vendorCancelledDate)
		securityClearance = try values.decodeIfPresent(Int.self, forKey: .securityClearance)
		experience = try values.decodeIfPresent(String.self, forKey: .experience)
	}

}
