//
//  ApiCheckSingleSignInResponseModel.swift
//  TotalVendor
//
//  Created by Shivansh SMIT on 13/01/22.
//

import Foundation
struct ApiCheckSingleSignInResponseModel : Codable {
    let result : String?

    enum CodingKeys: String, CodingKey {

        case result = "result"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        result = try values.decodeIfPresent(String.self, forKey: .result)
    }

}
