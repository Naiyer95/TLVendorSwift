//
//  CalendarViewController.swift
//  TotalVendor
//
//  Created by Darrin Brooks on 12/08/21.
//

import UIKit
import SideMenu
import FSCalendar
import CoreLocation
import Alamofire

import SwiftPullToRefresh
var userDefaults = UserDefaults.standard
class CalendarViewController: UIViewController, UITableViewDelegate,UITableViewDataSource,CLLocationManagerDelegate {
    var Live_BASE_URL = "https://lsp.totallanguage.com/"
    @IBOutlet weak var companyLogoIcon: UIImageView!
    var apiNotificationCountResponseModel : ApiNotificationCountResponseModel?
    @IBOutlet weak var availabilityStatusSwitch: UISwitch!
    var apiLogoutApi : ApiUpdateTokenResponseModel?
    var menu : SideMenuNavigationController!
    @IBOutlet weak var notificationBtn: MIBadgeButton!
    var apiGoogleTimeZoneresponse:ApiGoogleTimeZoneresponse?
    var cLocationManager = CLLocationManager()
    var apiNotificationCountNewResponseModel : ApiNotificationCountNewResponseModel?
//https://lsp.totallanguage.com/Home/GetData?methodType=NotificationsCounts%2CNOTIFICATIONSCOUNTSSTAFF%2CGETSYSTEMADMINNOTIFICATION&UserID=219342&CompanyId=52
    var apiCheckCallStatusResponseModel = [ApiCheckSingleSignInResponseModel]()
    @IBOutlet weak var userNameLbl: UILabel!
    var lattitude = "0.0"
    var longitude = "0.0"
    var apiAvailabilityStatusResponseModel : ApiAvailabilityStatusResponseModel?
    var eventColor = [UIColor]()
    @IBOutlet weak var dashboardTableView: UITableView!
    var apiScheduleAppointmentResponseModel : ApiCalendarDataResponseModel?
    var dataTask:URLSessionDataTask!
    var pullToRefreshCalled = false
    var URLReqObj:URLRequest!
    @IBOutlet weak var calendarTableView: UITableView!
    @IBOutlet weak var noDataLabel: UILabel!
    @IBOutlet weak var vriOpiView: UIView!
    @IBOutlet weak var calendarView: FSCalendar!
    var showAppointmentArr = [ApiCalendarDataVendorScheduleData?]()
    var calenderObject = FSCalendar()
    var apiGetSpecialityDataModel:ApiGetSpecialityDataModel?
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let userId = userDefaults.string(forKey: UserDeafultsString.instance.UserID) ?? ""
        if Reachability.isConnectedToNetwork(){
            self.getNotificatioDetail()
            self.checkSingleSignin()
            self.getCurrentAvailableStatus(customerId: userId)
           
        }else {
            self.view.makeToast("Please check your internet connection")
        }
        
        dashboardTableView.spr_beginRefreshing()
    }
    
    
    func locAuthentication(){
        cLocationManager.delegate = self
        cLocationManager.distanceFilter = 200
        cLocationManager.startUpdatingLocation()
        cLocationManager.requestAlwaysAuthorization()
        cLocationManager.requestWhenInUseAuthorization()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
        self.locAuthentication()
        vriOpiView.visibility = .gone
        dashboardTableView.spr_setIndicatorHeader { [weak self] in
            DispatchQueue.main.async {
                self?.action()
            }
        }
        getServiceType()
        print("companyname--------->",UserDefaults.standard.string(forKey: UserDeafultsString.instance.CompanyName))
        let imageData = (userDefaults.value(forKey: UserDeafultsString.instance.CompanyLogo) ?? "")
        let finalData = "\(Live_BASE_URL)\(imageData)"
        print("FINAL DATA IS \(finalData)")
        if imageData as! String != "" {
            self.companyLogoIcon.sd_setImage(with: URL(string: finalData), completed: nil)
        }else {
            self.companyLogoIcon.image = UIImage(named: "logo")
            
        }
        userNameLbl.text = UserDefaults.standard.string(forKey: UserDeafultsString.instance.CompanyName)
        notificationBtn.badgeString = "0"
        notificationBtn.badgeBackgroundColor = #colorLiteral(red: 0, green: 0.5686412892, blue: 0, alpha: 1)
        notificationBtn.badgeTextColor = UIColor.white
        notificationBtn.badgeEdgeInsets = UIEdgeInsets(top: 2, left: 0, bottom: 0, right: 2)
//        calendarTableView.bounces = false
        
//        noDataLabel.text = "No records found  Please select another date"
//        noDataLabel.isHidden = false
        //        calendarTableView.isHidden = true
        
//        calendarTableView.delegate = self
//        calendarTableView.dataSource = self
        menu = SideMenuNavigationController(rootViewController: SideMenuViewController())
        menu.leftSide = true
        menu.setNavigationBarHidden(true, animated: true)
        /*
         var URLReqObj = URLRequest(url: URL(string: "https://lspservices.totallanguage.com/api/GetVendorDashboard")!)
         URLReqObj.httpMethod = "POST"
         let parameters: [String: Any] = ["strSearchString": "<INFO><STARTDATE>05/01/2021 12:00 AM</STARTDATE><ENDDATE>05/30/2021 11:59 PM</ENDDATE><USERID>218032</USERID><COMPANYID>51</COMPANYID><INTERPRETERID>218032</INTERPRETERID></INFO>"]
         URLReqObj.httpBody = parameters.percentEncoded()
         dataTask = URLSession.shared.dataTask(with: URLReqObj, completionHandler: { (receiveData, connDetails, error) in
         print("ERROR IS \(error)")
         print("receiveData IS \(receiveData)")
         print("connDetails IS \(connDetails)")
         do{
         var JsonData = try JSONSerialization.jsonObject(with: receiveData!, options: JSONSerialization.ReadingOptions.allowFragments) as! NSArray
         var JsonDataArr = JsonData[0] as! NSDictionary
         var JsonDataDic = JsonDataArr["result"] as! String
         let  data = JsonDataDic.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))!
         let dataURL = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as! NSArray
         let responceData = dataURL[0] as! NSDictionary
         let UserAppInfo = responceData["UserAppInfo"] as! NSArray
         let CalendarInfo = responceData["CalendarInfo"] as! NSArray
         let GirdViewInfo = responceData["GirdViewInfo"] as! NSArray
         let GirdViewTooltipInfo = responceData["GirdViewTooltipInfo"] as! NSArray
         let CallActivity = responceData["CallActivity"] as! NSArray
         let QuickLinks = responceData["QuickLinks"] as! NSArray
         let Permission = responceData["Permission"] as! NSArray
         print("responceData DAHBOARD SCREEN DATA IS \(responceData)")
         }catch{
         print("Something went wrong")
         }
         })
         */
        // dataTask.resume()
        // Do any additional setup after loading the view.
    }
    func action() {
        pullToRefreshCalled=true
        print("Data reload ")
        SwiftLoader.show(animated: true)
        self.updateUI()
        
        self.getNotificatioDetail()
        createCalendar()
        //        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
        //            self.dashboardTableView.spr_endRefreshing()
        //        }
    }
    
    private func updateUI(){
        //            calendarTableView.register(UINib(nibName: nibNamed.calendarTVCell, bundle: nil), forCellReuseIdentifier: HomeCellIdentifier.calendarTVCell.rawValue)
        dashboardTableView.separatorStyle = .none
        dashboardTableView.tableFooterView = UIView(frame: .zero)
        dashboardTableView.delegate = self
        dashboardTableView.dataSource = self
        //        calendarTableView.reloadData()
    }
    
    fileprivate let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter
    }()
    
    
    //    @IBAction func actionReload(_ sender: UIButton) {
    //        self.createCalendar()
    //    }
    
    
    
    func createCalendar(){
        
        calendarView.subviews.forEach { (item) in
            item.removeFromSuperview()
        }
        let calendar = FSCalendar(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 300))
        calendar.placeholderType = .none
        calendar.appearance.caseOptions = FSCalendarCaseOptions.weekdayUsesSingleUpperCase
        calendar.dataSource = self
        calendar.delegate = self
        calendar.appearance.titleTodayColor = UIColor.black
        calendar.appearance.headerMinimumDissolvedAlpha = 0.3
        calendar.appearance.todaySelectionColor = UIColor(hexString: "199DD9")
        calendar.appearance.selectionColor = UIColor(hexString: "199DD9")
        calendar.appearance.todayColor = UIColor.white
        calendar.appearance.titleSelectionColor = UIColor.white
        //        calendar.appearance.separators = .interRows
        calendar.calendarHeaderView.backgroundColor = UIColor(hexString: "#199DD9")
        
        
        let tDate = Date()
        let formatterTest = DateFormatter()
        formatterTest.dateFormat = "yyyy/MM/dd"
        print(formatterTest.string(from: tDate))
        let finalDate = formatterTest.string(from: tDate)
        
        calendar.select(self.formatter.date(from: finalDate)!)
        //        calendar.appearance.headerMinimumDissolvedAlpha = (0.8)
        
        calendar.appearance.headerTitleColor = .white
        self.calenderObject = calendar
        calendar.scope = .month
        // if self.calendarView.subviews.count == 0 {
        self.calendarView.addSubview(calendar)
        let FirstDate = Date()    //.startOfMonth()
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        
        guard let result : String = formatter.string(from: FirstDate) as String? else { return }
        print("selected Date -->",result )
        let userId = userDefaults.string(forKey: UserDeafultsString.instance.UserID) ?? ""
        let VendorID = userDefaults.string(forKey: UserDeafultsString.instance.UserID) ?? ""
        let userTypeID = userDefaults.string(forKey: UserDeafultsString.instance.UserTypeID) ?? ""
        print("userId is \(userId) , cutomerId is \(VendorID) , usertypeID is \(userTypeID)")
        self.hitApigetAllScheduleAppointment(date: result, customerId: userId, selectedDate: result)
    }
    
    @IBAction func notificationBtnTapped(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "NotificationViewController") as! NotificationViewController
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventOffsetFor date: Date) -> CGPoint {
        return CGPoint(x: 0, y: -5)
    }
    
    
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
    }
    
    /*
     
     func hitGetCalendarDataApi(oldPass: String,newPassword: String){
     //        https://lspservices.smsionline.com/
     let liveURL = "https://lsp.smsionline.com/Appointment/GetFormData?methodType=VENDORSCHEDULEDATA&Vendor=217889&Type=1&Date=10/01/2021"
     let testingURL = "      https://lsp.smsionline.com/Appointment/GetFormData?methodType=VENDORSCHEDULEDATA&Vendor=217889&Type=1&Date=10/01/2021"
     let url =  URL(string:"\(APIs.Checkuser_API)")
     print("hitGetCalendarDataApi----------\(testingURL)")
     let token = UserDefaults.standard.value(forKey: "loginToken")//UserDefaults.value(forKey: "loginToken")
     let headers:HTTPHeaders = [
     //       "Authorization": "Bearer \(token!)",
     "Content-Type": "application/json",f
     "cache-control": "no-cache",
     ]
     let parameters = [
     "old_password": oldPass,
     "new_password": newPassword
     ] as [String : Any]
     
     AF.request(url as! URLConvertible, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
     .validate()
     .responseData { (respData) in
     switch (respData.result){
     case .success(_):
     guard let data = respData.data else {return}
     print("Success forgot_password-------\(data)")
     do{
     let decoder = JSONDecoder()
     self.updatePasswordApiResponseModel = try decoder.decode(UpdatePasswordApiResponseModel.self,1101 from: data)
     print("updatePasswordApiResponseModel-----Status----", self.updatePasswordApiResponseModel?.status ?? false)
     guard let status:Bool = self.updatePasswordApiResponseModel?.status else{ return }
     guard let apiMessage = self.updatePasswordApiResponseModel?.message else { return}
     
     
     //   let status = dict["error"] as! String
     if status == true{
     
     self.view.makeToast(apiMessage)
     
     print("results Otp\(apiMessage)")
     
     
     self.navigationController?.popToRootViewController(animated: true)
     
     //                            vc.modalPresentationStyle = .fullScreen
     //                            self.present(vc, animated: true, completion: nil)
     print("----- apiForgotPasswordResponseModel SUCCESSFUL----- ")
     }
     else {
     self.view.makeToast(apiMessage)
     }
     } catch let error {
     print(error)
     //                            self.view.makeToast(apiMessage)
     //       self.showAlertWithMsgNCancelBtn(withTitle: "Alert!", withMessage:"Error:Please try again later")
     }
     
     case .failure(_):
     //                        self.view.makeToast(apiMessage)
     //    self.showAlertWithMsgNCancelBtn(withTitle: "Alert!", withMessage:"Error:Please try again later")
     break
     }
     }
     
     }
     
     */
    
    
    
    var datesWithEvent = ["08/01/2021", "08/01/2021", "08/01/2021", "08/01/2021"]
    
    var datesWithMultipleEvents = ["2015-10-08", "2015-10-16", "2015-10-20", "2015-10-28"]
    
    fileprivate lazy var dateFormatter2: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/YYYY"
        return formatter
    }()
    
    //    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
    //
    //        let dateString = self.dateFormatter2.string(from: date)
    //
    //        if self.datesWithEvent.contains(dateString) {
    //            return 1
    //        }
    //
    //        if self.datesWithMultipleEvents.contains(dateString) {
    //            return 3
    //        }
    //
    //        return 0
    //    }
    
    
    
    @IBAction func SideMenuBtnAction(_ sender: Any) {
        present(menu, animated: true, completion: nil)
    }
   
    @IBAction func switchActionVRIOPI(_ sender: Any) {
        let statusAndFlagOn = "1"
        let statusAndFlagOff = "0"
        let vID = UserDefaults.standard.value(forKey: UserDeafultsString.instance.UserID) ?? "0"
        //        https://lsp.smsionline.com/Appointment/GetFormData?methodType=UPDATEAGENTSTATUS &vendoid=217712&status=1&flag=1
        //        var urlSTring = "https://lsp.totallanguage.com/Appointment/GetFormData?methodType=UPDATEAGENTSTATUS&vendoid=\(vID)&status=1&flag=1"
        var urlSTring = "https://lsp.totallanguage.com/Appointment/GetFormData?methodType=UPDATEAGENTSTATUS&vendoid=\(vID)&status=1&flag=1"
        if ((sender as AnyObject).isOn == true){
            
            urlSTring = "https://lsp.totallanguage.com/Appointment/GetFormData?methodType=UPDATEAGENTSTATUS&vendoid=\(vID)&status=\(statusAndFlagOn)&flag=1"
//            dashboardTableView.delegate = self
//            dashboardTableView.dataSource = self
//            noDataLabel.isHidden = true
//            calendarTableView.isHidden = false
            
        }
        else {
//            noDataLabel.isHidden = false
            //                calendarTableView.isHidden = true
            urlSTring = "https://lsp.totallanguage.com/Appointment/GetFormData?methodType=UPDATEAGENTSTATUS&vendoid=\(vID)&status=\(statusAndFlagOff)&flag=1"
        }
        
        //        if ((sender as AnyObject).isOn == true){
        //            let vID = UserDefaults.standard.value(forKey: UserDeafultsString.instance.UserID) ?? "0"
        //            let urlSTring = "https://lsp.totallanguage.com/Appointment/GetFormData?methodType=UPDATEAGENTSTATUS&vendoid=\(vID)&status=1&flag=1"
        
        URLReqObj = URLRequest(url: URL(string: urlSTring)!)
        print("URL REQUEST IS \(urlSTring)")
        URLReqObj.httpMethod = "GET"
        dataTask = URLSession.shared.dataTask(with: URLReqObj, completionHandler: { (receiveData, conneDetails, err) in
            
            do{
                print("RECEIVE DATA")
                var LanguageDataDic = try JSONSerialization.jsonObject(with: receiveData!, options: JSONSerialization.ReadingOptions.allowFragments) as! NSDictionary
                print(LanguageDataDic["UPDATEAGENTSTATUS"])
                print("UPDATING STATUS DATA IS \(LanguageDataDic)")
            }catch{
                print("Something went wrong")
            }
        })
        
        dataTask.resume()
        
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
extension CalendarViewController :FSCalendarDataSource ,FSCalendarDelegateAppearance , FSCalendarDelegate {
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        print("changed")
        let maxDate = calendar.currentPage
        // Create Date Formatter
        let dateFormatter = DateFormatter()
        // Set Date Format
        dateFormatter.dateFormat = "yyyy-MM-dd"
        // Convert Date to String
        let endDate = dateFormatter.string(from: maxDate)
        // self.hitApiGetWeeklyJournals(dateStr: endDate, calender: calendar )
        print("Week end date \(endDate) is")
        // let FirstDate = date.startOfMonth() ?? Date()
        let userId = userDefaults.string(forKey: UserDeafultsString.instance.UserID) ?? ""
        print("userId is \(userId)")
        
        self.hitApigetAllScheduleAppointment(date: endDate, customerId: userId, selectedDate: endDate)
        
    }
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventDefaultColorsFor date: Date) -> [UIColor]? {
            
            let formatter = DateFormatter()
            formatter.dateFormat = "MM/dd/yyyy"
            guard let result : String = formatter.string(from: date) as String? else { return nil }
            eventColor.removeAll()
            
            self.apiScheduleAppointmentResponseModel?.vENDORSCHEDULEDATA?.forEach({ appointmentData in
                let rawDate = appointmentData.startDateTime ?? ""
                let newDate = convertDateFormater(rawDate)
                print("new date is in number of event\(newDate)")
                print("result date is in number of event  \(result)")
                if newDate == result {
                    self.apiScheduleAppointmentResponseModel?.vENDORSCHEDULEDATA?.forEach({ appointmentStatusData in
                        
                    })
                        
                        let statusColor =  getHexaString(status: (appointmentData.appointmentStatusType?.lowercased()) as? String ?? "")
                        print("APPOINTMENT STATUS CODE IS \(appointmentData.appointmentStatusType ?? "") AND NEW DATE  IS \(result)")
                        print("STATUS COLOR IS \(statusColor ?? "")")
                        eventColor.append(UIColor(hexString: statusColor ?? ""))
        
                    
                }
                
            })

            if eventColor.count == 0 {
                SwiftLoader.hide()
                return nil
            }else {
                SwiftLoader.hide()
                return eventColor //[UIColor.green , UIColor.red]
            }
        }
    
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        
        let FirstDate = date.startOfMonth() ?? Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        guard let result : String = formatter.string(from: FirstDate) as String? else { return }
        guard let selectedDate : String = formatter.string(from: date) as String? else { return }
        print("selected Date -->",result )
        let userId = userDefaults.string(forKey: "userId") ?? ""
        print("userId is \(userId)")
        
        
        
        print("SELCTED DATE IS \(date) and today date is \(Date())")
        
        self.showAppointmentArr.removeAll()
        self.apiScheduleAppointmentResponseModel?.vENDORSCHEDULEDATA?.forEach({ appointmentData in
            let rawDate = appointmentData.startDateTime ?? ""
            let newDate = convertDateFormater(rawDate)
            print("raw date is ",rawDate)
            print("new date is ",newDate)
            print("selected date is ",selectedDate)
            if selectedDate == newDate {
                self.showAppointmentArr.append(appointmentData)
            }
        })
        
        
        print("total appointment for \(selectedDate) are \(self.showAppointmentArr.count)")
        
        dashboardTableView.reloadData()
        //        self.dashboardTableView.spr_endRefreshing()fevent
        // self.hitApigetAllScheduleAppointment(date: result, customerId: userId, selectedDate: selectedDate)
    }
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        guard let result : String = formatter.string(from: date) as String? else { return 0}
        var eventCount = 0
        print("count of appointment \(self.apiScheduleAppointmentResponseModel?.vENDORSCHEDULEDATA?.count ?? 0) for date \(result)")
        for scheduleAppointment in (self.apiScheduleAppointmentResponseModel?.vENDORSCHEDULEDATA ?? [ApiCalendarDataVendorScheduleData]())! {
            let rawDate = scheduleAppointment.startDateTime ?? ""
            let newDate = convertDateFormater(rawDate)
            print("new date is in number of event\(newDate)")
            print("result date is in number of event  \(result)")
            if newDate == result {
                eventCount = eventCount + 1
                print("event count \(eventCount)")
                
            }
        }
        return eventCount
    }
    
    func calendar(_ calendar: FSCalendar, imageFor date: Date) -> UIImage? {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        guard let result : String = formatter.string(from: date) as String? else { return UIImage(named: "")}
        var eventCount = 0
        print("count of appointment \(self.apiScheduleAppointmentResponseModel?.vENDORSCHEDULEDATA?.count ?? 0) for date \(result)")
        for scheduleAppointment in (self.apiScheduleAppointmentResponseModel?.vENDORSCHEDULEDATA ?? [ApiCalendarDataVendorScheduleData]())! {
            let rawDate = scheduleAppointment.startDateTime ?? ""
            let newDate = convertDateFormater(rawDate)
            print("new date is in number of event\(newDate)")
            print("result date is in number of event  \(result)")
            if newDate == result {
                eventCount = eventCount + 1
                print("event count \(eventCount)")
                
            }
        }
        if eventCount > 3 {
            return UIImage(named: "addTest")
        }else {
            return UIImage(named: "")
        }
        
        
        
        
        
        
        //        return UIImage(named: "addTest")
        
        
    }
    
    
    
    
}

extension Date {
    func startOfMonth() -> Date? {
        let comp: DateComponents = Calendar.current.dateComponents([.year, .month, .hour], from: Calendar.current.startOfDay(for: self))
        return Calendar.current.date(from: comp)!
    }
    
    func endOfMonth() -> Date? {
        var comp: DateComponents = Calendar.current.dateComponents([.month, .day, .hour], from: Calendar.current.startOfDay(for: self))
        comp.month = 1
        comp.day = -1
        return Calendar.current.date(byAdding: comp, to: self.startOfMonth()!)
    }
}






extension Dictionary {
    func percentEncoded() -> Data? {
        return map { key, value in
            let escapedKey = "\(key)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            let escapedValue = "\(value)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            return escapedKey + "=" + escapedValue
        }
        .joined(separator: "&")
        .data(using: .utf8)
    }
}

extension CharacterSet {
    static let urlQueryValueAllowed: CharacterSet = {
        let generalDelimitersToEncode = ":#[]@" // does not include "?" or "/" due to RFC 3986 - Section 3.4
        let subDelimitersToEncode = "!$&'()*+,;="
        
        var allowed = CharacterSet.urlQueryAllowed
        allowed.remove(charactersIn: "\(generalDelimitersToEncode)\(subDelimitersToEncode)")
        return allowed
    }()
}


struct JsonDataaa {
    var UserAppInfo:NSArray!
    var QuickLinks :NSArray!
    var PermissionType:NSArray!
}

extension UIView {
    func dropShadow(scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = .zero
        layer.shadowRadius = 1
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
}


class ScheduleTableViewCell : UITableViewCell{
    
    @IBOutlet weak var authCodelbl: UILabel!
    @IBOutlet weak var animatedBGView: UIView!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var targetLanguageLbl: UILabel!
    
    @IBOutlet weak var patientCaseNameLbl: UILabel!
    @IBOutlet weak var sourceLanguageLbl: UILabel!
    @IBOutlet var checkInLbl: UILabel!
    @IBOutlet var statusOfAppointmentLbl: UILabel!
    @IBOutlet var outerView: UIView!
    @IBOutlet var interpreterLbl: UILabel!
    @IBOutlet var typeOfMeetLbl: UILabel!
    @IBOutlet var venuLbl: UILabel!
    @IBOutlet var checkOutHeadingLbl: UILabel!
    @IBOutlet var clientNameLbl: UILabel!
    @IBOutlet var appointmentTimeLbl: UILabel!
    @IBOutlet var appointmentIDLbl: UILabel!
}

class AppointmentTVCell:UITableViewCell{
    
    @IBOutlet weak var clientVenueTitleView: UIStackView!
    @IBOutlet weak var clientVenueValueView: UIStackView!
    @IBOutlet weak var lblAppoinment: UILabel!
    
    @IBOutlet weak var lineOutlet: UILabel!
    @IBOutlet weak var checkInBtnIcon: UIImageView!
    @IBOutlet weak var plusBtn: UIButton!
    @IBOutlet weak var cameraBtn: UIButton!
    @IBOutlet weak var checkInBtn: UIButton!
    @IBOutlet weak var documentBtn: UIButton!
    @IBOutlet weak var venueLbl: UILabel!
    @IBOutlet weak var venueTitleLbl: UILabel!
    @IBOutlet weak var otherOptionsStackView: UIStackView!
    @IBOutlet weak var plusIconView: UIView!
    @IBOutlet weak var documentView: UIView!
    @IBOutlet weak var cameraIconView: UIView!
    @IBOutlet weak var checkInView: UIView!
    @IBOutlet var statusOuterView: UIView!
    @IBOutlet weak var venueNewLbl: UILabel!
    @IBOutlet var checkOutOuterView: UIView!
    @IBOutlet var startDateLbl: UILabel!
    @IBOutlet var customerName: UILabel!
    @IBOutlet var checkInLbl: UILabel!
    @IBOutlet var statusOfAppointmentLbl: UILabel!
    @IBOutlet var outerView: UIView!
    @IBOutlet var interpreterLbl: UILabel!
    @IBOutlet var typeOfMeetLbl: UILabel!
    
    @IBOutlet weak var venTitleLbl: UILabel!
    
    @IBOutlet var venuLbl: UILabel!
    @IBOutlet var checkOutHeadingLbl: UILabel!
    @IBOutlet var clientNameLbl: UILabel!
    @IBOutlet var targetLanguageLbl: UILabel!
    @IBOutlet var sourceLanguageLbl: UILabel!
    @IBOutlet var appointmentTimeLbl: UILabel!
    @IBOutlet var appointmentIDLbl: UILabel!
    override func awakeFromNib() {
        
        
        outerView.addShadowGrey()
        self.selectionStyle = .none
    }
}







extension UIColor {
    public convenience init?(hex: String) {
        let r, g, b, a: CGFloat
        
        if hex.hasPrefix("#") {
            let start = hex.index(hex.startIndex, offsetBy: 1)
            let hexColor = String(hex[start...])
            
            if hexColor.count == 8 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0
                
                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                    g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                    b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                    a = CGFloat(hexNumber & 0x000000ff) / 255
                    
                    self.init(red: r, green: g, blue: b, alpha: a)
                    return
                }
            }
        }
        
        return nil
    }
}


extension CalendarViewController{
    func hitApigetAllScheduleAppointment(date:String ,customerId:String , selectedDate:String){
        SwiftLoader.show(animated: true)
       
        
        let urlString = "https://lsp.totallanguage.com/Home/GetData?methodType=APPVENDORDASHBOARD&Vendor=\(customerId)&Date=\(date)"
        print("url to get schedule \(urlString)")
        AF.request(urlString, method: .get , parameters: nil, encoding: JSONEncoding.default, headers: nil)
            .validate()
            .responseData(completionHandler: { [self] (response) in
                //                SwiftLoader.hide()
                switch(response.result){
                    
                case .success(_):
                    print("Respose Success ")
                    guard let daata = response.data else { return }
                    do {
                        let jsonDecoder = JSONDecoder()
                        self.apiScheduleAppointmentResponseModel = try jsonDecoder.decode(ApiCalendarDataResponseModel.self, from: daata)
                        ColourResponse.sharedInstance.apiCalendarDataResponseModel = self.apiScheduleAppointmentResponseModel
                        print("Success")
                        print("SCHEDULE DATA IS \(self.apiScheduleAppointmentResponseModel)")
                        
                        self.showAppointmentArr.removeAll()
                        if self.apiScheduleAppointmentResponseModel?.vENDORSCHEDULEDATA?.count==0{
                            SwiftLoader.hide()
                        }
                        self.apiScheduleAppointmentResponseModel?.vENDORSCHEDULEDATA?.forEach({ appointmentData in
                            let rawDate = appointmentData.startDateTime ?? ""
                            let newDate = convertDateFormater(rawDate)
                            print("raw date is ",rawDate)
                            print("new date is ",newDate)
                            print("selected date is ",selectedDate)
                            if selectedDate == newDate {
                                self.showAppointmentArr.append(appointmentData)
                            }
                        })
                        
                        print("total appointment for \(selectedDate) are \(self.showAppointmentArr.count)")
                        DispatchQueue.main.async {
                            // calendarView.delegate=self
                            calenderObject.reloadData()
                            dashboardTableView.reloadData()
                            
                            
                            
                            
                            if pullToRefreshCalled{
                                pullToRefreshCalled=false
                                self.dashboardTableView.spr_endRefreshing()
                            }
                            
                            SwiftLoader.hide()
                            
                            
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


extension CalendarViewController{
    func getCurrentAvailableStatus(customerId:String){
        SwiftLoader.show(animated: true)
        /*  let headers: HTTPHeaders = [
         "Authorization": "Bearer \(UserDefaults.standard.value(forKey:"token") ?? "")",
         "cache-control": "no-cache"
         ]
         // print("😗---hitApiSignUpUser -" , Api.profile.url) 10/01/2021 */
        let urlString = "https://lsp.totallanguage.com/Appointment/GetFormData?methodType=UPDATEAGENTSTATUS&vendoid=\(customerId)&flag=0"//\(date)"
        print("url to get schedule \(urlString)")
        AF.request(urlString, method: .get , parameters: nil, encoding: JSONEncoding.default, headers: nil)
            .validate()
            .responseData(completionHandler: { [self] (response) in
                //                SwiftLoader.hide()
                switch(response.result){
                    
                case .success(_):
                    print("Respose Success ")
                    guard let daata = response.data else { return }
                    do {
                        let jsonDecoder = JSONDecoder()
                        self.apiAvailabilityStatusResponseModel = try jsonDecoder.decode(ApiAvailabilityStatusResponseModel.self, from: daata)
                        print("Success")
                        print("apiAvailabilityStatusResponseModel DATA IS \(self.apiAvailabilityStatusResponseModel)")
                        
                        print("API RESPONSE FINAL DATA IS \(self.apiAvailabilityStatusResponseModel?.uPDATEAGENTSTATUS?.first??.success)")
                        
                        if self.apiAvailabilityStatusResponseModel?.uPDATEAGENTSTATUS?.first??.success ?? 0==0{
                            availabilityStatusSwitch.isOn = false
                        }else {
                            availabilityStatusSwitch.isOn = true
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

extension CalendarViewController{
    func getServiceType(){
        //        SwiftLoader.show(animated: true)
        
        //Appointment/GetData?methodType=Speciality&CompanyId=55&SpType1=1
        let userId = userDefaults.string(forKey: UserDeafultsString.instance.UserID) ?? ""
        let companyId = userDefaults.string(forKey: UserDeafultsString.instance.CompanyID) ?? ""
        let userTypeID = userDefaults.string(forKey: UserDeafultsString.instance.UserTypeID) ?? ""
        let urlPostFix = "&CompanyId=\(companyId)&SpType1=1"
        
        let urlString = "\(APIs.Token_API)" + urlPostFix
        print("url for service  \(urlString)")
        AF.request(urlString, method: .get , parameters: nil, encoding: JSONEncoding.default, headers: nil)
            .validate()
            .responseData(completionHandler: { [self] (response) in
                //                SwiftLoader.hide()
                switch(response.result){
                    
                case .success(_):
                    print("Respose Success for service type  ")
                    guard let daata = response.data else { return }
                    do {
                        let jsonDecoder = JSONDecoder()
                        self.apiGetSpecialityDataModel = try jsonDecoder.decode(ApiGetSpecialityDataModel.self, from: daata)
                        print("Success")
                        GetPublicData.sharedInstance.apiGetSpecialityDataModel = self.apiGetSpecialityDataModel
                        
                        
                        
                        GetPublicData.sharedInstance.apic.removeAll()
                        self.apiGetSpecialityDataModel?.appointmentType?.forEach({ (abc) in
                            GetPublicData.sharedInstance.apic.append(abc)
                        })
                        print("count for appointment data \(GetPublicData.sharedInstance.apic.count)")
                        
                        
                        
                    } catch{
                        
                        print("error block forgot password " ,error)
                    }
                case .failure(_):
                    print("Respose Failure service ")
                    
                }
            })
    }
}

extension CalendarViewController{
    func getCurrentTimeZone(lattitude : String , longitude: String , timeStamp : String){
        let url = "https://maps.googleapis.com/maps/api/timezone/json?location=\(lattitude),\(longitude)&timestamp=\(timeStamp)&key=AIzaSyBs4BqawAAkN1ily7xcXUDeN7kruZ2BBI0"
        print("url to get time zone ", url )
        AF.request(url, method: .get , parameters: nil, encoding: JSONEncoding.default, headers: nil)
            .validate()
            .responseData(completionHandler: { [self] (response) in
                //                SwiftLoader.hide()
                switch(response.result){
                    
                case .success(_):
                    print("Respose getCurrentTimeZone ")
                    guard let daata = response.data else { return }
                    do {
                        let jsonDecoder = JSONDecoder()
                        self.apiGoogleTimeZoneresponse = try jsonDecoder.decode(ApiGoogleTimeZoneresponse.self, from: daata)
                        let status = self.apiGoogleTimeZoneresponse?.status ?? ""
                        print("GOOGLE TiME RESPONSE IS \(self.apiGoogleTimeZoneresponse)")
                        if status == "OK" {
                            let timeConverter1 = DateFormatter()
                            timeConverter1.dateFormat = "MM/dd/yyyy"
                            let dateStr = timeConverter1.string(from: Date())
                            let timeZone = self.apiGoogleTimeZoneresponse?.timeZoneName ?? ""
                            print("current time zone from google", timeZone)
                            let previousTimeZone = userDefaults.string(forKey: "TimeZone") ?? ""
                            print("previous TimeZone",previousTimeZone ?? "")
                            let updatedPTZ = previousTimeZone.replacingOccurrences(of: " ", with: "")
                            let updateCTZ = timeZone.replacingOccurrences(of: " ", with: "")
                            print("UPDTEED TIME ZONES ARE \(updatedPTZ) and \(updateCTZ)")
                            if updatedPTZ == updateCTZ {
                                
                            } else {
                                let tZoneDeclined =   UserDefaults.standard.value(forKey: UserDeafultsString.instance.timeZoneDeclined) as? Bool ?? false
                                if tZoneDeclined == false {
                                    let vc = storyboard?.instantiateViewController(identifier: "TimeZoneViewController") as! TimeZoneViewController
                                    vc.currentTimeZone = timeZone
                                    vc.timeZoneStr = "Your timezone had appeared to change from \(dateStr) - \(previousTimeZone) to \(dateStr) - \(timeZone)."
                                    vc.modalPresentationStyle = .overFullScreen
                                    self.present(vc, animated: true, completion: nil)
                                }
                               }
                        }
                    } catch{
                        self.view.makeToast("Please try after sometime.",duration: 2, position: .center)
                        print("error block forgot password " ,error)
                    }
                case .failure(_):
                    print("Respose Failure ")
                    self.view.makeToast("Please try after sometime.",duration: 2, position: .center)
                    
                }
            })
        
    }
    
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("location running....")
        self.lattitude = "\(locations.last!.coordinate.latitude)"
        self.longitude = "\(locations.last!.coordinate.longitude)"
        // self.studioListModel.dataList?.removeAllObjects()
        
        //startLocation = locations.last!
        let timeStamp = Int(Date().timeIntervalSince1970)
        let timeStampString = "\(timeStamp)"
        self.getCurrentTimeZone(lattitude: self.lattitude, longitude: self.longitude, timeStamp: timeStampString)
    }
}


extension CalendarViewController {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       // B = Blocked appointment
        //R = Regular appoinment
        let cell  = dashboardTableView.dequeueReusableCell(withIdentifier: "AppointmentTVCell", for: indexPath) as! AppointmentTVCell
        let index = showAppointmentArr[indexPath.row]
        cell.otherOptionsStackView.visibility = .gone
        
        let stringInput = index?.clientName?.trimmingCharacters(in: .whitespaces)
        let abc = stringInput ?? ""
        let stringInputArr = abc.components(separatedBy:" ")
        var stringNeed = ""
        let abcc:Character="C"
        for string in stringInputArr {
            stringNeed += String(string.first ?? abcc)
        }
       if index?.clientInitial != nil && index?.clientInitial != "" {
            cell.clientNameLbl.text = index?.clientInitial
        } else {
            cell.clientNameLbl.text = "N/A"
        }
        if index?.title?.replacingOccurrences(of: " ", with: "") == "B"{
            cell.lblAppoinment.text = "BLOCKED APPOINTMENT"
            cell.clientVenueTitleView.isHidden=true
            cell.clientVenueValueView.isHidden=true
           
        }else {
            cell.lblAppoinment.text = ""
            cell.clientVenueTitleView.isHidden=false
            cell.clientVenueValueView.isHidden=false
        }
        
        //        cell.clientNameLbl.text = stringNeed.uppercased()
        //        cell.clientNameLbl.text = index?.clientInitial
        cell.customerName.text = index?.customerName ?? "N/A"
        cell.typeOfMeetLbl.text = index?.appointmentType ?? "N/A"
        print("SLANGUAGE NAME IS \(index?.sLanguageName)")
        //        cell.clientNameLbl.text = index?.clientName ?? ""
        if index?.sLanguageName != nil && index?.sLanguageName != "" {
            cell.sourceLanguageLbl.text = index?.sLanguageName
        } else {
            cell.sourceLanguageLbl.text = "English"
        }
        if index?.languageName != nil && index?.languageName != "" {
            cell.targetLanguageLbl.text = index?.languageName
        } else {
            cell.targetLanguageLbl.text = "N/A"
        }
        
        
        if index?.appointmentType == "Schedule VRI" || index?.appointmentType == "Schedule OPI" || index?.appointmentType == "SCHEDULE VRI" || index?.appointmentType == "SCHEDULE OPI"{
            cell.appointmentIDLbl.text = index?.tierName ?? "N/A"
            print("TIER NAME IS \(index?.tierName)")
        }else {
            cell.appointmentIDLbl.text = index?.authCode ?? "N/A"
            print("AUTH CODE  IS \(index?.authCode)")
        }
       
        cell.statusOfAppointmentLbl.text = " \(index?.appointmentStatusType ?? "N/A") "
        
        let dateValue = index?.startDateTime ?? ""
        let timeValue = convertDateAndTimeFormat(dateValue)
       
        
        cell.statusOfAppointmentLbl.backgroundColor = hexStringToUIColor(hex: getHexaString(status: (index?.appointmentStatusType?.lowercased())!)!)
        let checkInStatus = index?.checkIn ?? 0
        let checkOutStatus = index?.checkOut  ?? 0
        let statusType = index?.appointmentStatusType ?? ""
        print("stsus of appointment  \(statusType) ,\(checkInStatus) , \(checkOutStatus)")
        if statusType == "BOOKED"{
            if checkInStatus == 1  && checkOutStatus == 0 {
                cell.checkInLbl.isHidden = false
                cell.checkOutHeadingLbl.isHidden = false
                cell.checkInLbl.text = "Checked In"
            }else if checkInStatus == 1  && checkOutStatus == 1 {
                cell.checkInLbl.isHidden = false
                cell.checkOutHeadingLbl.isHidden = false
                cell.checkInLbl.text = "Checked Out"
            }else {
                cell.checkInLbl.isHidden = true
                cell.checkOutHeadingLbl.isHidden = true
            }
        }else{
            cell.checkInLbl.isHidden = true
            cell.checkOutHeadingLbl.isHidden = true
        }
        
        let rawTime = index?.startDateTime ?? ""
        
        let endTimee = convertTimeFormater(index?.endDateTime ?? "")
//        let newDate = convertTimeFormaterOnlyDate(rawTime)
//        cell.startDateLbl.text = newDate
        cell.appointmentTimeLbl.text = convertTimeFormater(rawTime) + " \(userDefaults.value(forKey: UserDeafultsString.instance.ZoneShortForm) ?? "")"
        cell.startDateLbl.text = convertTimeFormater(rawTime) + " (\(userDefaults.value(forKey: UserDeafultsString.instance.ZoneShortForm) ?? ""))"
        cell.venuLbl.text = endTimee
        //        cell.venuLbl.text = newTime
        cell.venueLbl.text = index?.venueName ?? ""
        cell.venueLbl.removeEmptyString()
        if index?.appointmentType == "Onsite Interpretation"
        {
            //            cell.venueTitleLbl.isHidden = false
            //            cell.venueLbl.isHidden = false
            //            cell.venTitleLbl.isHidden = false
            //            cell.venueLbl.isHidden = false
            
            
            cell.lineOutlet.visibility = .visible
//            cell.otherOptionsStackView.visibility = .visible
//            cell.otherOptionsStackView.distribution = .fillEqually
//            cell.otherOptionsStackView.spacing = 5.0
            
            
            if index?.appointmentStatusType ==
                "BOOKED"{
                cell.lineOutlet.visibility = .visible
//                cell.otherOptionsStackView.visibility = .visible
            }else {
                cell.lineOutlet.visibility = .gone
//                cell.otherOptionsStackView.visibility = .gone
            }
            
            
            
            
        }
        else if  index?.appointmentType == "Telephone Conference"{
            
            if index?.appointmentStatusType ==
                "BOOKED"{
                cell.lineOutlet.visibility = .visible
//                
            }else {
                cell.lineOutlet.visibility = .gone
//
            }
        }
        else {
           
            cell.lineOutlet.visibility = .gone
            
        }
if  index?.appointmentType == "Virtual Meeting" || index?.appointmentType == "Telephone Conference"{
    cell.venueTitleLbl.isHidden = true
  cell.venueLbl.isHidden = true
        }
else {
    cell.venueTitleLbl.isHidden = false
  cell.venueLbl.isHidden = false
}
        
        cell.plusBtn.addTarget(self, action: #selector(openDialog(sender:)), for: .touchUpInside)
        cell.cameraBtn.addTarget(self, action: #selector(openDialog(sender:)), for: .touchUpInside)
        cell.checkInBtn.addTarget(self, action: #selector(openDialog(sender:)), for: .touchUpInside)
        cell.documentBtn.addTarget(self, action: #selector(openDialog(sender:)), for: .touchUpInside)
        
        return cell
    }
    
    @objc func openDialog(sender: UIButton){
        self.openDialogBox()
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        let cell = dashboardTableView.cellForRow(at: IndexPath(row: indexPath.row, section: 0)) as! AppointmentTVCell
    
        let sTime = cell.startDateLbl.text
        let eTime = cell.venuLbl.text
        if self.showAppointmentArr[indexPath.row]?.title?.replacingOccurrences(of: " ", with: "") == "B"{
            
            if self.showAppointmentArr[indexPath.row]?.appointmentType == "Onsite Interpretation" || self.showAppointmentArr[indexPath.row]?.appointmentType == "ONSITE INTERPRTATION"{
                let vc =   self.storyboard?.instantiateViewController(withIdentifier: "BlockedAppointmentVC") as! BlockedAppointmentVC
                vc.appointmentID = self.showAppointmentArr[indexPath.row]?.appointmentID ?? 0
                
                vc.startTime = sTime ?? ""
                vc.endTime = eTime ?? ""
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true, completion: nil)
            }
            else if self.showAppointmentArr[indexPath.row]?.appointmentType == "Telephone Conference" || self.showAppointmentArr[indexPath.row]?.appointmentType == "TELEPHONE CONFERENCE"{
                let vc =   self.storyboard?.instantiateViewController(withIdentifier: "BlockedAppointmentTelephonicConferenceDetails") as! BlockedAppointmentTelephonicConferenceDetails
                vc.appointmentID = self.showAppointmentArr[indexPath.row]?.appointmentID ?? 0
                
                vc.startTime = sTime ?? ""
                vc.endTime = eTime ?? ""
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true, completion: nil)
            }else if self.showAppointmentArr[indexPath.row]?.appointmentType == "Virtual Meeting" || self.showAppointmentArr[indexPath.row]?.appointmentType == "VIRTUAL MEETING"{
                
                let vc =   self.storyboard?.instantiateViewController(withIdentifier: "BlockedAppointmentVirtualMeetingDetails") as! BlockedAppointmentVirtualMeetingDetails
                vc.appointmentID = self.showAppointmentArr[indexPath.row]?.appointmentID ?? 0
                
                vc.startTime = sTime ?? ""
                vc.endTime = eTime ?? ""
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true, completion: nil)
            }else {
                return
            }
        }else {
            if self.showAppointmentArr[indexPath.row]?.appointmentType == "Onsite Interpretation" || self.showAppointmentArr[indexPath.row]?.appointmentType == "ONSITE INTERPRTATION" {
                let vc = self.storyboard?.instantiateViewController(identifier: "NewAppointmentDetailsVC") as! NewAppointmentDetailsVC
                vc.appointmentID = self.showAppointmentArr[indexPath.row]?.appointmentID ?? 0
                vc.serviceType = self.showAppointmentArr[indexPath.row]?.appointmentType ?? "N/A"
                self.navigationController?.pushViewController(vc, animated: true)
            }else if self.showAppointmentArr[indexPath.row]?.appointmentType == "Telephone Conference" || self.showAppointmentArr[indexPath.row]?.appointmentType == "TELEPHONE CONFERENCE" || self.showAppointmentArr[indexPath.row]?.appointmentType == "Virtual Meeting" || self.showAppointmentArr[indexPath.row]?.appointmentType == "VIRTUAL MEETING" {
                
                let vc = self.storyboard?.instantiateViewController(identifier: "TelephoneConferenceDetailsVC") as! TelephoneConferenceDetailsVC
                vc.appointmentID = self.showAppointmentArr[indexPath.row]?.appointmentID ?? 0
                vc.serviceType = self.showAppointmentArr[indexPath.row]?.appointmentType ?? "N/A"
                self.navigationController?.pushViewController(vc, animated: true)
            } else {
                return

                
            }
        }
        
        
        
        
        
        
        
        
        
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let countt = self.showAppointmentArr.count  ?? 0
        print("number of rows are \(self.showAppointmentArr.count  ?? 0)")
        if countt == 0 {
            dashboardTableView.setEmptyView(title: "", message: "No Data Found")
//            self.noDataLabel.isHidden = false
//            self.calendarTableView.isHidden = true
        }else {
            dashboardTableView.restore()
//            self.noDataLabel.isHidden = true
//            self.calendarTableView.isHidden = false
        }
        return countt
    }
    //    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    //        return 240
    //    }
    
    
}

extension CalendarViewController{
    
    func checkSingleSignin(){
        SwiftLoader.show(animated: true)
        
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
                                
                                if vendorId == nil {
                                    // user is  login another device
                                    self.view.makeToast("This customer already logged-in on another device")
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                                        print("UPDATE DEVICE TOKEN")
                                        
                                        self.hitLogoutApi()
                                    }
                                }else {
                                    // user is not login on another device
                                    print("user is not login on another device")
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
    
    
    func hitLogoutApi(){
        //  UserDefaults.standard.setValue(token, forKey: "FCMToken")
        let deviceToken = UserDefaults.standard.value(forKey: "FCMToken")
        let updateVoipToken = UserDefaults.standard.value(forKey: "voipToken") ?? ""
        let url =  APIs.logoutApi
        let userID = userDefaults.value(forKey: UserDeafultsString.instance.UserID) ?? "0"
        let currentGUID = userDefaults.string(forKey: UserDeafultsString.instance.userGUID) ?? "0"
        let parameters = [
            "UserGuid": currentGUID,
            "UserID": userID,
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
                        self.apiLogoutApi = try decoder.decode(ApiUpdateTokenResponseModel.self, from: data)
                        let status = self.apiLogoutApi?.table?.first?.success
                        //           isLoggedIn
                        
                        //                        print("ApiGrumerProfileResponseModel----------Status----", self.apiUpdateDeviceTokenResponseModel?.table?.first?.success)
                        //                        guard let status = self.apiUpdateDeviceTokenResponseModel?.table?.first?.success else{ return }
                        if status == 1{
                            print("----- HITBOOKINGSLOTSSSS SUCCESSFUL----- ")
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { // Change
                                //                                SwiftLoader.hide()
                                UserDefaults.standard.setValue(false, forKey: "isLoggedIn")
                                let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
                                let storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                                let navigationController:UINavigationController = storyboard.instantiateInitialViewController() as! UINavigationController
                                let rootViewController:UIViewController = storyboard.instantiateViewController(withIdentifier:"InitialViewController") as! InitialViewController
                                navigationController.viewControllers = [rootViewController]
                                appDelegate.window!.rootViewController = navigationController
                                appDelegate.window!.makeKeyAndVisible()
                                // Code you want to be delayed
                            }
                            
                            
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

extension CalendarViewController{
    
    func getNotificatioDetail(){
        SwiftLoader.show(animated: true)
        self.apiNotificationCountNewResponseModel = nil
        let userId = UserDefaults.standard.value(forKey: UserDeafultsString.instance.UserID) ?? "0"
        let companyID = UserDefaults.standard.value(forKey: UserDeafultsString.instance.CompanyID) ?? "0"
 
        let urlString = "https://lsp.totallanguage.com/Home/GetData?methodType=NotificationsCounts%2CNOTIFICATIONSCOUNTSSTAFF%2CGETSYSTEMADMINNOTIFICATION&UserID=\(userId)&CompanyId=\(companyID)"
        print("url to get notificationDetail  \(urlString)")
        AF.request(urlString, method: .get , parameters: nil, encoding: JSONEncoding.default, headers: nil)
            .validate()
            .responseData(completionHandler: { [self] (response) in
                //                        SwiftLoader.hide()
                switch(response.result){
                case .success(_):
                    print("Respose Success Notification Data ")
                    guard let daata = response.data else { return }
                    do {
                        let jsonDecoder = JSONDecoder()
                        self.apiNotificationCountNewResponseModel = try jsonDecoder.decode(ApiNotificationCountNewResponseModel.self, from: daata)
                        print("Success notification Model \(self.apiNotificationCountNewResponseModel)")
                        
                        let count = self.apiNotificationCountNewResponseModel?.nOTIFICATIONSCOUNTSSTAFF?.first?.notificationCounts ?? 0
                        
                        self.notificationBtn.badgeString = String(count)
                    } catch{
                        
                        print("error block notification Data  " ,error)
                    }
                    
                case .failure(_):
                    print("Respose Failure ")
                    
                }
            })
    }
}




















extension String {
    private var convertHtmlToNSAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else {
            return nil
        }
        do {
            return try NSAttributedString(data: data,options: [.documentType: NSAttributedString.DocumentType.html,.characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
        }
        catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    public func convertHtmlToAttributedStringWithCSS(font: UIFont? , csscolor: String , lineheight: Int, csstextalign: String) -> NSAttributedString? {
        guard let font = font else {
            return convertHtmlToNSAttributedString
        }
        let modifiedString = "<style>body{font-family: '\(font.fontName)'; font-size:\(font.pointSize)px; color: \(csscolor); line-height: \(lineheight)px; text-align: \(csstextalign); }</style>\(self)";
        guard let data = modifiedString.data(using: .utf8) else {
            return nil
        }
        do
        {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
        }
        catch
        {
            print(error)
            return nil
        }
    }
}


extension UIColor {
    convenience init(hexString: String, alpha: CGFloat = 1.0) {
        let hexString: String = hexString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let scanner = Scanner(string: hexString)
        if (hexString.hasPrefix("#")) {
            scanner.scanLocation = 1
        }
        var color: UInt32 = 0
        scanner.scanHexInt32(&color)
        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
        let red   = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue  = CGFloat(b) / 255.0
        self.init(red:red, green:green, blue:blue, alpha:alpha)
    }
    func toHexString() -> String {
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0
        getRed(&r, green: &g, blue: &b, alpha: &a)
        let rgb:Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
        return String(format:"#%06x", rgb)
    }
}

class ColourResponse{
    
    static var sharedInstance = ColourResponse()
    var apiCalendarDataResponseModel:ApiCalendarDataResponseModel?
}

struct ApiGoogleTimeZoneresponse : Codable {
    let dstOffset : Int?
    let rawOffset : Int?
    let status : String?
    let timeZoneId : String?
    let timeZoneName : String?
    
    enum CodingKeys: String, CodingKey {
        
        case dstOffset = "dstOffset"
        case rawOffset = "rawOffset"
        case status = "status"
        case timeZoneId = "timeZoneId"
        case timeZoneName = "timeZoneName"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        dstOffset = try values.decodeIfPresent(Int.self, forKey: .dstOffset)
        rawOffset = try values.decodeIfPresent(Int.self, forKey: .rawOffset)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        timeZoneId = try values.decodeIfPresent(String.self, forKey: .timeZoneId)
        timeZoneName = try values.decodeIfPresent(String.self, forKey: .timeZoneName)
    }
}


class ContentSizedTableView: UITableView {
    override var contentSize:CGSize {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }
    
    override var intrinsicContentSize: CGSize {
        layoutIfNeeded()
        return CGSize(width: UIView.noIntrinsicMetric, height: contentSize.height)
    }
}
