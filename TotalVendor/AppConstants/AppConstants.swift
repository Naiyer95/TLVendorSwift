//
//  AppConstants.swift
//  Total Vendor
//
//  Created by Mac on 17/08/21.
//

import Foundation

typealias JSONDictionary = [String:Any]
struct Storyboard_name {
    static let scanner = "scanner"
    static let main = "Main"
    
}
struct controller_Name{
    static let initial = "InitialViewController"
    static let newAptD = "NewAppointmentDetailsVC"
    static let blockedAptD = "BlockedAppointmentVC"
    static let telephoneAptD = "TelephoneConferenceDetailsVC"
    static let telephoneBD = "BlockedAppointmentTelephonicConferenceDetails"
    static let virtualBD = "BlockedAppointmentVirtualMeetingDetails"
}

struct NotificationData {
    var type: AnyHashable?
    var id: AnyHashable?
    public func getNotificationData() -> [AnyHashable:Any] {
        let dict = NSMutableDictionary()
        dict.setValue(type, forKey: "type")
        dict.setValue(id, forKey: "id")
        return dict as! [AnyHashable: Any]
    }
    
}
