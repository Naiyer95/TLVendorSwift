//
//  TimeZoneViewController.swift
//  TLClientApp
//
//  Created by SMIT 005 on 31/12/21.
//

import UIKit
import Alamofire
class TimeZoneViewController: UIViewController {

    @IBOutlet weak var timeZoneLbl: UILabel!
    var timeZoneStr = ""
    var currentTimeZone = ""
    var apiUpdateTimeZoneResponse:ApiUpdateTimeZoneResponse?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.gray.withAlphaComponent(0.6)
        
//        let visualEffectView = UIVisualEffectView.init(effect: UIBlurEffect.init(style: .light))
//          visualEffectView.backgroundColor = UIColor.init(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.5)
//          visualEffectView.frame = self.view.bounds
//          self.view.addSubview(visualEffectView)
        
        
        self.timeZoneLbl.text = self.timeZoneStr ?? ""
    }
    

    @IBAction func actionAcknowledge(_ sender: UIButton) {
        updateTimeZoneWithParams()
    }
    
     @IBAction func actionDecline(_ sender: UIButton) {
         UserDefaults.standard.setValue(true, forKey: UserDeafultsString.instance.timeZoneDeclined)
        self.dismiss(animated: true, completion: nil)
     }
    func updateTimeZoneWithParams(){
        SwiftLoader.show(animated: true)
        let userID = userDefaults.string(forKey: UserDeafultsString.instance.UserID) ?? ""
//        let userID = GetPublicData.sharedInstance.userID
        let timeZone = self.currentTimeZone.replacingOccurrences(of: " ", with: "%20")
        let url = "https://lsp.totallanguage.com/Home/GetData?methodType=UPDATETIMEZONE&UserID=\(userID)&TZone=\(timeZone)"
        print("url to get time zone ", url )
        AF.request(url, method: .get , parameters: nil, encoding: JSONEncoding.default, headers: nil)
            .validate()
            .responseData(completionHandler: { [self] (response) in
                SwiftLoader.hide()
                switch(response.result){
                
                case .success(_):
                    print("Respose getCurrentTimeZone ")
                    guard let daata = response.data else { return }
                    do {
                        let jsonDecoder = JSONDecoder()
                        self.apiUpdateTimeZoneResponse = try jsonDecoder.decode(ApiUpdateTimeZoneResponse.self, from: daata)
                        let success = self.apiUpdateTimeZoneResponse?.uPDATETIMEZONE?.first?.success ?? 0
                        if success == 1 {
                            userDefaults.set(self.currentTimeZone, forKey: "TimeZone")
                            self.view.makeToast("Timezone updated successfully.")
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                                self.dismiss(animated: true, completion: nil)
                            }
                            
                        }else {
                            self.view.makeToast("Please try after sometime.")
                        }
                    } catch{
                        self.view.makeToast("Please try after sometime.",duration: 2, position: .center)
                        print("error block forgot password " ,error)
                    }
                case .failure(let error):
                    print("Respose Failure ",error.localizedDescription)
                    self.view.makeToast("Please try after sometime.",duration: 2, position: .center)
                   
                }
        })
        
    }

}
/*
Copyright (c) 2022 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

//import Foundation
struct ApiUpdateTimeZoneResponse : Codable {
    let uPDATETIMEZONE : [ApiUPDATETIMEZONEDataModel]?

    enum CodingKeys: String, CodingKey {

        case uPDATETIMEZONE = "UPDATETIMEZONE"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        uPDATETIMEZONE = try values.decodeIfPresent([ApiUPDATETIMEZONEDataModel].self, forKey: .uPDATETIMEZONE)
    }

}



struct ApiUPDATETIMEZONEDataModel : Codable {
    let status : String?
    let message : String?
    let success : Int?

    enum CodingKeys: String, CodingKey {

        case status = "Status"
        case message = "Message"
        case success = "success"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        success = try values.decodeIfPresent(Int.self, forKey: .success)
    }

}
