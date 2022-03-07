//
//  VendorTimeOffAddEditionVC.swift
//  TotalVendor
//
//  Created by Shivansh SMIT on 02/02/22.
//

import UIKit
import Alamofire

class VendorTimeOffAddEditionVC: UIViewController {

    @IBOutlet weak var timeOffHeading: UILabel!
    @IBOutlet weak var endDateTimeTF: UITextField!
    @IBOutlet weak var startDateTimeTF: UITextField!
    @IBOutlet weak var timeOffEventTF: UITextField!
    @IBOutlet weak var vendorNameTF: UITextField!
    @IBOutlet weak var customerCoTF: UITextField!
    var apiUpdateVenorTimeOffResponseModel : ApiUpdateVenorTimeOffResponseModel?
    var timeOfId = 0
    var timeOffEventData=""
    var startDateTimeDate=""
    var endDateTimeDate=""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if timeOfId == 0{
            timeOffHeading.text = "Add Time Off"
        }else {
            timeOffHeading.text = "Edit Time Off"
        }
        self.timeOffEventTF.text = timeOffEventData
        self.startDateTimeTF.text = startDateTimeDate
        self.endDateTimeTF.text = endDateTimeDate
        
        self.customerCoTF.setLeftPaddingPoints(10)
        self.vendorNameTF.setLeftPaddingPoints(10)
        self.timeOffEventTF.setLeftPaddingPoints(10)
        self.startDateTimeTF.setLeftPaddingPoints(10)
        self.endDateTimeTF.setLeftPaddingPoints(10)
        
        
        customerCoTF.text = UserDefaults.standard.value(forKey: UserDeafultsString.instance.CompanyName) as? String ?? ""
        vendorNameTF.text = UserDefaults.standard.value(forKey: UserDeafultsString.instance.fullName) as? String ?? ""
        self.customerCoTF.isUserInteractionEnabled = false
        self.vendorNameTF.isUserInteractionEnabled = false
        
        self.startDateTimeTF.setRightViewIcon(icon: UIImage(systemName: "calendar")!, txtField: startDateTimeTF)
        self.endDateTimeTF.setRightViewIcon(icon: UIImage(systemName: "calendar")!, txtField: endDateTimeTF)
    }
    
    @IBAction func startDateTimeBtnTapped(_ sender: Any) {
        RPicker.selectDate(title: "Select Date & Time", cancelText: "Cancel", datePickerMode: .dateAndTime,didSelectDate: {[weak self] (selectedDate) in
                        // TODO: Your implementation for date
                        self?.startDateTimeTF.text = selectedDate.dateString("MM/dd/yyyy hh:mm a")
               })
    }
    
    
    @IBAction func endDateTimeBtnTapped(_ sender: Any) {
        RPicker.selectDate(title: "Select Date & Time", cancelText: "Cancel", datePickerMode: .dateAndTime,didSelectDate: {[weak self] (selectedDate) in
                        // TODO: Your implementation for date
                        self?.endDateTimeTF.text = selectedDate.dateString("MM/dd/yyyy hh:mm a")
                    })
        
    }
    
    
    
    @IBAction func backBtnTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func submitBtnTapped(_ sender: Any) {
       
        guard let customerCompany = self.customerCoTF.text, !customerCompany.isEmpty else {
            self.view.makeToast("Please enter valid Customer Company")
            return
        }
        guard let vendorName = self.vendorNameTF.text, !vendorName.isEmpty else {
            self.view.makeToast("Please enter valid Vendor Name")
            return
        }
        guard let eventNameTimeOff = self.timeOffEventTF.text, !eventNameTimeOff.isEmpty else {
            self.view.makeToast("Please enter valid Time Off Event")
            return
        }
        guard let startDateTime = self.startDateTimeTF.text, !startDateTime.isEmpty else {
            self.view.makeToast("Please enter valid Start Date Time")
            return
        }
        guard let endDateTime = self.endDateTimeTF.text, !endDateTime.isEmpty else {
            self.view.makeToast("Please enter valid End Date Time")
            return
        }
        
        
        if startDateTime > endDateTime{
            self.view.makeToast("Start time cannot be greater than End Time")
        }else {
            self.updateVendorTimeOffData(eventName: eventNameTimeOff, fromDateTime: startDateTime, toDateTime: endDateTime)
        }
    }
    
    
}

extension VendorTimeOffAddEditionVC{
    
    func updateVendorTimeOffData(eventName:String,fromDateTime:String,toDateTime:String){
        SwiftLoader.show(animated: true)
        let companyName = userDefaults.value(forKey: UserDeafultsString.instance.CompanyName) ?? ""
        let vendorID = userDefaults.value(forKey: UserDeafultsString.instance.UserID) ?? 0
        let companyID = userDefaults.value(forKey: UserDeafultsString.instance.CompanyID) ?? 0
        let parameterss = ["VendorTimeOffID":self.timeOfId,
                           "EventName":eventName,
                           "CompanyID":companyID,
                           "VendorID":vendorID,
                           "FromDateTime":fromDateTime,
                           "ToDateTime":toDateTime,
                           "Active":true,
                           "CompanyName":companyID] as! [String : Any]
        let userID = userDefaults.value(forKey: UserDeafultsString.instance.UserID) ?? 0
        let urlString = "https://lsp.totallanguage.com/VendorManagement/VendorTimeOff/AddUpdateVendorTimeOff"
        print("API HIT DATA IS \(urlString) and parameter is \(parameterss)")
        AF.request(urlString, method: .post , parameters: parameterss, encoding: JSONEncoding.default, headers: nil)
            .validate()
            .responseData(completionHandler: { [self] (response) in
                SwiftLoader.hide()
                switch(response.result){
                    
                case .success(_):
                    print("Respose Success ")
                    guard let daata = response.data else { return }
                    do {
                        let jsonDecoder = JSONDecoder()
                        self.apiUpdateVenorTimeOffResponseModel = try jsonDecoder.decode(ApiUpdateVenorTimeOffResponseModel.self, from: daata)
                        print("Success")
                        print("getVendorTimeOffData DATA IS \(self.apiUpdateVenorTimeOffResponseModel)")
                        if apiUpdateVenorTimeOffResponseModel?.vendorTimeOffs?.first?.success == 1{
                            
                            
                            if timeOfId == 0 {
                                self.view.makeToast("VendorTimeOff Added successfully")
                            }else {
                                self.view.makeToast("VendorTimeOff Edited successfully")
                            }
                            
                            let seconds = 2.0
                            DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
                                self.dismiss(animated: true, completion: nil)
                                NotificationCenter.default.post(name: Notification.Name("refreshTimeOffData"), object: nil, userInfo: nil)
                            }
                            
                            
                          

                        }else {
                            self.view.makeToast(apiUpdateVenorTimeOffResponseModel?.vendorTimeOffs?.first?.message ?? "")
                            return
                        }
                        
    

                    } catch{
                        print("error block forgot password " ,error)
                    }
                case .failure(_):
                    print("Respose Failure ")
                    
                }
            })
    }
}


extension UITextField{
    func setLeftPaddingPoints(_ amount:CGFloat){
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
            self.leftView = paddingView
            self.leftViewMode = .always
        }
        func setRightPaddingPoints(_ amount:CGFloat) {
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
            self.rightView = paddingView
            self.rightViewMode = .always
        }
    
    func setLeftViewIcon(image: UIImage, textField: UITextField){
            let imageView = UIImageView(image: image)
            imageView.contentMode = .scaleAspectFit
            let view = UIView(frame: CGRect(x: 0, y: 0, width: 60, height: 50))
            imageView.frame = CGRect(x: 15, y: 15, width: 20, height: 18)
            //For Setting extra padding other than Icon.
            let seperatorView = UIView(frame: CGRect(x: 23, y: 0, width: 10, height: 50))
            view.addSubview(seperatorView)
            textField.leftViewMode = .always
            view.addSubview(imageView)
            textField.leftViewMode = UITextField.ViewMode.always
            textField.leftView = view
        }
    
    func setRightViewIcon(icon: UIImage , txtField : UITextField) {
            
            
            let btnView = UIButton(frame: CGRect(x: 0, y: 0, width:80, height: 80))
            btnView.tintColor = UIColor(hex: "#199DD9")
            btnView.setImage(icon, for: .normal)
            btnView.imageEdgeInsets = UIEdgeInsets(top: -10, left: -36, bottom: -10, right:  10)
            btnView.imageView?.contentMode = .scaleAspectFit
            txtField.rightViewMode = .always
            txtField.rightView = btnView
        }
    /*
        @objc func showButtonTapped(_ sender: UIButton) {
                    sender.isSelected = !sender.isSelected
                    if sender.isSelected{
                        sender.setImage(UIImage(named: "ic_remove_red_eye_24px-1"), for: .normal)
                        passwordTF.isSecureTextEntry=false
                    }
                    else {
                        sender.setImage(UIImage(named: "ic_remove_red_eye_24px-1"), for: .normal)
                        passwordTF.isSecureTextEntry=true
                    }
        }
    */
    
  
}

