//
//  VendorTimeFinishedViewController.swift
//  TotalVendor
//
//  Created by Darrin Brooks on 12/08/21.
//

import UIKit
import Alamofire

class vendortimeofftableViewCell:UITableViewCell {
    
    @IBOutlet weak var uploadDocumentCell: MIBadgeButton!
    
    @IBOutlet weak var processBtn: UIButton!
    @IBOutlet weak var moreInfoBtn: UIButton!
    @IBOutlet weak var endTimeLbl: UILabel!
    @IBOutlet weak var startTimeLbl: UILabel!
    @IBOutlet weak var appointmentDateLbl: UILabel!
    @IBOutlet weak var jobTypeLbl: UILabel!
    @IBOutlet weak var languageNameLbl: UILabel!
    @IBOutlet var statusOfAppointmentLbl: UILabel!
    @IBOutlet weak var customerNameLbl: UILabel!
    @IBOutlet weak var authCodeLbl: UILabel!
}
class VendorTimeFinishedViewController: UIViewController,RefreshVendorTimeFinish  {
    
    
    
var apiNotificationCountNewResponseModel:ApiNotificationCountNewResponseModel?
    @IBOutlet weak var companyLogoImage: UIImageView!
    
    @IBOutlet weak var topViewOutlet: UIView!
    
    @IBOutlet weak var nodataLbl: UILabel!
    var Live_BASE_URL = "https://lsp.totallanguage.com/"
    
    @IBOutlet weak var companyNameLbl: UILabel!
    
//    @IBOutlet weak var companyNameLbl: UILabel!
    @IBOutlet weak var endDateTF: UITextField!
    @IBOutlet weak var startDateTF: UITextField!
    @IBOutlet weak var vendorTimeOffTV: UITableView!
    var miDate = Calendar.current.date(byAdding: .year, value: -50, to: Date())
    var apiScheduleAppointmentResponseModel : ApiCalendarDataResponseModel?
    @IBOutlet weak var notificationBtnOutlet: MIBadgeButton!
    var apiVendorTimeFinishResponseModel:ApiVendorTimeFinishResponseModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        notificationBtnOutlet.badgeString = "0"
        notificationBtnOutlet.badgeBackgroundColor = #colorLiteral(red: 0, green: 0.5686412892, blue: 0, alpha: 1)
        notificationBtnOutlet.badgeTextColor = UIColor.white
        notificationBtnOutlet.badgeEdgeInsets = UIEdgeInsets(top: 2, left: 0, bottom: 0, right: 2)
        
        
        
        let imageData = (userDefaults.value(forKey: UserDeafultsString.instance.CompanyLogo) ?? "")
        let finalData = "\(Live_BASE_URL)\(imageData)"
        print("FINAL DATA IS \(finalData)")
        if imageData as! String != "" {
            self.companyLogoImage.sd_setImage(with: URL(string: finalData), completed: nil)
        }else {
            self.companyLogoImage.image = UIImage(named: "logo")
        }
        companyNameLbl.text = UserDefaults.standard.value(forKey: UserDeafultsString.instance.CompanyName) as? String ?? ""
        vendorTimeOffTV.delegate = self
        vendorTimeOffTV.dataSource = self
        let abc = Date()
       
        let startDate =   abc.dateString("MM/dd/yyyy")
        let endDate =   abc.dateString("MM/dd/yyyy")
        startDateTF.text = startDate
        endDateTF.text = startDate
        getTimeFinishData(startDate: startDate, endDate: endDate)
        // Do any additional setup after loading the view.
        
    }
    func reloadVendorTimeFinish() {
          
          let abc = Date()
         
          let startDate =   abc.dateString("MM/dd/yyyy")
          let endDate =   abc.dateString("MM/dd/yyyy")
          startDateTF.text = startDate
          endDateTF.text = startDate
          getTimeFinishData(startDate: startDate, endDate: endDate)
      }
    
    
    @IBAction func sideMenuBtnTapped(_ sender: Any) {
   
    }
    
    @IBAction func notificationBtnTapped(_ sender: Any) {
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getNotificatioDetail()
        mainAddReimbursementArray.removeAll()
        self.tabBarController?.tabBar.isHidden = true
    }
    
    @IBAction func actionBackBtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func actionSearch(_ sender: UIButton) {
        if self.startDateTF.text == "" {
            self.view.makeToast("Please fill Start Date.")
            return
        }else if self.endDateTF.text == "" {
            self.view.makeToast("Please fill End Date.")
            return
        }else {
            let startDate = startDateTF.text ?? ""
            let endDate = endDateTF.text ?? ""
            getTimeFinishData(startDate: startDate, endDate: endDate)
        }
        
    }
    @IBAction func selectStartDate(_ sender: UIButton) {
        RPicker.selectDate(title: "Select Date & Time", cancelText: "Cancel", datePickerMode: .date, minDate: miDate, maxDate: Date().dateByAddingYears(5), didSelectDate: {[weak self] (selectedDate) in
                        // TODO: Your implementation for date
                        self?.startDateTF.text = selectedDate.dateString("MM/dd/YYYY")
                         
                    })
        
    }
    @IBAction func selectEndDate(_ sender: UIButton) {
        RPicker.selectDate(title: "Select Date & Time", cancelText: "Cancel", datePickerMode: .date, minDate: miDate, maxDate: Date().dateByAddingYears(5), didSelectDate: {[weak self] (selectedDate) in
                        // TODO: Your implementation for date
                        self?.endDateTF.text = selectedDate.dateString("MM/dd/YYYY")
                         
                    })
    }
    func getTimeFinishData(startDate: String , endDate : String ){
        SwiftLoader.show(animated: true)
        self.apiVendorTimeFinishResponseModel = nil
        let userId = UserDefaults.standard.value(forKey: UserDeafultsString.instance.UserID) ?? "0"
        let companyID = UserDefaults.standard.value(forKey: UserDeafultsString.instance.CompanyID) ?? "0"
        //01/07/2021  MM/dd/yyyy
        let urlString = "https://lsp.totallanguage.com/VendorManagement/VendorTimeFinished/GetCommonData?methodType=GETNEWTIMEFINISHEDLIST&CompanyID=\(companyID)&VendorId=\(userId)&UserType=6&UserID=\(userId)&TimeFinished=BOOKEDANDTIME&FilterCount=1000&StartDateTime=\(startDate)&EndDateTime=\(endDate)&RowNumber=0&Filter_RowNumber=1000"
        print("url to get apiGetVendorDetail  \(urlString)")
                AF.request(urlString, method: .get , parameters: nil, encoding: JSONEncoding.default, headers: nil)
                    .validate()
                    .responseData(completionHandler: { [self] (response) in
                        SwiftLoader.hide()
                        switch(response.result){
                        
                        case .success(_):
                            print("Respose Success apiGetVendorDetail Data ")
                            guard let daata = response.data else { return }
                            do {
                                let jsonDecoder = JSONDecoder()
                                self.apiVendorTimeFinishResponseModel = try jsonDecoder.decode(ApiVendorTimeFinishResponseModel.self, from: daata)
                             
                                
                                DispatchQueue.main.async {
                                    self.vendorTimeOffTV.reloadData()
                                }
                                
                            } catch{
                                
                                print("error block apiGetVendorDetail Data  " ,error)
                            }
                        case .failure(_):
                            print("Respose Failure apiGetVendorDetail")
                           
                        }
                })
     }
    
    
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
                        
                        self.notificationBtnOutlet.badgeString = String(count)
                        SwiftLoader.hide()
                    } catch{
                        
                        print("error block notification Data  " ,error)
                    }
                    
                case .failure(_):
                    print("Respose Failure ")
                    
                }
            })
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
    

}

//MARK: - Table Work
extension VendorTimeFinishedViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        let count = self.apiVendorTimeFinishResponseModel?.gETNEWTIMEFINISHEDLIST?.count ?? 0
        if count == 0 {
            self.nodataLbl.text = "No Record Found"
            self.nodataLbl.isHidden = false
            self.vendorTimeOffTV.isHidden = true
        }else {
            self.nodataLbl.isHidden = true
            self.vendorTimeOffTV.isHidden = false
        }
        print("connt " , count)
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "vendortimeofftableViewCell") as! vendortimeofftableViewCell
        cell.selectionStyle = .none
    
        let indx = self.apiVendorTimeFinishResponseModel?.gETNEWTIMEFINISHEDLIST?[indexPath.row]
        cell.customerNameLbl.text = indx?.customerName ?? ""
        cell.authCodeLbl.text = indx?.authCode ?? ""
        cell.jobTypeLbl.text = indx?.appointmentType ?? ""
        cell.languageNameLbl.text = indx?.languageName ?? ""
        print("APPOINTMENT ID FOR INDEX \(indexPath.row + 1) and Appointment ID is \(indx?.appointmentID ?? 0)")
        //let appointmentDate = indx
        cell.statusOfAppointmentLbl.text = " \(indx?.appointmentStatusType ?? "N/A") "
        cell.appointmentDateLbl.text = convertDateFormater(indx?.startDateTime ?? "")
        let startTime = indx?.startDateTime ?? ""
        let endTime = indx?.endDateTime ?? ""
        cell.startTimeLbl.text = convertTimeFormater(startTime)
        cell.endTimeLbl.text = convertTimeFormater(endTime)
        if indx?.vendorFilecounts ?? 0>0{
            
            cell.uploadDocumentCell.isHidden=false
            cell.uploadDocumentCell.badgeString = "\(indx?.vendorFilecounts ?? 0)"
        }else {
            cell.uploadDocumentCell.isHidden=true
        }
        cell.processBtn.tag = indexPath.row
        cell.processBtn.addTarget(self, action: #selector(openProcessScreen(sender:)), for: .touchUpInside)
        cell.uploadDocumentCell.tag = indexPath.row
        cell.uploadDocumentCell.addTarget(self, action: #selector(uploadDocumentsTapped(sender:)), for: .touchUpInside)
        cell.moreInfoBtn.tag = indexPath.row
        cell.moreInfoBtn.addTarget(self, action: #selector(moreInfoTapped(sender:)), for: .touchUpInside)
        ColourResponse.sharedInstance.apiCalendarDataResponseModel?.appointmentStatus?.forEach({ statusDetail in
            if statusDetail.code == indx?.appointmentStatusType {
                //cell.statusOuterView.backgroundColor = UIColor(hexString: statusDetail.color!)
                cell.statusOfAppointmentLbl.backgroundColor = UIColor(hexString: statusDetail.color!)
            }
        })
        return cell
    }
    
    @objc func uploadDocumentsTapped(sender: UIButton){
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "UploadedDocumentsVC") as! UploadedDocumentsVC
        vc.appointmentID = self.apiVendorTimeFinishResponseModel?.gETNEWTIMEFINISHEDLIST?[sender.tag].appointmentID ?? 0
       // vc.isModalInPresentation = true
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
        
    }
    
    @objc func moreInfoTapped(sender: UIButton){
 
        let cell = vendorTimeOffTV.cellForRow(at: IndexPath(row: sender.tag, section: 0)) as! vendortimeofftableViewCell
    
        let sTime = cell.startTimeLbl.text
        let eTime = cell.endTimeLbl.text
        
        
        
        print("TYPE STATUS IS \(self.apiVendorTimeFinishResponseModel?.gETNEWTIMEFINISHEDLIST?[sender.tag].unicFlag  ?? "")")
        if self.apiVendorTimeFinishResponseModel?.gETNEWTIMEFINISHEDLIST?[sender.tag].unicFlag?.replacingOccurrences(of: " ", with: "") == "B"{
            
            if self.apiVendorTimeFinishResponseModel?.gETNEWTIMEFINISHEDLIST?[sender.tag].appointmentType == "Onsite Interpretation" || self.apiVendorTimeFinishResponseModel?.gETNEWTIMEFINISHEDLIST?[sender.tag].appointmentType == "ONSITE INTERPRTATION"{
                let vc =   self.storyboard?.instantiateViewController(withIdentifier: "BlockedAppointmentVC") as! BlockedAppointmentVC
                vc.appointmentID = self.apiVendorTimeFinishResponseModel?.gETNEWTIMEFINISHEDLIST?[sender.tag].appointmentID ?? 0
                
                vc.startTime = sTime ?? ""
                vc.endTime = eTime ?? ""
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true, completion: nil)
            }
            else if self.apiVendorTimeFinishResponseModel?.gETNEWTIMEFINISHEDLIST?[sender.tag].appointmentType == "Telephone Conference" || self.apiVendorTimeFinishResponseModel?.gETNEWTIMEFINISHEDLIST?[sender.tag].appointmentType == "TELEPHONE CONFERENCE"{
                let vc =   self.storyboard?.instantiateViewController(withIdentifier: "BlockedAppointmentTelephonicConferenceDetails") as! BlockedAppointmentTelephonicConferenceDetails
                vc.appointmentID = self.apiVendorTimeFinishResponseModel?.gETNEWTIMEFINISHEDLIST?[sender.tag].appointmentID ?? 0
                
                vc.startTime = sTime ?? ""
                vc.endTime = eTime ?? ""
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true, completion: nil)
            }else if self.apiVendorTimeFinishResponseModel?.gETNEWTIMEFINISHEDLIST?[sender.tag].appointmentType == "Virtual Meeting" || self.apiVendorTimeFinishResponseModel?.gETNEWTIMEFINISHEDLIST?[sender.tag].appointmentType == "VIRTUAL MEETING"{
                
                let vc =   self.storyboard?.instantiateViewController(withIdentifier: "BlockedAppointmentVirtualMeetingDetails") as! BlockedAppointmentVirtualMeetingDetails
                vc.appointmentID = self.apiVendorTimeFinishResponseModel?.gETNEWTIMEFINISHEDLIST?[sender.tag].appointmentID ?? 0
                
                vc.startTime = sTime ?? ""
                vc.endTime = eTime ?? ""
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true, completion: nil)
            }else {
                return
            }
        }else {
            if self.apiVendorTimeFinishResponseModel?.gETNEWTIMEFINISHEDLIST?[sender.tag].appointmentType == "Onsite Interpretation" || self.apiVendorTimeFinishResponseModel?.gETNEWTIMEFINISHEDLIST?[sender.tag].appointmentType == "ONSITE INTERPRTATION" {
                let vc = self.storyboard?.instantiateViewController(identifier: "NewAppointmentDetailsVC") as! NewAppointmentDetailsVC
                vc.appointmentID = self.apiVendorTimeFinishResponseModel?.gETNEWTIMEFINISHEDLIST?[sender.tag].appointmentID ?? 0
                vc.serviceType = self.apiVendorTimeFinishResponseModel?.gETNEWTIMEFINISHEDLIST?[sender.tag].appointmentType ?? "N/A"
                self.navigationController?.pushViewController(vc, animated: true)
            }else if self.apiVendorTimeFinishResponseModel?.gETNEWTIMEFINISHEDLIST?[sender.tag].appointmentType == "Telephone Conference" || self.apiVendorTimeFinishResponseModel?.gETNEWTIMEFINISHEDLIST?[sender.tag].appointmentType == "TELEPHONE CONFERENCE" || self.apiVendorTimeFinishResponseModel?.gETNEWTIMEFINISHEDLIST?[sender.tag].appointmentType == "Virtual Meeting" || self.apiVendorTimeFinishResponseModel?.gETNEWTIMEFINISHEDLIST?[sender.tag].appointmentType == "VIRTUAL MEETING" {
                
                let vc = self.storyboard?.instantiateViewController(identifier: "TelephoneConferenceDetailsVC") as! TelephoneConferenceDetailsVC
                vc.appointmentID = self.apiVendorTimeFinishResponseModel?.gETNEWTIMEFINISHEDLIST?[sender.tag].appointmentID ?? 0
                vc.serviceType = self.apiVendorTimeFinishResponseModel?.gETNEWTIMEFINISHEDLIST?[sender.tag].appointmentType ?? "N/A"
                self.navigationController?.pushViewController(vc, animated: true)
            } else {
                return
//                let vc = self.storyboard?.instantiateViewController(identifier: "ScheduleDetailsVC") as! ScheduleDetailsVC
//                vc.appointmentID = self.showAppointmentArr[indexPath.row]?.appointmentID ?? 0
//                vc.serviceType = self.showAppointmentArr[indexPath.row]?.appointmentType ?? "N/A"
//                print("vc.serviceType ", vc.serviceType)
//                self.navigationController?.pushViewController(vc, animated: true)
                
            }
        }
        
        
        
        
        
        
        
        
        
        
        
    }
    
    @objc func openProcessScreen(sender: UIButton){
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "VendorTimeFinishDetailsVC") as! VendorTimeFinishDetailsVC
        vc.modalPresentationStyle = .fullScreen
        vc.appointmentID = self.apiVendorTimeFinishResponseModel?.gETNEWTIMEFINISHEDLIST?[sender.tag].appointmentID ?? 0
        vc.delegate = self
        self.present(vc, animated: true, completion: nil)
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
}




extension Date {
    
    func dateString(_ format: String = "MMM-dd-YYYY, hh:mm a") -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        
        return dateFormatter.string(from: self)
    }
    func changeDateString(_ format: String = "MM/dd/YYYY hh:mm a") -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        
        return dateFormatter.string(from: self)
    }
    
    func dateByAddingYears(_ dYears: Int) -> Date {
        
        var dateComponents = DateComponents()
        dateComponents.year = dYears
     
        return Calendar.current.date(byAdding: dateComponents, to: self)!
    }
}

extension UIView {
func addBottomShadow() {
    layer.masksToBounds = false
    layer.shadowRadius = 4
    layer.shadowOpacity = 1
    layer.shadowColor = UIColor.red.cgColor
    layer.shadowOffset = CGSize(width: 0 , height: 0.5)
    layer.shadowPath = UIBezierPath(rect: CGRect(x: 0,
                                                 y: bounds.maxY - layer.shadowRadius,
                                                 width: bounds.width,
                                                 height: layer.shadowRadius)).cgPath
}
}

