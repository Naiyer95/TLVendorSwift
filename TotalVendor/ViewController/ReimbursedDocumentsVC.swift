//
//  ReimbursedDocumentsVC.swift
//  TotalVendor
//
//  Created by Shivansh SMIT on 26/02/22.
//

import UIKit
import Alamofire

class ReimbursedDocumentsVC: UIViewController {
    @IBOutlet weak var documentsCV: UICollectionView!
    var indexx = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        documentsCV.delegate=self
        documentsCV.dataSource=self
    }
    
    @IBAction func closeBtnTapped(_ sender: Any) {
        self.dismiss(animated: true,completion: nil)
    }

}
extension ReimbursedDocumentsVC:UICollectionViewDelegate,UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        mainAddReimbursementArray[indexx].filesString.count
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let itemm = mainAddReimbursementArray[indexx].filesString[indexPath.row]
        
        let fName = itemm.selectedFileName
        let fExtension = itemm.selectedFileType.replacingOccurrences(of: ".", with: "")
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
        let cell = documentsCV.dequeueReusableCell(withReuseIdentifier: "UploadDocumentsCVC", for: indexPath) as! UploadDocumentsCVC
        let itemm = mainAddReimbursementArray[indexx].filesString[indexPath.row]
        
        let fName = itemm.selectedFileName
        let fExtension = itemm.selectedFileType
        
        self.getFileImgURl(fileName: fName, extensionType: fExtension) { Completion, token, error in
//            cell.documentImgView.sd_setImage(with: URL(string: token ?? ""), completed: nil)
            cell.configFileType(type: fExtension, imageURL: token ?? "")
        
//            cell.documentImgView.contentMode = .scaleAspectFill
        }
        
        
        return cell
    }
    
}

extension ReimbursedDocumentsVC{
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
