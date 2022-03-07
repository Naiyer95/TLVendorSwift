//
//  BookingDetailViewController.swift
//  TotalVendor
//
//  Created by Shivansh SMIT on 25/11/21.
//

import UIKit
import Alamofire
class BookingDetailViewController: UIViewController {
      var appointmentID = 0
    @IBOutlet weak var interpreterNameLbl : UILabel!
    @IBOutlet weak var contactnameLbl : UILabel!
    @IBOutlet weak var authenticationCodeLbl : UILabel!
    @IBOutlet weak var serviceTypeLbl : UILabel!
    @IBOutlet weak var dateLbl : UILabel!
    @IBOutlet weak var timeLbl : UILabel!
    @IBOutlet weak var venueNameLbl : UILabel!
    @IBOutlet weak var venueAddresslbl : UILabel!
    @IBOutlet weak var departmentlbl : UILabel!
    @IBOutlet weak var customerNameLbl : UILabel!
    @IBOutlet weak var specialityLbl : UILabel!
    @IBOutlet weak var patientIntialLbl : UILabel!
    @IBOutlet weak var languageLbl : UILabel!
    @IBOutlet weak var descriptionLbl : UILabel!
    @IBOutlet weak var specialNotesLbl : UILabel!
    @IBOutlet weak var statsuLbl : UILabel!
    var isComeFromBooking = false
    var appointmentStatus =  [ApiCalendarDataAppointmentStatus]()
    var apiBookingDetailresponseModel:ApiBookingDetailresponseModel?
    override func viewDidLoad() {
        super.viewDidLoad()
          getbooingDetail()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func actionBackbtn(_ sender: UIButton) {
        if isComeFromBooking {
            self.dismiss(animated: true, completion: nil)
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func updateUI(){
        let dataValue = self.apiBookingDetailresponseModel?.appointmentInterpreterData?.first
        self.interpreterNameLbl.text = ":  \(dataValue?.interpretorName ?? "")"
        self.contactnameLbl.text = ":  \(dataValue?.contactName ?? "")"
        self.authenticationCodeLbl.text = ":  \(dataValue?.authCode ?? "")"
        self.serviceTypeLbl.text = ": \(dataValue?.serviceType ?? "")"
        let startDate = convertDateFormater(dataValue?.startDateTimeTemp ?? "")
        print("date value \(startDate)")
        self.dateLbl.text = ":  \(startDate)"
        let aptTime = dataValue?.endDateTimeTemp ?? ""
        let startTime = convertTimeFormater(dataValue?.startDateTimeTemp ?? "")
        let endTime = convertTimeFormater(aptTime)
        print("start time  \(startTime) , endtime \(endTime)")
        let showtime = "\(startTime) - \(endTime)"
        self.timeLbl.text = ":  \(showtime)"
        self.venueNameLbl.text = ":  \(dataValue?.venueName ?? "")"
        let address = dataValue?.address ?? ""
        let city = dataValue?.city ?? ""
        let state = dataValue?.stateName ?? ""
        let zipcode = dataValue?.zipcode ?? ""
        let venueAddress = address + city + state + zipcode
        
        self.venueAddresslbl.text = ":  \(venueAddress)"
        self.departmentlbl.text = ":  \(dataValue?.departmentName ?? "")"
        self.customerNameLbl.text = ": \(dataValue?.customerName ?? "")"
        self.specialityLbl.text = ":  \(dataValue?.specialityName ?? "")"
        self.patientIntialLbl.text = ": \(dataValue?.cPIntials ?? "")"
        self.languageLbl.text = ": \(dataValue?.languageName ?? "")"
        self.descriptionLbl.text = ": \(dataValue?.aptDetails ?? "")"
        self.specialNotesLbl.text = ": \(dataValue?.text ?? "")"
        let actualStatus = dataValue?.appointmentStatusType ?? ""
        self.statsuLbl.text = ": \(actualStatus)"
        self.appointmentStatus.forEach { statusData in
            
            print("actual Status \(actualStatus)",statusData.value ?? "")
            if statusData.value ?? ""  == actualStatus {
                print("\(statusData.color ?? "" )")
                let color = statusData.color ?? ""
                self.statsuLbl.textColor = UIColor(hexString: color)
            }
        }
    }
    func getbooingDetail(){
        SwiftLoader.show(animated: true)
        self.apiBookingDetailresponseModel = nil
        let userId = UserDefaults.standard.value(forKey: UserDeafultsString.instance.UserID) ?? "0"
        //let companyID = UserDefaults.standard.value(forKey: UserDeafultsString.instance.CompanyID) ?? "0"
      
        let urlString = "https://lsp.totallanguage.com/Home/GetData?methodType=AppointmentInterpreterData&NotoficationId=0&AppointmentID=\(self.appointmentID)&Interpreterid=\(userId)&UserType=6&Userid=\(userId)"
        print("url to get notificationDetail  \(urlString)")
                AF.request(urlString, method: .get , parameters: nil, encoding: JSONEncoding.default, headers: nil)
                    .validate()
                    .responseData(completionHandler: { [self] (response) in
                        SwiftLoader.hide()
                        switch(response.result){
                        
                        case .success(_):
                            print("Respose Success Notification Data ")
                            guard let daata = response.data else { return }
                            do {
                                let jsonDecoder = JSONDecoder()
                                self.apiBookingDetailresponseModel = try jsonDecoder.decode(ApiBookingDetailresponseModel.self, from: daata)
                               print("Success notification Model \(self.apiBookingDetailresponseModel)")
                                
                                updateUI()
        
                                
                            } catch{
                                
                                print("error block notification Data  " ,error)
                            }
                        case .failure(_):
                            print("Respose Failure ")
                           
                        }
                })
     }
    
    func convertDateFormater(_ date: String) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss" //2021-11-01T01:00:00
        print("date intially \(date)")
        if let newdate = dateFormatter.date(from: date) {
            dateFormatter.dateFormat = "MM/dd/yyyy"
            return  dateFormatter.string(from: newdate)
            print("date intially \(date), new date \(newdate)")
        }else {
            return ""
        }
    }
    func convertTimeFormater(_ date: String) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss" //
        print("time format \(date)")
        if let newdate = dateFormatter.date(from: date) {
            dateFormatter.dateFormat = "h:mm a"
            return  dateFormatter.string(from: newdate)
        }else {
            return ""
        }
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
