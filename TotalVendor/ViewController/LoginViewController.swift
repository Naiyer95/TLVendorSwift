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
    
    var apiCheckCallStatusResponseModel = [ApiCheckSingleSignInResponseModel]()
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
     
        if  touchID as! Bool  {
            getAuthDetail()
          
            self.touchIdBtnOutlet.isHidden = false
            
        }
        else{
            self.touchIdBtnOutlet.isHidden = true
            
        }
     
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    @IBAction func btnRegisterTapped(_ sender: Any) {
        guard let url = URL(string: signUPUrl) else { return }
        UIApplication.shared.open(url)
    }
    
    @IBAction func cancelBtnTapped(_ sender: Any) {
        
    }
    
    @IBAction func okbtnTapped(_ sender: Any) {
        let localString = "Biometric Authentication!"
        let userName = userDefaults.value(forKey: "userNameForTouchID") as? String ?? ""
        let userPassword = userDefaults.value(forKey: "userPasswordForTouchID") as? String ?? ""
        if context.canEvaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, error: &err){
            
            if context.biometryType == .faceID {
                context.evaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, localizedReason: localString) { success, err in
                    if success{
                        DispatchQueue.main.async {
                            SwiftLoader.show(title: "Login...", animated: true)
                            let userName = userName
                            let userPassword = userPassword
                            self.userNameTxtField.text = userName
                            self.passwordTxtField.text = userPassword
                            
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
                            self.userNameTxtField.text = userName
                            self.passwordTxtField.text = userPassword
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
                       
                        
                        DispatchQueue.main.async {
                            userDefaults.set(true, forKey: "touchID" )
                            userDefaults.set(self.userNameTxtField.text, forKey: "userNameForTouchID" )
                            userDefaults.set(fullName, forKey: "fullNameforTouchID")
                            
                            userDefaults.set(self.passwordTxtField.text, forKey: "userPasswordForTouchID")
                            
                            
                            self.hitUpdateTokenApi(userID: newUserID)
                        }
                        
                    }else {
                        print("ERROR IS \(err?.localizedDescription)")
                    }
                }
            }
        }
        
        
    }
    public func getAuthDetail(){
        let localString = "Biometric Authentication!"
        
        
        let userName = userDefaults.value(forKey: "userNameForTouchID") as? String ?? ""
        let userPassword = userDefaults.value(forKey: "userPasswordForTouchID") as? String ?? ""
        if context.canEvaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, error: &err){
            
            if context.biometryType == .faceID {
                context.evaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, localizedReason: localString) { success, err in
                    if success{
                        DispatchQueue.main.async {
                            SwiftLoader.show(title: "Login...", animated: true)
                            let userName = userName
                            let userPassword = userPassword
                            self.userNameTxtField.text = userName
                            self.passwordTxtField.text = userPassword
                            
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
                            self.userNameTxtField.text = userName
                            self.passwordTxtField.text = userPassword
                            
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
    
    
}


extension LoginViewController {
    
    func doLogin(){
        var activite = NVActivityIndicatorView(frame: .zero, type: .lineScaleParty, color:.white , padding: 0)
        activite.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(activite)
        NSLayoutConstraint.activate([activite.widthAnchor.constraint(equalToConstant: 40),activite.heightAnchor.constraint(equalToConstant: 40),activite.centerYAnchor.constraint(equalTo: view.centerYAnchor),activite.centerXAnchor.constraint(equalTo: view.centerXAnchor)])
        activite.startAnimating()
        let userName = self.userNameTxtField.text
        let password = self.passwordTxtField.text
        let parameters = ["UserName": userName, "Password": password, "Ip": "M", "Latitude": "0", "Longitude": "0", "UserSessionId" : "", "UserLoginKey": ""]
        NetworkLayer.shared.postRequest(url: APIs.USER_LOGIN, parameters: parameters) { response in
            
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
            
           
        } failure: { error in
           
            print("API error ===\(error.localizedDescription)")
        }
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == passwordTxtField{
            if userNameTxtField.text?.isEmpty ?? true || passwordTxtField.text?.isEmpty ?? true  {
               
            }
            else
            {
                self.postLoginDetails()
                
            }
        }
        return true
    }
}


extension LoginViewController{
    
    func postLoginDetails(){
        SwiftLoader.show(title: "Login..",animated: true)
        guard let uuid = UIDevice.current.identifierForVendor?.uuidString else {
            return
        }
        let parameters = ["UserName": userNameTxtField.text ?? "", "Password": passwordTxtField.text ?? "", "Ip": "M", "Latitude": "0", "Longitude": "0", "UserSessionId" : "", "UserLoginKey": ""]
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
                    
                    self.apiLoginResponseModel = try decoder.decode(ApiLoginResponseModel.self, from: data)
                    let status : Bool = self.apiLoginResponseModel?.userDetails?.first?.status ?? false
                    if status == true{
                        
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
                            }
                            else {
                                let alert = UIAlertController(title: "Do you want to save this login to use FACE ID/TOUCH ID", message: "", preferredStyle: .alert)
                                let cancel = UIAlertAction(title: "Cancel", style: .cancel){ cancel  in
                                    
                                    self.hitUpdateTokenApi(userID: userData?.userID ?? 0)
                                }
                                let yes = UIAlertAction(title: "Yes", style: .destructive) { alert in
                                    
                                    
                                    self.bioMetricForLogin(newUserID: userData?.userID ?? 0, fullName: userData?.fullName ?? "")
                                    
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
                            
                        }
                    } else {
                        SwiftLoader.hide()
                        self.view.makeToast(self.apiLoginResponseModel?.userDetails?.first?.Message ?? "", duration: 3.0, position: .center)
                    }
                } catch let error {
                    SwiftLoader.hide()
                    self.view.makeToast("Please enter correct password.", duration: 3.0, position: .center)
                    print(error)
                }
            case .failure(let error):
                print(error)
                SwiftLoader.hide()
                self.view.makeToast("Please try after sometime.", duration: 3.0, position: .center)
            }
        }
    }
    
}
let callController = CXCallController()
extension LoginViewController{
    
    func hitUpdateTokenApi(userID:Int){
        
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
        print("updatetoken-->",parameters)
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
                
                do{
                    let decoder = JSONDecoder()
                    self.apiUpdateDeviceTokenResponseModel = try decoder.decode(ApiUpdateTokenResponseModel.self, from: data)
                    if (self.apiUpdateDeviceTokenResponseModel?.table!.count)! > 0 {
                        self.hitlogoutFromWebApi()
                    }
                    userDefaults.set(self.apiUpdateDeviceTokenResponseModel?.table?.first?.currentUserGuid, forKey: UserDeafultsString.instance.userGUID)
                    
                    guard let status = self.apiUpdateDeviceTokenResponseModel?.table?.first?.success else{ return }
                    if status == 1{
                    print("updattokenfirstdata-->",self.apiUpdateDeviceTokenResponseModel?.table?.first)
                        self.checkSingleSignin { sucess, err in
                            if sucess == true{
                                
                                UserDefaults.standard.setValue(true, forKey: "isLoggedIn")
                                userDefaults.set(self.apiLoginResponseModel?.userDetails?.first?.timeZone, forKey: "TimeZone")
                                
                                UserDefaults.standard.setValue(self.apiUpdateDeviceTokenResponseModel?.table?.first?.currentUserGuid ?? 0, forKey: UserDeafultsString.instance.userGUID)
                                UserDefaults.standard.setValue(false, forKey: UserDeafultsString.instance.timeZoneDeclined)
                                DispatchQueue.main.async {
                                    let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "navCalendar") as? UINavigationController
                                    vc!.modalPresentationStyle = .fullScreen
                                    self.present(vc!, animated: true, completion: nil)
                                }
                                
                            }
                            else {
                                self.showAlert()
                            }
                        }
                        
                    }
                } catch let error {
                    
                    print(error)
                    
                    
                }
            case .failure(_):
                
                break
            }
        }
    }
    
    func checkSingleSignin(completionHandler:@escaping(Bool?, Error?) ->()){
        SwiftLoader.show(animated: true)
        
        let urlString = APIs.getSingleSignInStatus
        let userID = userDefaults.value(forKey: UserDeafultsString.instance.UserID) ?? "0"
        let currentGUID = userDefaults.string(forKey: UserDeafultsString.instance.userGUID) ?? "0"
        let srchString = "<INFO><USERID>\(userID)</USERID><GUID>\(currentGUID)</GUID></INFO>"
        let parameters = [
            "strSearchString":srchString
        ] as [String:Any]
        print("url to get  checkSingleSignintttt \(urlString),\(parameters)")
        AF.request(urlString, method: .post , parameters: parameters, encoding: JSONEncoding.default, headers: nil)
            .validate()
            .responseData(completionHandler: { (response) in
                //                SwiftLoader.hide()
                switch(response.result){
                    
                case .success(_):
                    guard let daata = response.data else { return }
                    do {
                        print("check singel user response ",daata)
                        let jsonDecoder = JSONDecoder()
                        self.apiCheckCallStatusResponseModel = try jsonDecoder.decode([ApiCheckSingleSignInResponseModel].self, from: daata)
                        print("Success getVendorIDs Model ",self.apiCheckCallStatusResponseModel.first?.result ?? "")
                        let str = self.apiCheckCallStatusResponseModel.first?.result ?? ""
                        
                        
                        let data = str.data(using: .utf8)!
                        do {
                            
                            if let jsonArray = try JSONSerialization.jsonObject(with: data, options : .allowFragments) as? [Dictionary<String,Any>]
                            {
                                
                                let newjson = jsonArray.first
                                let userInfo = newjson?["UserGuIdInfo"] as? [[String:Any]]
                                if userInfo!.count > 0 {
                                    completionHandler(true, nil)
                                }
                                else {
                                    completionHandler(false, nil)
                                }
                                
                            }
                            else {
                                print("bad json")
                            }
                        } catch let error as NSError {
                            print(error)
                        }
                        
                    } catch{
                        
                        print("error block getVendorIDs Data  " ,error)
                    }
                case .failure(_):
                    print("Respose Failure getVendorIDs ")
                    
                }
            })
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
                
                do{
                    let decoder = JSONDecoder()
                    self.apiLogoutFromWebResponseModel = try decoder.decode(ApiLogoutFromWebResponseModel.self, from: data)
                    
                    guard let status = self.apiLogoutFromWebResponseModel?.status else{ return }
                    if status == 1{
                        
                        
                    }
                } catch let error {
                    //                               SwiftLoader.hide()
                    print(error)
                    
                    
                }
            case .failure(_):
                //                           SwiftLoader.hide()
                
                break
            }
        }
    }
    func showAlert(){
        let refreshAlert = UIAlertController(title: "Someone Logged in", message: "The vendor already logged-in on another device.", preferredStyle: UIAlertController.Style.alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Login", style: .default, handler: { (action: UIAlertAction!) in
            self.navigationController?.popViewController(animated: true)
        }))
        present(refreshAlert, animated: true, completion: nil)
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
