/* 
Copyright (c) 2021 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
struct ApiLoginResponseModelUserDetails : Codable {
    let userID : Int?
    let userTypeID : Int?
    let companyID : Int?
    let userName : String?
    let password : String?
    let status : Bool?
    let email : String?
    let firstName : String?
    let lastName : String?
    let categoryID : String?
    let fullName : String?
    let qBID : String?
    let qBEditID : String?
    let interpreter : String?
    let Message : String?
    let translator : String?
    let subCompanyName : String?
    let createDate : String?
    let createUser : String?
    let updateDate : String?
    let updateUser : String?
    let active : Bool?
    let emailActivationKey : String?
    let emailActivationKeyDateTime : String?
    let groupID : Int?
    let phoneNumber : String?
    let messageActivationKey : String?
    let isAlreadyLoggedIN : Bool?
    let forgotPasswordKey : String?
    let isAcceptedAgreement : Bool?
    let mulGroups : String?
    let mulGroupIDs : String?
    let tempCompanyID : String?
    let latitude : String?
    let longitude : String?
    let ip : String?
    let device : String?
    let decline : Bool?
    let usertoken : String?
    let timeZone : String?
    let proZ_UUID : String?
    let proz_imgurl : String?
    let passwordResetStatus : Int?
    let deviceType : String?
    let companyNameTemp : String?
    let companyPhone : String?
    let loginWay : String?
    let newRegFlag : String?
    let materCategoryId : Int?
    let invitedID : String?
    let adminCustomerID : String?
    let imageId : Int?
    let imageName : String?
    let imageData : String?
    let userTypeID1 : Int?
    let userTypeCode : String?
    let userType : String?
    let createDate1 : String?
    let createUser1 : String?
    let updateDate1 : String?
    let updateUser1 : String?
    let active1 : Bool?
    let userTypeName : String?
    let categoryID1 : Int?
    let dataOrderBy : Int?
    let isAuthenticated : Int?
    let customerID : String?
    let companyEmail : String?
    let companyName : String?
    let companyLogo : String?
    let sessionID : Int?
    let userGuID : String?
    let adminJobApproval : Int?
    let vendorActive : Int?
    let agentOnline : Int?
    let tokenID : String?
    let deviceType1 : String?
    let companyUserToken : String?
    let timeZone1 : String?
    let currencyCode : String?
    let companyTimeZone : String?
    let paymentType : String?
    let currantBal : Double?
    let dateFormat : String?
    let dateTimeFormate : String?
    let isSupportPermission : Int?
    let ZoneShortForm : String?

    enum CodingKeys: String, CodingKey {

        case userID = "UserID"
        case userTypeID = "UserTypeID"
        case companyID = "CompanyID"
        case userName = "UserName"
        case password = "Password"
        case status = "Status"
        case email = "Email"
        case firstName = "FirstName"
        case lastName = "LastName"
        case categoryID = "CategoryID"
        case fullName = "FullName"
        case Message = "Message"
        case qBID = "QBID"
        case qBEditID = "QBEditID"
        case interpreter = "Interpreter"
        case translator = "Translator"
        case subCompanyName = "SubCompanyName"
        case createDate = "CreateDate"
        case createUser = "CreateUser"
        case updateDate = "UpdateDate"
        case updateUser = "UpdateUser"
        case active = "Active"
        case emailActivationKey = "EmailActivationKey"
        case emailActivationKeyDateTime = "EmailActivationKeyDateTime"
        case groupID = "GroupID"
        case phoneNumber = "PhoneNumber"
        case messageActivationKey = "MessageActivationKey"
        case isAlreadyLoggedIN = "IsAlreadyLoggedIN"
        case forgotPasswordKey = "forgotPasswordKey"
        case isAcceptedAgreement = "IsAcceptedAgreement"
        case mulGroups = "MulGroups"
        case mulGroupIDs = "MulGroupIDs"
        case tempCompanyID = "TempCompanyID"
        case latitude = "Latitude"
        case longitude = "Longitude"
        case ip = "Ip"
        case device = "device"
        case decline = "Decline"
        case usertoken = "usertoken"
        case timeZone = "TimeZone"
        case proZ_UUID = "ProZ_UUID"
        case proz_imgurl = "Proz_imgurl"
        case passwordResetStatus = "PasswordResetStatus"
        case deviceType = "DeviceType"
        case companyNameTemp = "CompanyNameTemp"
        case companyPhone = "CompanyPhone"
        case loginWay = "LoginWay"
        case newRegFlag = "NewRegFlag"
        case materCategoryId = "MaterCategoryId"
        case invitedID = "InvitedID"
        case adminCustomerID = "AdminCustomerID"
        case imageId = "ImageId"
        case imageName = "ImageName"
        case imageData = "ImageData"
        case userTypeID1 = "UserTypeID1"
        case userTypeCode = "UserTypeCode"
        case userType = "UserType"
        case createDate1 = "CreateDate1"
        case createUser1 = "CreateUser1"
        case updateDate1 = "UpdateDate1"
        case updateUser1 = "UpdateUser1"
        case active1 = "Active1"
        case userTypeName = "UserTypeName"
        case categoryID1 = "CategoryID1"
        case dataOrderBy = "DataOrderBy"
        case isAuthenticated = "IsAuthenticated"
        case customerID = "CustomerID"
        case companyEmail = "CompanyEmail"
        case companyName = "CompanyName"
        case companyLogo = "CompanyLogo"
        case sessionID = "SessionID"
        case userGuID = "UserGuID"
        case adminJobApproval = "AdminJobApproval"
        case vendorActive = "VendorActive"
        case agentOnline = "AgentOnline"
        case tokenID = "TokenID"
        case deviceType1 = "DeviceType1"
        case companyUserToken = "CompanyUserToken"
        case timeZone1 = "TimeZone1"
        case currencyCode = "currencyCode"
        case companyTimeZone = "CompanyTimeZone"
        case paymentType = "PaymentType"
        case currantBal = "CurrantBal"
        case dateFormat = "DateFormat"
        case dateTimeFormate = "DateTimeFormate"
        case isSupportPermission = "IsSupportPermission"
        case ZoneShortForm = "ZoneShortForm"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        userID = try values.decodeIfPresent(Int.self, forKey: .userID)
        userTypeID = try values.decodeIfPresent(Int.self, forKey: .userTypeID)
        companyID = try values.decodeIfPresent(Int.self, forKey: .companyID)
        userName = try values.decodeIfPresent(String.self, forKey: .userName)
        password = try values.decodeIfPresent(String.self, forKey: .password)
        status = try values.decodeIfPresent(Bool.self, forKey: .status)
        email = try values.decodeIfPresent(String.self, forKey: .email)
        firstName = try values.decodeIfPresent(String.self, forKey: .firstName)
        lastName = try values.decodeIfPresent(String.self, forKey: .lastName)
        Message = try values.decodeIfPresent(String.self, forKey: .Message)
        categoryID = try values.decodeIfPresent(String.self, forKey: .categoryID)
        fullName = try values.decodeIfPresent(String.self, forKey: .fullName)
        qBID = try values.decodeIfPresent(String.self, forKey: .qBID)
        qBEditID = try values.decodeIfPresent(String.self, forKey: .qBEditID)
        interpreter = try values.decodeIfPresent(String.self, forKey: .interpreter)
        translator = try values.decodeIfPresent(String.self, forKey: .translator)
        subCompanyName = try values.decodeIfPresent(String.self, forKey: .subCompanyName)
        createDate = try values.decodeIfPresent(String.self, forKey: .createDate)
        createUser = try values.decodeIfPresent(String.self, forKey: .createUser)
        updateDate = try values.decodeIfPresent(String.self, forKey: .updateDate)
        updateUser = try values.decodeIfPresent(String.self, forKey: .updateUser)
        active = try values.decodeIfPresent(Bool.self, forKey: .active)
        emailActivationKey = try values.decodeIfPresent(String.self, forKey: .emailActivationKey)
        emailActivationKeyDateTime = try values.decodeIfPresent(String.self, forKey: .emailActivationKeyDateTime)
        groupID = try values.decodeIfPresent(Int.self, forKey: .groupID)
        phoneNumber = try values.decodeIfPresent(String.self, forKey: .phoneNumber)
        messageActivationKey = try values.decodeIfPresent(String.self, forKey: .messageActivationKey)
        isAlreadyLoggedIN = try values.decodeIfPresent(Bool.self, forKey: .isAlreadyLoggedIN)
        forgotPasswordKey = try values.decodeIfPresent(String.self, forKey: .forgotPasswordKey)
        isAcceptedAgreement = try values.decodeIfPresent(Bool.self, forKey: .isAcceptedAgreement)
        mulGroups = try values.decodeIfPresent(String.self, forKey: .mulGroups)
        mulGroupIDs = try values.decodeIfPresent(String.self, forKey: .mulGroupIDs)
        tempCompanyID = try values.decodeIfPresent(String.self, forKey: .tempCompanyID)
        latitude = try values.decodeIfPresent(String.self, forKey: .latitude)
        longitude = try values.decodeIfPresent(String.self, forKey: .longitude)
        ip = try values.decodeIfPresent(String.self, forKey: .ip)
        device = try values.decodeIfPresent(String.self, forKey: .device)
        decline = try values.decodeIfPresent(Bool.self, forKey: .decline)
        usertoken = try values.decodeIfPresent(String.self, forKey: .usertoken)
        timeZone = try values.decodeIfPresent(String.self, forKey: .timeZone)
        proZ_UUID = try values.decodeIfPresent(String.self, forKey: .proZ_UUID)
        proz_imgurl = try values.decodeIfPresent(String.self, forKey: .proz_imgurl)
        passwordResetStatus = try values.decodeIfPresent(Int.self, forKey: .passwordResetStatus)
        deviceType = try values.decodeIfPresent(String.self, forKey: .deviceType)
        companyNameTemp = try values.decodeIfPresent(String.self, forKey: .companyNameTemp)
        companyPhone = try values.decodeIfPresent(String.self, forKey: .companyPhone)
        loginWay = try values.decodeIfPresent(String.self, forKey: .loginWay)
        newRegFlag = try values.decodeIfPresent(String.self, forKey: .newRegFlag)
        materCategoryId = try values.decodeIfPresent(Int.self, forKey: .materCategoryId)
        invitedID = try values.decodeIfPresent(String.self, forKey: .invitedID)
        adminCustomerID = try values.decodeIfPresent(String.self, forKey: .adminCustomerID)
        imageId = try values.decodeIfPresent(Int.self, forKey: .imageId)
        imageName = try values.decodeIfPresent(String.self, forKey: .imageName)
        imageData = try values.decodeIfPresent(String.self, forKey: .imageData)
        userTypeID1 = try values.decodeIfPresent(Int.self, forKey: .userTypeID1)
        userTypeCode = try values.decodeIfPresent(String.self, forKey: .userTypeCode)
        userType = try values.decodeIfPresent(String.self, forKey: .userType)
        createDate1 = try values.decodeIfPresent(String.self, forKey: .createDate1)
        createUser1 = try values.decodeIfPresent(String.self, forKey: .createUser1)
        updateDate1 = try values.decodeIfPresent(String.self, forKey: .updateDate1)
        updateUser1 = try values.decodeIfPresent(String.self, forKey: .updateUser1)
        active1 = try values.decodeIfPresent(Bool.self, forKey: .active1)
        userTypeName = try values.decodeIfPresent(String.self, forKey: .userTypeName)
        categoryID1 = try values.decodeIfPresent(Int.self, forKey: .categoryID1)
        dataOrderBy = try values.decodeIfPresent(Int.self, forKey: .dataOrderBy)
        isAuthenticated = try values.decodeIfPresent(Int.self, forKey: .isAuthenticated)
        customerID = try values.decodeIfPresent(String.self, forKey: .customerID)
        companyEmail = try values.decodeIfPresent(String.self, forKey: .companyEmail)
        companyName = try values.decodeIfPresent(String.self, forKey: .companyName)
        companyLogo = try values.decodeIfPresent(String.self, forKey: .companyLogo)
        sessionID = try values.decodeIfPresent(Int.self, forKey: .sessionID)
        userGuID = try values.decodeIfPresent(String.self, forKey: .userGuID)
        adminJobApproval = try values.decodeIfPresent(Int.self, forKey: .adminJobApproval)
        vendorActive = try values.decodeIfPresent(Int.self, forKey: .vendorActive)
        agentOnline = try values.decodeIfPresent(Int.self, forKey: .agentOnline)
        tokenID = try values.decodeIfPresent(String.self, forKey: .tokenID)
        deviceType1 = try values.decodeIfPresent(String.self, forKey: .deviceType1)
        companyUserToken = try values.decodeIfPresent(String.self, forKey: .companyUserToken)
        timeZone1 = try values.decodeIfPresent(String.self, forKey: .timeZone1)
        currencyCode = try values.decodeIfPresent(String.self, forKey: .currencyCode)
        companyTimeZone = try values.decodeIfPresent(String.self, forKey: .companyTimeZone)
        paymentType = try values.decodeIfPresent(String.self, forKey: .paymentType)
        currantBal = try values.decodeIfPresent(Double.self, forKey: .currantBal)
        dateFormat = try values.decodeIfPresent(String.self, forKey: .dateFormat)
        dateTimeFormate = try values.decodeIfPresent(String.self, forKey: .dateTimeFormate)
        isSupportPermission = try values.decodeIfPresent(Int.self, forKey: .isSupportPermission)
        ZoneShortForm = try values.decodeIfPresent(String.self, forKey: .ZoneShortForm)
    }

}
