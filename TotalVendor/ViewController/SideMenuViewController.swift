//
//  SideMenuViewController.swift
//  TotalVendor
//
//  Created by Darrin Brooks on 12/08/21.
//

import UIKit
import Alamofire

class SideMenuViewController: UIViewController,UITableViewDelegate,UITableViewDataSource{
    
    
    var image  = UIImageView()
    var nameLabel = UILabel()
    var versionLabel = UILabel()
    var MenuTabelView = UITableView()
     
    private let imgOpen = UIImage(named: "DashBoard")
    private let imgClose = UIImage(named: "DashBoard")
    private var dataSource = [Item]()

    override func viewDidLoad() {
        super.viewDidLoad()
        MenuTabelView.register(MenuTableViewCell.self, forCellReuseIdentifier: "cell")
        self.MenuTabelView.dataSource = self
        self.MenuTabelView.delegate = self
        self.dataSource.append(Item("DashBoard"))
        self.dataSource.append(Item("Controls", items: ["Vendor Details", "Vendor Time off","Vendor Time Finshed","Earnings"]))
        self.dataSource.append(Item("VRI & OPI Logs"))
        self.dataSource.append(Item("Interpreter Call History"))
        self.dataSource.append(Item("Support"))
        self.dataSource.append(Item("LogOut"))
        self.MenuTabelView.reloadData()
        

        view.backgroundColor = #colorLiteral(red: 0.1019607857, green: 0.2784313858, blue: 0.400000006, alpha: 1)
       
        image.frame = CGRect(x: 5, y: 50, width: 85, height: 85)
        image.layer.cornerRadius = 20
        image.layer.masksToBounds = true
        image.layer.borderWidth = 2
        image.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        image.image = UIImage(named: "vriprofile")
        view.addSubview(image)
        nameLabel.frame = CGRect(x: 95, y: 55, width: 150, height: 30)
        nameLabel.textColor = .white
        nameLabel.text = "CustomerName"
        //nameLabel.backgroundColor = #ecolorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        view.addSubview(nameLabel)
        versionLabel.frame = CGRect(x: 95, y: 85, width: 150, height: 30)
        versionLabel.textColor = .white
        versionLabel.text = "10.45.1"
        //versionLabel.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        view.addSubview(versionLabel)
        MenuTabelView.frame  = CGRect(x: 0, y: 150, width: Int(self.view.frame.width), height: Int(self.view.frame.height)-150)
        MenuTabelView.separatorStyle = .singleLine
        MenuTabelView.backgroundColor = #colorLiteral(red: 0.1019607857, green: 0.2784313858, blue: 0.400000006, alpha: 1)

        view.addSubview(MenuTabelView)
       

        // Do any additional setup after loading the view.
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.dataSource.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let item = self.dataSource[section]
        if item.isExpanded, let count = item.subItems?.count {
            return count + 1
        }

        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let item = self.dataSource[indexPath.section]
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MenuTableViewCell
            var imageView: UIImageView?
            if indexPath.row > 0, let text = item.subItems?[indexPath.row - 1] {
                cell.nameLabel.text = text
                cell.CellImage.image = UIImage(named: "Xlsheet")
                cell.backgroundColor = #colorLiteral(red: 0, green: 0.2802452445, blue: 0.5438946486, alpha: 1)
            } else {
                cell.nameLabel.text = item.text
                cell.CellImage.image = UIImage(named: "Xlsheet")
                if item.subItems != nil {
                    cell.ExpandImage = UIImageView(image: UIImage(named: "\(imgClose)"))
                    
                }
                cell.backgroundColor = #colorLiteral(red: 0.1019607857, green: 0.2784313858, blue: 0.400000006, alpha: 1)
            }
        
        

            return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let item = self.dataSource[indexPath.section]
        if indexPath.row == 0 && item.subItems != nil {
         
            self.dataSource[indexPath.section].isExpanded = !item.isExpanded
            let indexSet = IndexSet(integer: indexPath.section)
            tableView.reloadSections(indexSet, with: .automatic)
            
        } else {
            
            if(item.text == "DashBoard" ){
                
                print("DashBoard")
            }else
            if(item.text == "VRI & OPI Logs" ){
//                let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "VRInOPILogsViewController") as? VRI_OPILogsViewController
//                self.navigationController?.pushViewController(vc!, animated: true)
                
                
                print("VRI & OPI Logs")
            }else
            if(item.text == "Support" ){
                
//                let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "SupportViewController") as? SupportViewController
//                self.navigationController?.pushViewController(vc!, animated: true)
                
               
                print("Support")
            } else
            if(item.text == "Interpreter Call History" ){
                
//                let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "VendorCallHistoryViewController") as? VendorCallHistoryViewController
//                self.navigationController?.pushViewController(vc!, animated: true)
                print("Interpreter Call History")
            }
            else
            if(item.text == "LogOut" ){
                SwiftLoader.show(animated: true)
                UserDefaults.standard.setValue(false, forKey: "isLoggedIn")
                print("LogOut")
//                let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController
//                vc!.modalPresentationStyle = .fullScreen
//                present(vc!, animated: true, completion: nil)
//                self.navigationController?.pushViewController(vc!, animated: true)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { // Change
                    SwiftLoader.hide()
                    let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
                                             let storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                                             let navigationController:UINavigationController = storyboard.instantiateInitialViewController() as! UINavigationController
                                             let rootViewController:UIViewController = storyboard.instantiateViewController(withIdentifier:"InitialViewController") as! InitialViewController
                                             navigationController.viewControllers = [rootViewController]
                                             appDelegate.window!.rootViewController = navigationController
                                             appDelegate.window!.makeKeyAndVisible()
                   // Code you want to be delayed
                }
              
                
                
            }
            else
            if(item.text == "Controls" ){
                if(indexPath.row == 1){
                    print("Vendor Details")
//                    let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "VendorDetailsOneViewController") as? VendorDetailsViewController
//                    self.navigationController?.pushViewController(vc!, animated: true)
                }else if(indexPath.row == 2){
//                    let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "VendorTimeOffViewController") as? VendorTimeOffViewController
//                    self.navigationController?.pushViewController(vc!, animated: true)
                print("Vendor Time off")
            }else if(indexPath.row == 3){
                
//                let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "VendorTimeFinishedViewController") as? VendorTimeFinishedViewController
//                self.navigationController?.pushViewController(vc!, animated: true)
                print("Vendor Time Finshed")
        
            }else{
//                let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "PaymentMainViewController") as? PaymentsViewController
//                self.navigationController?.pushViewController(vc!, animated: true)
                print("Earnings")
            }
            // non-expandable menu item tapped
        }
        }}
}


struct Item {
    let text: String
    var subItems: [String]?
    var isExpanded = false
    init(_ text: String, items: [String]? = nil) {
        self.text = text
        self.subItems = items
    }
}

/*
extension SideMenuViewController{
    func hitChaangePasswordApi(){
           let url =  URL(string:"\(APIs.logoutApi)")
           print("hitChaangePasswordApi----------\(APIs.logoutApi)")
           
   //        let headers:HTTPHeaders = [
   //            "Authorization": "Bearer \(token!)",
   //            "cache-control": "no-cache",
   //        ]
        let userID = UserDefaults.standard.value(forKey: UserDeafultsString.instance.UserID)
        let userGUID = UserDefaults.standard.value(forKey: UserDeafultsString.instance.userGUID)
           let parameters = [
               "UserID": userID,
               "UserGuID":userGUID ?? ""
           ] as [String : Any]
          
           AF.request(url as! URLConvertible, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil)
               .validate()
               .responseData { (respData) in
                   switch (respData.result){
                   case .success(_):
                       guard let data = respData.data else {return}
                       print("Success hitChaangePasswordApi-------\(data)")
                       do{
                           let decoder = JSONDecoder()
                           self.apiChangePasswordResponseModel = try decoder.decode(ApiChangePasswordResponseModel.self, from: data)
                           print("apiPasswordChangeResponseModel-----Status----", self.apiChangePasswordResponseModel?.status ?? false)
                           guard let status:Bool = self.apiChangePasswordResponseModel?.status else{ return }
                           guard let apiMessage = self.apiChangePasswordResponseModel?.message else { return}
                           
                           if status == true{
                           //    self.view.makeToast(apiMessage,duration: 2.0, position: .center)
                               SwiftLoader.hide()
                               self.navigationController?.popToRootViewController(animated: true)
   //                     let vc = self.storyboard?.instantiateViewController(identifier: "SignInViewController") as! SignInViewController
   //                            vc.modalPresentationStyle = .fullScreen
   //                            self.present(vc, animated: true, completion: nil)

                               print("----- hitVerifyOtpApi SUCCESSFUL----- ")
                           }
                           else {
                               self.view.makeToast(apiMessage,duration: 2.0, position: .center)
                           }
                       } catch let error {
                           SwiftLoader.hide()
                           print(error)
                           
   //                            self.view.makeToast(apiMessage)
                       //    self.showAlertWithMsgNCancelBtn(withTitle: "Alert!", withMessage:"Error:Please try again later")
                       }
                       
                   case .failure(_):
                       SwiftLoader.hide()
   //                        self.view.makeToast(apiMessage)
         //              self.showAlertWithMsgNCancelBtn(withTitle: "Alert!", withMessage:"Error:Please try again later")
                       break
                   }
               }
       }
}
*/
