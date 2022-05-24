//
//  TelephoneConferenceDetailsVC.swift
//  TotalVendor
//
//  Created by Shivansh SMIT on 29/12/21.
//

import UIKit
import Alamofire
//1 is Onsite Interpretation 
//2. Is Telephonic Conference
//13 is Virtual meeting

class TelephoneConferenceDetailsVC: UIViewController {
    
    @IBOutlet weak var interpreterNameView: UIView!
    
    
    var appointmentTYPE = "Telephone Conference"
    var urlToOpen = ""
    
    @IBOutlet weak var authenticationCodeView: UIView!
    
    @IBOutlet weak var serviceTypeView: UIView!
    
    @IBOutlet weak var dateView: UIView!
    
    @IBOutlet weak var timeView: UIView!
    
    @IBOutlet weak var contactView: UIView!
    
    @IBOutlet weak var languageView: UIView!
    
    @IBOutlet weak var languageLabel: UILabel!
    
    @IBOutlet weak var descriptionView: UIView!
    
    @IBOutlet weak var conCallsView: UIView!
    
    @IBOutlet weak var conCallsLabel: UILabel!
    
    @IBOutlet weak var statusView: UIView!
    @IBOutlet weak var interpreterNameLbl: UILabel!
//    @IBOutlet weak var specialRequestsView: UIView!
    @IBOutlet weak var casePatientInitialView: UIView!
    
    @IBOutlet weak var casePatientView: UIView!
    
    @IBOutlet weak var authenticationCodelbl: UILabel!
    @IBOutlet weak var serviceTypeLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var statusLbl: UILabel!
//    @IBOutlet weak var specialRequestsLbl: UILabel!
    @IBOutlet weak var linkView: UIView!
    @IBOutlet weak var linkLbl: ActiveLabel!
    @IBOutlet weak var notesLbl: UILabel!
    @IBOutlet weak var notesView: UIView!
    
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var languageLbl: UILabel!
    @IBOutlet weak var patientInitialLbl: UILabel!
    @IBOutlet weak var patientLbl: UILabel!
    @IBOutlet weak var contactLbl: UILabel!
    var serviceType = ""
    @IBOutlet weak var departmentLbl: UILabel!
    @IBOutlet weak var venueAddressLbl: UILabel!
    @IBOutlet weak var venueNameLbl: UILabel!
    @IBOutlet weak var importantNoteLbl: UILabel!
    var apiOnsiteDetailsResponseModel : ApiOnsiteDetailsResponseModel?
    var appointmentID = 0
    var fileName = ""
    var apiAcceptByVendorRequestDataModel:ApiAcceptByVendorRequestDataModel?
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var bottomBtnView: UIStackView!
    @IBOutlet weak var importtentLblView: UIView!
    @IBOutlet weak var serviceVerificationview: UIView!
    @IBOutlet weak var AppointmentInfoLbl: UILabel!
    @IBOutlet weak var titleLblView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

       // self.setupLabelTap()
        let userId = userDefaults.string(forKey: UserDeafultsString.instance.UserID) ?? ""
        self.getOnsiteData(customerId: userId)
     
    }
    
    @objc func labelTapped(_ sender: UITapGestureRecognizer) {
           
        if let url = URL(string: self.urlToOpen) {
            UIApplication.shared.open(url)
        }
        }
    
    func setupLabelTap() {
            
            let labelTap = UITapGestureRecognizer(target: self, action: #selector(self.labelTapped(_:)))
            self.linkLbl.isUserInteractionEnabled = true
            self.linkLbl.addGestureRecognizer(labelTap)
            
        }

    @IBAction func backBtnTapped(){
        self.navigationController?.popViewController(animated: true)
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
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension TelephoneConferenceDetailsVC{
    func getOnsiteData(customerId:String){
        SwiftLoader.show(animated: true)
        let urlString =   "https://lsp.totallanguage.com/Home/GetData?methodType=AppointmentInterpreterData&NotoficationId=0&AppointmentID=\(appointmentID)&Interpreterid=\(customerId)&UserType=6&Userid=\(customerId)"
       
        //\(date)"
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
                        self.apiOnsiteDetailsResponseModel = try jsonDecoder.decode(ApiOnsiteDetailsResponseModel.self, from: daata)
                       
                        let apiData = self.apiOnsiteDetailsResponseModel?.appointmentInterpreterData?.first
                        if apiData?.serviceVerificationName != nil && apiData?.serviceVerificationName != "" {
                            self.fileName = (apiData?.serviceVerificationName!)!
                        }
                        else {
                            self.fileName = ""
                        }
                       
                        
                        if apiData?.text?.replacingOccurrences(of: "\\", with: "").isValidURL ?? false{

                            
                            linkLbl.text = apiData?.text
                            linkLbl.handleURLTap { url in
                                
                                CommonClass.share.activeLinkCall(activeURL: url)
                            }
                            
                            
                        }else {
                            linkLbl.text = apiData?.text
                            linkLbl.removeEmptyString()

                        }
        
                        
                        let companyName = (UserDefaults.standard.value(forKey: UserDeafultsString.instance.CompanyName) as? String) ?? ""
                        
                        let attributesBold = [NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-Bold", size: 14)!,NSAttributedString.Key.foregroundColor: UIColor.darkGray]
                        
                        let attributesBasic = [NSAttributedString.Key.font: UIFont(name: "HelveticaNeue", size: 14)!,NSAttributedString.Key.foregroundColor: UIColor.darkGray]
                        
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
                        if self.serviceType == "Telephone Conference"{
                            self.notesView.visibility = .gone
                            self.conCallsView.visibility = .visible
                        }
                        else {
                            self.notesView.visibility = .visible
                            self.conCallsView.visibility = .gone
                        }
                        
                        self.notesLbl.text = apiData?.location ?? ""
                        
                        self.notesLbl.removeEmptyString()
                        self.interpreterNameLbl.text = apiData?.interpretorName ?? "N/A"
                        //self.customerNameLbl.text = apiData?.customerName ?? "N/A"
                        self.authenticationCodelbl.text = apiData?.authCode ?? "N/A"
                        self.serviceTypeLbl.text = apiData?.appointmentType ?? "N/A"
                        self.dateLbl.text = self.convertTimeFormaterOnlyDate(apiOnsiteDetailsResponseModel?.appointmentInterpreterData?.first?.startDateTime ?? "")
                        let timeZone = "(\(userDefaults.value(forKey: UserDeafultsString.instance.ZoneShortForm) ?? ""))"
                        self.timeLbl.text = "\(self.convertTimeFormater(apiOnsiteDetailsResponseModel?.appointmentInterpreterData?.first?.startDateTimeTemp ??  "")) \(timeZone) - \(self.convertTimeFormater(apiOnsiteDetailsResponseModel?.appointmentInterpreterData?.first?.endDateTime ?? "")) (Estimated)"
                        
                        
                        self.contactLbl.text = (apiData?.providerName != "") ? apiData?.providerName : "N/A"
                        self.contactLbl.removeEmptyString()
                        self.patientLbl.text = (apiData?.caseNumber != "") ? apiData?.caseNumber : "N/A"
                        self.patientLbl.removeEmptyString()
                        self.patientInitialLbl.text = (apiData?.cPIntials != "") ? apiData?.cPIntials : "N/A"
                        self.patientInitialLbl.removeEmptyString()
                        self.languageLbl.text = self.apiOnsiteDetailsResponseModel?.appointmentInterpreterData?.first?.languageName ?? "N/A"
                        self.conCallsLabel.text = (apiData?.location != "") ? apiData?.location : "N/A"
                        self.conCallsLabel.removeEmptyString()
                        
                        if apiData?.text == "" || apiData?.text == nil{
                            self.linkLbl.removeEmptyString()
                        }
                        
//                        self.linkLbl.text = apiData?.text
//                        self.linkLbl.removeEmptyString()
                        self.descriptionLbl.text = apiData?.aptDetails ?? "N/A"
                        self.descriptionLbl.removeEmptyString()
                        self.statusLbl.text = self.apiOnsiteDetailsResponseModel?.appointmentInterpreterData?.first?.appointmentStatusType ?? "N/A"
                        let userId = userDefaults.string(forKey: UserDeafultsString.instance.UserID) ?? ""
                        if (apiData?.appointmentStatusID == "1" || apiData?.appointmentStatusID == "7" || apiData?.appointmentStatusID == "8") && (apiData?.interpreterID == Int(userId)){
                            //                            BOOKED APPOINTMENT AND WHOLE DATA AND SERVICE VERIFICATION FORM NEEDS TO BE SHOWN
                            
                            self.statusLbl.text = "Booked"
                            
                            self.serviceVerificationview.visibility = .visible
                            
                            self.interpreterNameView.visibility = .visible
                            self.authenticationCodeView.visibility = .visible
                            self.serviceTypeView.visibility = .visible
                            self.dateView.visibility = .visible
                            self.timeView.visibility = .visible
                            self.contactView.visibility = .visible
                            self.casePatientView.visibility = .visible
                            self.casePatientInitialView.visibility = .visible
                            self.languageView   .visibility = .visible
//                            self.conCallsView.visibility = .visible
                            self.linkView.visibility = .visible
                            self.statusView.visibility = .visible
                            self.bottomBtnView.isHidden = true
                            self.AppointmentInfoLbl.visibility = .gone
                        }else {
                            
                            self.serviceVerificationview.visibility = .gone
                            self.interpreterNameView.visibility = .visible
                            self.authenticationCodeView.visibility = .visible
                            self.serviceTypeView.visibility = .visible
                            self.dateView.visibility = .visible
                            self.timeView.visibility = .visible
                            self.contactView.visibility = .gone
                            self.casePatientView.visibility = .gone
                            self.casePatientInitialView.visibility = .gone
                            self.languageView.visibility = .visible
//                            self.conCallsView.visibility = .visible
                            self.linkView.visibility = .gone
                            self.descriptionView.visibility = .visible
                            self.statusView.visibility = .visible
                            if (apiData?.appointmentStatusID == "2" || apiData?.appointmentStatusID == "11") && (apiData?.acceptAndDeclineStatus == nil){
                                
                                self.AppointmentInfoLbl.visibility = .visible
                                                       self.titleLbl.text = "Availability Inquiry"
        let coName = apiData?.companyName ?? ""
                                self.AppointmentInfoLbl.text = "\(coName) has sent you an INQUIRY. Please check your availability and select the option below to indicate if you are available or have to decline the work."
                                bottomBtnView.isHidden=false
                                
                            }else {
                                self.titleLbl.text = "\(apiData?.appointmentStatusType ?? "") Appointment"
                                self.AppointmentInfoLbl.visibility = .gone
                                
                            }

                            
                            if (apiData?.appointmentStatusID == "2") && (apiData?.acceptAndDeclineStatus == nil) && (apiData?.isAssigned == nil){
                                self.statusLbl.text = "Not Booked"
                                self.bottomBtnView.isHidden = false
                            }else if (apiData?.appointmentStatusID == "11") && (apiData?.acceptAndDeclineStatus == true) && (apiData?.isAssigned == nil) && (apiData?.interpreterID == 0 || apiData?.interpreterID ==  Int(userId) || apiData?.interpreterID == nil) {
                                self.statusLbl.text = "\(apiData?.appointmentStatusType ?? "")"
                                self.bottomBtnView.isHidden = true
                            }else if  (apiData?.acceptAndDeclineStatus == false) {
                                self.statusLbl.text = "Unavailable Appointment"
                                self.bottomBtnView.isHidden = true
                            }else {
                                self.bottomBtnView.isHidden = true
                            }
                        }
                        
                        
                        if apiData?.appointmentStatusID == "2" || apiData?.appointmentStatusID == "11"{
                            self.importtentLblView.visibility = .visible
                            self.importantNoteLbl.attributedText = finalNoteString
                            
                        }else if apiData?.appointmentStatusID == "1" || apiData?.appointmentStatusID == "7" || apiData?.appointmentStatusID == "8"{
                            self.importtentLblView.visibility = .visible
                            self.importantNoteLbl.attributedText = finalImportantString
                        }else
                        {
                            self.importtentLblView.visibility = .gone
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
    

    
    func previewFiles(fileName : String ,serviceType:String , completionHandler : @escaping(Bool? , String?) -> ()){
        SwiftLoader.show(animated: true)
        let urlString =   "https://lsp.totallanguage.com/PreviewFiles/Previewawsfiles?filename=\(fileName)&type=\(serviceType)"
       
        //\(date)"
        print("url to get previewFiles\(urlString)")
        AF.request(urlString, method: .get , parameters: nil, encoding: JSONEncoding.default, headers: nil)
            .validate()
            .responseData(completionHandler: { [self] (response) in
                SwiftLoader.hide()
                switch(response.result){
                    
                case .success(_):
                    print("Respose Success ")
                    guard let daata = response.data else { return }
                    print(String(data: daata, encoding: .utf8)!)
                    let fileURL = String(data: daata, encoding: .utf8)!
                    print("file path  is ",fileURL)
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
}

extension TelephoneConferenceDetailsVC{
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



extension String {
    var isValidURL: Bool {
        let detector = try! NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        if let match = detector.firstMatch(in: self, options: [], range: NSRange(location: 0, length: self.utf16.count)) {
            // it is a link, if the match covers the whole string
            return match.range.length == self.utf16.count
        } else {
            return false
        }
    }
}
