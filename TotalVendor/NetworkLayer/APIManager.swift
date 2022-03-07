//
//  APIManager.swift
//  Total Vendor
//
//  Created by Mac on 17/08/21.
//

import Foundation
import Alamofire

class NetworkLayer: NSObject {
    static let shared: NetworkLayer = NetworkLayer()
}

extension NetworkLayer {
    func postRequest(url: String, parameters: [String: Any], onSuccess: @escaping(Any)->(), failure:@escaping(Error)->()) {
        AF.request(url, method:.post, parameters: parameters, encoding: JSONEncoding.default) .responseJSON { (response) in
            print(response.result)
            switch response.result {
            case .success(let result):
                onSuccess(response.value as! Any)
            case.failure(let error):
                failure(error)
            }
        }
    }
}
