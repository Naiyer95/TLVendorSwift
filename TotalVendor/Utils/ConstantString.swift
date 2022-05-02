//
//  ConstantString.swift
//  TotalVendor
//
//  Created by Darrin Brooks on 08/04/22.
//

import Foundation
enum ConstantStr {
    case noItnernet
    var val:String {
        switch self {
        case .noItnernet:
            return "No internet connection!"
        
        }
    }
    
}
