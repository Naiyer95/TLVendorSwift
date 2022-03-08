//
//  VendorTimeFinishDetailsVC.swift
//  TotalVendor
//
//  Created by Shivansh SMIT on 20/01/22.
//

import UIKit
import HSAttachmentPicker
import Alamofire
import AASignatureView
import UIView_draggable
import Foundation


class ReimbursementListTVC:UITableViewCell{
    
    @IBOutlet weak var statusLabel: UILabel!
    
    @IBOutlet weak var documentBtn: UIButton!
    
    @IBOutlet weak var editButton: UIButton!
    
    @IBOutlet weak var descriptionTitleLabel: UILabel!
    
    @IBOutlet weak var reimbursementTitleLabl: UILabel!
    
    @IBOutlet weak var typeLbl: UILabel!
    
    @IBOutlet weak var priceLabel: UILabel!
    
}
protocol BringSelectedImage{
    func selectImage(selectedImage : UIImage)
}
protocol RefreshVendorTimeFinish{
    func reloadVendorTimeFinish()
}
class VendorTimeFinishDetailsVC: UIViewController,ReimbursingDelegate ,BringSelectedImage{
    
    func reimbursingMethod() {
        DispatchQueue.main.async {
            self.addReimbursementTV.reloadData()
        }
    }
    
    var apiAdditionalReimbursementResponseModel : ApiAdditionalReimbursementResponseModel?
    @IBOutlet weak var notesTF: GrowingTextView!
    var endDate = ""
    var startDateFull = ""
    @IBOutlet weak var percentageTotalLabel: UILabel!
    @IBOutlet weak var percentageLabel: UILabel!
    @IBOutlet weak var progressBarSuperView: UIView!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var uploadAddRembursementBtnOutlet: UIButton!
    let rest = RestManager()
    @IBOutlet weak var addReimbursementTV: ContentSizedTableView!
   
    @IBOutlet weak var endTimeTF: UITextField!
    
    @IBOutlet weak var bookingStatusLbl: UILabel!
    @IBOutlet weak var authCodeLbl: UILabel!
    @IBOutlet weak var customerNameLbl: UILabel!
    @IBOutlet weak var startTimeLbl: UILabel!
    @IBOutlet weak var endTimeLbl: UILabel!
    @IBOutlet weak var durationLbl: UILabel!
    @IBOutlet weak var lblTotal: UILabel!
    var apiGetVendorTimeFinishedDetailsApiResponseModel : ApiGetVendorTimeFinishedDetailsApiResponseModel?
    var appointmentID = 0
    let picker = HSAttachmentPicker()
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var addressLbl: UILabel!
    @IBOutlet weak var cityLbl: UILabel!
    @IBOutlet weak var stateLbl: UILabel!
    @IBOutlet weak var zipCodeLbl: UILabel!
    @IBOutlet weak var departmentLbl: UILabel!
    @IBOutlet weak var rateLbl: UILabel!
    @IBOutlet weak var contactLbl: UILabel!
    @IBOutlet weak var languageLbl: UILabel!
    @IBOutlet weak var patientInitialLbl: UILabel!
    @IBOutlet weak var documentsTV: UITableView!
    var appointmentStatus: String = ""
    var delegate:RefreshVendorTimeFinish?
    var currentSelectedDate = Date()
    
    override func viewDidLoad() {
        self.getReimbursementData()
        addReimbursementTV.delegate=self
        addReimbursementTV.dataSource=self
        picker.delegate = self
     
        super.viewDidLoad()
        self.progressBarSuperView.dropShadow()
        self.progressBarSuperView.isHidden=true
        self.progressView.progress = 0.0
        //        progressView.progressTintColor = UIColor.blue
        progressView.alpha = 0
        documentsTV.delegate=self
        documentsTV.dataSource=self
      
        self.endTimeTF.visibility = .gone
        self.getTimeFinishedDetailsApiData()
        NotificationCenter.default.addObserver(self, selector: #selector(self.methodOfReceivedNotification(notification:)), name: Notification.Name("RpickerDismiss"), object: nil)

        bookingStatusLbl.text = appointmentStatus
    }
    
    @objc func methodOfReceivedNotification(notification: Notification) {
          self.endTimeTF.visibility = .gone
      }
    @IBAction func submitBtnTapped(_ sender: Any) {
        //        self.updateVendorTimeFinishDocumentData()
        
        let cID = userDefaults.value(forKey: UserDeafultsString.instance.CompanyID) as? String ?? "0"
        if cID != "61"{
            if uploadedTimeFinishDocumentArray.count > 0{
                self.updateVendorTimeFinishURL()
            }else{
                self.view.makeToast("Please upload Vendor Time Finish Document")
            }
        }else{
            self.updateVendorTimeFinishURL()
        }
        
 
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        DispatchQueue.main.async{
            self.addReimbursementTV.reloadData()
        }
        
        
    }
    
    
    
    
    
    @IBAction func addBtnOutlet(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddReimbursementVC") as! AddReimbursementVC
        vc.reimburseDelegate=self
        vc.forEdit = false
        vc.modalPresentationStyle = .overFullScreen
        
        self.present(vc, animated: true, completion: nil)
    }
    
    
 
    
    @IBAction func endTimeBtnTapped(_ sender: Any) {
        self.endTimeTF.visibility = .visible
    }
    
    
    @IBAction func backBtnTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
   
    
    @IBAction func endDateTimeBtnTapped(_ sender: Any) {
        //        currentSelectedDate = Date()
                RPicker.selectDate(title: "Select Date & Time", cancelText: "Cancel", datePickerMode: .time,selectedDate: currentSelectedDate,didSelectDate: { (selectedDate) in
                    // TODO: Your implementation for date
                    
                    self.endTimeTF.text = selectedDate.dateString("hh:mm a")
                    self.endTimeTF.visibility = .gone
                    self.endTimeLbl.text = selectedDate.dateString("hh:mm a")
                    
                    self.currentSelectedDate = selectedDate
                    self.durationLbl.text = self.calculateTimeDifference(startTime: self.startTimeLbl.text ?? "" , endTime: self.endTimeTF.text ?? "")
                    }
                )
       }
  
  
    
    func getTrimTime(yourTime: String, isEndTime:Bool) -> Double{
        let nTime = yourTime.trimmingCharacters(in: ["A", "P","M"])
        let dTime = nTime.replacingOccurrences(of: ":", with: ".")
        if isEndTime {
            return Double(dTime)!
        }
        else {
            return Double(dTime)!
        }
    }
    
    func  calculateTimeDifference(startTime:String,endTime:String)->String{
        //        let startTime = "10:30AM"
        //            let endTime = "1:20PM"
        
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mma"
        
        let date1 = formatter.date(from: startTime)!
        let date2 = formatter.date(from: endTime)!
        
        let elapsedTime = date2.timeIntervalSince(date1)
        
        // convert from seconds to hours, rounding down to the nearest hour
        let hours = floor(elapsedTime / 60 / 60)
        
        // we have to subtract the number of seconds in hours from minutes to get
        // the remaining minutes, rounding down to the nearest minute (in case you
        // want to get seconds down the road)
        let minutes = floor((elapsedTime - (hours * 60 * 60)) / 60)
        
        //            print("\(Int(hours)) hr and \(Int(minutes)) min")
        return "\(Int(hours))Hrs : \(Int(minutes))Mins"
        
    }
    
    
    
    
    
    @IBAction func uploadBtnTapped(_ sender: Any) {
        picker.showAttachmentMenu()
        
    }
}

extension VendorTimeFinishDetailsVC: HSAttachmentPickerDelegate {
    func attachmentPickerMenu(_ menu: HSAttachmentPicker, showErrorMessage errorMessage: String) {
        
    }
    
    func attachmentPickerMenuDismissed(_ menu: HSAttachmentPicker) {
        
    }
    
    func attachmentPickerMenu(_ menu: HSAttachmentPicker, show controller: UIViewController, completion: (() -> Void)? = nil) {
        self.present(controller, animated: true, completion: completion)
    }
    
    func attachmentPickerMenu(_ menu: HSAttachmentPicker, upload data: Data, filename: String, image: UIImage?) {
        
        print("FILE SELECTED IS \(filename), and image is \(image) and data is \(data)")
        let fm = FileManager.default
        let docsurl = try! fm.url(for:.documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        let myurl = docsurl.appendingPathComponent(filename)
        let mtype = myurl.mimeType()
        
        let fileNameWithoutExtension = filename.fileName()
        let fileExtension = filename.fileExtension()
        self.uploadDocument(data, filename: filename, myMineTYPE: mtype) { resultt in
            print("RESULLT IS \(resultt)")
        }
       /* if image == nil {
            self.uploadDocument(data, filename: filename, myMineTYPE: mtype) { resultt in
                print("RESULLT IS \(resultt)")
            }
        }
        else {
            DispatchQueue.main.async {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "SignatureVC") as! SignatureVC
                vc.modalPresentationStyle = .fullScreen
                vc.selectedImage = image!
                vc.delegate=self
                self.present(vc, animated: true, completion: nil)
            }
        }*/
        
        
    }
}
extension VendorTimeFinishDetailsVC{
    
    fileprivate func uploadDocument(_ file: Data,filename : String,myMineTYPE:String,handler : @escaping (String) -> Void) {
        DispatchQueue.main.async {
            self.progressView.alpha = 1.0
            self.progressView.progress=0.0
            self.progressBarSuperView.isHidden=false
            self.percentageLabel.text = "0%"
            self.percentageTotalLabel.text = "0/100"
        }
       let authCode = self.authCodeLbl.text ?? ""
        print("API REQUEST IS \(filename)and myMimeTYPE is \(myMineTYPE)")
        let headers: HTTPHeaders = [
            "Content-type": "multipart/form-data"
        ]
        let url = "https://lsp.totallanguage.com/VendorManagement/VendorTimeFinished/ImportData?AuthCode=\(authCode)"
        AF.upload(
            multipartFormData: { multipartFormData in
                multipartFormData.append(file, withName: "files" , fileName: filename, mimeType: myMineTYPE)
            },
            to: url, method: .post , headers: headers)
            .response{ response in
                
                if let data = response.data{
                    let conJson = self.dataToJSON(data: data)
                    print("JSON FINAL IS \(conJson)")
                    let jsonDecoder = JSONDecoder()
                    do{
                        let parsedJSON = try jsonDecoder.decode([ApiUploadedFileToS3ResponseModel].self, from:data )
                        
                        let uploadFileResponse = parsedJSON
                        print("uploadFileResponse \(uploadFileResponse)")
                        
                        let fileObject = AddReimubursementModel(selectedFileName:uploadFileResponse.first?.fileName ?? "" , selectedFileType: uploadFileResponse.first?.fileExtension ?? "")
                        
                        uploadedTimeFinishDocumentArray.append(fileObject)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5 ){
                            print("REIMBURSE ARRAY COUNT 1 IS \(timeFinishedReimbursementArray.count)")
                            self.documentsTV.reloadData()
                            self.progressView.alpha = 0.0
                            self.progressBarSuperView.isHidden=true
                        }
                    }
                    catch
                    {
                        print(error)
                    }
                    
                    //handle the response however you like
                }
                
            }.uploadProgress { (progress) in
                self.progressView.setProgress(Float(progress.fractionCompleted), animated: true)
                let percentage = Float(progress.fractionCompleted)*100
                let rPer = round(percentage)
                self.percentageLabel.text = "\(rPer)%"
                self.percentageTotalLabel.text = "\(rPer)/100"
                
                print("VALUEE IS \(Float(progress.fractionCompleted))")
                print("Progress: \(progress.fractionCompleted)")
                
                if progress.fractionCompleted == 1.0{
                    
                    DispatchQueue.main.async {
                        print("REIMBURSE ARRAY COUNT 2 IS \(timeFinishedReimbursementArray.count)")
                        self.documentsTV.reloadData()
                    }
                }
                
                
            }
    }
    
    func dataToJSON(data: Data) -> Any? {
        do {
            return try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
        } catch let myJSONError {
            print(myJSONError)
        }
        return nil
    }
    func selectImage(selectedImage: UIImage) {
        print("SELCTED IMAGE IS \(selectedImage)")
        
        let imgData = selectedImage.jpegData(compressionQuality: 0.5) ?? Data()
        
        let fileName = "uploadedImg\(Date().timeIntervalSince1970).jpeg"
        
        self.uploadDocument(imgData, filename: fileName, myMineTYPE: "image/jpeg") { resultt in
            print("RESULLT IS \(resultt)")
        }
        
        
    }
    
}


extension VendorTimeFinishDetailsVC:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == addReimbursementTV{
            print("ARRAY ARR COUNT iS \(mainAddReimbursementArray.count)")
            return mainAddReimbursementArray.count
        }
        else {
            return uploadedTimeFinishDocumentArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = documentsTV.dequeueReusableCell(withIdentifier: "VendorFinishDetailDocumentCell", for: indexPath) as! VendorFinishDetailDocumentCell
        let cell1 = addReimbursementTV.dequeueReusableCell(withIdentifier: "ReimbursementListTVC", for: indexPath) as! ReimbursementListTVC
        
        if tableView == addReimbursementTV{
            print("CELL1 IS BEING CALLED")
            if indexPath.row == 0 {
                cell1.descriptionTitleLabel.isHidden=false
                cell1.reimbursementTitleLabl.isHidden=false
            }
            else {
                cell1.descriptionTitleLabel.isHidden=true
                cell1.reimbursementTitleLabl.isHidden=true
            }
            cell1.statusLabel.text = mainAddReimbursementArray[indexPath.row].reimburseStaus
            cell1.typeLbl.text = mainAddReimbursementArray[indexPath.row].type
            cell1.priceLabel.text = "$\(mainAddReimbursementArray[indexPath.row].price)"
            cell1.editButton.tag = indexPath.row
            cell1.editButton.addTarget(self, action: #selector(editBtnTapped(sender:)), for: .touchUpInside)
            cell1.documentBtn.tag = indexPath.row
            cell1.documentBtn.addTarget(self, action: #selector(documentBtnTapped(sender:)), for: .touchUpInside)
            
            return cell1
        }
        else {
            let fName = uploadedTimeFinishDocumentArray[indexPath.row].selectedFileName
            let fExtension = uploadedTimeFinishDocumentArray[indexPath.row].selectedFileType
            //        cell.docImage.image = UIImage(systemName: "doc.fill")
            cell.configFileType(type: fExtension, imageURL: "token" ?? "")
            cell.docNameLabel.text = uploadedTimeFinishDocumentArray[indexPath.row].selectedFileName
            cell.deleteButton.tag = indexPath.row
            cell.deleteButton.addTarget(self, action: #selector(deleteBtnTapped(sender:)), for: .touchUpInside)
            return cell
        }
    }
    @objc func deleteBtnTapped(sender: UIButton){
        uploadedTimeFinishDocumentArray.remove(at: sender.tag)
        self.documentsTV.reloadData()
    }
    
    @objc func editBtnTapped(sender: UIButton){
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddReimbursementVC") as! AddReimbursementVC
        let abc = mainAddReimbursementArray[sender.tag].filesString
        vc.typeee = mainAddReimbursementArray[sender.tag].type
        vc.pricee = mainAddReimbursementArray[sender.tag].price
        vc.forEdit = true
        abc.forEach { abcd in
            let fName = abcd.selectedFileName
            let fType = abcd.selectedFileType
            let temp = AddReimubursementModel(selectedFileName: fName, selectedFileType: fType)
            timeFinishedReimbursementArray.append(temp)
            
        }
        vc.reimburseDelegate=self
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true, completion: nil)
        
        
        
        
        
        
    }
    @objc func documentBtnTapped(sender: UIButton){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ReimbursedDocumentsVC") as! ReimbursedDocumentsVC
        vc.indexx = sender.tag
        vc.isModalInPresentation = true
        self.present(vc, animated: true, completion: nil)
    }
}

extension VendorTimeFinishDetailsVC{
    
    
    
    
    
    func decimalHoursConv (hours : Double) -> (_hrs:String, mins:String) {
        let remainder = hours.truncatingRemainder(dividingBy: 1) * 60
        let mins = (String(format: "%.0f", remainder))
        
        let hours = hours.rounded(.towardZero)
        let hrs = (String(format: "%.0f", hours))
        return (hrs, mins)
    }
    
    
    func convertTimeFormater(_ date: String) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        if let newdate = dateFormatter.date(from: date) {
            dateFormatter.dateFormat = "h:mm a"
            return  dateFormatter.string(from: newdate)
        }else {
            return ""
        }
    }
}

extension VendorTimeFinishDetailsVC{
    
    func getTimeFinishedDetailsApiData(){
        SwiftLoader.show(animated: true)
        let userId = UserDefaults.standard.value(forKey: UserDeafultsString.instance.UserID) ?? "0"
        let companyID = UserDefaults.standard.value(forKey: UserDeafultsString.instance.CompanyID) ?? "0"
        //01/07/2021  MM/dd/yyyy  SwiftLoader.show(animated: true)
        
        let urlString = "https://lsp.totallanguage.com/Home/GetData?methodType=AppointmentInterpreterData&NotoficationId=0&AppointmentID=\(appointmentID)&Interpreterid=\(userId)&UserType=6&Userid=\(userId)"
        print("url to get apiGetVendorDetail  \(urlString)")
        AF.request(urlString, method: .get , parameters: nil, encoding: JSONEncoding.default, headers: nil)
            .validate()
            .responseData(completionHandler: { [self] (response) in
                SwiftLoader.hide()
                switch(response.result){
                
                case .success(_):
                    print("Respose Success apiGetVendorDetail Data ")
                    guard let daata = response.data else { return }
                    do {
                        let jsonDecoder = JSONDecoder()
                        self.apiGetVendorTimeFinishedDetailsApiResponseModel = try jsonDecoder.decode(ApiGetVendorTimeFinishedDetailsApiResponseModel.self, from: daata)
                        let apiData = self.apiGetVendorTimeFinishedDetailsApiResponseModel?.appointmentInterpreterData?.first
                        self.authCodeLbl.text = apiData?.authCode ?? "N/A"
                        self.customerNameLbl.text = apiData?.customerName ?? "N/A"
                        self.startTimeLbl.text = self.convertTimeFormater(apiData?.startDateTime ?? "")
                        self.endDate = self.convertDateFormater(apiData?.endDateTime ?? "")
                        self.startDateFull=self.convertDateFormater(apiData?.startDateTime ?? "")
                        self.endTimeLbl.text = self.convertTimeFormater(apiData?.endDateTime  ?? "N/A")
                        self.nameLbl.text = (apiData?.venueName ?? "N/A")
                        self.addressLbl.text = (apiData?.address ?? "N/A")
                        self.cityLbl.text = apiData?.city ?? "N/A"
                        self.stateLbl.text = apiData?.stateName ?? "N/A"
                        self.zipCodeLbl.text = apiData?.zipcode ?? "N/A"
                       
                        let dformatter = DateFormatter()
                                                dformatter.dateFormat = "h:mm a"
                                                self.currentSelectedDate = dformatter.date(from: self.endTimeLbl.text ?? "") ?? Date()
                       
                       // let abc = self.decimalHoursConv(hours: apiData?.duration ?? 0.00)
                        
                        self.durationLbl.text = self.calculateTimeDifference(startTime: self.startTimeLbl.text ?? "" , endTime: self.endTimeLbl.text ?? "")
                        self.departmentLbl.text = apiData?.departmentName ?? "N/A"
                        self.rateLbl.text = apiData?.oSPerHourFee ?? "0"
                        self.contactLbl.text = apiData?.providerName ?? "N/A"
                        contactLbl.removeEmptyString()
                        self.languageLbl.text = apiData?.languageName ?? "N/A"
                        self.patientInitialLbl.text = apiData?.cPIntials ?? "N/A"
                        self.lblTotal.text = apiData?.total ?? "N/A"
                        patientInitialLbl.removeEmptyString()
                        print("Success apiGetVendorDetail Model \(self.apiGetVendorTimeFinishedDetailsApiResponseModel)")
                    } catch{
                        
                        self.view.makeToast("Please try after sometime")
                        print("error block apiGetVendorDetail Data  " ,error)
                    }
                case .failure(_):
                    print("Respose Failure apiGetVendorDetail")
                }
            })
    }
    
    
    func getReimbursementData(){
        let userId = UserDefaults.standard.value(forKey: UserDeafultsString.instance.UserID) ?? "0"
        let companyID = UserDefaults.standard.value(forKey: UserDeafultsString.instance.CompanyID) ?? "0"
        //01/07/2021  MM/dd/yyyy  SwiftLoader.show(animated: true)
        
        let urlString = "https://lsp.totallanguage.com/Home/GetData?methodType=ADDITIONREMBERSMENT&AppointmentID=\(self.appointmentID)"
        print("getReimbursementData  \(urlString)")
        AF.request(urlString, method: .get , parameters: nil, encoding: JSONEncoding.default, headers: nil)
            .validate()
            .responseData(completionHandler: { [self] (response) in
                SwiftLoader.hide()
                switch(response.result){
                
                case .success(_):
                    print("Respose Success apiGetVendorDetail Data ")
                    guard let daata = response.data else { return }
                    do {
                        let jsonDecoder = JSONDecoder()
                        self.apiAdditionalReimbursementResponseModel = try jsonDecoder.decode(ApiAdditionalReimbursementResponseModel.self, from: daata)
                        
                        apiAdditionalReimbursementResponseModel?.aDDITIONREMBERSMENT?.forEach({ apiData in
                            
                            let reimFile = apiData.rembersmentFile?.split(separator: ",")
                            
                            
                            
                            var filesArray = [AddReimubursementModel]()
                            
                            reimFile?.forEach({ fileNameFull in
                                
                                let separator =  fileNameFull.split(separator: ".")
                                
                                let fXtension = ".\(separator.last ?? "")"
                                let fName = fileNameFull.dropLast(fXtension.count)
                                
                                let tempObject = AddReimubursementModel(selectedFileName: String(fName), selectedFileType: fXtension)
                                filesArray.append(tempObject)
                                
                                
                            })
                            
                            
                            
                            
                            
                            var st = ""
                            switch apiData.tAdditionalresStatus {
                            case 0:
                                st="Pending"
                            case 1:
                                st="Approved"
                            case 2:
                                st="Declined"
                            default:
                                st=""
                            }
                            
                            
                            let obj = MainReimbursementModel(filesString:
                                                                filesArray, price: apiData.additionRembersment ?? "", type: apiData.additionRembersmentLable ?? "", reimburseStaus: st)
                            
                            mainAddReimbursementArray.append(obj)
                            
                        })
                        self.addReimbursementTV.reloadData()
                        
                    } catch{
                        
                        print("error block apiGetVendorDetail Data  " ,error)
                    }
                case .failure(_):
                    print("Respose Failure apiGetVendorDetail")
                }
            })
    }
    
    
}

extension VendorTimeFinishDetailsVC{
    func updateVendorTimeFinishDocumentData(){
        let vendorID = userDefaults.value(forKey: UserDeafultsString.instance.UserID) as? String ?? "0"
        
        var finalServerArray = [SendingToServerApiModel]()
        
        
        
        mainAddReimbursementArray.forEach {
            MainReimbursementModel in
            MainReimbursementModel.filesString.forEach { AddReimubursementModel in
                let obj = SendingToServerApiModel(AppointmentID: self.appointmentID, fileName: AddReimubursementModel.selectedFileName, fileType: AddReimubursementModel.selectedFileType,fileSize:"0",fileID: 0,Active:true)
                finalServerArray.append(obj)
            }
        }
        
        uploadedTimeFinishDocumentArray.forEach { AddReimubursementModel in
            let obj = SendingToServerApiModel(AppointmentID: self.appointmentID, fileName: AddReimubursementModel.selectedFileName, fileType: AddReimubursementModel.selectedFileType,fileSize: "0",fileID: 0,Active: true)
            finalServerArray.append(obj)
        }
        let addOnArr = finalServerArray.map { roomDetail in
            [ "AppointmentID" : roomDetail.AppointmentID,
              "FileName" : roomDetail.fileName,
              "FileSize" : roomDetail.fileSize,
              "FileType":roomDetail.fileType.replacingOccurrences(of: ".", with: ""),
              "FileID" : roomDetail.fileID,
              "Active" : roomDetail.Active
            ] as [String:Any]
        }
        print("FINAL SERVER ARRAY IS \(finalServerArray)")
        print("ADD ON ARRAY IS \(addOnArr)")
       
        
        //
        let parameterss:[String:Any] = [
            "VendorUploadFile":addOnArr
        ]
        print("updateVendorTimeFinishDocumentData Request is",parameterss )
        
        print("DATA TYPE IS \(type(of: addOnArr))and datatype of final is \(type(of: parameterss))")
        
        let headerss:HTTPHeaders = [
            "Content-Type": "application/form-data",
            
        ]
        AF.request(API.UploadDocuments.url,
                   method: .post,
                   parameters: parameterss,encoding:URLEncoding.default,headers: headerss
                   //                   ,headers:headerss
        )
        .validate()
        .responseData { response in
            switch response.result {
            case .success(_):
                print("API REQUEST IS \(AF.request)")
                guard let data = response.data else { return }
                print("updateVendorTimeFinishDocumentData ",data)
                var uploadDocumentsResponseModel:ApiUploadDocumentResponseModel?
                do {
                    let decoder = JSONDecoder()
                    uploadDocumentsResponseModel = try decoder.decode(ApiUploadDocumentResponseModel.self, from: data)
                    print("uploadDocumentsResponseModel dataa isss \(uploadDocumentsResponseModel)")
                    SwiftLoader.hide()
                    
                    
                } catch let error {
                    SwiftLoader.hide()
                    self.view.makeToast("Please enter correct password.", duration: 3.0, position: .center)
                    print(error)
                }
            case .failure(let error):
                print(error)
                self.view.makeToast("Please try after sometime.", duration: 3.0, position: .center)
            }
        }
    }
    
    
    func updateVendorTimeFinishURL(){
        SwiftLoader.show(animated: true)
        
        var finalServerArray = [SendingToServerApiModel]()
//        mainAddReimbursementArray.forEach {
//            MainReimbursementModel in
//            MainReimbursementModel.filesString.forEach { AddReimubursementModel in
//                let obj = SendingToServerApiModel(AppointmentID: self.appointmentID, fileName: AddReimubursementModel.selectedFileName, fileType: AddReimubursementModel.selectedFileType,fileSize:"0",fileID: 0,Active:true)
//                finalServerArray.append(obj)
//            }
//        }
        
        uploadedTimeFinishDocumentArray.forEach { AddReimubursementModel in
            let obj = SendingToServerApiModel(AppointmentID: self.appointmentID, fileName: AddReimubursementModel.selectedFileName, fileType: AddReimubursementModel.selectedFileType,fileSize: "0",fileID: 0,Active: true)
            finalServerArray.append(obj)
        }
        let addOnArr = finalServerArray.map { roomDetail in
            [ "AppointmentID" : roomDetail.AppointmentID,
              "FileName" : roomDetail.fileName,
              "FileSize" : roomDetail.fileSize,
              "FileType":roomDetail.fileType.replacingOccurrences(of: ".", with: ""),
              "FileID" : roomDetail.fileID,
              "Active" : roomDetail.Active
            ] as [String:Any]
        }
        print("FINAL SERVER ARRAY IS \(finalServerArray)")
        print("ADD ON ARRAY IS \(addOnArr)")
        
        
        //
        let parameterss:[String:Any] = [
            "VendorUploadFile":addOnArr
        ]
        let jsonData = try? JSONSerialization.data(withJSONObject: parameterss)
        // create post request
        let url = URL(string: "https://lsp.totallanguage.com/VendorManagement/VendorTimeFinished/UploadDocuments")!
        print("PARAMTER\(parameterss) AND JSON DATA IS\(jsonData)")
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        // insert json data to the request
        request.httpBody = jsonData
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON as? [String: Any] {
                print("RESPONSE DATA JSON IS",responseJSON)
                self.updateVendorTimeFinishFinalUpdate()
            }
        }
        task.resume()
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
    
    func updateVendorTimeFinishFinalUpdate(){
        var finalServerReimburseArray = [SendingToServerFinalApiModel]()
        mainAddReimbursementArray.forEach {
            MainReimbursementModel in
            
            var fileNameArray = [String]()
            let currentRe = MainReimbursementModel.filesString
            var currentFile = ""
            fileNameArray.removeAll()
            
            currentRe.forEach { AddReimubursementModel in
                fileNameArray.append("\(AddReimubursementModel.selectedFileName)\(AddReimubursementModel.selectedFileType)")
            }
            
            let fileNameString = fileNameArray.joined(separator: ",")
            print("FILE NAME STRING IS \(fileNameString)")
            print("FILE NAME ARRAY IS \(fileNameArray)")
            
            let obj = SendingToServerFinalApiModel(AdditionRembersment: MainReimbursementModel.price, AdditionRembersmentLable: MainReimbursementModel.type, AppointmentID: self.appointmentID, RembersmentFile: fileNameString)
            finalServerReimburseArray.append(obj)
            
        }
        
        print("REIMBURSEMENT MY ARRAY IS \(finalServerReimburseArray)")
        
        let addOnArr = finalServerReimburseArray.map { roomDetail in
            [ "AppointmentID" : roomDetail.AppointmentID,
              "AdditionRembersment" : roomDetail.AdditionRembersment,
              "AdditionRembersmentLable" : roomDetail.AdditionRembersmentLable,
              "RembersmentFile":roomDetail.RembersmentFile,
              
            ] as [String:Any]
        }
        let userId = userDefaults.string(forKey: UserDeafultsString.instance.UserID) ?? ""
        print("FINAL SERVER REIMBURSEMENT ARRAY IS \(finalServerReimburseArray)")
        print("ADD ON ARRAY IS \(addOnArr)")
        var notess=""
        var eTime = ""
        var sime = ""
        DispatchQueue.main.async { [self] in
            sime = self.startTimeLbl.text ?? ""
            notess = self.notesTF.text ?? ""
            eTime = self.endTimeLbl.text ?? ""
        }
        
       let apiData = self.apiGetVendorTimeFinishedDetailsApiResponseModel?.appointmentInterpreterData?.first
        
        let parameterss:[String:Any] = [
            "AppointmentDetails":[
                "AppointmentID":self.appointmentID,
                "ClientInvoiceNotes":apiData?.clientInvoiceNotes ?? "",
                "AdditionRembersmentList":addOnArr,
                "OnsiteMilage":false,
                "UpdatedStartDate":"\(sime)",
                "FinishedTime":"\(eTime)",
                "BillProcess":false,
                "typeuser":"Vendor",
                "AdditionTravelTimePay":"00:00",
                "hashofminutes":"",
                "CustomerUserID":userId,
                "Encounter":"0",
                "TFNotes":notess
            ]
            
        ]
        print(" eTime-------------->", eTime, "par:",parameterss)
        let jsonData = try? JSONSerialization.data(withJSONObject: parameterss)
        // create post request
        
        let url = URL(string: "https://lsp.totallanguage.com/VendorManagement/VendorTimeFinished/AddUpdateTimeFinishedAppointment")!
        print("PARAMTERUPDATE REQUEST IS\(parameterss) AND JSON DATA IS\(jsonData)")
        
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        // insert json data to the request
        request.httpBody = jsonData
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON as? [String: Any] {
                
                DispatchQueue.main.async {
                    SwiftLoader.hide()
                    print("RESPONSE DATA JSON IS",responseJSON)
                    mainAddReimbursementArray.removeAll()
                    uploadedTimeFinishDocumentArray.removeAll()
                    timeFinishedReimbursementArray.removeAll()
                    timeFinishedDocumentArray.removeAll()
                    
                    self.view.makeToast("Submitted Successfully")
                    self.delegate?.reloadVendorTimeFinish()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        self.dismiss(animated: true, completion: nil)
                    }
                  }
            }}
        task.resume()
        
    }}

class VendorFinishDetailDocumentCell:UITableViewCell{
    
    @IBOutlet weak var docImage:UIImageView!
    @IBOutlet weak var docNameLabel:UILabel!
    @IBOutlet weak var deleteButton:UIButton!
    
    
    func configFileType(type:String,imageURL:String){
        //        ".txt", ".pdf", ".zip", ".rar", ".doc", ".docx",".ppt", ".pptx", ".xls", ".xlsx", images ,videos, audio,
        switch type {
        case ".txt","txt" :
            docImage.image = UIImage(systemName: "doc.text.fill")
            docImage.tintColor = .black
        case ".pdf","pdf":
            docImage.image = UIImage(named:"pdfIcon")
        case ".zip","zip":
            docImage.image = UIImage(systemName:"doc.zipper")
            docImage.tintColor = .black
        case ".rar","rar":
            docImage.image = UIImage(systemName:"doc.zipper")
            docImage.tintColor = .black
        case ".doc","doc":
            docImage.image = UIImage(systemName:"doc.fill")
            docImage.tintColor = .black
        case ".docx","docx":
            docImage.image = UIImage(systemName:"doc.fill")
            docImage.tintColor = .black
        case ".ppt","ppt":
            docImage.image = UIImage(systemName:"doc.on.doc.fill")
            docImage.tintColor = .black
        case ".pptx","pptx":
            docImage.image = UIImage(systemName:"doc.on.doc.fill")
            docImage.tintColor = .black
        case ".xls","xls":
            docImage.image = UIImage(systemName:"xls")
            docImage.tintColor = .black
        case ".xlsx","xlsx":
            docImage.image = UIImage(systemName:"xls")
            docImage.tintColor = .black
        case ".png","png":
            //            docImage.sd_setImage(with: URL(string: imageURL), completed: nil)
            docImage.image = UIImage(systemName:"doc.fill")
            docImage.tintColor = .black
        case ".jpeg","jpeg":
            //            docImage.sd_setImage(with: URL(string: imageURL), completed: nil)
            docImage.image = UIImage(systemName:"doc.fill")
            docImage.tintColor = .black
        case ".gif","gif":
            //            docImage.sd_setImage(with: URL(string: imageURL), completed: nil)
            docImage.image = UIImage(systemName:"doc.fill")
            docImage.tintColor = .black
        case ".xml","xml":
            docImage.image = UIImage(systemName:"safari.fill")
            docImage.tintColor = .black
        case ".html","html":
            docImage.image = UIImage(systemName:"safari.fill")
            docImage.tintColor = .black
        default:
            docImage.image = UIImage(systemName:"doc.circle.fill")
            docImage.tintColor = .black
        }
    }
}

struct SendingToServerApiModel{
    var AppointmentID:Int
    var fileName:String
    var fileType:String
    var fileSize:String
    var fileID:Int
    var Active:Bool
}

struct SendingToServerFinalApiModel{
    var AdditionRembersment : String
    var AdditionRembersmentLable : String
    var AppointmentID : Int
    var RembersmentFile : String
}
