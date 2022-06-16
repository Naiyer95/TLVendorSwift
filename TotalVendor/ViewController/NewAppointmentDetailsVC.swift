//
//  NewAppointmentDetailsVC.swift
//  TotalVendor
//
//  Created by Shivansh SMIT on 27/12/21.
//

import UIKit
import Alamofire

class NewAppointmentDetailsVC: UIViewController {
    
    @IBOutlet weak var venueNameView: UIView!
    @IBOutlet weak var specialRequestsView: UIView!
    @IBOutlet weak var departmentView: UIView!
    @IBOutlet weak var contactView: UIView!
    @IBOutlet weak var specialityView: UIView!
    @IBOutlet weak var statusView: UIView!
    @IBOutlet weak var descriptionView: UIView!
    @IBOutlet weak var languageView: UIView!
    @IBOutlet weak var casePatientInitialView: UIView!
    @IBOutlet weak var casePatientView: UIView!
    @IBOutlet weak var interpreterNameView: UIView!
    @IBOutlet weak var timeView: UIView!
    @IBOutlet weak var dateView: UIView!
    @IBOutlet weak var servicetypeView: UIView!
    @IBOutlet weak var authenticationCodeView: UIView!
    
    @IBOutlet weak var importtentLblView: UIView!
    @IBOutlet weak var interpreterNameLbl: UILabel!
    @IBOutlet weak var customerNameLbl: UILabel!
    @IBOutlet weak var lblNotes: UILabel!
    @IBOutlet weak var authenticationCodelbl: UILabel!
    @IBOutlet weak var serviceTypeLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var statusLbl: UILabel!
    @IBOutlet weak var specialRequestsLbl: UILabel!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var languageLbl: UILabel!
    @IBOutlet weak var patientInitialLbl: UILabel!
    @IBOutlet weak var patientLbl: UILabel!
    @IBOutlet weak var specialityLbl: UILabel!
    @IBOutlet weak var contactLbl: UILabel!
    @IBOutlet weak var departmentLbl: UILabel!
    @IBOutlet weak var venueAddressLbl: UILabel!
    @IBOutlet weak var venueNameLbl: UILabel!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var bottomBtnView: UIStackView!
    @IBOutlet weak var importantNoteLbl: UILabel!
    @IBOutlet weak var locationView: UIView!
    var companyName = ""
    var appointmentID = 0
    var isfromfcm = false
    var serviceType = ""
    var apiOnsiteDetailsResponseModel : ApiOnsiteDetailsResponseModel?
    var appointmentType = ""
    var fileName = ""
    var apiAcceptByVendorRequestDataModel:ApiAcceptByVendorRequestDataModel?
    @IBOutlet weak var serviceVerificationview: UIView!
    @IBOutlet weak var AppointmentInfoLbl: UILabel!
    @IBOutlet weak var venueAddressViewOutlet: UIView!
    @IBOutlet weak var titleLblView: UIView!
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden=true
        self.departmentView.visibility = .gone
        self.casePatientView.visibility = .gone
        self.casePatientInitialView.visibility = .gone
        self.casePatientInitialView.visibility = .gone
        self.contactView.visibility = .gone
        self.specialRequestsView.visibility = .gone
        self.venueNameView.visibility = .gone
        companyName = (UserDefaults.standard.value(forKey: UserDeafultsString.instance.CompanyName) as? String) ?? ""
        let userId = userDefaults.string(forKey: UserDeafultsString.instance.UserID) ?? ""
        self.getOnsiteData(customerId: userId)
        //  GetPublicData.sharedInstance.
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.servicetypeView.visibility = .gone
        // importantNoteLbl.text = "*** Important: Please note that an interpreter cannot cancel/return an appointment without speaking to someone at '\(companyName)' directly. Not via email nor voicemail. All returns are to be discussed with '\(companyName)'"
    }
    
    @IBAction func actionAvilableRequest(_ sender: UIButton) {
        let userId = userDefaults.string(forKey: UserDeafultsString.instance.UserID) ?? ""
        acceptRequestApi(notificationID: "0", appointmentID: "\(appointmentID)", userID: userId)
    }
    @IBAction func actionDeclineRequest(_ sender: UIButton) {
        let userId = userDefaults.string(forKey: UserDeafultsString.instance.UserID) ?? ""
        declineRequestApi(notificationID: "0", appointmentID: "\(appointmentID)", userID: userId)
    }
    
    @IBAction func actionShowDoc(_ sender: UIButton) {
        let filename = self.fileName.replacingOccurrences(of: " ", with: "%20")
        
        previewFiles(fileName: filename, serviceType: "TempServiceFile") { (completion, fileNameNew) in
            print("file name is ", fileNameNew ?? "")
            let vc = self.storyboard?.instantiateViewController(identifier: "ServiceVerificationURLViewController") as! ServiceVerificationURLViewController
            vc.isFromRegular=true
            vc.serviceURL = fileNameNew ?? ""
            vc.fileName = filename
            vc.isfromfcm = self.isfromfcm
         
            if self.isfromfcm {
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true, completion: nil)
            }
            else {
                self.navigationController?.pushViewController(vc, animated: true)
            }
           
        }
    }
    
    @IBAction func backBtnTapped(){
        if isfromfcm {
           dismiss(animated: true)
        }
        else {
            self.navigationController?.popViewController(animated: true)
        }
        
    }
    
    func previewFiles(fileName : String ,serviceType:String , completionHandler : @escaping(Bool? , String?) -> ()){
        SwiftLoader.show(animated: true)
        let urlString =   "https://lsp.totallanguage.com/PreviewFiles/Previewawsfiles?filename=\(fileName)&type=\(serviceType)"
    
        AF.request(urlString, method: .get , parameters: nil, encoding: JSONEncoding.default, headers: nil)
            .validate()
            .responseData(completionHandler: { [self] (response) in
                SwiftLoader.hide()
                switch(response.result){
                    
                case .success(_):
                    
                    guard let daata = response.data else { return }
                    print(String(data: daata, encoding: .utf8)!)
                    let fileURL = String(data: daata, encoding: .utf8)!
                   
                    completionHandler(true , fileURL)
                    
                case .failure(_):
                    print("Respose Failure ")
                    completionHandler(false , nil)
                }
            })
    }
 
    func declineRequestApi(notificationID : String , appointmentID : String , userID : String){
        SwiftLoader.show(animated: true)
        let urlString =   "https://lsp.totallanguage.com/Home/GetData?methodType=VendorAcceptAndDeclineStatus&NotoficationId=\(notificationID)&type=0&AppointmentID=\(appointmentID)&UserId=\(userID)&IsUpdated=&smsflog=4"
        
        print("url to get schedule declineRequestApi\(urlString)")
        AF.request(urlString, method: .get , parameters: nil, encoding: JSONEncoding.default, headers: nil)
            .validate()
            .responseData(completionHandler: { [self] (response) in
                SwiftLoader.hide()
                switch(response.result){
                case .success(_):
                   
                    guard let daata = response.data else { return }
                    do {
                        let jsonDecoder = JSONDecoder()
                        self.apiAcceptByVendorRequestDataModel = try jsonDecoder.decode(ApiAcceptByVendorRequestDataModel.self, from: daata)
                       
                       
                        let showMessage = self.apiAcceptByVendorRequestDataModel?.vendorAcceptAndDeclineStatus?.first?.message ?? ""
                        let alert = UIAlertController(title: "Confirmation", message: showMessage, preferredStyle: .alert)
                        
                        let ok = UIAlertAction(title: "OK", style: .default, handler: { action in
                            if self.isfromfcm{
                                self.dismiss(animated: true)
                            }
                            else {
                                self.navigationController?.popViewController(animated: true)
                            }
                           
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
    func acceptRequestApi(notificationID : String , appointmentID : String , userID : String ){
        SwiftLoader.show(animated: true)
        let urlString =   "https://lsp.totallanguage.com/Home/GetData?methodType=VendorAcceptAndDeclineStatus&NotoficationId=\(notificationID)&type=1&AppointmentID=\(appointmentID)&UserId=\(userID)&IsUpdated=&smsflog=4"
        
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
                        let alert = UIAlertController(title: "Alert", message: showMessage, preferredStyle: .alert)
                        
                        let ok = UIAlertAction(title: "OK", style: .default, handler: { action in
                            if self.isfromfcm{
                                self.dismiss(animated: true)
                            }
                            else {
                                self.navigationController?.popViewController(animated: true)
                            }
                            
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
}

extension NewAppointmentDetailsVC{
    func getOnsiteData(customerId:String){
        SwiftLoader.show(animated: true)
        let urlString =   "https://lsp.totallanguage.com/Home/GetData?methodType=AppointmentInterpreterData&NotoficationId=0&AppointmentID=\(appointmentID)&Interpreterid=\(customerId)&UserType=6&Userid=\(customerId)"
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
                        self.apiOnsiteDetailsResponseModel = try jsonDecoder.decode(ApiOnsiteDetailsResponseModel.self, from: daata)
                        
                        let attributesBold = [NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-Bold", size: 17)!,NSAttributedString.Key.foregroundColor: UIColor.black]
                        
                        let attributesBasic = [NSAttributedString.Key.font: UIFont(name: "HelveticaNeue", size: 17)!,NSAttributedString.Key.foregroundColor: UIColor.black]
                        
                        let attriStringNote = NSAttributedString(string:"Note:", attributes:attributesBold)
                        let attriStringImportant = NSAttributedString(string:"***Important:", attributes:attributesBold)
                        
                        
                        let attriBasicNote = NSAttributedString(string:" Before you click that you are available, it is expected that you will have checked your personal schedule and will be committed to provide the service. Giving back an appointment once you have been Booked costs time and money and can lead to Botched appointments for the client and a possible termination for the interpreter. Please be sure you have no other scheduling conflicts.", attributes:attributesBasic)
                        
                        let attriBasicImportant = NSAttributedString(string:" Please note that an interpreter cannot cancel/return an appointment without speaking to someone at \(companyName) directly. Not via email nor voicemail. All returns are to be discussed with \(companyName) Scheduling staff.", attributes:attributesBasic)
                        
                        
                        let finalNoteString = NSMutableAttributedString()
                        finalNoteString.append(attriStringNote)
                        finalNoteString.append(attriBasicNote)
                        
                        
                        let finalImportantString = NSMutableAttributedString()
                        finalImportantString.append(attriStringImportant)
                        finalImportantString.append(attriBasicImportant)
                       
                        
                        let apiData = self.apiOnsiteDetailsResponseModel?.appointmentInterpreterData?.first
                        self.fileName = apiData?.serviceVerificationName ?? ""
                       
                        if (apiData?.appointmentStatusID == "1" || apiData?.appointmentStatusID == "7" || apiData?.appointmentStatusID == "8") && (apiData?.interpreterID == Int(customerId)){
                            self.locationView.visibility = .visible
                            self.serviceVerificationview.visibility = .visible
                            self.interpreterNameView.visibility = .visible
                            self.authenticationCodeView.visibility = .visible
                            self.dateView.visibility = .visible
                            self.timeView.visibility = .gone
                            self.venueNameView.visibility = .visible
                            self.venueAddressViewOutlet.visibility = .visible
                            self.venueAddressLbl.text = "\(apiData?.address ?? ""), \(apiData?.city ?? ""), \(apiData?.stateName ?? ""), \(apiData?.zipcode ?? "")"
                            self.venueAddressLbl.removeEmptyString()
                            self.departmentView.visibility = .visible
                            self.contactView.visibility = .visible
                            self.specialityView.visibility = .visible
                            self.casePatientView.visibility = .visible
                            self.casePatientInitialView.visibility = .visible
                            self.languageView.visibility = .visible
                            self.descriptionView.visibility = .visible
                            self.bottomBtnView.isHidden = true
                        }
                        else if (apiData?.appointmentStatusID == "2" || apiData?.appointmentStatusID == "11") && (apiData?.acceptAndDeclineStatus == nil){
                            self.venueAddressLbl.text = "\(apiData?.city ?? ""), \(apiData?.stateName ?? "")"
                            self.venueAddressLbl.removeEmptyString()
                            self.serviceVerificationview.visibility = .gone
                            self.interpreterNameView.visibility = .visible
                            self.authenticationCodeView.visibility = .visible
                            self.servicetypeView.visibility = .gone
                            self.dateView.visibility = .visible
                            self.timeView.visibility = .gone
                            
                            self.venueNameView.visibility = .gone
                            self.specialityView.visibility = .visible
                            self.venueAddressViewOutlet.visibility = .visible
                            self.specialityView.visibility = .visible
                            self.departmentView.visibility = .gone
                            self.contactView.visibility = .gone
                            self.casePatientView.visibility = .gone
                            self.casePatientInitialView.visibility = .gone
                            self.languageView.visibility = .visible
                            self.descriptionView.visibility = .visible
                            self.bottomBtnView.isHidden = false
                            self.locationView.visibility = .gone
                        }
                        else {
                            self.venueAddressLbl.text = "\(apiData?.city ?? ""), \(apiData?.stateName ?? "")"
                            self.venueAddressLbl.removeEmptyString()
                            self.serviceVerificationview.visibility = .gone
                            self.bottomBtnView.isHidden = true
                            self.interpreterNameView.visibility = .visible
                            self.authenticationCodeView.visibility = .visible
                            self.servicetypeView.visibility = .gone
                            self.dateView.visibility = .visible
                            self.timeView.visibility = .gone
                            
                            self.venueNameView.visibility = .gone
                            self.venueAddressViewOutlet.visibility = .visible
                            self.specialityView.visibility = .visible
                            self.departmentView.visibility = .gone
                            self.contactView.visibility = .gone
                            
                            self.casePatientView.visibility = .gone
                            self.casePatientInitialView.visibility = .gone
                            self.languageView.visibility = .visible
                            self.descriptionView.visibility = .visible
                            self.locationView.visibility = .gone
                            
                        }
                        self.interpreterNameLbl.text = apiData?.interpretorName ?? "N/A"
                        self.interpreterNameLbl.removeEmptyString()
                        self.authenticationCodelbl.text = apiData?.authCode ?? "N/A"
                        self.authenticationCodelbl.removeEmptyString()
                        self.serviceTypeLbl.text = apiData?.serviceType ?? "N/A"
                        self.serviceTypeLbl.removeEmptyString()
                        self.venueNameLbl.text = apiData?.venueName ?? "N/A"
                        self.venueNameLbl.removeEmptyString()
                        self.departmentLbl.text = apiData?.departmentName ?? "N/A"
                        self.departmentLbl.removeEmptyString()
                        self.contactLbl.text = apiData?.providerName ?? "N/A"
                        self.contactLbl.removeEmptyString()
                        self.specialityLbl.text = apiData?.displayValue ?? "N/A"
                        self.specialityLbl.removeEmptyString()
                        self.patientLbl.text = apiData?.caseNumber ?? "N/A"
                        self.patientLbl.removeEmptyString()
                        self.patientInitialLbl.text = apiData?.cPIntials ?? "N/A"
                        self.patientInitialLbl.removeEmptyString()
                        self.languageLbl.text = apiData?.languageName ?? "N/A"
                        self.languageLbl.removeEmptyString()
                        self.descriptionLbl.text = apiData?.aptDetails ?? "N/A"
                        self.descriptionLbl.removeEmptyString()
                        self.statusView.visibility = .visible
                        lblNotes.text = apiData?.text ?? "N/A"
                        self.lblNotes.removeEmptyString()
                        lblLocation.text = apiData?.location ?? "N/A"
                        self.lblLocation.removeEmptyString()
                        let sDate = self.convertDateAndTimeFormat(apiData?.startDateTimeTemp ?? "")
                        let eTime = self.convertTimeFormater(apiData?.endDateTime ?? "")
                        
                        let stringInput = apiData?.label ?? ""
                        let stringInputArr = stringInput.components(separatedBy:" ")
                        var stringNeed = ""
                        
                        for string in stringInputArr {
                            stringNeed += String(string.first!)
                        }
                        self.dateLbl.text = "\(sDate) (\(stringNeed)) - \(eTime) (Estimated)"
                        if (apiData?.appointmentStatusID == "2")&&(apiData?.acceptAndDeclineStatus == nil)&&(apiData?.isAssigned == nil)&&(apiData?.interpreterID == nil || apiData?.interpreterID == 0){
                            
                            self.statusLbl.text = "Not Booked"
                        }
                        else if (apiData?.appointmentStatusID == "2" || apiData?.appointmentStatusID == "11")&&(apiData?.acceptAndDeclineStatus == true)&&(apiData?.isAssigned == nil)&&(apiData?.interpreterID == nil || apiData?.interpreterID == 0){
                            
                            self.statusLbl.text = "\(apiData?.appointmentStatusType ?? "")"
                        }else if (apiData?.appointmentStatusID == "2" || apiData?.appointmentStatusID == "11" || apiData?.appointmentStatusID == "1")&&(apiData?.acceptAndDeclineStatus == false){
                            
                            self.statusLbl.text = "Unavailable Appointment"
                        }else if (apiData?.appointmentStatusID == "1" || apiData?.appointmentStatusID == "7" || apiData?.appointmentStatusID == "8") && (apiData?.interpreterID == Int(customerId)) {
                            self.statusLbl.text = "Booked"
                        }else {
                            self.statusLbl.text = apiData?.appointmentStatusType ?? ""
                        }
                        
                        if (apiData?.appointmentStatusID == "2" || apiData?.appointmentStatusID == "11"){
                            self.importtentLblView.visibility = .visible
                           
                            self.importantNoteLbl.attributedText = finalNoteString
                            self.importtentLblView.backgroundColor = .clear
                        }else if (apiData?.appointmentStatusID == "1" || apiData?.appointmentStatusID == "7" || apiData?.appointmentStatusID == "8"){
                            self.importtentLblView.visibility = .visible
                            self.importtentLblView.backgroundColor = UIColor(hex: "FFF700")
                            
                            self.importantNoteLbl.attributedText = finalImportantString
                        }else {
                            self.importtentLblView.visibility = .gone
                        }
                        
                        if (apiData?.appointmentStatusID == "2" || apiData?.appointmentStatusID == "11") && (apiData?.acceptAndDeclineStatus == nil || apiData?.acceptAndDeclineStatus == true ){
                            self.titleLbl.text = "Availability Inquiry"
                        }else if (apiData?.acceptAndDeclineStatus ==  false) {
                            self.titleLbl.text = "Unavailable Appointment"
                        }
                        else {
                            
                            self.titleLbl.text = "\(apiData?.appointmentStatusType ?? "") Appointment"
                        }
                        if (apiData?.appointmentStatusType ?? "") == "Not Booked"{
                            self.titleLbl.text = "Availability Inquiry"
                        }
                        if (apiData?.appointmentStatusID == "2" || apiData?.appointmentStatusID == "11") && (apiData?.acceptAndDeclineStatus == nil){
                            
                            self.titleLbl.text = "Availability Inquiry"
                            self.AppointmentInfoLbl.text = "\(companyName) has sent you an INQUIRY. Please check your availability and select the option below to indicate if you are available or have to decline the work."
                            self.AppointmentInfoLbl.isHidden=false
                            
                        }else {
                            self.AppointmentInfoLbl.isHidden=true
                            self.titleLbl.text = "\(apiData?.appointmentStatusType ?? "") Appointment"
                        }
   
                        if apiData?.serviceVerificationName == nil || apiData?.serviceVerificationName == ""{
                            self.serviceVerificationview.visibility = .gone
                        }
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
}

extension NewAppointmentDetailsVC{
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
    func convertTimeFormater(_ date: String) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        if let newdate = dateFormatter.date(from: date) {
            dateFormatter.dateFormat = "h:mm a"
            return  dateFormatter.string(from: newdate)
        }else {
            return ""
        }
    }
    
    func convertTimeFormaterOnlyDate(_ date: String) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        if let newdate = dateFormatter.date(from: date) {
            dateFormatter.dateFormat = "MM/dd/yyyy"
            return  dateFormatter.string(from: newdate)
        }else {
            return ""
        }
    }
}

extension UILabel {
    func removeEmptyString(){
        if self.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || self.text?.trimmingCharacters(in: .whitespacesAndNewlines) == nil{
            self.text = "N/A"
        }
    }
}
