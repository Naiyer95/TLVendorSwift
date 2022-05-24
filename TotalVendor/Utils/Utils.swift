//
//  Utils.swift
//
//  Copyright © 2016-2019 Twilio, Inc. All rights reserved.
//

import Foundation
import UIKit
// Helper to determine if we're running on simulator or device
struct PlatformUtils {
    static let isSimulator: Bool = {
        var isSim = false
        #if arch(i386) || arch(x86_64)
        isSim = true
        #endif
        return isSim
    }()
}

struct TokenUtils {
    static func fetchToken(url : String) throws -> String {
        var token: String = "TWILIO_ACCESS_TOKEN"
        let requestURL: URL = URL(string: url)!
        do {
            let data = try Data(contentsOf: requestURL)
            if let tokenReponse = String(data: data, encoding: String.Encoding.utf8) {
                token = tokenReponse
            }
        } catch let error as NSError {
            print ("Invalid token url, error = \(error)")
            throw error
        }
        return token
    }
}




@IBDesignable extension UIView {
    @IBInspectable var borderColor: UIColor? {
        set {
            layer.borderColor = newValue?.cgColor
        }
        get {
            guard let color = layer.borderColor else {
                return nil
            }
            return UIColor(cgColor: color)
        }
    }
    @IBInspectable var borderWidth: CGFloat {
        set {
            layer.borderWidth = newValue
        }
        get {
            return layer.borderWidth
        }
    }
    @IBInspectable var cornerRadius: CGFloat {
        set {
            layer.cornerRadius = newValue
            clipsToBounds = newValue > 0
        }
        get {
            return layer.cornerRadius
        }
    }
}

func getHexaString(status: String) -> String? {
    switch status {
    case "booked":
        return "#31FF98"
    case "notbooked":
        return "#FF2525"
    case "cancelled":
        return "#C9C9C9"
    case "botched":
        return "#9739F4"
    case "latecancelled":
        return "#C9C9C9"
    case "invoiceprocessing":
        return "#2AFFFF"
    case "assigned":
        return "#099c2f"
    case "inprocess":
        return "#2AFFFF "
    case "invoiced":
        return "#A1B587"
    case "notbooked1":
        return "#FF2525"
    case "confirmed":
        return "#32ad52"
    case "pending":
        return "#B3E9F1"
    case "finished":
       return "#1D75DB"
    case "inpocessclr":
        return "#8EDEEB"
    case "lateCusomerReq":
        return "#acea31"
    default:
        return "#827c7c"
    }
}
class CommonClass: NSObject{
    static let share = CommonClass()
    public func activeLinkCall(activeURL : URL) {
        if #available(iOS 10, *) {
            UIApplication.shared.open(activeURL, options: [:], completionHandler:nil)
        } else {
            UIApplication.shared.openURL(activeURL)
        }
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
    func getDateAndTime(startDateAndTime: String,endDateAndTime:String) -> Bool{
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy hh:mm a"
        let sTime = formatter.date(from: startDateAndTime)
        let eTime = formatter.date(from: endDateAndTime)
        
        if sTime?.compare(eTime!) == .orderedAscending {
            
            print("First Date is smaller then second date")
            return true
        }
        if sTime?.compare(eTime!) == .orderedDescending {
            return  false
        }
        if sTime?.compare(eTime!) == .orderedSame {
            return  false
        }
        return  false
    }
    func pickerDateAndTimeformate(dateAndTime: String) -> Date {
        let dformatter = DateFormatter()
        dformatter.dateFormat = "MM/dd/yyyy hh:mm a"
        let pickerDate = dformatter.date(from: dateAndTime) ?? Date()
        return pickerDate
    }
}

