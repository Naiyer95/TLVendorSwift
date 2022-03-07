//
//  AddReimbursementVC.swift
//  TotalVendor
//
//  Created by Shivansh SMIT on 23/02/22.
//

import UIKit
import iOSDropDown
import HSAttachmentPicker
import Alamofire

protocol ReimbursingDelegate{
    func reimbursingMethod()
}


class AddReimbursementVC: UIViewController,BringSelectedImage {
   
    
    let rest = RestManager()
    var reimburseDelegate:ReimbursingDelegate?
    @IBOutlet weak var documentListTV: ContentSizedTableView!
    @IBOutlet weak var percentageTotalLabel: UILabel!
    @IBOutlet weak var percentageLabel: UILabel!
    var apiUploadedFileToS3ResponseModel:ApiUploadedFileToS3ResponseModel?
    var dropDownArray = ["Parking","Toll","Others"]
    let picker = HSAttachmentPicker()
    var forEdit = false
    var index = 0
    @IBOutlet weak var uploadBtnOutlet: UIButton!
    @IBOutlet weak var progressBarSuperView: UIView!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var rateTF: UITextField!
    @IBOutlet weak var typeTF: DropDown!
    var pricee = ""
    var typeee = ""

//    var imageArray = ["doc.fill","doc.fill","doc.fill","doc.fill","doc.fill","I am Testing iOS","I am Testing iOS"]
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.documentListTV.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timeFinishedReimbursementArray.removeAll()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.rateTF.text = self.pricee
        self.typeTF.text = self.typeee
        if forEdit {
            self.uploadBtnOutlet.visibility = .gone
        }else {
            self.uploadBtnOutlet.visibility = .visible
        }
         
        self.progressBarSuperView.dropShadow()
        self.progressBarSuperView.isHidden=true
        self.progressView.progress = 0.0
//        progressView.progressTintColor = UIColor.blue
        progressView.alpha = 0
        typeTF.setLeftPaddingPoints(8)
        picker.delegate = self
        rateTF.keyboardType = .numberPad
        rateTF.delegate=self
        documentListTV.delegate=self
        documentListTV.dataSource=self
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        uploadBtnOutlet.contentMode = .center
        uploadBtnOutlet.imageView?.contentMode = .scaleAspectFit
        if let myImage = UIImage(systemName: "dollarsign.circle.fill"){
            rateTF.withImage(direction: .Left, image: myImage, colorSeparator: UIColor.clear, colorBorder: UIColor.clear,selectedTintColor: .black)
        }
        
//        typeTF.endEditing(true)
        typeTF.delegate=self
        typeTF.optionArray = dropDownArray
        typeTF.didSelect { selectedText, index, id in
            self.typeTF.text = selectedText
        }
    }
    func selectImage(selectedImage: UIImage) {
            print("SELCTED IMAGE IS \(selectedImage)")
            
            let imgData = selectedImage.pngData() ?? Data()
            
            let fileName = "uploadedImg\(Date().timeIntervalSince1970)"
           
            
      //      self.uploadImageToServer(img: image!, myMineType: mtype,myExtension: fileExtension)
      //      uploadSingleFile(fileNamee: filename, customFileURL: myurl,mimeTYPE: mtype)
            
            
            self.uploadDocument(imgData, filename: fileName, myMineTYPE: "image/jpeg") { resultt in
                print("RESULLT IS \(resultt)")
            }
        
            
        }
    @IBAction func dismissBtnTapped(_ sender: Any) {
        self.dismiss(animated: true,completion: nil)
    }

    @IBAction func uploadBtnTapped(_ sender: Any) {
        picker.showAttachmentMenu()
    }
    @IBAction func addBtnTapped(_ sender: Any) {
    
        guard let type = typeTF.text,!type.isEmpty && type != "" else {
            self.view.makeToast("Please select type of the reimbursement")
            return
        }
        guard let price = rateTF.text,!price.isEmpty && price != ""else {
            self.view.makeToast("Please enter value of reimbursement")
            return
        }
        if timeFinishedReimbursementArray.count==0{
            self.view.makeToast("Please upload document in support of reimbursement")
            return
        }
        let intPrice = Double(price) ?? 0
        if intPrice > 25 {
            self.view.makeToast("Maximum $25 can be asked for reimbursement")
            return
        }else {
            
            
            
            
            if forEdit{
                
                mainAddReimbursementArray[index].price = self.rateTF.text ?? ""
                mainAddReimbursementArray[index].type = self.typeTF.text ?? ""
                //[1].updateValue("2:50 AM", forKey: "Start")
               
                reimburseDelegate?.reimbursingMethod()
                self.dismiss(animated: true,completion: nil)
            }else {
                let finalObject = MainReimbursementModel(filesString: timeFinishedReimbursementArray, price: price, type: type, reimburseStaus: "")
                
                mainAddReimbursementArray.append(finalObject)
                reimburseDelegate?.reimbursingMethod()
                self.dismiss(animated: true,completion: nil)
            }
            
         
            
        }
        
        
        
    }
}

extension AddReimbursementVC: HSAttachmentPickerDelegate {
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
         
   //      self.uploadImageToServer(img: image!, myMineType: mtype,myExtension: fileExtension)
   //      uploadSingleFile(fileNamee: filename, customFileURL: myurl,mimeTYPE: mtype)
         print("IMAGEE IS \(image)")
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

extension AddReimbursementVC:UITableViewDelegate,UITableViewDataSource{
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return timeFinishedReimbursementArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = documentListTV.dequeueReusableCell(withIdentifier: "ReimbursementDocumentListTVC", for: indexPath) as! ReimbursementDocumentListTVC
        let fName = timeFinishedReimbursementArray[indexPath.row].selectedFileName
        let fExtension = timeFinishedReimbursementArray[indexPath.row].selectedFileType
        
        
        if self.forEdit{
            cell.deleteButton.isHidden=true
            cell.deleteImg.isHidden=true
            
        }else {
            cell.deleteButton.isHidden = false
            cell.deleteImg.isHidden=false
        }
        
        //        cell.docImage.image = UIImage(systemName: "doc.fill")
        cell.configFileType(type: fExtension, imageURL: "token" ?? "")
        cell.docNameLabel.text = timeFinishedReimbursementArray[indexPath.row].selectedFileName
        cell.deleteButton.tag = indexPath.row
        cell.deleteButton.addTarget(self, action: #selector(deleteBtnTapped(sender:)), for: .touchUpInside)

        return cell
    }
    @objc func deleteBtnTapped(sender: UIButton){
        
        timeFinishedReimbursementArray.remove(at: sender.tag)
        self.documentListTV.reloadData()
        
    }
}



extension AddReimbursementVC:UITextFieldDelegate{
    func textField(_ textField: UITextField,shouldChangeCharactersIn range: NSRange,replacementString string: String) -> Bool
    {
        if textField == rateTF{
            let countdots = rateTF.text?.components(separatedBy: ".").count ?? 0 - 1

            if countdots > 0 && string == "."
            {
                return false
            }
            
            return true
        }
        return true
        
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == typeTF{
            textField.resignFirstResponder()
        }
    }
    
}


class ReimbursementDocumentListTVC:UITableViewCell{
    
    
    @IBOutlet weak var deleteImg: UIImageView!
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

extension AddReimbursementVC{
    
    fileprivate func uploadDocument(_ file: Data,filename : String,myMineTYPE:String,handler : @escaping (String) -> Void) {
        DispatchQueue.main.async {
            self.progressView.alpha = 1.0
            self.progressView.progress=0
            self.progressBarSuperView.isHidden=false
            self.percentageLabel.text = "0%"
            self.percentageTotalLabel.text = "0/100"
        }
        
        
//        self.progressView.progress = 0.0
        print("API REQUEST IS \(filename)and myMimeTYPE is \(myMineTYPE)")
           let headers: HTTPHeaders = [
               "Content-type": "multipart/form-data"
           ]

           AF.upload(
               multipartFormData: { multipartFormData in
                   multipartFormData.append(file, withName: "files" , fileName: filename, mimeType: myMineTYPE)
           },
               to: "https://lsp.totallanguage.com/VendorManagement/VendorTimeFinished/ImportData", method: .post , headers: headers)
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
                                
                                timeFinishedReimbursementArray.append(fileObject)
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5 ){
                                    print("REIMBURSE ARRAY COUNT 1 IS \(timeFinishedReimbursementArray.count)")
                                    self.documentListTV.reloadData()
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
                                                      self.documentListTV.reloadData()
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
    
    
    /*
    func convertToJSON(resulTDict:NSDictionary) -> NSDictionary {
            let theJSONData = try? JSONSerialization.data(withJSONObject: resulTDict ,options: JSONSerialization.WritingOptions(rawValue: 0))
            let jsonString = NSString(data: theJSONData!,encoding: String.Encoding.utf8.rawValue)
            let returnDict = self.convertToDictionary(text:jsonString! as String)
            let userData = returnDict as NSDictionary? as? [AnyHashable: Any] ?? [:]
            return userData as NSDictionary
        }
        
        func convertToJSONFromData(resulTDict:NSData) -> NSDictionary {
            let theJSONData = try? JSONSerialization.data(withJSONObject: resulTDict ,options: JSONSerialization.WritingOptions(rawValue: 0))
            let jsonString = NSString(data: theJSONData!,encoding: String.Encoding.utf8.rawValue)
            let returnDict = self.convertToDictionary(text:jsonString! as String)
            let userData = returnDict as NSDictionary? as? [AnyHashable: Any] ?? [:]
            return userData as NSDictionary
        }
    
    func convertToDictionary(text: String) -> [String: Any]? {
            if let data = text.data(using: .utf8) {
                do {
                    let jsonDict =  try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions(rawValue: UInt(0)))
                    return jsonDict as? [String : Any]
                } catch {
                    //print(error.localizedDescription)
                }
            }
            return nil
        }
    */
    
}


struct UploadDocumentToServerModel{
    var AppointmentID:Int
    var FileName:String
    var FileSize:Int
    var FileType:String
    var FileID:Int
    var Active:Bool
}


struct AddReimubursementModel{
    var selectedFileName : String
    var selectedFileType : String
}

struct MainReimbursementModel{
    var filesString:[AddReimubursementModel]
    var price:String
    var type:String
    var reimburseStaus:String
}

var uploadedTimeFinishDocumentArray = [AddReimubursementModel]()
var timeFinishedReimbursementArray = [AddReimubursementModel]()
var timeFinishedDocumentArray = [AddReimubursementModel]()
var mainAddReimbursementArray = [MainReimbursementModel]()

extension String {

    func fileName() -> String {
        return URL(fileURLWithPath: self).deletingPathExtension().lastPathComponent
    }

    func fileExtension() -> String {
        return URL(fileURLWithPath: self).pathExtension
    }
}
