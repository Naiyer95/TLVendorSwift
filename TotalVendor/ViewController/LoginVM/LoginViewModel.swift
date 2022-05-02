//
//  LoginViewModel.swift
//  TotalVendor
//
//  Created by Darrin Brooks on 08/04/22.
//

import Foundation
import Alamofire
class LoginViewModel{
    var apiCheckCallStatusResponseModel = [ApiCheckSingleSignInResponseModel]()

    
    func checkSingleSignin(completionHandler:@escaping(Bool?, Error?) ->()){
       
        
        let urlString = APIs.getSingleSignInStatus
        let userID = userDefaults.value(forKey: UserDeafultsString.instance.UserID) ?? "0"
        let currentGUID = userDefaults.string(forKey: UserDeafultsString.instance.userGUID) ?? "0"
        let srchString = "<INFO><USERID>\(userID)</USERID><GUID>\(currentGUID)</GUID></INFO>"
        let parameters = [
            "strSearchString":srchString
        ] as [String:Any]
        print("url to get  checkSingleSignin \(urlString),\(parameters)")
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
                        
                        print("STRING DATA IS \(str)")
                        let data = str.data(using: .utf8)!
                        do {
                            //
                            print("DATAAA ISSS \(data)")
                            if let jsonArray = try JSONSerialization.jsonObject(with: data, options : .allowFragments) as? [Dictionary<String,Any>]
                            {
                                
                                let newjson = jsonArray.first
                                let userInfo = newjson?["UserGuIdInfo"] as? [[String:Any]]
                                
                                let userIfo = userInfo?.first
                                let vendorId = userIfo?["id"] as? Int
                                print("vendorId ....",vendorId ?? 0)
                                if userInfo!.count > 0 {
                                    completionHandler(true, nil)
                                }
                                else {
                                    completionHandler(false, nil)
                                }
                                
                               
                                
                                } else {
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
}
