//
//  ScheduleDetailsVC.swift
//  TotalVendor
//
//  Created by Shivansh SMIT on 27/12/21.
//

import UIKit
import Alamofire

class ScheduleDetailsVC: UIViewController {
    @IBOutlet weak var roomNoLbl: UILabel!
    var serviceType = ""
    @IBOutlet weak var serviceTypeLbl: UILabel!
    @IBOutlet weak var statusLbl: UILabel!
    @IBOutlet weak var noteLbl: UILabel!
    @IBOutlet weak var dateTimeLbl: UILabel!
    @IBOutlet weak var targetLanguageLbl: UILabel!
    @IBOutlet weak var sourceLanguageLbl: UILabel!
    var appointmentID = 0
    var cType = ""
    var apiAcceptByVendorRequestDataModel:ApiAcceptByVendorRequestDataModel?
    var  apiGetVRIScheduleDataResponseMdel:ApiGetVRIScheduleDataResponseMdel?
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let userId = userDefaults.string(forKey: UserDeafultsString.instance.UserID) ?? ""
        serviceTypeLbl.text = serviceType
        self.getScheduleVRIOPIData(customerId: userId)
        
    }
    @IBAction func actionAvilableRequest(_ sender: UIButton) {
        let userId = userDefaults.string(forKey: UserDeafultsString.instance.UserID) ?? ""
        if self.serviceType == "Schedule VRI" {
            self.cType = "1"
        }else if serviceType == "Schedule OPI" {
            self.cType = "0"
        }else {
            
        }
        acceptRequestApi(notificationID: "0", appointmentID: "\(appointmentID)", userID: userId, cType: self.cType)
    }
    @IBAction func actionDeclineRequest(_ sender: UIButton) {
        let userId = userDefaults.string(forKey: UserDeafultsString.instance.UserID) ?? ""
        if self.serviceType == "Schedule VRI" {
            self.cType = "1"
        }else if serviceType == "Schedule OPI" {
            self.cType = "0"
        }
        declineRequestApi(notificationID: "0", appointmentID: "\(appointmentID)", userID: userId, cType: self.cType)
    }
    func declineRequestApi(notificationID : String , appointmentID : String , userID : String , cType :String){
        SwiftLoader.show(animated: true)
                                  
        let urlString =   "https://lsp.totallanguage.com/home/GetData?methodType=APPSCHEDULEACCEPTORDECCLINE&iq=\(appointmentID)&Type=0&ui=\(userID)&CType=\(cType)"
       
        //\(date)"
        print("url to get schedule declineRequestApi\(urlString)")
        AF.request(urlString, method: .get , parameters: nil, encoding: JSONEncoding.default, headers: nil)
            .validate()
            .responseData(completionHandler: { [self] (response) in
                SwiftLoader.hide()
                switch(response.result){
                    
                case .success(_):
                    print("Respose Success ")
                    guard let daata = response.data else { return }
                    do {
                        let jsonDecoder = JSONDecoder()
                        self.apiAcceptByVendorRequestDataModel = try jsonDecoder.decode(ApiAcceptByVendorRequestDataModel.self, from: daata)
                        print("Success")
                        print("ApiAcceptByVendorRequestDataModel DATA IS \(self.apiAcceptByVendorRequestDataModel)")
                        let showMessage = self.apiAcceptByVendorRequestDataModel?.vendorAcceptAndDeclineStatus?.first?.message ?? ""
                        let alert = UIAlertController(title: "Total Language", message: showMessage, preferredStyle: .alert)
                            
                             let ok = UIAlertAction(title: "OK", style: .default, handler: { action in
                                self.navigationController?.popViewController(animated: true)
                             })
                             alert.addAction(ok)
                             DispatchQueue.main.async(execute: {
                                self.present(alert, animated: true)
                        })
                    }
                    catch
                    {
                        print("error block forgot password " ,error)
                    }
                case .failure(_):
                    print("Respose Failure ")
                    
                }
            })
    }
    func acceptRequestApi(notificationID : String , appointmentID : String , userID : String , cType : String ){
        SwiftLoader.show(animated: true)
        let urlString =   "https://lsp.totallanguage.com/home/GetData?methodType=APPSCHEDULEACCEPTORDECCLINE&iq=\(appointmentID)&Type=1&ui=\(userID)&CType=\(cType)"
       
        //\(date)"
        print("url to get schedule getOnsiteData\(urlString)")
        AF.request(urlString, method: .get , parameters: nil, encoding: JSONEncoding.default, headers: nil)
            .validate()
            .responseData(completionHandler: { [self] (response) in
                SwiftLoader.hide()
                switch(response.result){
                    
                case .success(_):
                    print("Respose Success ")
                    guard let daata = response.data else { return }
                    do {
                        let jsonDecoder = JSONDecoder()
                        self.apiAcceptByVendorRequestDataModel = try jsonDecoder.decode(ApiAcceptByVendorRequestDataModel.self, from: daata)
                        print("Success")
                        print("ApiAcceptByVendorRequestDataModel DATA IS \(self.apiAcceptByVendorRequestDataModel)")
                        let showMessage = self.apiAcceptByVendorRequestDataModel?.vendorAcceptAndDeclineStatus?.first?.message ?? ""
                        let alert = UIAlertController(title: "Total Language", message: showMessage, preferredStyle: .alert)
                            
                             let ok = UIAlertAction(title: "OK", style: .default, handler: { action in
                                self.navigationController?.popViewController(animated: true)
                             })
                             alert.addAction(ok)
                             DispatchQueue.main.async(execute: {
                                self.present(alert, animated: true)
                        })
                    }
                    catch
                    {
                        print("error block forgot password " ,error)
                    }
                case .failure(_):
                    print("Respose Failure ")
                    
                }
            })
    }
    
    @IBAction func backBtnTapped(){
        self.navigationController?.popViewController(animated: true)
    }

}

extension ScheduleDetailsVC{
    
    func getScheduleVRIOPIData(customerId:String){
        SwiftLoader.show(animated: true)
        let urlString = "https://lsp.totallanguage.com/CustomerManagement/CustomerDetail/GetData?methodType=SCHEDULVRIDETAILSBYID&id=\(appointmentID)&userid=\(customerId)&Type=1"//\(date)"
        print("url to get schedule \(urlString)")
        AF.request(urlString, method: .get , parameters: nil, encoding: JSONEncoding.default, headers: nil)
            .validate()
            .responseData(completionHandler: { [self] (response) in
                SwiftLoader.hide()
                switch(response.result){
                    
                case .success(_):
                    print("Respose Success ")
                    guard let daata = response.data else { return }
                    do {
                        let jsonDecoder = JSONDecoder()
                        self.apiGetVRIScheduleDataResponseMdel = try jsonDecoder.decode(ApiGetVRIScheduleDataResponseMdel.self, from: daata)
                        print("Success")
                        print("ApiGetVRIScheduleDataResponseMdel DATA IS \(self.apiGetVRIScheduleDataResponseMdel)")
                        
                        print("apiGetVRIScheduleDataResponseMdel \(self.apiGetVRIScheduleDataResponseMdel)")
                        
                        self.sourceLanguageLbl.text = self.apiGetVRIScheduleDataResponseMdel?.sCHEDULVRIDETAILSBYID?.first?.sLanguageName ?? "N/A"
                        self.targetLanguageLbl.text = self.apiGetVRIScheduleDataResponseMdel?.sCHEDULVRIDETAILSBYID?.first?.tLanguageName ?? "N/A"
                        self.dateTimeLbl.text = self.convertDateAndTimeFormat(self.apiGetVRIScheduleDataResponseMdel?.sCHEDULVRIDETAILSBYID?.first?.dateTime ?? "")
                        self.roomNoLbl.text = self.apiGetVRIScheduleDataResponseMdel?.sCHEDULVRIDETAILSBYID?.first?.random ?? "N/A"
                        self.noteLbl.text = self.apiGetVRIScheduleDataResponseMdel?.sCHEDULVRIDETAILSBYID?.first?.notes ?? "N/A"
                        self.statusLbl.text = self.apiGetVRIScheduleDataResponseMdel?.sCHEDULVRIDETAILSBYID?.first?.appointmentStatusType ?? "N/A"
                        
                        } catch{
                        print("error block forgot password " ,error)
                    }
                case .failure(_):
                    print("Respose Failure ")
                    
                }
            })
    }
    
    func convertDateAndTimeFormat(_ date: String) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        if let newdate = dateFormatter.date(from: date) {
            dateFormatter.dateFormat = "MM/dd/yyyy h:mm a"
            return  dateFormatter.string(from: newdate)
        }else {
            return ""
        }
    }
}
