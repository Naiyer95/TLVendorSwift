//
//  VendorTimeOffViewController.swift
//  TotalVendor
//
//  Created by Darrin Brooks on 12/08/21.
//

import UIKit
import Alamofire

class VendorTimeOffViewController: UIViewController {
    var Live_BASE_URL = "https://lsp.totallanguage.com/"
    @IBOutlet weak var companyLogoIcon: UIImageView!
    var apiNotificationCountNewResponseModel:ApiNotificationCountNewResponseModel?
    @IBOutlet weak var notificationBtnOutlet: MIBadgeButton!
    @IBOutlet weak var userNameLbl: UILabel!
    var apiUpdateVenorTimeOffResponseModel : ApiUpdateVenorTimeOffResponseModel?
    @IBOutlet weak var vendorTimeOffTV: UITableView!
    var apiVendorTimeOffResponseModel : ApiVendorTimeOffResponseModel?

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
            self.companyLogoIcon.sd_setImage(with: URL(string: finalData), completed: nil)
        }else {
            self.companyLogoIcon.image = UIImage(named: "logo")
        }
        vendorTimeOffTV.delegate=self
        vendorTimeOffTV.dataSource=self
        userNameLbl.text = UserDefaults.standard.value(forKey: UserDeafultsString.instance.CompanyName) as? String ?? ""
        NotificationCenter.default.addObserver(self, selector: #selector(self.hitApiRefreshData(notification:)), name: Notification.Name("refreshTimeOffData"), object: nil)
        self.getNotificatioDetail()
    }
    
    @objc func hitApiRefreshData(notification: Notification) {
        self.getVendorTimeOffData()
         }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getVendorTimeOffData()
    }
    
    @IBAction func plusBtnTapped(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "VendorTimeOffAddEditionVC") as! VendorTimeOffAddEditionVC
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
}

extension VendorTimeOffViewController{
    func getVendorTimeOffData(){
        SwiftLoader.show(animated: true)
        let companyID = userDefaults.value(forKey: UserDeafultsString.instance.CompanyID) ?? 0

        let userID = userDefaults.value(forKey: UserDeafultsString.instance.UserID) ?? 0
        let urlString = "https://lsp.totallanguage.com/VendorManagement/VendorTimeOff/GetData?methodType=VENDORTIMEOFFDATA&VendorID=\(userID)&CompanyId=\(companyID)&UserID=\(userID)"//\(date)"
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
                        self.apiVendorTimeOffResponseModel = try jsonDecoder.decode(ApiVendorTimeOffResponseModel.self, from: daata)
                        print("Success")
                        print("getVendorTimeOffData DATA IS \(self.apiVendorTimeOffResponseModel)")
                        DispatchQueue.main.async {
                            self.vendorTimeOffTV.reloadData()
                        }
    

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
        dateFormatter.dateFormat = "MM/dd/yyyy HH:mm:ss"
        if let newdate = dateFormatter.date(from: date) {
            dateFormatter.dateFormat = "MM/dd/yyyy hh:mm a"
            return  dateFormatter.string(from: newdate)
        }else {
            return ""
        }
    }
    
}





extension VendorTimeOffViewController:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if self.apiVendorTimeOffResponseModel?.vendorTimeOffs?.count ?? 0 == 0{
            self.vendorTimeOffTV.setEmptyView(title: "No Data Found", message: "")
        }else {
            self.vendorTimeOffTV.restore()
        }
        

        return self.apiVendorTimeOffResponseModel?.vendorTimeOffs?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = vendorTimeOffTV.dequeueReusableCell(withIdentifier: "VendorTimeOffDetailsCellL", for: indexPath) as! VendorTimeOffDetailsCellL
        let cellData = self.apiVendorTimeOffResponseModel?.vendorTimeOffs?[indexPath.row]
        cell.companyLbl.text = cellData?.companyName ?? ""
        cell.venodrNamelbl.text = cellData?.vendorName ?? ""
        cell.eventNameLbl.text = cellData?.eventName ?? ""
        let fromTime = self.convertDateAndTimeFormat(cellData?.fromDateTime ?? "")
        let toTime = self.convertDateAndTimeFormat(cellData?.toDateTime ?? "")
        let updateTime = self.convertDateAndTimeFormat(cellData?.updateDate ?? "")
        
        print("FROM TIME IS \(fromTime) tO time iss \(toTime) and update time is \(updateTime)")
        cell.fromDateLbl.text = fromTime
        cell.toDateLbl.text = toTime
        cell.lastUpdatedLbl.text = updateTime
        cell.editBtnOutlet.tag = indexPath.row
        cell.editBtnOutlet.addTarget(self, action: #selector(openEditTimeOff(sender:)), for: .touchUpInside)
        cell.deleteBtnOutlet.tag = indexPath.row
        cell.deleteBtnOutlet.addTarget(self, action: #selector(deleteTimeOffDataApi(sender:)), for: .touchUpInside)
        return cell
    }
    
    
    
    @objc func openEditTimeOff(sender: UIButton){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "VendorTimeOffAddEditionVC") as! VendorTimeOffAddEditionVC
        let fromTime = self.convertDateAndTimeFormat(self.apiVendorTimeOffResponseModel?.vendorTimeOffs?[sender.tag].fromDateTime ?? "")
        let toTime = self.convertDateAndTimeFormat(self.apiVendorTimeOffResponseModel?.vendorTimeOffs?[sender.tag].toDateTime ?? "")
        vc.timeOffEventData = self.apiVendorTimeOffResponseModel?.vendorTimeOffs?[sender.tag].eventName ?? ""
        vc.startDateTimeDate = fromTime
        vc.endDateTimeDate = toTime
        vc.timeOfId =  self.apiVendorTimeOffResponseModel?.vendorTimeOffs?[sender.tag].vendorTimeOffID ?? 0
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    @objc func deleteTimeOffDataApi(sender: UIButton){
       
        let fromTime = self.convertDateAndTimeFormat(self.apiVendorTimeOffResponseModel?.vendorTimeOffs?[sender.tag].fromDateTime ?? "")
        let toTime = self.convertDateAndTimeFormat(self.apiVendorTimeOffResponseModel?.vendorTimeOffs?[sender.tag].toDateTime ?? "")
        let timeOffEventData = self.apiVendorTimeOffResponseModel?.vendorTimeOffs?[sender.tag].eventName ?? ""
      
        let timeOfId =  self.apiVendorTimeOffResponseModel?.vendorTimeOffs?[sender.tag].vendorTimeOffID ?? 0

        
        
        let deleteAlert = UIAlertController(title: "Total Language", message: "Are you sure you want to delete the data?", preferredStyle: UIAlertController.Style.alert)
                
        deleteAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
                    print("Handle Ok logic here")
            
            
            self.deleteTimeOffDataApi(eventName: timeOffEventData, fromDateTime: fromTime, toDateTime: toTime, timeOfID: timeOfId)
            
           }))
                
        deleteAlert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { (action: UIAlertAction!) in
                    print("Handle Cancel Logic here")
            deleteAlert .dismiss(animated: true, completion: nil)
           }))
            self.present(deleteAlert, animated: true, completion: nil)
    }
    

}

extension VendorTimeOffViewController{
    func deleteTimeOffDataApi(eventName:String,fromDateTime:String,toDateTime:String,timeOfID:Int){
        SwiftLoader.show(animated: true)
     
        let vendorID = userDefaults.value(forKey: UserDeafultsString.instance.UserID) ?? 0
        let companyID = userDefaults.value(forKey: UserDeafultsString.instance.CompanyID) ?? 0
        let parameterss = ["VendorTimeOffID":timeOfID,
                           "EventName":eventName,
                           "CompanyID":companyID,
                           "VendorID":vendorID,
                           "FromDateTime":fromDateTime,
                           "ToDateTime":toDateTime,
                           "Active":false,
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
                            self.view.makeToast("VendorTimeOff Deleted successfully")
                            
                            NotificationCenter.default.post(name: Notification.Name("refreshTimeOffData"), object: nil, userInfo: nil)

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

extension VendorTimeOffViewController{
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
                    } catch{
                        
                        print("error block notification Data  " ,error)
                    }
                    
                case .failure(_):
                    print("Respose Failure ")
                    
                }
            })
    }
}

class VendorTimeOffDetailsCellL:UITableViewCell{
    @IBOutlet weak var companyLbl: UILabel!
    @IBOutlet weak var lastUpdatedLbl: UILabel!
    @IBOutlet weak var toDateLbl: UILabel!
    @IBOutlet weak var venodrNamelbl: UILabel!
    @IBOutlet weak var fromDateLbl: UILabel!
    @IBOutlet weak var eventNameLbl: UILabel!
    
    @IBOutlet weak var editBtnOutlet: UIButton!
    
    @IBOutlet weak var deleteBtnOutlet: UIButton!
    
}




