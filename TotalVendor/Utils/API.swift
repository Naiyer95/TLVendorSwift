//
//  API.swift
//  TotalVendor
//
//  Created by Darrin Brooks on 01/03/22.
//

import Foundation
var baseURL = "https://lsp.totallanguage.com/"
var signUPUrl = "https://lsp.totallanguage.com/Security/Register/Vendor"
enum API {
    
    
    case UploadDocuments
    case AddUpdateTimeFinishedAppointment
    var url :URL {
        switch self {
        case .UploadDocuments:
            return URL(string: baseURL + "VendorManagement/VendorTimeFinished/UploadDocuments")!
        case .AddUpdateTimeFinishedAppointment:
            return URL(string: baseURL + "VendorManagement/VendorTimeFinished/AddUpdateTimeFinishedAppointment")!
        
        }
    }
}
