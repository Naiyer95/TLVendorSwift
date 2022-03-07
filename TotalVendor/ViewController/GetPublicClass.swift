//
//  GetPublicDetail.swift
//  TLClientApp
//
//  Created by Mac on 02/11/21.
//

import Foundation
import Alamofire
public class GetPublicData {
    static var sharedInstance = GetPublicData()
    public var languageArray:[String] = []
    public var userID = userDefaults.string(forKey: UserDeafultsString.instance.UserID) ?? ""
    
    public var usenName = userDefaults.string(forKey: UserDeafultsString.instance.USER_USERNAME) ?? ""
    public var companyName = userDefaults.string(forKey: UserDeafultsString.instance.CompanyName) ?? ""
    public var userTypeID = userDefaults.string(forKey: UserDeafultsString.instance.UserTypeID) ?? ""
    public var companyID = userDefaults.string(forKey: UserDeafultsString.instance.CompanyID) ?? ""
    var apic = [AppointmentTypeDataModel]()
    var apiGetSpecialityDataModel:ApiGetSpecialityDataModel?
    
    public var apiGetAllLanguageResponse:ApiGetAllLanguageResponse?
    public func getAllLanguage(){
        SwiftLoader.show(animated: true)
             
        //languageArray.removeAll()
        //self.apiGetAllLanguageResponse = nil
        let urlString = "https://lsp.totallanguage.com/Security/GetData?methodType=LanguageData"
                AF.request(urlString, method: .get , parameters: nil, encoding: JSONEncoding.default, headers: nil)
                    .validate()
                    .responseData(completionHandler: { [self] (response) in
                        SwiftLoader.hide()
                        switch(response.result){
                        
                        case .success(_):
                            print("Respose Success language data ")
                            guard let daata = response.data else { return }
                            do {
                                let jsonDecoder = JSONDecoder()
                                self.apiGetAllLanguageResponse = try jsonDecoder.decode(ApiGetAllLanguageResponse.self, from: daata)
                               print("Success language ")
                                self.apiGetAllLanguageResponse?.languageData?.forEach({ languageData in
                                       let languageString = languageData.languageName ?? ""
                                         languageArray.append(languageString)
                                })
                                
                            } catch{
                                
                                print("error block forgot password " ,error)
                            }
                        case .failure(_):
                            
                            print("Respose Failure ")
                           
                        }
                })
     }
    
}




public class ApiGetAllLanguageResponse : Codable {
    let languageData : [ApiLanguageResponseData]?

    enum CodingKeys: String, CodingKey {

        case languageData = "LanguageData"
    }

    required public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        languageData = try values.decodeIfPresent([ApiLanguageResponseData].self, forKey: .languageData)
    }

}



struct ApiLanguageResponseData : Codable {
    let languageID : Int?
    let languageName : String?
    let active : Bool?
    let type : String?
    let rate : Int?
    let vendorLanguageID : String?
    let languageColorCode : String?

    enum CodingKeys: String, CodingKey {

        case languageID = "LanguageID"
        case languageName = "LanguageName"
        case active = "Active"
        case type = "Type"
        case rate = "Rate"
        case vendorLanguageID = "VendorLanguageID"
        case languageColorCode = "LanguageColorCode"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        languageID = try values.decodeIfPresent(Int.self, forKey: .languageID)
        languageName = try values.decodeIfPresent(String.self, forKey: .languageName)
        active = try values.decodeIfPresent(Bool.self, forKey: .active)
        type = try values.decodeIfPresent(String.self, forKey: .type)
        rate = try values.decodeIfPresent(Int.self, forKey: .rate)
        vendorLanguageID = try values.decodeIfPresent(String.self, forKey: .vendorLanguageID)
        languageColorCode = try values.decodeIfPresent(String.self, forKey: .languageColorCode)
    }

}

/*
class AppointmentTypeDataModel : Codable {
    let id : Int?
    let code : String?
    let value : String?
    let type : String?
    let sortOrder : Int?
    let exactValue : String?
    let color : String?
    let flag : String?

    enum CodingKeys: String, CodingKey {

        case id = "Id"
        case code = "Code"
        case value = "Value"
        case type = "Type"
        case sortOrder = "SortOrder"
        case exactValue = "ExactValue"
        case color = "Color"
        case flag = "Flag"
    }

    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        code = try values.decodeIfPresent(String.self, forKey: .code)
        value = try values.decodeIfPresent(String.self, forKey: .value)
        type = try values.decodeIfPresent(String.self, forKey: .type)
        sortOrder = try values.decodeIfPresent(Int.self, forKey: .sortOrder)
        exactValue = try values.decodeIfPresent(String.self, forKey: .exactValue)
        color = try values.decodeIfPresent(String.self, forKey: .color)
        flag = try values.decodeIfPresent(String.self, forKey: .flag)
    }
}
*/
struct ApiGetSpecialityDataModel : Codable {
    let speciality : [SpecialityDataModel]?
    let appointmentType : [AppointmentTypeDataModel]?
    let documentTranslationJobType : [DocumentTranslationJobTypeDataModel]?
    let appointmentStatus : [AppointmentStatusDataModel]?
    let gender : [GenderDataModel]?
    let vendorRanking : [VendorRankingDataModel]?
    let travelMiles : [TravelMilesDataModel]?

    enum CodingKeys: String, CodingKey {

        case speciality = "Speciality"
        case appointmentType = "AppointmentType"
        case documentTranslationJobType = "DocumentTranslationJobType"
        case appointmentStatus = "AppointmentStatus"
        case gender = "Gender"
        case vendorRanking = "VendorRanking"
        case travelMiles = "TravelMiles"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        speciality = try values.decodeIfPresent([SpecialityDataModel].self, forKey: .speciality)
        appointmentType = try values.decodeIfPresent([AppointmentTypeDataModel].self, forKey: .appointmentType)
        documentTranslationJobType = try values.decodeIfPresent([DocumentTranslationJobTypeDataModel].self, forKey: .documentTranslationJobType)
        appointmentStatus = try values.decodeIfPresent([AppointmentStatusDataModel].self, forKey: .appointmentStatus)
        gender = try values.decodeIfPresent([GenderDataModel].self, forKey: .gender)
        vendorRanking = try values.decodeIfPresent([VendorRankingDataModel].self, forKey: .vendorRanking)
        travelMiles = try values.decodeIfPresent([TravelMilesDataModel].self, forKey: .travelMiles)
    }

}



struct SpecialityDataModel : Codable {
    let specialityID : Int?
    let displayValue : String?
    let companyID : Int?
    let isDefault : Bool?
    let duration : String?
    let active : Bool?
    //let internal : Bool?
    let checkList : String?
    let interpretationType : String?
    let sType : String?
    let interpretationTypeID : String?
    let interpretationID : String?
    let specialityExperience : String?

    enum CodingKeys: String, CodingKey {

        case specialityID = "SpecialityID"
        case displayValue = "DisplayValue"
        case companyID = "CompanyID"
        case isDefault = "IsDefault"
        case duration = "Duration"
        case active = "Active"
        //case internal = "Internal"
        case checkList = "CheckList"
        case interpretationType = "InterpretationType"
        case sType = "SType"
        case interpretationTypeID = "InterpretationTypeID"
        case interpretationID = "InterpretationID"
        case specialityExperience = "SpecialityExperience"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        specialityID = try values.decodeIfPresent(Int.self, forKey: .specialityID)
        displayValue = try values.decodeIfPresent(String.self, forKey: .displayValue)
        companyID = try values.decodeIfPresent(Int.self, forKey: .companyID)
        isDefault = try values.decodeIfPresent(Bool.self, forKey: .isDefault)
        duration = try values.decodeIfPresent(String.self, forKey: .duration)
        active = try values.decodeIfPresent(Bool.self, forKey: .active)
        //internal = try values.decodeIfPresent(Bool.self, forKey: .internal)
        checkList = try values.decodeIfPresent(String.self, forKey: .checkList)
        interpretationType = try values.decodeIfPresent(String.self, forKey: .interpretationType)
        sType = try values.decodeIfPresent(String.self, forKey: .sType)
        interpretationTypeID = try values.decodeIfPresent(String.self, forKey: .interpretationTypeID)
        interpretationID = try values.decodeIfPresent(String.self, forKey: .interpretationID)
        specialityExperience = try values.decodeIfPresent(String.self, forKey: .specialityExperience)
    }

}




class AppointmentTypeDataModel : Codable {
    let id : Int?
    let code : String?
    let value : String?
    let type : String?
    let sortOrder : Int?
    let exactValue : String?
    let color : String?
    let flag : String?

    enum CodingKeys: String, CodingKey {

        case id = "Id"
        case code = "Code"
        case value = "Value"
        case type = "Type"
        case sortOrder = "SortOrder"
        case exactValue = "ExactValue"
        case color = "Color"
        case flag = "Flag"
    }

    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        code = try values.decodeIfPresent(String.self, forKey: .code)
        value = try values.decodeIfPresent(String.self, forKey: .value)
        type = try values.decodeIfPresent(String.self, forKey: .type)
        sortOrder = try values.decodeIfPresent(Int.self, forKey: .sortOrder)
        exactValue = try values.decodeIfPresent(String.self, forKey: .exactValue)
        color = try values.decodeIfPresent(String.self, forKey: .color)
        flag = try values.decodeIfPresent(String.self, forKey: .flag)
    }
}

struct DocumentTranslationJobTypeDataModel : Codable {
    let id : Int?
    let code : String?
    let value : String?
    let type : String?
    let sortOrder : Int?
    let exactValue : String?
    let color : String?
    let flag : String?

    enum CodingKeys: String, CodingKey {

        case id = "Id"
        case code = "Code"
        case value = "Value"
        case type = "Type"
        case sortOrder = "SortOrder"
        case exactValue = "ExactValue"
        case color = "Color"
        case flag = "Flag"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        code = try values.decodeIfPresent(String.self, forKey: .code)
        value = try values.decodeIfPresent(String.self, forKey: .value)
        type = try values.decodeIfPresent(String.self, forKey: .type)
        sortOrder = try values.decodeIfPresent(Int.self, forKey: .sortOrder)
        exactValue = try values.decodeIfPresent(String.self, forKey: .exactValue)
        color = try values.decodeIfPresent(String.self, forKey: .color)
        flag = try values.decodeIfPresent(String.self, forKey: .flag)
    }

}

struct AppointmentStatusDataModel : Codable {
    let id : Int?
    let code : String?
    let value : String?
    let type : String?
    let sortOrder : Int?
    let exactValue : String?
    let color : String?
    let flag : Int?

    enum CodingKeys: String, CodingKey {

        case id = "Id"
        case code = "Code"
        case value = "Value"
        case type = "Type"
        case sortOrder = "SortOrder"
        case exactValue = "ExactValue"
        case color = "Color"
        case flag = "Flag"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        code = try values.decodeIfPresent(String.self, forKey: .code)
        value = try values.decodeIfPresent(String.self, forKey: .value)
        type = try values.decodeIfPresent(String.self, forKey: .type)
        sortOrder = try values.decodeIfPresent(Int.self, forKey: .sortOrder)
        exactValue = try values.decodeIfPresent(String.self, forKey: .exactValue)
        color = try values.decodeIfPresent(String.self, forKey: .color)
        flag = try values.decodeIfPresent(Int.self, forKey: .flag)
    }

}



struct GenderDataModel : Codable {
    let id : Int?
    let code : String?
    let value : String?
    let type : String?
    let sortOrder : Int?
    let exactValue : String?
    let color : String?
    let flag : String?

    enum CodingKeys: String, CodingKey {

        case id = "Id"
        case code = "Code"
        case value = "Value"
        case type = "Type"
        case sortOrder = "SortOrder"
        case exactValue = "ExactValue"
        case color = "Color"
        case flag = "Flag"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        code = try values.decodeIfPresent(String.self, forKey: .code)
        value = try values.decodeIfPresent(String.self, forKey: .value)
        type = try values.decodeIfPresent(String.self, forKey: .type)
        sortOrder = try values.decodeIfPresent(Int.self, forKey: .sortOrder)
        exactValue = try values.decodeIfPresent(String.self, forKey: .exactValue)
        color = try values.decodeIfPresent(String.self, forKey: .color)
        flag = try values.decodeIfPresent(String.self, forKey: .flag)
    }

}

struct VendorRankingDataModel : Codable {
    let id : Int?
    let code : String?
    let value : String?
    let type : String?
    let sortOrder : Int?
    let exactValue : String?
    let color : String?
    let flag : String?

    enum CodingKeys: String, CodingKey {

        case id = "Id"
        case code = "Code"
        case value = "Value"
        case type = "Type"
        case sortOrder = "SortOrder"
        case exactValue = "ExactValue"
        case color = "Color"
        case flag = "Flag"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        code = try values.decodeIfPresent(String.self, forKey: .code)
        value = try values.decodeIfPresent(String.self, forKey: .value)
        type = try values.decodeIfPresent(String.self, forKey: .type)
        sortOrder = try values.decodeIfPresent(Int.self, forKey: .sortOrder)
        exactValue = try values.decodeIfPresent(String.self, forKey: .exactValue)
        color = try values.decodeIfPresent(String.self, forKey: .color)
        flag = try values.decodeIfPresent(String.self, forKey: .flag)
    }

}


struct TravelMilesDataModel : Codable {
    let id : Int?
    let code : String?
    let value : String?
    let type : String?
    let sortOrder : Int?
    let exactValue : Int?
    let color : String?
    let flag : String?

    enum CodingKeys: String, CodingKey {

        case id = "Id"
        case code = "Code"
        case value = "Value"
        case type = "Type"
        case sortOrder = "SortOrder"
        case exactValue = "ExactValue"
        case color = "Color"
        case flag = "Flag"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        code = try values.decodeIfPresent(String.self, forKey: .code)
        value = try values.decodeIfPresent(String.self, forKey: .value)
        type = try values.decodeIfPresent(String.self, forKey: .type)
        sortOrder = try values.decodeIfPresent(Int.self, forKey: .sortOrder)
        exactValue = try values.decodeIfPresent(Int.self, forKey: .exactValue)
        color = try values.decodeIfPresent(String.self, forKey: .color)
        flag = try values.decodeIfPresent(String.self, forKey: .flag)
    }

}
