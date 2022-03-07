//
//  API.swift
//  TotalVendor
//
//  Created by Darrin Brooks on 01/03/22.
//

import Foundation
var baseURL = "https://lsp.totallanguage.com/"
enum API {
    
    
    case UploadDocuments
    var url :URL {
        switch self {
        case .UploadDocuments:
            return URL(string: baseURL + "VendorManagement/VendorTimeFinished/UploadDocuments")!
        
        }
    }
}
