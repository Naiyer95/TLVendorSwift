//
//  EndPoints.swift
//  Total Vendor
//
//  Created by Mac on 17/08/21.
//

import Foundation

//private let API_BASE_URL_ = "https://lspservices.smsionline.com/"
private let BASE_URL = "https://lsp.smsionline.com/"
private let newURL = "https://lspservices.smsionline.com/"
private let API_BASE_URL_ = "https://lspservices.totallanguage.com/"
private let Live_BASE_URL = "https://lsp.totallanguage.com/"

struct APIs {
    static let USER_LOGIN = API_BASE_URL_ + "api/Security/Login"
    static let Token_API = API_BASE_URL_ + "api/Security/AddUpdateUserDeviceToken"
    static let Checkuser_API = BASE_URL + "Voicecall/Logoutfromwebforall"
    static let FORGOT_PASSWORD = Live_BASE_URL + "Security/ForgetPassword"
    static let UpdateDeviceToken = API_BASE_URL_ + "api/Security/AddUpdateUserDeviceToken"
    static let logoutFromWeb = Live_BASE_URL + "Voicecall/Logoutfromwebforall"
    static let CreateVRICallVendor = BASE_URL + "api/CreateVRICallVendor"
    static let getRatingData = API_BASE_URL_ + "api/chatBox/getFeedbackdetails"
    static let AcceptMember = Live_BASE_URL + "Appointment/AcceptMember/"
    static let getVRICallStatus = API_BASE_URL_ + "api/GetVRICallStatus"
    static let forgotPassword = Live_BASE_URL + "Security/ForgetPassword"
    static let addCallRatingFeedback = API_BASE_URL_ + "api/Security/AddCallFeedback"
    static let logoutApi = API_BASE_URL_ + "api/Security/ChangeLogoutStatus"
    static let getTwilioToken = "https://vri.totallanguage.com/apitoken"
    static let getSingleSignInStatus = API_BASE_URL_ + "api/GetUserGUIDtoChecksinglesignin"
    static let GetBlockedAppointmentDetails = API_BASE_URL_ + "api/GetAppointmentBlokedHomeScreenPopupApi"
    static let speciality = Live_BASE_URL + "/Appointment/GetData?methodType=Speciality"
    static let Get_Online = BASE_URL + "Appointment/GetFormData?methodType=UPDATEAGENTSTATUS&vendoid=\(UserDefaults.standard.object(forKey: "userID")!)&status=1&flag=1"
    
//    static let logoutFromWeb = BASE_URL + "Voicecall/Logoutfromwebforall"
//    static let getSingleSignInStatus = newURL + "api/GetUserGUIDtoChecksinglesignin"
//    static let USER_LOGIN = newURL + "api/Security/Login"
//    static let Token_API = newURL + "api/Security/AddUpdateUserDeviceToken"
//    static let Checkuser_API = BASE_URL + "Voicecall/Logoutfromwebforall"
//    static let FORGOT_PASSWORD = BASE_URL + "Security/ForgetPassword"
//    static let UpdateDeviceToken = newURL + "api/Security/AddUpdateUserDeviceToken"
//    static let CreateVRICallVendor = BASE_URL + "api/CreateVRICallVendor"
//    static let AcceptMember = BASE_URL + "Appointment/AcceptMember/"
//    static let getRatingData = newURL + "api/chatBox/getFeedbackdetails"
//    static let addCallRatingFeedback = newURL + "api/Security/AddCallFeedback"
//    static let getVRICallStatus = newURL + "api/GetVRICallStatus"
//    static let getTwilioToken = "https://vri.totallanguage.com/apitoken"
//    static let logoutApi = newURL + "api/Security/ChangeLogoutStatus"
//    static let getCalendarData = newURL + "api/Security/ChangeLogoutStatus"
    
    
    
//    https://lsp.totallanguage.com/Appointment/GetFormData?methodType=VENDORSCHEDULEDATA&Vendor=217889&Type=1&Date=10/01/2021
//    https://lspservices.totallanguage.com/api/Security/ChangeLogoutStatus
    
}



