//
//  VRINewViewController.swift
//  TotalVendor
//
//  Created by Shivansh SMIT on 03/12/21.
//

import UIKit
import Alamofire

class VRINewViewController: UIViewController {

    
    @IBOutlet weak var newUserImgView: UIImageView!
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var languageCV: UICollectionView!
    var Live_BASE_URL = "https://lsp.totallanguage.com/"
    var apiLanguageDataResponseModel : ApiLanguageDataResponseModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let imageData = (userDefaults.value(forKey: UserDeafultsString.instance.USER_IMAGEDATA) ?? "")
        let finalData = "\(Live_BASE_URL)\(imageData)"
        print("FINAL DATA IS \(finalData)")
        if imageData as! String != "" {
            self.userImageView.sd_setImage(with: URL(string: finalData), completed: nil)
            self.newUserImgView.sd_setImage(with: URL(string: finalData), completed: nil)
        }else {
            self.userImageView.image = UIImage(systemName: "person.fill")
            self.userImageView.tintColor  = .white
            self.newUserImgView.image = UIImage(systemName: "person.fill")
            self.newUserImgView.tintColor  = .white
        }

        self.languageCV.bounces = false
        hitApiGetLanguageList()
        userNameLbl.text = (userDefaults.value(forKey: UserDeafultsString.instance.fullName) as? String) ?? ""
        print("IMAGE DATA IS \(userDefaults.value(forKey: UserDeafultsString.instance.USER_IMAGEDATA) ?? "")")

    }
}

extension VRINewViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.apiLanguageDataResponseModel?.languageData?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = languageCV.dequeueReusableCell(withReuseIdentifier: "VRINewCVC", for: indexPath) as! VRINewCVC
        cell.languageNameLbl.text = self.apiLanguageDataResponseModel?.languageData?[indexPath.row].languageName ?? ""
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
                    let noOfCellsInRow = 2
            let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
            flowLayout.minimumInteritemSpacing = 0
        flowLayout.minimumLineSpacing=0
            let totalSpace = flowLayout.sectionInset.left
            + flowLayout.sectionInset.right
            + (flowLayout.minimumInteritemSpacing * CGFloat(noOfCellsInRow - 1))
            let size = Int((collectionView.bounds.width - totalSpace) / CGFloat(noOfCellsInRow))
            //print("😙",size)
            //colloectionview height 160
            return CGSize(width: size, height: 45)
    }
}

extension VRINewViewController{
    
    func hitApiGetLanguageList(){
        SwiftLoader.show(animated: true)
        /*  let headers: HTTPHeaders = [
         "Authorization": "Bearer \(UserDefaults.standard.value(forKey:"token") ?? "")",
         "cache-control": "no-cache"
         ]
         // print("😗---hitApiSignUpUser -" , Api.profile.url) 10/01/2021 */
        var userID = userDefaults.value(forKey: UserDeafultsString.instance.UserID)
        let urlString = "https://lsp.totallanguage.com/Appointment/GetData?methodType=Companies%2CLanguageData&UserID=\(userID ?? "0")&UserType=6&AppTypefg=2"//\(date)"
        print("url to get schedule \(urlString)")
        AF.request(urlString, method: .get , parameters: nil, encoding: JSONEncoding.default, headers: nil)
            .validate()
            .responseData(completionHandler: { [self] (response) in
                SwiftLoader.hide()
                switch(response.result){
                    
                case .success(_):
                    print("Respose Success ")
                    guard let daata = response.data else { return }
                    do {
                        let jsonDecoder = JSONDecoder()
                  
                        self.apiLanguageDataResponseModel = try jsonDecoder.decode(ApiLanguageDataResponseModel.self, from: daata)
                        print("Success")
                        print("apiLanguageDataResponseModel DATA IS \(self.apiLanguageDataResponseModel)")
                       
                        
                        DispatchQueue.main.async {
                            self.languageCV.delegate=self
                            self.languageCV.dataSource=self
                            self.languageCV.reloadData()
                        }
                        
                        
                    } catch{
                        
                        print("error block forgot password " ,error)
                    }
                case .failure(_):
                    print("Respose Failure ")
                    
                }
            })
    }
    
}



class VRINewCVC:UICollectionViewCell{
    
    @IBOutlet weak var languageNameLbl: UILabel!
    
}
