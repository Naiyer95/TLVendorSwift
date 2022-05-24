//
//  BlockedAppointmentTelephonicConferenceDetails.swift
//  TotalVendor
//
//  Created by Shivansh SMIT on 27/02/22.
//

import UIKit
import Alamofire

class BlockedAppointmentTelephonicTVC:UITableViewCell{
    
    @IBOutlet weak var locationLbl: ActiveLabel!
    @IBOutlet weak var locationView: UIView!
    @IBOutlet weak var genderView: UIView!
    @IBOutlet weak var genderLbl: UILabel!
    @IBOutlet weak var departmentView: UIView!
    @IBOutlet weak var jobTypeLbl: UILabel!
    @IBOutlet weak var departmentLbl: UILabel!
    @IBOutlet weak var venueNameView: UIView!
    @IBOutlet weak var venueNameLbl: UILabel!
    @IBOutlet weak var venueAddressLbl: UILabel!
    @IBOutlet weak var departmentLblNew: UILabel!
    @IBOutlet weak var venueAddressView: UIView!
    @IBOutlet weak var collapseBtnOutlet: UIButton!
    @IBOutlet weak var appointmentDetailsUIView: UIView!
    @IBOutlet weak var appointmentLbl: UILabel!
    @IBOutlet weak var arrowOutlet: UIImageView!
    @IBOutlet weak var interpreterNameView: UIView!
    @IBOutlet weak var interpreterNameLbl: UILabel!
    @IBOutlet weak var authenticationCodeView: UIView!
    @IBOutlet weak var authenticationCodeLbl: UILabel!
    @IBOutlet weak var serviceTypeVie: UIView!
    @IBOutlet weak var serviceTypeLbl: UILabel!
    @IBOutlet weak var dateTimeView: UIView!
    
    @IBOutlet weak var dateTimeLbl: UILabel!
    
    @IBOutlet weak var contactView: UIView!
    
    @IBOutlet weak var contactLbl: UILabel!
    
    @IBOutlet weak var specialityView: UIView!
    
    @IBOutlet weak var specialityLbl: UILabel!
    
    @IBOutlet weak var casePatientView: UIView!
    
    @IBOutlet weak var casePatientLbl: UILabel!
    
    @IBOutlet weak var cpInitialView: UIView!
    
    @IBOutlet weak var cpInitialsLbl: UILabel!
    
    @IBOutlet weak var languageView: UIView!
    
    @IBOutlet weak var languageLbl: UILabel!
    
    @IBOutlet weak var descriptionView: UIView!
    
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var notesView: UIView!
    @IBOutlet weak var specialRequestsLbl: UILabel!
    @IBOutlet weak var statusLbl: UILabel!
    @IBOutlet weak var statusView: UIView!
    override  func awakeFromNib() {
        //        self.appointmentDetailsUIView.visibility = .gone
    }
}




class BlockedAppointmentTelephonicConferenceDetails: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var appInfoLbl: UILabel!
    @IBOutlet weak var locationLbl: UILabel!
    @IBOutlet weak var locationView: UIView!
    @IBOutlet weak var mainDateLbl: UILabel!
    var companyName = ""
    var apiAcceptByVendorRequestDataModel:ApiAcceptByVendorRequestDataModel?
    
    @IBOutlet weak var mainStartTimeLbl: UILabel!
    @IBOutlet weak var startTimeLbl: UILabel!
    @IBOutlet weak var estEndTimeLbl: UILabel!
    var firstTime = true
    var urlToOpen = ""
    var apiEncryptedDataResponse : ApiEncryptedDataResponse?
    var apiGetCustomerDetailResponseModel : [ApiGetCustomerDetailResponseModel]?
    @IBOutlet weak var appointmentListTV: UITableView!
    var appointmentDataArray = [ApiBlockedAppointmentResponseModelData]()
    var appointmentID = 0
    var startTime = ""
    var endTime = ""
    @IBOutlet weak var serviceVerificationFormView: UIView!
    @IBOutlet weak var acceptAndDeclineStackView: UIStackView!
    @IBOutlet weak var importantNoteLbl: UILabel!
    @IBOutlet weak var importantNoteView: UIView!
    var collapseStatus = [false,false,false,false,false,false,false,false,false,false]
    override func viewDidLoad() {
        super.viewDidLoad()
        companyName = (UserDefaults.standard.value(forKey: UserDeafultsString.instance.CompanyName) as? String) ?? ""
        self.mainStartTimeLbl.text = startTime
        self.estEndTimeLbl.text = endTime
        self.getAppointmentDetailsApi()
        appointmentListTV.delegate=self
        appointmentListTV.dataSource=self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden=true
    }
    
    
    @IBAction func backBtnTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func openServiceVerificationForm(_ sender: Any) {
        
        let vc = self.storyboard?.instantiateViewController(identifier: "ServiceVerificationURLViewController") as! ServiceVerificationURLViewController
        vc.isFromRegular=false
        let vID = UserDefaults.standard.value(forKey: UserDeafultsString.instance.UserID) as? String ?? "0"
        
        let fileNameNew = "https://lsp.totallanguage.com//Appointment/previewserviceform?a=\(self.appointmentID)&v=\(vID)"
        vc.serviceURL = fileNameNew
        print("URL DATA IS \(fileNameNew)")
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
//        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @IBAction func imAvailableTapped(_ sender: Any) {
        let userId = userDefaults.string(forKey: UserDeafultsString.instance.UserID) ?? ""
        acceptRequestApi(notificationID: "0", appointmentID: "\(appointmentID)", userID: userId)
    }
    
    @IBAction func declined(_ sender: Any) {
        let userId = userDefaults.string(forKey: UserDeafultsString.instance.UserID) ?? ""
        declineRequestApi(notificationID: "0", appointmentID: "\(appointmentID)", userID: userId)
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
                        let alert = UIAlertController(title: "Confirmation", message: showMessage, preferredStyle: .alert)
                            
                        let ok = UIAlertAction(title: "OK", style: .default, handler: { action in
                            self.dismiss(animated: true, completion: nil)
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
                                self.dismiss(animated: true,completion: nil)
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


extension BlockedAppointmentTelephonicConferenceDetails:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.appointmentDataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = appointmentListTV.dequeueReusableCell(withIdentifier: "BlockedAppointmentTelephonicTVC", for: indexPath) as! BlockedAppointmentTelephonicTVC
        cell.appointmentLbl.text = "Appointment \(indexPath.row + 1)"
        if firstTime && indexPath.row == 0{
            cell.appointmentDetailsUIView.visibility = .visible
            self.appointmentDataArray[indexPath.row].collapsedStatus = false
            cell.arrowOutlet.image = UIImage(systemName: "chevron.up")
        }
        else{
            firstTime = false
            if self.appointmentDataArray[indexPath.row].collapsedStatus == true{
                
                cell.appointmentDetailsUIView.visibility = .gone
                cell.arrowOutlet.image = UIImage(systemName: "chevron.down")
                
            }else {
                cell.appointmentDetailsUIView.visibility = .visible
                cell.arrowOutlet.image = UIImage(systemName: "chevron.up")
            }
        }
      
       
            let apiData = self.appointmentDataArray[indexPath.row]
            let userId = userDefaults.string(forKey: UserDeafultsString.instance.UserID) ?? ""
            
            if (apiData.AppointmentStatusTypeID == 1 || apiData.AppointmentStatusTypeID == 7 || apiData.AppointmentStatusTypeID == 8) && (apiData.Interpreterid == Int(userId)){
                //                            BOOKED APPOINTMENT AND WHOLE DATA AND SERVICE VERIFICATION FORM NEEDS TO BE SHOWN
                
                cell.statusLbl.text = "Booked"
                self.serviceVerificationFormView.visibility = .visible
                cell.interpreterNameView.isHidden = false
                cell.authenticationCodeView.isHidden = false
    //            cell.serviceTypeVie.isHidden = false
                cell.dateTimeView.isHidden = false
    //            cell.venueNameView.isHidden = false
                cell.locationView.isHidden = false

                cell.contactView.isHidden = false
    //            cell.specialityView.isHidden = false
                cell.casePatientView.isHidden = false
                cell.cpInitialView.isHidden = false
                cell.languageView.isHidden = false
                cell.descriptionView.isHidden = false
                cell.notesView.isHidden = false
                cell.statusView.isHidden = false
      
              
                self.acceptAndDeclineStackView.isHidden = true
            }else
            
            {
                
                self.serviceVerificationFormView.visibility = .gone
                cell.interpreterNameView.isHidden = false
                cell.authenticationCodeView.isHidden = false
    //            cell.serviceTypeVie.isHidden = true
                cell.dateTimeView.isHidden = false
                cell.locationView.isHidden = true
    //            cell.venueNameView.isHidden = false
    //            cell.venueAddressView.isHidden = false
    //            cell.venueAddressLbl.text = "\(apiData.city ?? ""), \(apiData.stateName ?? "")"
    //            cell.departmentView.isHidden = true
                cell.contactView.isHidden = true
    //            cell.specialityView.isHidden = true
                cell.casePatientView.isHidden = true
                cell.cpInitialView.isHidden = true
                cell.languageView.isHidden = false
                cell.descriptionView.isHidden = false
                cell.notesView.isHidden = false
                cell.statusView.isHidden = false
                
                
                if (apiData.AppointmentStatusTypeID == 2 || apiData.AppointmentStatusTypeID == 11) && (apiData.AcceptAndDeclineStatus == -1){
                    self.appInfoLbl.isHidden = false
                                           self.titleLabel.text = "Availability Inquiry"
                    self.appInfoLbl.text = "\(self.companyName) has sent you an INQUIRY. Please check your availability and select the option below to indicate if you are available or have to decline the work."
                                           
                }else {
                    self.titleLabel.text = "\(apiData.AppointmentStatusType ?? "") Appointment"
                    self.appInfoLbl.isHidden = true
                }
                
                
                
                
                
                if (apiData.AppointmentStatusTypeID == 2) && (apiData.AcceptAndDeclineStatus == -1) && (apiData.IsAssigned == -1) && (apiData.Interpreterid == 0){
                    cell.statusLbl.text = "Not Booked"
                    self.acceptAndDeclineStackView.isHidden = false
                }else if (apiData.AppointmentStatusTypeID == 11) && (apiData.AcceptAndDeclineStatus == 1) && (apiData.IsAssigned == -1) && (apiData.Interpreterid == 0 || apiData.Interpreterid ==  Int(userId)){
                    cell.statusLbl.text = "\(apiData.AppointmentStatusType ?? "")"
                    self.acceptAndDeclineStackView.isHidden = true
                }else if  (apiData.AcceptAndDeclineStatus == 0) {
                    cell.statusLbl.text = "Unavailable Appointment"
                    self.acceptAndDeclineStackView.isHidden = true
                }
            }
            let fName = userDefaults.value(forKey: UserDeafultsString.instance.fullName) as? String ?? ""
            
            cell.interpreterNameLbl.text = fName  //apiData.Interpretername ?? "N/A"//fName as? String ?? ""//apiData.Interpretername ?? "N/A"
            
            cell.interpreterNameLbl.removeEmptyString()
            if apiData.CText?.replacingOccurrences(of: "\\", with: "").isValidURL ?? false{
                cell.locationLbl.text = apiData.CText
                cell.locationLbl.handleURLTap { url in
                    CommonClass.share.activeLinkCall(activeURL: url)
                }
                         
                        
                    }else {
                        cell.locationLbl.text = apiData.CText
                        cell.locationLbl.removeEmptyString()

                    }

            cell.authenticationCodeLbl.text = apiData.authcode ?? "N/A"
            cell.authenticationCodeLbl.removeEmptyString()

            cell.contactLbl.text = apiData.ProviderName ?? "N/A"
            cell.contactLbl.removeEmptyString()

            cell.specialRequestsLbl.text = apiData.CLocation ?? "N/A"
            cell.specialRequestsLbl.removeEmptyString()
            cell.jobTypeLbl.text = apiData.JobType ?? "N/A"
            cell.jobTypeLbl.removeEmptyString()
            self.hitApiEncryptValue(value: apiData.CaseNumber ?? "") { plant, initialText in
                cell.casePatientLbl.text = initialText
                cell.casePatientLbl.removeEmptyString()
            }
            
            self.hitApiEncryptValue(value: apiData.ClientCase ?? "") { plant, initialText in
                cell.cpInitialsLbl.text = initialText ?? "N/A"
                cell.cpInitialsLbl.removeEmptyString()
            }
            cell.statusLbl.text = apiData.AppointmentStatusType ?? "N/A"
            cell.statusLbl.removeEmptyString()
            cell.languageLbl.text = apiData.LanguageName ?? "N/A"
            cell.languageLbl.removeEmptyString()
            cell.descriptionLbl.text = apiData.CAptDetails ?? "N/A"
            cell.descriptionLbl.removeEmptyString()
            cell.statusView.visibility = .visible
            cell.dateTimeLbl.text = apiData.StarEndDateTime ?? "N/A"
            cell.dateTimeLbl.removeEmptyString()
            
            
            cell.collapseBtnOutlet.tag = indexPath.row
            cell.collapseBtnOutlet.addTarget(self, action: #selector(self.btnAction(_:)), for: .touchUpInside)
       
        
        
 
        
        
        
        return cell
    }
    
    @objc func labelTapped(_ sender: UITapGestureRecognizer) {
              print("labelTapped")
          if let url = URL(string: self.urlToOpen) {
              UIApplication.shared.open(url)
          }
          }
    
    @objc func btnAction(_ sender: UIButton)
    {
        //        let cell = appointmentListTV.cellForRow(at: IndexPath(row: sender.tag, section: 0)) as! BlockedAppointmentTVC
        self.appointmentDataArray[sender.tag].collapsedStatus = !self.appointmentDataArray[sender.tag].collapsedStatus
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            self.appointmentListTV.reloadData()
            self.appointmentListTV.reloadRows(at: [IndexPath(row: sender.tag, section: 0)], with: .automatic)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}



extension BlockedAppointmentTelephonicConferenceDetails{
    func getAppointmentDetailsApi(){
        SwiftLoader.show(animated: true)
        let urlString = APIs.GetBlockedAppointmentDetails
        let companyID = userDefaults.value(forKey: UserDeafultsString.instance.CompanyID) ?? 0
        let userID = userDefaults.value(forKey: UserDeafultsString.instance.UserID) ?? 0
        let userTypeId = userDefaults.value(forKey: UserDeafultsString.instance.UserTypeID) ?? 0//GetPublicData.sharedInstance.userTypeID
        let searchString = "<INFO><UserID>\(userID)</UserID><AppointmentID>\(appointmentID)</AppointmentID><Companyid>\(companyID)</Companyid><UsertypeID>\(userTypeId)</UsertypeID></INFO>"
        let parameter = [
            "strSearchString" : searchString
        ] as [String : String]
        print("url and parameter for customer Detail are ", urlString, parameter)
        AF.request(urlString, method: .post , parameters: parameter, encoding: JSONEncoding.default, headers: nil)
            .validate()
            .responseData(completionHandler: { [self] (response) in
                SwiftLoader.hide()
                switch(response.result){
                    
                case .success(_):
                    print("Respose Success getCustomerDetail ")
                    guard let daata = response.data else { return }
                    do {
                        let jsonDecoder = JSONDecoder()
                        self.apiGetCustomerDetailResponseModel = try jsonDecoder.decode([ApiGetCustomerDetailResponseModel].self, from: daata)
                        print("Success getCustomerDetail Model ",self.apiGetCustomerDetailResponseModel?.first?.result ?? "")
                        let str = self.apiGetCustomerDetailResponseModel?.first?.result ?? ""
                        let data = str.data(using: .utf8)!
                        do {
                            //
                            print("DATAAA ISSS \(data)")
                            if let jsonArray = try JSONSerialization.jsonObject(with: data, options : .allowFragments) as? [Dictionary<String,Any>]
                            {
                                
                                let newjson = jsonArray.first
                                let userInfo = newjson?["BlockedAppList"] as? [[String:Any]]
                               
                                let userIfo = userInfo?.first
                              
                                userInfo?.forEach({ BlockedAppListApiData in
                                    let ClientCase = BlockedAppListApiData["ClientCase"] as? String
                                    let ReasonforBotch = BlockedAppListApiData["ReasonforBotch"] as? String
                                    let BookedBy = BlockedAppListApiData["BookedBy"] as? String
                                    let CaseNumber = BlockedAppListApiData["CaseNumber"] as? String
                                    let SpecialityName = BlockedAppListApiData["SpecialityName"] as? String
                                    let StartDateTimee = BlockedAppListApiData["StartDateTime"] as? String
                                    let StartDateTime = BlockedAppListApiData["StartDateTime"] as? String
                                    let AppointmentStatusType = BlockedAppListApiData["AppointmentStatusType"] as? String
                                    let JobType = BlockedAppListApiData["JobType"] as? String
                                    let CompanyEmail = BlockedAppListApiData["CompanyEmail"] as? String
                                    let ProviderName = BlockedAppListApiData["ProviderName"] as? String
                                    let ServiceTypeName = BlockedAppListApiData["ServiceTypeName"] as? String
                                    let AppointmentTypeCode = BlockedAppListApiData["AppointmentTypeCode"] as? String
                                    let Interpretername = BlockedAppListApiData["Interpretername"] as? String
                                    let CAptDetails = BlockedAppListApiData["CAptDetails"] as? String
                                    let VenueAddress = BlockedAppListApiData["VenueAddress"] as? String
                                    let DepartmentName = BlockedAppListApiData["DepartmentName"] as? String
                                    let StarEndDateTime = BlockedAppListApiData["StarEndDateTime"] as? String
                                    let BookedOn = BlockedAppListApiData["BookedOn"] as? String
                                    let LanguageName = BlockedAppListApiData["LanguageName"] as? String
                                    let UpdatedOn = BlockedAppListApiData["UpdatedOn"] as? String
                                    let CScheduleNotes = BlockedAppListApiData["CScheduleNotes"] as? String
                                    let CancelledOn = BlockedAppListApiData["CancelledOn"] as? String
                                    let VenueName = BlockedAppListApiData["VenueName"] as? String
                                    let CompanyLogo = BlockedAppListApiData["CompanyLogo"] as? String
                                    let CFinancialNotes = BlockedAppListApiData["CFinancialNotes"] as? String
                                    let AppointmentID = BlockedAppListApiData["AppointmentID"] as? Int
                                    let ConfirmedOn = BlockedAppListApiData["ConfirmedOn"] as? String
                                    let LanguageNameP = BlockedAppListApiData["LanguageNameP"] as? String
                                    let CompanyName = BlockedAppListApiData["CompanyName"] as? String
                                    let CText = BlockedAppListApiData["CText"] as? String
                                    let AppointmentStatusTypeID = BlockedAppListApiData["AppointmentStatusTypeID"] as? Int
                                    let authcode = BlockedAppListApiData["authcode"] as? String
                                    let ConfirmedBy = BlockedAppListApiData["ConfirmedBy"] as? String
                                    let CLocation = BlockedAppListApiData["CLocation"] as? String
                                    
                                    let aPVenueID = BlockedAppListApiData["aPVenueID"] as? Int
                                    let Gender = BlockedAppListApiData["Gender"] as? String
                                    let AppDate = BlockedAppListApiData["AppDate"] as? String
                                    let IsAssigned = BlockedAppListApiData["IsAssigned"] as? Int
                                    let AppSTime = BlockedAppListApiData["AppSTime"] as? String
                                    let EndDateTime = BlockedAppListApiData["EndDateTime"] as? String
                                    let LoadedBy = BlockedAppListApiData["LoadedBy"] as? String
                                    let CancelledBy = BlockedAppListApiData["CancelledBy"] as? String
                                    let AcceptAndDeclineStatus = BlockedAppListApiData["AcceptAndDeclineStatus"] as? Int
                                    let VendorTimezoneshort = BlockedAppListApiData["VendorTimezoneshort"] as? String
                                    let num_row = BlockedAppListApiData["num_row"] as? String
                                    let ClientName = BlockedAppListApiData["ClientName"] as? String
                                    let AppETime = BlockedAppListApiData["AppETime"] as? String
                                    let AppointmentType = BlockedAppListApiData["AppointmentType"] as? String
                                    let RequestedOn = BlockedAppListApiData["RequestedOn"] as? String
                                    let CompanyPhone = BlockedAppListApiData["CompanyPhone"] as? String
                                    let Interpreterid = BlockedAppListApiData["Interpreterid"] as? Int
                                    let ISAUTHUSER = BlockedAppListApiData["ISAUTHUSER"] as? Int
                                    let Address = BlockedAppListApiData["Address"] as? String
                                    let city = BlockedAppListApiData["city"] as? String
                                    let stateName = BlockedAppListApiData["stateName"] as? String
                                    let zipcode = BlockedAppListApiData["zipcode"] as? String
                                    let itemA = ApiBlockedAppointmentResponseModelData(Address:Address,city:city,stateName:stateName,zipcode:zipcode,ClientCase: ClientCase, ReasonforBotch: ReasonforBotch, BookedBy: BookedBy, CaseNumber: CaseNumber, SpecialityName: SpecialityName, StartDateTimee: StartDateTimee, DepartmentName: DepartmentName, StartDateTime: StartDateTime, AppointmentStatusType: AppointmentStatusType, JobType: JobType, CompanyEmail: CompanyEmail, ProviderName: ProviderName, ServiceTypeName: ServiceTypeName, AppointmentTypeCode: AppointmentTypeCode, Interpretername: Interpretername, CAptDetails: CAptDetails, VenueAddress: VenueAddress, StarEndDateTime: StarEndDateTime, BookedOn: BookedOn, LanguageName: LanguageName, UpdatedOn: UpdatedOn, CScheduleNotes: CScheduleNotes, CancelledOn: CancelledOn, VenueName: VenueName, CompanyLogo: CompanyLogo, CFinancialNotes: CFinancialNotes, AppointmentID: AppointmentID, ConfirmedOn: ConfirmedOn, LanguageNameP: LanguageNameP, CompanyName: CompanyName, CText: CText, AppointmentStatusTypeID: AppointmentStatusTypeID, authcode: authcode, ConfirmedBy: ConfirmedBy, CLocation: CLocation, aPVenueID: aPVenueID, Gender: Gender, AppDate: AppDate, IsAssigned: IsAssigned, AppSTime: AppSTime, EndDateTime: EndDateTime, LoadedBy: LoadedBy, CancelledBy: CancelledBy, AcceptAndDeclineStatus: AcceptAndDeclineStatus, VendorTimezoneshort: VendorTimezoneshort, num_row: num_row, ClientName: ClientName, AppETime: AppETime, AppointmentType: AppointmentType, RequestedOn: RequestedOn, CompanyPhone: CompanyPhone, Interpreterid: Interpreterid, ISAUTHUSER: ISAUTHUSER)
                                    self.appointmentDataArray.append(itemA)
                                    })
                                self.mainStartTimeLbl.text = self.appointmentDataArray.first?.AppSTime ?? ""
                                self.estEndTimeLbl.text = self.appointmentDataArray.first?.AppETime ?? ""  
                                self.mainDateLbl.text = convertTimeFormaterOnlyDate(self.appointmentDataArray.first?.StartDateTime ?? "")
                                
                                
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
                                
                                if self.appointmentDataArray.first?.AppointmentStatusTypeID == 2 || self.appointmentDataArray.first?.AppointmentStatusTypeID == 11{
                                    self.importantNoteView.visibility = .visible
                                    self.importantNoteLbl.attributedText = finalNoteString
                                    
                                }else if self.appointmentDataArray.first?.AppointmentStatusTypeID == 1 || self.appointmentDataArray.first?.AppointmentStatusTypeID == 7 || self.appointmentDataArray.first?.AppointmentStatusTypeID == 8{
                                    self.importantNoteView.visibility = .visible
                                    self.importantNoteLbl.attributedText = finalImportantString
                                }else
                                {
                                    self.importantNoteView.visibility = .gone
                                }
                                
                                print("APPOINTMENT DATA ARRAY IS \(self.appointmentDataArray)")
                                DispatchQueue.main.async {
                                    self.appointmentListTV.reloadData()
                                }
                              } else {
                                print("bad json")
                            }
                        } catch let error as NSError {
                            print(error)
                        }
                    } catch{
                        
                        print("error block getCustomerDetail " ,error)
                    }
                case .failure(_):
                    print("Respose getCustomerDetail ")
                    
                }
            })
    }
}

extension BlockedAppointmentTelephonicConferenceDetails{
    func convertDateFormater(_ date: String) -> String
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
    }}

extension BlockedAppointmentTelephonicConferenceDetails{
    func hitApiEncryptValue(value : String , encryptedValue : @escaping(Bool? , String?) -> ()){
        //            SwiftLoader.show(animated: true)
        
        let urlString = "https://lspservices.totallanguage.com/api/encryptdecryptvalue"
        
        let parameter = [
            "value": value, "key": "Dcrpt"
        ] as [String : Any]
        print("url and parameter apiEncryptedDataResponse ", urlString, parameter)
        AF.request(urlString, method: .post , parameters: parameter, encoding: JSONEncoding.default, headers: nil)
            .validate()
            .responseData(completionHandler: { [self] (response) in
                SwiftLoader.hide()
                switch(response.result){
                    
                case .success(_):
                    print("Respose Success apiEncryptedDataResponse ")
                    guard let daata = response.data else { return }
                    do {
                        let jsonDecoder = JSONDecoder()
                        self.apiEncryptedDataResponse = try jsonDecoder.decode(ApiEncryptedDataResponse.self, from: daata)
                        print("Success apiEncryptedDataResponse Model ",self.apiEncryptedDataResponse)
                        let encrypValue = self.apiEncryptedDataResponse?.value ?? ""
                        encryptedValue(true , encrypValue)
                        
                    } catch{
                        
                        print("error block getCommonDetail " ,error)
                    }
                case .failure(_):
                    print("Respose getCommonDetail ")
                    
                }
            })
    }
}
