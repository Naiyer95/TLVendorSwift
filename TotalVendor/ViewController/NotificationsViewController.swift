//
//  NotificationViewController.swift
//  TLClientApp
//
//  Created by Mac on 12/10/21.
//




import UIKit
import Alamofire
import SwiftDate
class NotificationTableViewCell:UITableViewCell{
    
    
    @IBOutlet weak var detailsBtnTapped: UIButton!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var notificationWebview: UIWebView!
    
    @IBOutlet var authCodeLbl: UILabel!
    @IBOutlet var jobTypeLbl: UILabel!
    @IBOutlet var startDateAndTimeLbl: UILabel!
    @IBOutlet var endTimeLbl: UILabel!
    @IBOutlet var venueLbl: UILabel!
    @IBOutlet var languageLbl: UILabel!
    @IBOutlet var interpreterLbl: UILabel!
    @IBOutlet var dateLbl: UILabel!
    @IBOutlet var notificationLbl: UILabel!
    @IBOutlet var notificationTV: UITableView!

    override func awakeFromNib() {
        
        self.mainView.addShadowGrey()
    }
}
class NotificationViewController: UIViewController,UITextFieldDelegate {
    
    @IBOutlet weak var searchTF:UITextField!// ImageTextField!
    @IBOutlet weak var filterTV: UITableView!
    @IBOutlet weak var filterView: UIView!
    var appointmentStatusArr = [String]()
    var filterSearch = [FilterSearch]()
    var statusFilterSearch = ""
    var isSearchFilter = false
    @IBOutlet var notificationTV: UITableView!
    @IBOutlet var countLbl: UILabel!
    var apiNotificationDetailResponseModel:ApiNotificationResponseModel?
    var customerID = "0"
    var searchArray = [ApiNotificationResponseModelByUsername]()
    var parentArray = [ApiNotificationResponseModelByUsername]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.filterTV.delegate = self
        self.filterTV.dataSource = self
        GetPublicData.sharedInstance.getAllLanguage()
        let userId = userDefaults.string(forKey: UserDeafultsString.instance.UserID) ?? ""
        self.customerID = userId
        filterView.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        filterView.isHidden = true
        notificationTV.tableFooterView = UIView(frame: .zero)
        notificationTV.estimatedRowHeight = 200
        notificationTV.rowHeight = UITableView.automaticDimension
        //        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        self.notificationTV.delegate = self
        self.notificationTV.dataSource = self
        if Reachability.isConnectedToNetwork(){
            getNotificatioDetail()
        }else {
            self.view.makeToast("Please check your internet connection")
        }
        
    }
    
    @IBAction func cancelBtnTapped(_ sender: UIButton){
        self.filterView.isHidden = true
    }
    
    
    
    @IBAction func actionDoneFilter(_ sender: UIButton) {
        self.searchArray.removeAll()
        
        if appointmentStatusArr.count == 0 {
            
            isSearchFilter=false
            
//            self.apiNotificationDetailResponseModel?.notificationsByUsername?.forEach({ (notificationData) in
//
//                self.searchArray.append(notificationData)
//            })
            
        }
        else {
            isSearchFilter=true
            self.apiNotificationDetailResponseModel?.notificationsByUsername?.forEach({ (notificationData) in
                let notification = notificationData.appStatus ?? ""
                
                print("exists text ",notification)
                print("exists text ",statusFilterSearch)
                self.appointmentStatusArr.forEach { (ab) in
                    
                    if ab == notification {
                        //print("exists text ",searchText)
                        self.searchArray.append(notificationData)
                    }else{
                        // print("not exists text ",searchText)
                        //self.searchArray.removeAll()
                    }
                }
                
            })
        }
        notificationTV.reloadData()
        self.filterView.isHidden = true
    }
    
    
    @IBAction func actionBackButton(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func actionFilterTapped(_ sender: UIButton) {
        self.filterView.isHidden = false
    }
    func getNotificatioDetail(){
//        SwiftLoader.show(animated: true)
        self.apiNotificationDetailResponseModel = nil
        let userId = UserDefaults.standard.value(forKey: UserDeafultsString.instance.UserID) ?? "0"
        let companyID = UserDefaults.standard.value(forKey: UserDeafultsString.instance.CompanyID) ?? "0"
        
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.startAnimating()
        spinner.color = UIColor.black
        spinner.center = CGPoint(x: self.notificationTV.bounds.size.width/2-40, y: self.notificationTV.bounds.size.height/2)
        self.notificationTV.isUserInteractionEnabled = false
        self.notificationTV.addSubview(spinner)
        let urlString = "https://lsp.totallanguage.com/Home/GetData?methodType=NotificationsByUsername&UserID=\(userId)&CompanyID=\(companyID)&SortOrder=Desc&RowNumber=0&AppID=0"
        print("url to get notificationDetail  \(urlString)")
        AF.request(urlString, method: .get , parameters: nil, encoding: JSONEncoding.default, headers: nil)
            .validate()
            .responseData(completionHandler: { [self] (response) in
//                SwiftLoader.hide()
                switch(response.result){
                case .success(_):
                    
                    self.notificationTV.isUserInteractionEnabled = true
                    spinner.stopAnimating()
                    spinner.removeFromSuperview()
                    print("Respose Success Notification Data ")
                    guard let daata = response.data else { return }
                    do {
                        let jsonDecoder = JSONDecoder()
                        self.apiNotificationDetailResponseModel = try jsonDecoder.decode(ApiNotificationResponseModel.self, from: daata)
                        
                     
                        self.searchTF.delegate=self
                        //                                SwiftLoader.hide()
                        self.apiNotificationDetailResponseModel?.notificationsByUsername?.forEach({ (notificationData) in
                            self.parentArray.append(notificationData)
                            
                            let aptStatus = notificationData.appStatus ?? ""
                            let item = FilterSearch(name: aptStatus, searchSelect: false)
                            if filterSearch.contains(where: { $0.name == aptStatus }) {
                                print("status Already exist ")
                            } else {
                                print("status not exist ")
                                filterSearch.append(item)
                            }
                            
                        })
                        DispatchQueue.main.async {
                            self.filterTV.reloadData()
                            self.notificationTV.reloadData()
                        }
                    } catch{
                        
                        print("error block notification Data  " ,error)
                    }
                    
                case .failure(_):
                    print("Respose Failure ")
                    
                }
            })
    }
    
    func conertDateString(time :Double ) -> String{
        print("MILI SECONDS IS \(time)")
        //        let milisecond = 1479714427
        let dateVar = Date.init(timeIntervalSinceNow: TimeInterval(time)/1000)
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.dateFormat = "dd-MM-yyyy"
        print(dateFormatter.string(from: dateVar))
        let timeConverted = (dateFormatter.string(from: dateVar))
        return timeConverted
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        print("searchtext from searchbar  \(textField.text ?? "")")
       
        if searchTF.text!.isEmpty {
            isSearchFilter=false
            self.notificationTV.reloadData()
            }
            else {
                isSearchFilter=true
                self.searchArray.removeAll()
                self.apiNotificationDetailResponseModel?.notificationsByUsername?.forEach({ (notificationData) in
                    let notification = notificationData.appStatus?.lowercased() ?? ""
//                    notification.range(of: textField.text ?? "", options: .caseInsensitive)
                    // if (notification.range(of: searchText, options: .caseInsensitive) != nil) {
                    let text = textField.text?.lowercased() ?? ""
                    if notification.contains(text) {
                        print("exists text ",textField.text ?? "")
                        self.searchArray.append(notificationData)
                    }else{
                        print("not exists text ",textField.text ?? "")
                        //self.searchArray.removeAll()
                    }
                    notificationTV.reloadData()
                })
            }
            
    
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        self.resignFirstResponder()
        return true
    }
}
extension NotificationViewController{
    func hitGetAppointmentDetailApi(appointmentID : String ,notificationID:String ,encryptedValue : @escaping(Bool? , String?,ApiOnsiteDetailsResponseModel?) -> ()){
        //            SwiftLoader.show(animated: true)
        
        let urlString =   "https://lsp.totallanguage.com/Home/GetData?methodType=AppointmentInterpreterData&NotoficationId=0&AppointmentID=\(appointmentID)&Interpreterid=\(self.customerID)&UserType=6&Userid=\(self.customerID)"
        
        print("url and parameter hitGetAppointmentDetailApi ", urlString)
        AF.request(urlString, method: .get , parameters: nil, encoding: JSONEncoding.default, headers: nil)
            .validate()
            .responseData(completionHandler: { [self] (response) in
//                SwiftLoader.hide()
                switch(response.result){
                    
                case .success(_):
                    print("Respose Success apiEncryptedDataResponse ")
                    guard let daata = response.data else { return }
                    do {
                        let jsonDecoder = JSONDecoder()
                        let apiOnsiteDetailsResponseModel = try jsonDecoder.decode(ApiOnsiteDetailsResponseModel.self, from: daata)
                        encryptedValue(true, "", apiOnsiteDetailsResponseModel
                        )
                        
                    } catch{
                        
                        print("error block getCommonDetail " ,error)
                    }
                case .failure(_):
                    print("Respose getCommonDetail ")
                    
                }
            })
    }
}


extension NotificationViewController :UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == notificationTV {
//            print("APII NOTIFICATION DATA COUNT IS \(self.apiNotificationDetailResponseModel?.notificationsByUsername?.count ?? 0)")
            
            if isSearchFilter{
                self.countLbl.text = "No. of Record \(searchArray.count)"
                return searchArray.count
                
            }else{
                self.countLbl.text = "No. of Record \(parentArray.count)"
                return parentArray.count
                
            }

        }else {
            return filterSearch.count
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == notificationTV {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationTableViewCell") as! NotificationTableViewCell
            if isSearchFilter{
                let indx = searchArray[indexPath.row]
                //self.apiNotificationDetailResponseModel?.notificationsByUsername?[indexPath.row]
                let abcDate = indx.createDate?.digits
                let dateString = self.getTimefromTimeStamp(timeStamp: abcDate ?? "")
               
                cell.dateLbl.text = dateString //actualDate
                cell.dateLbl.textColor = UIColor.gray
                let appStatus = indx.appStatus ?? ""
                let actualStatus = indx.appStatus ?? ""
//                ColourResponse.sharedInstance.apiCalendarDataResponseModel?.appointmentStatus?.forEach({ (appointmentStatus) in
//                    if  appointmentStatus.code == appStatus {
//                        cell.notificationLbl.text = actualStatus
//                        let color = appointmentStatus.color ?? ""
//                        cell.notificationLbl.textColor = UIColor(hexString: color)
//                    }
//                })
                cell.notificationLbl.text = appStatus
                cell.notificationLbl.backgroundColor = hexStringToUIColor(hex: getHexaString(status: (appStatus.lowercased()))!)
                
                hitGetAppointmentDetailApi(appointmentID: String(self.searchArray[indexPath.row].appointmentID ?? 0) , notificationID: String(self.searchArray[indexPath.row].notoficationId ?? 0) ) { testBool, testString, apiModelNew in
                    
                    let details = apiModelNew?.appointmentInterpreterData?.first
                    cell.authCodeLbl.text = details?.authCode ?? ""
                    cell.jobTypeLbl.text = details?.appointmentType ?? ""
                    cell.startDateAndTimeLbl.text = self.convertDateAndTimeFormat(details?.startDateTime ?? "")  + " (\(userDefaults.value(forKey: UserDeafultsString.instance.ZoneShortForm) ?? ""))"
                    cell.endTimeLbl.text = self.convertTimeFormater(details?.endDateTime ?? "")
                    cell.venueLbl.text = details?.venueName
                    cell.venueLbl.removeEmptyString()
                    cell.languageLbl.text = details?.languageName ?? ""
                    let namee = userDefaults.value(forKey: UserDeafultsString.instance.fullName) as? String ?? ""
                    cell.interpreterLbl.text = namee
                    
                }
            }else{
                let indx = parentArray[indexPath.row]
                //self.apiNotificationDetailResponseModel?.notificationsByUsername?[indexPath.row]
                let abcDate = indx.createDate?.digits
                let dateString = self.getTimefromTimeStamp(timeStamp: abcDate ?? "")
                print("date ms is \(indx.createDate)")
                //let actualDate = conertDateString(time: Double(date) ?? 0)
                // "Apr 16, 2015, 2:40 AM"
                print("Converted Time \(dateString)")
                cell.dateLbl.text = dateString //actualDate
                cell.dateLbl.textColor = UIColor.gray
                let appStatus = indx.appStatus ?? ""
                let actualStatus = indx.appStatus ?? ""
//                ColourResponse.sharedInstance.apiCalendarDataResponseModel?.appointmentStatus?.forEach({ (appointmentStatus) in
//                    if  appointmentStatus.code == appStatus {
//                        cell.notificationLbl.text = actualStatus
//                        let color = appointmentStatus.color ?? ""
//                        cell.notificationLbl.textColor = UIColor(hexString: color)
//                    }
//                })
                cell.notificationLbl.text = appStatus
                cell.notificationLbl.backgroundColor = hexStringToUIColor(hex: getHexaString(status: (appStatus.lowercased()))!)
                
                hitGetAppointmentDetailApi(appointmentID: String(self.parentArray[indexPath.row].appointmentID ?? 0) , notificationID: String(self.parentArray[indexPath.row].notoficationId ?? 0) ) { testBool, testString, apiModelNew in
                    
                    let details = apiModelNew?.appointmentInterpreterData?.first
                    cell.authCodeLbl.text = details?.authCode ?? ""
                    cell.jobTypeLbl.text = details?.appointmentType ?? ""
                    cell.startDateAndTimeLbl.text = self.convertDateAndTimeFormat(details?.startDateTime ?? "")  + " (\(userDefaults.value(forKey: UserDeafultsString.instance.ZoneShortForm) ?? ""))"
                    cell.endTimeLbl.text = self.convertTimeFormater(details?.endDateTime ?? "")
                    cell.venueLbl.text = details?.venueName
                    cell.venueLbl.removeEmptyString()
                    cell.languageLbl.text = details?.languageName ?? ""
                    let namee = userDefaults.value(forKey: UserDeafultsString.instance.fullName) as? String ?? ""
                    cell.interpreterLbl.text = namee
                    
                }
            }
       
            
            
            
            return cell
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "StatusFilterTableViewCell", for: indexPath) as! StatusFilterTableViewCell
            let indx = filterSearch[indexPath.row]
            //            GetPublicData.sharedInstance.apiGetSpecialityDataModel?.appointmentStatus?.forEach({ (appointmentStatus) in
            //                let appStatus = indx.name
            //                if  appointmentStatus.code == appStatus {
            //                    //cell.titleLbl.text = appStatus
            //                    let color = appointmentStatus.color ?? ""
            //                    cell.titleLbl.textColor = UIColor(hexString: color)
            //                }
            //            })
            
            ColourResponse.sharedInstance.apiCalendarDataResponseModel?.appointmentStatus?.forEach({ (appointmentStatus) in
                let appStatus = indx.name
                if  appointmentStatus.value == appStatus {
                    
                    let color = appointmentStatus.color ?? ""
                    cell.titleLbl.textColor = UIColor(hexString: color)
                }
            })
            
            
            
            cell.titleLbl.text = indx.name
            if indx.searchSelect == true {
                cell.titleImg.image = UIImage(systemName: "checkmark.square.fill")
            }else {
                cell.titleImg.image = UIImage(systemName: "square")
            }
            return cell
            
        }
        
        
    }
    
    @objc func detailsTapped(sender: UIButton){
        let vc = self.storyboard?.instantiateViewController(identifier: "NewAppointmentDetailsVC") as! NewAppointmentDetailsVC
        vc.appointmentID = self.apiNotificationDetailResponseModel?.notificationsByUsername?[sender.tag].appointmentID ?? 0
        //        vc.isComeFromBooking = true
        //        self.present(vc, animated: true, completion: nil)
        self.navigationController?.pushViewController(vc, animated: true)
        
        
    }
    
    
   
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            
            if tableView == notificationTV {
    //            NotificationTableViewCell
                let cell = notificationTV.cellForRow(at: IndexPath(row: indexPath.row, section: 0)) as! NotificationTableViewCell
                let jtype = cell.jobTypeLbl.text ?? ""
    //            let vc = self.storyboard?.instantiateViewController(identifier: "NewAppointmentDetailsVC") as! NewAppointmentDetailsVC
    //
                if isSearchFilter{
    //                vc.appointmentID = searchArray[indexPath.row].appointmentID ?? 0//
    //                self.navigationController?.pushViewController(vc, animated: true)
                    
                    if self.searchArray[indexPath.row].fileType?.replacingOccurrences(of: " ", with: "") == "B"{
                        
                        if jtype == "Onsite Interpretation" || jtype == "ONSITE INTERPRTATION"{
                            let vc =   self.storyboard?.instantiateViewController(withIdentifier: "BlockedAppointmentVC") as! BlockedAppointmentVC
                            vc.appointmentID = self.searchArray[indexPath.row].appointmentID ?? 0
                            
    //                        vc.startTime = sTime ?? ""
    //                        vc.endTime = eTime ?? ""
                            vc.modalPresentationStyle = .fullScreen
                            self.present(vc, animated: true, completion: nil)
                        }
                        else if jtype == "Telephone Conference" || jtype == "TELEPHONE CONFERENCE"{
                            let vc =   self.storyboard?.instantiateViewController(withIdentifier: "BlockedAppointmentTelephonicConferenceDetails") as! BlockedAppointmentTelephonicConferenceDetails
                            vc.appointmentID = self.searchArray[indexPath.row].appointmentID ?? 0
                            
    //                        vc.startTime = sTime ?? ""
    //                        vc.endTime = eTime ?? ""
                            vc.modalPresentationStyle = .fullScreen
                            self.present(vc, animated: true, completion: nil)
                        }else if jtype == "Virtual Meeting" || jtype == "VIRTUAL MEETING"{
                            
                            let vc =   self.storyboard?.instantiateViewController(withIdentifier: "BlockedAppointmentVirtualMeetingDetails") as! BlockedAppointmentVirtualMeetingDetails
                            vc.appointmentID = self.searchArray[indexPath.row].appointmentID ?? 0
                            
    //                        vc.startTime = sTime ?? ""
    //                        vc.endTime = eTime ?? ""
                            vc.modalPresentationStyle = .fullScreen
                            self.present(vc, animated: true, completion: nil)
                        }else {
                            return
                        }
                    }else {
                        if jtype == "Onsite Interpretation" || jtype == "ONSITE INTERPRTATION" {
                            let vc = self.storyboard?.instantiateViewController(identifier: "NewAppointmentDetailsVC") as! NewAppointmentDetailsVC
                            vc.appointmentID = self.searchArray[indexPath.row].appointmentID ?? 0
                            vc.serviceType = jtype ?? "N/A"
                            self.navigationController?.pushViewController(vc, animated: true)
                        }else if jtype == "Telephone Conference" || jtype == "TELEPHONE CONFERENCE" || jtype == "Virtual Meeting" || jtype == "VIRTUAL MEETING" {
                            
                            let vc = self.storyboard?.instantiateViewController(identifier: "TelephoneConferenceDetailsVC") as! TelephoneConferenceDetailsVC
                            vc.appointmentID = self.searchArray[indexPath.row].appointmentID ?? 0
                            vc.serviceType = jtype ?? "N/A"
                            self.navigationController?.pushViewController(vc, animated: true)
                        } else {
                            return

                            
                        }
                    }
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                }else {
             
                    if self.parentArray[indexPath.row].fileType?.replacingOccurrences(of: " ", with: "") == "B"{
                        
                        if jtype == "Onsite Interpretation" || jtype == "ONSITE INTERPRTATION"{
                            let vc =   self.storyboard?.instantiateViewController(withIdentifier: "BlockedAppointmentVC") as! BlockedAppointmentVC
                            vc.appointmentID = self.parentArray[indexPath.row].appointmentID ?? 0
                            
    //                        vc.startTime = sTime ?? ""
    //                        vc.endTime = eTime ?? ""
                            vc.modalPresentationStyle = .fullScreen
                            self.present(vc, animated: true, completion: nil)
                        }
                        else if jtype == "Telephone Conference" || jtype == "TELEPHONE CONFERENCE"{
                            let vc =   self.storyboard?.instantiateViewController(withIdentifier: "BlockedAppointmentTelephonicConferenceDetails") as! BlockedAppointmentTelephonicConferenceDetails
                            vc.appointmentID = self.parentArray[indexPath.row].appointmentID ?? 0
                            
    //                        vc.startTime = sTime ?? ""
    //                        vc.endTime = eTime ?? ""
                            vc.modalPresentationStyle = .fullScreen
                            self.present(vc, animated: true, completion: nil)
                        }else if jtype == "Virtual Meeting" || jtype == "VIRTUAL MEETING"{
                            
                            let vc =   self.storyboard?.instantiateViewController(withIdentifier: "BlockedAppointmentVirtualMeetingDetails") as! BlockedAppointmentVirtualMeetingDetails
                            vc.appointmentID = self.parentArray[indexPath.row].appointmentID ?? 0
                            
    //                        vc.startTime = sTime ?? ""
    //                        vc.endTime = eTime ?? ""
                            vc.modalPresentationStyle = .fullScreen
                            self.present(vc, animated: true, completion: nil)
                        }else {
                            return
                        }
                    }else {
                        if jtype == "Onsite Interpretation" || jtype == "ONSITE INTERPRTATION" {
                            let vc = self.storyboard?.instantiateViewController(identifier: "NewAppointmentDetailsVC") as! NewAppointmentDetailsVC
                            vc.appointmentID = self.parentArray[indexPath.row].appointmentID ?? 0
                            vc.serviceType = jtype ?? "N/A"
                            self.navigationController?.pushViewController(vc, animated: true)
                        }else if jtype == "Telephone Conference" || jtype == "TELEPHONE CONFERENCE" || jtype == "Virtual Meeting" || jtype == "VIRTUAL MEETING" {
                            
                            let vc = self.storyboard?.instantiateViewController(identifier: "TelephoneConferenceDetailsVC") as! TelephoneConferenceDetailsVC
                            vc.appointmentID = self.parentArray[indexPath.row].appointmentID ?? 0
                            vc.serviceType = jtype ?? "N/A"
                            self.navigationController?.pushViewController(vc, animated: true)
                        } else {
                            return

                            
                        }
                    }
                    
                    
                    
                    
                    
                    
                }
                
                
                
    //            vc.appointmentID = searchArray[indexPath.row].appointmentID ?? 0//
    //            self.navigationController?.pushViewController(vc, animated: true)
            }else {
                //statusFilterSearch = self.appointmentStatusArr[indexPath.row]
                print("abcd ")
                let cell = filterTV.cellForRow(at: indexPath) as! StatusFilterTableViewCell
                
                if self.filterSearch[indexPath.row].searchSelect == false{
                    
                    cell.titleImg.image = UIImage(systemName: "checkmark.square.fill")
                    self.filterSearch[indexPath.row].searchSelect = true
                    let status = self.filterSearch[indexPath.row].name
                    self.appointmentStatusArr.append(status)
                    print("SENDDD TO SERVERR ARRAY ISSS \(appointmentStatusArr)")
                }
                else {
                    cell.titleImg.image = UIImage(systemName: "square")
                    self.filterSearch[indexPath.row].searchSelect = false
                    let status = self.filterSearch[indexPath.row].name
                    if let index = appointmentStatusArr.firstIndex(of: status) {
                        appointmentStatusArr.remove(at: index)
                        print("SENDDD TO SERVERR ARRAY ISSS \(appointmentStatusArr)")
                    }
                }
                
            }
            
        }
    func getTimefromTimeStamp(timeStamp: String ) -> String {
        let t = Int(timeStamp) ?? 0/1000
        let unixTimestamp = "\(t)"
        print("unixTimestamp",unixTimestamp , t )
        //"\(1622138536)"   1638360102567
        let epochTime = TimeInterval(t) / 1000
        // let date6 = Date(timeIntervalSince1970: epochTime)
        let ddate = Date(timeIntervalSince1970: epochTime)
        print("date from timestamp is ",ddate )
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.locale = Locale(identifier: "en_US_POSIX")
        dateFormatterGet.timeZone = NSTimeZone(name: "UTC") as TimeZone?
        dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateString = dateFormatterGet.string(from: ddate)
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.locale = Locale(identifier: "en_US_POSIX")
        dateFormatterPrint.dateFormat = "MM/dd/yyyy hh:mm a"
        let date: NSDate? = dateFormatterGet.date(from: dateString) as NSDate?
        let currentdate = dateFormatterPrint.string(from: date! as Date)
        
        print("date converted is ", currentdate)
        return currentdate
    }
}

class StatusFilterTableViewCell : UITableViewCell{
    @IBOutlet var titleLbl: UILabel!
    @IBOutlet var titleImg: UIImageView!
}

class TestNav : UINavigationController{
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension UIView{
    func addShadowGrey(){
        self.layer.borderWidth = 0.0
        self.layer.masksToBounds = false
        self.layer.shadowRadius = 4.0
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        self.layer.shadowOpacity = 0.4
        self.layer.cornerRadius = 10
    }
}

extension String{
    var digits: String {
        return components(separatedBy: CharacterSet.decimalDigits.inverted)
            .joined()
    }
}

struct FilterSearch{
    var name: String = ""
    var searchSelect : Bool = false
}

//let urlString = "https://lsp.smsionline.com/Home/GetData?methodType=NotificationsByUsername&UserID=\(userId)&CompanyID=\(companyID)&SortOrder=Desc&RowNumber=0&AppID=0"

extension NotificationViewController{
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

