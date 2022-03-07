//
//  UploadedDocumentsVC.swift
//  TotalVendor
//
//  Created by Shivansh SMIT on 19/01/22.
//

import UIKit
import Alamofire

class UploadDocumentsCVC:UICollectionViewCell{
    
    @IBOutlet weak var documentImgView:UIImageView!
    
    
    func configFileType(type:String,imageURL:String){
//        ".txt", ".pdf", ".zip", ".rar", ".doc", ".docx",".ppt", ".pptx", ".xls", ".xlsx", images ,videos, audio,
        
        
        switch type {
        case "txt",".txt":
            documentImgView.image = UIImage(systemName: "doc.text.fill")
            documentImgView.tintColor = .black
        case "pdf",".pdf":
            documentImgView.image = UIImage(named:"pdfIcon")
        case "zip",".zip":
            documentImgView.image = UIImage(systemName:"doc.zipper")
            documentImgView.tintColor = .black
        case "rar",".rar":
            documentImgView.image = UIImage(systemName:"doc.zipper")
            documentImgView.tintColor = .black
        case "doc",".doc":
            documentImgView.image = UIImage(systemName:"doc.fill")
            documentImgView.tintColor = .black
        case "docx",".docx":
            documentImgView.image = UIImage(systemName:"doc.fill")
            documentImgView.tintColor = .black
        case "ppt",".ppt":
            documentImgView.image = UIImage(systemName:"doc.on.doc.fill")
            documentImgView.tintColor = .black
        case "pptx",".pptx":
            documentImgView.image = UIImage(systemName:"doc.on.doc.fill")
            documentImgView.tintColor = .black
        case "xls",".xls":
            documentImgView.image = UIImage(systemName:"xls")
            documentImgView.tintColor = .black
        case "xlsx",".xlsx":
            documentImgView.image = UIImage(systemName:"xls")
            documentImgView.tintColor = .black
        case "png",".png":
            documentImgView.sd_setImage(with: URL(string: imageURL), completed: nil)
        case "jpeg",".jpeg":
            documentImgView.sd_setImage(with: URL(string: imageURL), completed: nil)
        case "gif",".gif":
            documentImgView.sd_setImage(with: URL(string: imageURL), completed: nil)
        case "xml",".xml":
            documentImgView.image = UIImage(systemName:"safari.fill")
            documentImgView.tintColor = .black
        case "html",".html":
            documentImgView.image = UIImage(systemName:"safari.fill")
            documentImgView.tintColor = .black
        default:
            documentImgView.image = UIImage(systemName:"doc.circle.fill")
            documentImgView.tintColor = .black
        }
        
        
        
    }
    
    
    
}

class UploadedDocumentsVC: UIViewController {
    var appointmentID = 0
    @IBOutlet weak var documentsListCV: UICollectionView!
    var apiUploadedFileListResponseModel : ApiUploadedFileListResponseModel?
    override func viewDidLoad() {
        super.viewDidLoad()
        documentsListCV.delegate = self
        documentsListCV.dataSource = self
        self.getUploadedFileList()
    }
  
    @IBAction func dismissButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
}

extension UploadedDocumentsVC:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.apiUploadedFileListResponseModel?.gETVENDORFILELIST?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let fName = self.apiUploadedFileListResponseModel?.gETVENDORFILELIST?[indexPath.row].fileName ?? ""
        let fExtension = self.apiUploadedFileListResponseModel?.gETVENDORFILELIST?[indexPath.row].fileType ?? ""
        self.getFileImgURl(fileName: fName, extensionType: fExtension) { Completion, token, error in
//            cell.documentImgView.sd_setImage(with: URL(string: token ?? ""), completed: nil)
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ServiceVerificationURLViewController") as! ServiceVerificationURLViewController
            vc.fromUploadedDocuments = true
            vc.serviceURL = token ?? ""
            vc.isFromRegular=false
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: true, completion: nil)
            
            
        
//            cell.documentImgView.contentMode = .scaleAspectFill
        }
        
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = documentsListCV.dequeueReusableCell(withReuseIdentifier: "UploadDocumentsCVC", for: indexPath) as! UploadDocumentsCVC
        
        let fName = self.apiUploadedFileListResponseModel?.gETVENDORFILELIST?[indexPath.row].fileName ?? ""
        let fExtension = self.apiUploadedFileListResponseModel?.gETVENDORFILELIST?[indexPath.row].fileType ?? ""
        
        
       
        
        
        self.getFileImgURl(fileName: fName, extensionType: fExtension) { Completion, token, error in
//            cell.documentImgView.sd_setImage(with: URL(string: token ?? ""), completed: nil)
            cell.configFileType(type: fExtension, imageURL: token ?? "")
        
//            cell.documentImgView.contentMode = .scaleAspectFill
        }
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
                    let noOfCellsInRow = 3
            let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
            flowLayout.minimumInteritemSpacing = 2
        flowLayout.minimumLineSpacing=3
            let totalSpace = flowLayout.sectionInset.left
            + flowLayout.sectionInset.right
            + (flowLayout.minimumInteritemSpacing * CGFloat(noOfCellsInRow - 1))
            let size = Int((collectionView.bounds.width - totalSpace) / CGFloat(noOfCellsInRow))
            return CGSize(width: size, height: size)
    }
}

extension UploadedDocumentsVC{
    func getUploadedFileList(){
        SwiftLoader.show(animated: true)
        let userId = UserDefaults.standard.value(forKey: UserDeafultsString.instance.UserID) ?? "0"
        let companyID = UserDefaults.standard.value(forKey: UserDeafultsString.instance.CompanyID) ?? "0"
        //01/07/2021  MM/dd/yyyy
        let urlString = "https://lsp.totallanguage.com/VendorTimeFinished/GetData?methodType=GETVENDORFILELIST&AppointmentID=\(appointmentID)"
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
                                self.apiUploadedFileListResponseModel = try jsonDecoder.decode(ApiUploadedFileListResponseModel.self, from: daata)
                               print("Success apiGetVendorDetail Model \(self.apiUploadedFileListResponseModel)")
                                
                                DispatchQueue.main.async {
                                    self.documentsListCV.reloadData()
                                }
                                
                            } catch{
                                
                                print("error block apiGetVendorDetail Data  " ,error)
                            }
                        case .failure(_):
                            print("Respose Failure apiGetVendorDetail")
                           
                        }
                })
     }
    
    func getFileImgURl(fileName:String,extensionType:String,completionHandler:@escaping(Bool?, String?,Error?) -> ()){
         
         let urlString = "https://lsp.totallanguage.com/PreviewFiles/Previewawsfiles?filename=\(fileName).\(extensionType)&type=VendorTimeFinishedDocUploaded"
        
         print("url and parameter for getCreateVRICallVendor",urlString, urlString)
         AF.request(urlString, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil)
             .validate()
             .responseData(completionHandler: { (response) in
                 SwiftLoader.hide()
                 switch(response.result){
                 
                 case .success(_):
                     
                     print("get twillio token  ",response)
                     guard let daata = response.data else { return }
                     print(String(data: daata, encoding: .utf8)!)
                     let token = String(data: daata, encoding: .utf8)!
                     print("token is ",token)
                     completionHandler(true,token,nil)
                    case .failure(_):
                     print("Respose Failure getCreateVRICallClient ")
                    
                 }
         })
         
     }
    
    
    
    
}
