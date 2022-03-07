//
//  LoginViewController.swift
//  TotalVendor
//
//  Created by Darrin Brooks on 12/08/21.
//

import UIKit
import NVActivityIndicatorView
import Toast_Swift
import Alamofire
import CallKit
import Foundation
import LocalAuthentication
class LoginViewController: UIViewController, UITextFieldDelegate {

    
    @IBOutlet weak var fingerPrintParentView: UIView!
    
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var userNameTxtField: UITextField!
    var apiLogoutFromWebResponseModel : ApiLogoutFromWebResponseModel?
    @IBOutlet weak var touchIdBtnOutlet: UIButton!
    
    var forLogin = false
    var err:NSError?
    var context = LAContext()
    var apiUpdateDeviceTokenResponseModel : ApiUpdateTokenResponseModel?
    @IBOutlet weak var passwordTxtField: UITextField!
    var apiLoginResponseModel : ApiLoginResponseModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userNameTxtField.delegate=self
        passwordTxtField.delegate=self
        let touchID = userDefaults.value(forKey: "touchID") ?? false //keychainServices.getKeychaindata(key: "touchID")
                print("touch id after ", touchID)
                if  touchID as! Bool  {
                    getAuthDetail()
                    print("touch id saved")
                    self.touchIdBtnOutlet.isHidden = false
                    self.fingerPrintParentView.isHidden=true
                }
                else{
                    self.touchIdBtnOutlet.isHidden = true
                    self.fingerPrintParentView.isHidden=true
                }

    }
        
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let abc = userDefaults.value(forKey: "fullNameforTouchID") as? String ?? ""
        self.nameLbl.text = "Hi \(abc)"
        self.fingerPrintParentView.clipsToBounds=true
        fingerPrintParentView.layer.cornerRadius = 25
        fingerPrintParentView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        
       
    }
    
    
    @IBAction func cancelBtnTapped(_ sender: Any) {
        self.fingerPrintParentView.isHidden=true
    }
    
    @IBAction func okbtnTapped(_ sender: Any) {
        let localString = "Biometric Authentication!"
        
//        userDefaults.set(self.userNameTxtField.text, forKey: "userNameForTouchID" )
//        userDefaults.set(self.passwordTxtField.text, forKey: "userPasswordForTouchID")
        
        let userName = userDefaults.value(forKey: "userNameForTouchID") as? String ?? ""
        let userPassword = userDefaults.value(forKey: "userPasswordForTouchID") as? String ?? ""
     if context.canEvaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, error: &err){
            
            if context.biometryType == .faceID {
                context.evaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, localizedReason: localString) { success, err in
                    if success{
                        DispatchQueue.main.async {
                            SwiftLoader.show(title: "Login...", animated: true)
                            let userName = userName
                            let userPassword = userPassword// = GetPublicData.sharedInstance.userPasswordForTouchID
                            
                            print("user name and password ",userName, userPassword)
                            
                            
                            self.userNameTxtField.text = userName
                            self.passwordTxtField.text = userPassword
                          //  self.biometricAuthentication(username: CEnumClass.share.loadKeydata(keyname: "username"), pwd: CEnumClass.share.loadKeydata(keyname: "password"))
                            self.postLoginDetails()
                        }
                        
                    }
                }
                
                
            }
            else if context.biometryType == .touchID  {
                context.evaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, localizedReason: localString) { success, err in
                    if success{
                        DispatchQueue.main.async {
                            SwiftLoader.show(title: "Login..", animated: true)
                            
                            let userName = userName
                            let userPassword = userPassword
                            
                          
                            print("user name and password ",userName, userPassword)
                            self.userNameTxtField.text = userName
                            self.passwordTxtField.text = userPassword
                           // self.biometricAuthentication(username: CEnumClass.share.loadKeydata(keyname: "username"), pwd: CEnumClass.share.loadKeydata(keyname: "password"))
                            self.postLoginDetails()
                            
                        }
                        
                    }
                }
            }
        }
        
    }
    
    
    func bioMetricForLogin(newUserID:Int,fullName:String){

        
        let localString = "Biometric Authentication!"
                
                if context.canEvaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, error: &err){
                    
                    if context.biometryType == .faceID {
                        context.evaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, localizedReason: localString) { success, err in
                            if success{
                                print("SUUCESS FACE ID\(localString)")
                                DispatchQueue.main.async {
                                    userDefaults.set(true, forKey: "touchID" )
                                    userDefaults.set(self.userNameTxtField.text, forKey: "userNameForTouchID" )
                                    userDefaults.set(fullName, forKey: "fullNameforTouchID" )
                                    
                                    userDefaults.set(self.passwordTxtField.text, forKey: "userPasswordForTouchID")
                                }
                                
                        
                                self.hitUpdateTokenApi(userID: newUserID)
                                
                          
                                
                            }else {
                                print("ERROR IS \(err?.localizedDescription)")
                            }
                        }
                        
                        
                    }
                    else if context.biometryType == .touchID  {
                        context.evaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, localizedReason: localString) { success, err in
                            if success{
                                print("SUUCESS TOUCH ID\(localString)")
                                
                                DispatchQueue.main.async {
                                    userDefaults.set(true, forKey: "touchID" )
                                    userDefaults.set(self.userNameTxtField.text, forKey: "userNameForTouchID" )
                                    userDefaults.set(fullName, forKey: "fullNameforTouchID")
                                    
                                    userDefaults.set(self.passwordTxtField.text, forKey: "userPasswordForTouchID")
                            
                            
                                    self.hitUpdateTokenApi(userID: newUserID)
                                }
                                    
//                                DispatchQueue.main.async {
//                                    SwiftLoader.show(title: "Login..", animated: true)
//                                    self.biometricAuthentication(username: CEnumClass.share.loadKeydata(keyname: "username"), pwd: CEnumClass.share.loadKeydata(keyname: "password"))
//                                }
                                
                            }else {
                                print("ERROR IS \(err?.localizedDescription)")
                            }
                        }
                    }
                }
        
        
    }
    public func getAuthDetail(){
        let localString = "Biometric Authentication!"
        
//        userDefaults.set(self.userNameTxtField.text, forKey: "userNameForTouchID" )
//        userDefaults.set(self.passwordTxtField.text, forKey: "userPasswordForTouchID")
        
        let userName = userDefaults.value(forKey: "userNameForTouchID") as? String ?? ""
        let userPassword = userDefaults.value(forKey: "userPasswordForTouchID") as? String ?? ""
     if context.canEvaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, error: &err){
            
            if context.biometryType == .faceID {
                context.evaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, localizedReason: localString) { success, err in
                    if success{
                        DispatchQueue.main.async {
                            SwiftLoader.show(title: "Login...", animated: true)
                            let userName = userName
                            let userPassword = userPassword// = GetPublicData.sharedInstance.userPasswordForTouchID
                            
                            print("user name and password ",userName, userPassword)
                            
                            
                            self.userNameTxtField.text = userName
                            self.passwordTxtField.text = userPassword
                          //  self.biometricAuthentication(username: CEnumClass.share.loadKeydata(keyname: "username"), pwd: CEnumClass.share.loadKeydata(keyname: "password"))
                            self.postLoginDetails()
                        }
                        
                    }
                }
                
                
            }
            else if context.biometryType == .touchID  {
                context.evaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, localizedReason: localString) { success, err in
                    if success{
                        DispatchQueue.main.async {
                            SwiftLoader.show(title: "Login..", animated: true)
                            
                            let userName = userName
                            let userPassword = userPassword
                            
                          
                            print("user name and password ",userName, userPassword)
                            self.userNameTxtField.text = userName
                            self.passwordTxtField.text = userPassword
                           // self.biometricAuthentication(username: CEnumClass.share.loadKeydata(keyname: "username"), pwd: CEnumClass.share.loadKeydata(keyname: "password"))
                            self.postLoginDetails()
                            
                        }
                        
                    }
                }
            }
        }
    }
    
    @IBAction func touchIDBtnTapped(_ sender: Any){
        getAuthDetail()
           
       }
    @IBAction func ForgotBtnAction(_ sender: Any) {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ForgotViewController") as? ForgotViewController
        vc!.modalPresentationStyle = .fullScreen
        self.present(vc!, animated: true, completion: nil)
    }
    
    @IBAction func SignInBtnAction(_ sender: Any) {
        
        if userNameTxtField.text!.isEmpty {
            return self.view.makeToast("Please enter username", position : .top)
        }
        else if passwordTxtField.text!.isEmpty   {
            return self.view.makeToast("Please enter password",position : .top)
        }
        else
    {
        
        if Reachability.isConnectedToNetwork(){
            self.postLoginDetails()
        }else {
            self.view.makeToast("Please check your internet connection")
        }
            
        
        
//            self.doLogin()
    }
    }
    
    var iconClick = true
    
    @IBAction func iconAction(sender: AnyObject) {
        
            if(iconClick == true) {
                passwordTxtField.isSecureTextEntry = false
            } else {
                passwordTxtField.isSecureTextEntry = true
            }
            iconClick = !iconClick
        
        }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


extension LoginViewController {
    
    func doLogin(){
        var activite = NVActivityIndicatorView(frame: .zero, type: .lineScaleParty, color:.white , padding: 0)
        activite.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(activite)
        NSLayoutConstraint.activate([activite.widthAnchor.constraint(equalToConstant: 40),activite.heightAnchor.constraint(equalToConstant: 40),activite.centerYAnchor.constraint(equalTo: view.centerYAnchor),activite.centerXAnchor.constraint(equalTo: view.centerXAnchor)])
        activite.startAnimating()
        var userName = self.userNameTxtField.text
        var password = self.passwordTxtField.text
        let parameters = ["UserName": userName, "Password": password, "Ip": "M", "Latitude": "0", "Longitude": "0", "UserSessionId" : "", "UserLoginKey": ""]
        NetworkLayer.shared.postRequest(url: APIs.USER_LOGIN, parameters: parameters) { response in
            print("URL REQUEST IS \(APIs.USER_LOGIN) and parameter is \(parameters)")
            print("API Response ===\(response)")
            activite.stopAnimating()
            
            var responsedata  = response as! NSDictionary
            let jsonDecoder = JSONDecoder()
                 do{
                let parsedJSON = try jsonDecoder.decode(ApiLoginResponseModel.self, from: response as! Data )
                
                let loginResponse = parsedJSON
                print("LOGIN RESPONSE IS \(loginResponse)")
                    }
            catch
                    {
                        print(error)
                    }

            //Handle Response
        } failure: { error in
            //Handle Response
            print("API error ===\(error.localizedDescription)")
        }
      
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == passwordTxtField{
            if userNameTxtField.text?.isEmpty ?? true || passwordTxtField.text?.isEmpty ?? true  {
                    // Alert
                }
                else
            {
                    self.postLoginDetails()
        //            self.doLogin()
            }
        }
        return true
    }
    
    
    
    
}


extension LoginViewController{
    
    func postLoginDetails(){
        SwiftLoader.show(animated: true)
            guard let uuid = UIDevice.current.identifierForVendor?.uuidString else {
               return
            }
        var userName = userNameTxtField.text ?? ""
        var password = passwordTxtField.text ?? ""
        let parameters = ["UserName": userName, "Password": password, "Ip": "M", "Latitude": "0", "Longitude": "0", "UserSessionId" : "", "UserLoginKey": ""]
            print("postLoginDetails--",parameters , APIs.USER_LOGIN)
            AF.request(APIs.USER_LOGIN,
                       method: .post,
                       parameters: parameters,
                       encoding: URLEncoding.default)
                .validate()
                .responseData {  [unowned self]  response in
                    switch response.result {
                    case .success(_):
                        guard let data = response.data else { return }
                        print("Success postLoginDetails Api ",data)
                        do {
                            let decoder = JSONDecoder()
                            SwiftLoader.hide()
                            self.apiLoginResponseModel = try decoder.decode(ApiLoginResponseModel.self, from: data)
                            let status : Bool = self.apiLoginResponseModel?.userDetails?.first?.status ?? false
                            if status == true{
                                print("🎖",self.apiLoginResponseModel)
                                let userData = self.apiLoginResponseModel?.userDetails?.first
                                if userData?.vendorActive==1 && userData?.userType == "6"{
                                    self.view.makeToast("Please proceed through web to upload the documents (Confidentiality Agreement, Contractor Agreement, Criminal Background Check, Hippa Policy, W9, Payroll Policy) for further registration process")
                                }
                                else if userData?.vendorActive==1 && userData?.adminJobApproval == 0 && userData?.userTypeID==6 {
                                    self.view.makeToast("Please proceed through web to upload the documents (Confidentiality Agreement, Contractor Agreement, Criminal Background Check, Hippa Policy, W9, Payroll Policy) for further registration process")
                                }else {
                                    let uname = userDefaults.value(forKey: "userNameForTouchID") as? String ?? ""
                                    let touchID = userDefaults.value(forKey: "touchID") ?? false
                                    if touchID as! Bool && userNameTxtField.text == uname{
                                        hitUpdateTokenApi(userID: userData?.userID ?? 0)
                                                                    
                                                                    
                                                                    
                                    //                                self.registerTwilioAccessToken(with: item)
                                                                }
                                    else {
                                        let alert = UIAlertController(title: "Do you want to save this login to use FACE ID/TOUCH ID", message: "", preferredStyle: .alert)
                                        let cancel = UIAlertAction(title: "Cancel", style: .cancel){ cancel  in
                                            
                                            hitUpdateTokenApi(userID: userData?.userID ?? 0)
                                            
                                            
        //                                    self.registerTwilioAccessToken(with: item)
                                        }
                                        let yes = UIAlertAction(title: "Yes", style: .destructive) { alert in
//                                            self.touchIdBtnOutlet.isHidden = false
                                            print("username and password ", self.userNameTxtField.text , self.passwordTxtField.text)
                                            print("FULL NAMe FROM API IS \(userData?.fullName)")
                                            self.bioMetricForLogin(newUserID: userData?.userID ?? 0, fullName: userData?.fullName ?? "")
        //                                    self.registerTwilioAccessToken(with: item)
                                        }
                                        alert.addAction(cancel)
                                        alert.addAction(yes)
                                        self.present(alert, animated: true, completion: nil)
                                        
                                    }
                                    
                                    
                                    UserDefaults.standard.setValue(userData?.ZoneShortForm, forKey: UserDeafultsString.instance.ZoneShortForm)

                                    UserDefaults.standard.setValue(userData?.userTypeID, forKey: UserDeafultsString.instance.UserTypeID)
                                    UserDefaults.standard.setValue(userData?.userName, forKey: UserDeafultsString.instance.USER_USERNAME)
                                    UserDefaults.standard.setValue(userData?.firstName, forKey: UserDeafultsString.instance.FirstName)
                                    UserDefaults.standard.setValue(userData?.lastName, forKey: UserDeafultsString.instance.LastName)
                                    UserDefaults.standard.setValue(userData?.fullName, forKey: UserDeafultsString.instance.fullName)
                                    UserDefaults.standard.setValue(userData?.userTypeID, forKey: UserDeafultsString.instance.USER_TYPE)
                                    UserDefaults.standard.setValue(userData?.customerID, forKey: UserDeafultsString.instance.USER_CUSTOMER_ID)
                                    UserDefaults.standard.setValue(userData?.email, forKey: UserDeafultsString.instance.Email)
                                    UserDefaults.standard.setValue(userData?.imageData, forKey: UserDeafultsString.instance.USER_IMAGEDATA)
                                    UserDefaults.standard.setValue(userData?.companyName, forKey: UserDeafultsString.instance.CompanyName)
                                    UserDefaults.standard.setValue(userData?.companyID, forKey:
                                    UserDeafultsString.instance.CompanyID)
                                    UserDefaults.standard.setValue(userData?.companyLogo, forKey: UserDeafultsString.instance.CompanyLogo)
                                    UserDefaults.standard.setValue(userData?.usertoken, forKey: UserDeafultsString.instance.UserToken)
                                    UserDefaults.standard.setValue(userData?.timeZone, forKey: UserDeafultsString.instance.TimeZone)
                                    UserDefaults.standard.setValue(userData?.timeZone1, forKey: UserDeafultsString.instance.TimeZone1)
                                    UserDefaults.standard.setValue(userData?.userID ?? 0, forKey: UserDeafultsString.instance.UserID)
                                    UserDefaults.standard.setValue(userData?.userGuID ?? 0, forKey: UserDeafultsString.instance.userGUID)
//                                    hitUpdateTokenApi(userID: userData?.userID ?? 0)
                                }
                            } else {
                                self.view.makeToast(self.apiLoginResponseModel?.userDetails?.first?.Message ?? "", duration: 3.0, position: .center)
                            }
                        } catch let error {
                            SwiftLoader.hide()
                            self.view.makeToast("Please enter correct password.", duration: 3.0, position: .center)
                            print(error)
                        }
                    case .failure(let error):
                        print(error)
                        self.view.makeToast("Please try after sometime.", duration: 3.0, position: .center)
                    }
                }
        }
  
}
let callController = CXCallController()
extension LoginViewController{
//  func hitUpdateTokenApi(userID:Int){
        func hitUpdateTokenApi(userID:Int){
//  UserDefaults.standard.setValue(token, forKey: "FCMToken")
            let deviceToken = UserDefaults.standard.value(forKey: "FCMToken")
            let updateVoipToken = UserDefaults.standard.value(forKey: "voipToken") ?? ""
            let url =  APIs.UpdateDeviceToken
               let parameters = [
                   "voipToken": updateVoipToken,
                   "UserID": userID,
                   "TokenID": deviceToken ?? "",
                   "Status": "Y",
                   "DeviceType": "I"
               ] as [String : Any]
               print("HITBOOKINGSLOTSSSS----------","\(url)",parameters)
               AF.request(url,
                          method: .post,
                          parameters: parameters,
                          encoding: JSONEncoding.default,
                          headers: nil)
                   .validate()
                   .responseData { (respData) in
                       switch (respData.result){
                       case .success(_):
                           guard let data = respData.data else {return}
                           print("Success HITBOOKINGSLOTSSSS-------\(data)")
                           do{
                               self.hitlogoutFromWebApi()
                               let decoder = JSONDecoder()
                               self.apiUpdateDeviceTokenResponseModel = try decoder.decode(ApiUpdateTokenResponseModel.self, from: data)
//           isLoggedIn
                        UserDefaults.standard.setValue(true, forKey: "isLoggedIn")
                            print("ApiGrumerProfileResponseModel----------Status----", self.apiUpdateDeviceTokenResponseModel?.table?.first?.success)
                            guard let status = self.apiUpdateDeviceTokenResponseModel?.table?.first?.success else{ return }
                               if status == 1{
                                   print("----- HITBOOKINGSLOTSSSS SUCCESSFUL----- ")
                                   
                                   userDefaults.set(self.apiLoginResponseModel?.userDetails?.first?.timeZone, forKey: "TimeZone")
                                   
                                   UserDefaults.standard.setValue(self.apiUpdateDeviceTokenResponseModel?.table?.first?.currentUserGuid ?? 0, forKey: UserDeafultsString.instance.userGUID)
                                   UserDefaults.standard.setValue(false, forKey: UserDeafultsString.instance.timeZoneDeclined)
                                   
                                let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "navCalendar") as? UINavigationController
                                    vc!.modalPresentationStyle = .fullScreen
                                self.present(vc!, animated: true, completion: nil)
                               }
                           } catch let error {
//                               SwiftLoader.hide()
                               print(error)
                               
//         self.showAlertWithMsgNCancelBtn(withTitle: "success--error", withMessage:"Please try again Later")
                           }
                       case .failure(_):
//                           SwiftLoader.hide()
//                           self.showAlertWithMsgNCancelBtn(withTitle: "Failure", withMessage: "Please try Again later")
                           break
                       }
                   }
           }

    func hitlogoutFromWebApi(){
//  UserDefaults.standard.setValue(token, forKey: "FCMToken")
        
        let url =  APIs.logoutFromWeb
        let userID = userDefaults.value(forKey: UserDeafultsString.instance.UserID) ?? "0"
        let currentGUID = userDefaults.string(forKey: UserDeafultsString.instance.userGUID) ?? "0"
           let parameters = [
               "UserID": userID,
               "UserGuID": currentGUID,
               
           ] as [String : Any]
           print("HITBOOKINGSLOTSSSS----------","\(url)",parameters)
           AF.request(url,
                      method: .post,
                      parameters: parameters,
                      encoding: JSONEncoding.default,
                      headers: nil)
               .validate()
               .responseData { (respData) in
                   switch (respData.result){
                   case .success(_):
                       guard let data = respData.data else {return}
                       print("Success HITBOOKINGSLOTSSSS-------\(data)")
                       do{
                           let decoder = JSONDecoder()
                           self.apiLogoutFromWebResponseModel = try decoder.decode(ApiLogoutFromWebResponseModel.self, from: data)
//           isLoggedIn
                  
                           print("apiLogoutFromWebResponseModel----------Status----", self.apiLogoutFromWebResponseModel?.status)
                        guard let status = self.apiLogoutFromWebResponseModel?.status else{ return }
                           if status == 1{
                               print("----- HITBOOKINGSLOTSSSS SUCCESSFUL----- ")
                          
                           }
                       } catch let error {
//                               SwiftLoader.hide()
                           print(error)
                           
//         self.showAlertWithMsgNCancelBtn(withTitle: "success--error", withMessage:"Please try again Later")
                       }
                   case .failure(_):
//                           SwiftLoader.hide()
//                           self.showAlertWithMsgNCancelBtn(withTitle: "Failure", withMessage: "Please try Again later")
                       break
                   }
               }
       }


}


public class UserDeafultsString{
     static let instance = UserDeafultsString()
    var UserTypeID = "UserTypeID"
    var USER_USERNAME = "USER_USERNAME"
    var FirstName = "FirstName"
    var UserID = "0"
    var LastName = "LastName"
    var fullName = "fullName"
    var USER_TYPE = "USER_TYPE"
    var USER_CUSTOMER_ID = "USER_CUSTOMER_ID"
    var Email = "Email"
    var USER_IMAGEDATA = "USER_IMAGEDATA"
    var CompanyID = "CompanyID"
    var CompanyName = "CompanyName"
    var CompanyLogo = "CompanyLogo"
    var UserToken = "UserToken"
    var TimeZone = "TimeZone"
    var TimeZone1 = "TimeZone1"
    var userGUID = "userGuID"
    var timeZoneDeclined = "timeZoneDeclined"
    var ZoneShortForm = "ZoneShortForm"
}
