//
//  RatingViewController.swift
//  TotalVendor
//
//  Created by Darrin Brooks on 12/08/21.
//

import UIKit
import SDWebImage
import RSColourSlider
import SteppableSlider


class RatingViewController: UIViewController {
//    var ratingApiResponseModel = [RatingApiResponseModel]?.self
    var apiGetRatindScreenResponseModel : ApiGetRatindScreenResponseModel?
    @IBOutlet weak var allInViewOutlet: UIView!
    
    @IBOutlet weak var straightLineLbl: UILabel!
    @IBOutlet weak var callRatingLabel: UILabel!
    @IBOutlet weak var overallRatingLabel: UILabel!
    @IBOutlet weak var ratingView: UIView!
    @IBOutlet weak var newSlider: SteppableSlider!
    @IBOutlet weak var newSliderTwo: SteppableSlider!
    var vendorID = 0
    var customerID = 0
    @IBOutlet weak var customerImageView: UIImageView!
    @IBOutlet weak var customerNameLBl: UILabel!
    @IBOutlet weak var durationLbl: UILabel!
    @IBOutlet weak var roomNoLbl: UILabel!
    @IBOutlet weak var dateAndTimeLbl: UILabel!
    @IBOutlet weak var typeLbl: UILabel!
    @IBOutlet weak var translationLbl: UILabel!
    
    @IBOutlet weak var cancelBtnOutlet: UIButton!
    
    @IBOutlet weak var submitBtnOutlet: UIButton!
    
    var apiRateUserPostResponseModel:ApiRateUserPostResponseModel?
    
//    @IBOutlet weak var ratingSliderFirst: RSColourSlider!
//    @IBOutlet weak var ratingSliderFirst: RSColourSlider!
    var callDuration = ""
    var roomNo = ""
    var dateAndTime = ""
    var type = ""
    var customerName = ""
    var customerImage = ""
    var translateLanguage1 = ""
    var translateLanguage2 = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        let date = Date()
        hitGetRatingData()
        callRatingLabel.text = ""
        overallRatingLabel.text = ""
        // Create Date Formatter
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy h:mm a"
        // Convert Date to String
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        let abc = dateFormatter.string(from: date)
        
        print("CURRENT DATE TIME IS \(abc)")
        self.dateAndTimeLbl.text = abc
        
        allInViewOutlet.layer.cornerRadius = 30
        allInViewOutlet.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        straightLineLbl.layer.cornerRadius = straightLineLbl.frame.height/2
        
        customerImageView.layer.cornerRadius = customerImageView.frame.height/2
        customerImageView.layer.cornerRadius = customerImageView.frame.width/2
    
        
//        self.customerImageView.sd_setImage(with: URL(string: self.customerImage), completed: nil)
//        self.customerNameLBl.text = self.customerName
////        self.dateAndTimeLbl.text = "\(Date())"
//        self.roomNoLbl.text = roomNo
//        self.durationLbl.text = callDuration
//        self.typeLbl.text = "Video"
//        self.translationLbl.text = "\(self.translateLanguage1) >> \(self.translateLanguage2)"
//        view.backgroundColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
//        view.layer.cornerRadius = 20
        
        ratingView.layer.cornerRadius = 10
        cancelBtnOutlet.layer.cornerRadius = 10
        submitBtnOutlet.layer.cornerRadius = 10
//        newSlider.numberOfSteps = 5
        newSlider.layer.cornerRadius = newSlider.frame.height/2
        newSliderTwo.layer.cornerRadius = newSliderTwo.frame.height/2
        newSlider.addTarget(self, action: #selector(sliderValueChanged(_:)), for: .valueChanged)
        newSliderTwo.addTarget(self, action: #selector(slider2ValueChanged(_:)), for: .valueChanged)
        updateLabels()
        
    }
    
    
    @IBAction func cancelBtnTapped(_ sender: Any) {
        let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
                                 let storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                                 let navigationController:UINavigationController = storyboard.instantiateInitialViewController() as! UINavigationController
                                 let rootViewController:UIViewController = storyboard.instantiateViewController(withIdentifier:"CalendarViewController") as! CalendarViewController
                                 navigationController.viewControllers = [rootViewController]
                                 appDelegate.window!.rootViewController = navigationController
                                 appDelegate.window!.makeKeyAndVisible()
    }
    
    @IBAction func submitBtnTapped(_ sender: Any) {
        
        if self.newSlider.value != 0 && self.newSlider.value != 0 {
            
            hitRateCallApi()
            
        }else {
            self.view.makeToast("Please select minimum one star or else click dismiss")
        }

        
        
    }
    
    
    
    private func updateLabels() {
//           valueLabel.text = "\(newSlider.value)"
//           numberOfStepsLabel.text = "\(newSlider.numberOfSteps)"
//           currentStepLabel.text = "\(newSlider.currentIndex)"
       }
    
    @objc func sliderValueChanged(_ sender: SteppableSlider) {
        print(sender.value) // 0 ~ 4
        sender.value = round(sender.value)
        switch sender.value {
        case 0:
            print("SENDER VALUE IS 0")
            callRatingLabel.text = ""
        case 1:
            print("SENDER VALUE IS 1")
            callRatingLabel.text = "Poor"
        case 2:
            print("SENDER VALUE IS 2")
            callRatingLabel.text = "Average"
        case 3:
            print("SENDER VALUE IS 3")
            callRatingLabel.text = "Good"
        case 4:
            print("SENDER VALUE IS 4")
            callRatingLabel.text = "Very Good"
        case 5:
            print("SENDER VALUE IS 4")
            callRatingLabel.text = "Excellent"
        default:
            print("Awesome")
        }
    }
    
    @objc func slider2ValueChanged(_ sender: SteppableSlider) {
        print(sender.value) // 0 ~ 4
        sender.value = round(sender.value)
        switch sender.value {
        case 0:
            print("SENDER VALUE IS 0")
            overallRatingLabel.text = ""
        case 1:
            print("SENDER VALUE IS 1")
            overallRatingLabel.text = "Poor"
        case 2:
            print("SENDER VALUE IS 2")
            overallRatingLabel.text = "Average"
        case 3:
            print("SENDER VALUE IS 3")
            overallRatingLabel.text = "Good"
        case 4:
            print("SENDER VALUE IS 4")
            overallRatingLabel.text = "Very Good"
        case 5:
            print("SENDER VALUE IS 4")
            overallRatingLabel.text = "Excellent"
        default:
            print("Awesome")
        }
        
    }
    
    
    
    @IBAction func cancelBtnAction(_ sender: Any) {
        view.removeFromSuperview()        }
    @IBAction func callRatingBtnAction(_ sender: UISlider) {
        let currentValue = Int(sender.value)
        callRatingLabel.text = "\(currentValue)"
        }
    
    @IBAction func overallRatingBtnAction(_ sender: UISlider) {
        let currentValue = Int(sender.value)
        overallRatingLabel.text = "\(currentValue)"
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

extension RatingViewController{
    
    func hitGetRatingData(){
        var URLReqObj = URLRequest(url: URL(string:APIs.getRatingData)!)
        
        URLReqObj.httpMethod = "POST"
    
        let parameters: [String: Any] = [ "RoomId": self.roomNo, "calltype": "V"]
        

        
//        URLReqObj.setValue("application/json", forHTTPHeaderFieLoginld: "Content-Type")
//        URLReqObj.setValue("application/json", forHTTPHeaderField: "Accept")
        print("URL REQUEST IS \(URLReqObj)")
        print("PARAMETERS ARE \(parameters)")
        
    
        URLReqObj.httpBody = parameters.percentEncoded()
     var  dataTask = URLSession.shared.dataTask(with: URLReqObj, completionHandler: { (receiveData, connDetails, error) in
            
//        do{
//                   var JsonData = try JSONSerialization.jsonObject(with: receiveData!, options: JSONSerialization.ReadingOptions.allowFragments) as! NSArray
//            print(JsonData)
//            let callAvailablility = JsonData.first?["ErrorId"] as? Int ?? 00
//            print("Call Availability is \(callAvailablility)")
//
//        }catch{
//            print("Something went wrong")
//        }
        
        let jsonDecoder = JSONDecoder()
        do {
            let parsedJSON = try jsonDecoder.decode(ApiGetRatindScreenResponseModel.self, from: receiveData!)
            print("RATING DATA API IS \(parsedJSON)")
            self.apiGetRatindScreenResponseModel = parsedJSON
            let dataRating = parsedJSON.getMembers?.first
            DispatchQueue.main.async {
                let imgURL = "https://lsp.totallanguage.com/\(self.apiGetRatindScreenResponseModel?.getMembers?.first?.custImg ?? "")"
                if dataRating?.custImg == "" || dataRating == nil{
                    self.customerImageView.visibility = .gone
                }
                else {
                    self.customerImageView.visibility = .visible
                }
                print("IMAGE URL FOR IMAGE IS \(imgURL)")
                self.customerImageView.sd_setImage(with: URL(string: imgURL), completed: nil)
                self.customerNameLBl.text = dataRating?.customerName ?? ""
                self.roomNoLbl.text = dataRating?.roomno ?? ""
                self.durationLbl.text = self.callDuration
                self.typeLbl.text = "Video"
                self.translationLbl.text = "\(dataRating?.sourcelanguageName ?? "") >> \(dataRating?.languageName ?? "")"
                
    //            let errorID = parsedJSON.first?.errorId ?? "0"
                print("hitGetRatingData DATA IS \(parsedJSON)")
            }
            }
        catch
            {
        print(error)
            }
     })
    dataTask.resume()
    }
    
}

extension RatingViewController {
    
    func hitRateCallApi(){
        var URLReqObj = URLRequest(url: URL(string:APIs.addCallRatingFeedback)!)
        
        URLReqObj.httpMethod = "POST"
//        {"calltype":"V", "VendID":"211684", "callquality":"4", "CustID":"212016", "rating":"5", "LID":"1", "roomno":"21538"}

 // "calltype": self.roomNo,

        let parameters: [String: Any] = [ "calltype":"V", "VendID":self.vendorID, "callquality":newSlider.value, "CustID":customerID, "rating":newSliderTwo.value, "LID":"1", "roomno":self.roomNo]

        
//        URLReqObj.setValue("application/json", forHTTPHeaderFieLoginld: "Content-Type")
//        URLReqObj.setValue("application/json", forHTTPHeaderField: "Accept")
        print("URL REQUEST IS \(URLReqObj)")
        print("PARAMETERS ARE \(parameters)")
        
    
        URLReqObj.httpBody = parameters.percentEncoded()
     var  dataTask = URLSession.shared.dataTask(with: URLReqObj, completionHandler: { (receiveData, connDetails, error) in
            
//        do{
//                   var JsonData = try JSONSerialization.jsonObject(with: receiveData!, options: JSONSerialization.ReadingOptions.allowFragments) as! NSArray
//            print(JsonData)
//            let callAvailablility = JsonData.first?["ErrorId"] as? Int ?? 00
//            print("Call Availability is \(callAvailablility)")
//
//        }catch{
//            print("Something went wrong")
//        }
        
        let jsonDecoder = JSONDecoder()
        do {
            let parsedJSON = try jsonDecoder.decode(ApiRateUserPostResponseModel.self, from: receiveData!)
            print("RATED PARSED JSON IS \(parsedJSON)")
            DispatchQueue.main.async {
                self.view.makeToast("Call Rated Successfully")
            }
         
         let seconds = 3.0
            DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
                let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
                                         let storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                                         let navigationController:UINavigationController = storyboard.instantiateInitialViewController() as! UINavigationController
                                         let rootViewController:UIViewController = storyboard.instantiateViewController(withIdentifier:"CalendarViewController") as! CalendarViewController
                                         navigationController.viewControllers = [rootViewController]
                                         appDelegate.window!.rootViewController = navigationController
                                         appDelegate.window!.makeKeyAndVisible()
            }//            self.navigationController?.popToRootViewController(animated: true)

            
//            self.apiGetRatindScreenResponseModel = parsedJSON
//            let errorID = parsedJSON.first?.errorId ?? "0"
            
}
        catch
            {
        print(error)
            }
     })
    dataTask.resume()
    }
}




struct ApiRateUserPostResponseModel : Codable {
    let table : [ApiRateUserPostResponseModelUserTable]?

    enum CodingKeys: String, CodingKey {

        case table = "Table"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        table = try values.decodeIfPresent([ApiRateUserPostResponseModelUserTable].self, forKey: .table)
    }
}

struct ApiRateUserPostResponseModelUserTable : Codable {
    let success : Int?
    enum CodingKeys: String, CodingKey {
        case success = "success"
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        success = try values.decodeIfPresent(Int.self, forKey: .success)
    }
}

//extension UIView {
//    func roundTopCornersTopRight(radius:CGFloat = 20) {
//
//         self.clipsToBounds = true
//         self.layer.cornerRadius = radius
//         if #available(iOS 11.0, *) {
//             self.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
//         } else {
//            self.roundCornersSide(corners: [.topLeft,.topRight], radius: radius)
//         }
//     }
//}
