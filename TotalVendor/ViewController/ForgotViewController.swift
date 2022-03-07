//
//  ForgotViewController.swift
//  TotalVendor
//
//  Created by Darrin Brooks on 12/08/21.
//

import UIKit

class ForgotViewController: UIViewController {
    
    @IBOutlet var txtFieldEmail: UITextField!
    @IBOutlet var txtFieldUserName: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func backBtnTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func SendBtnAction(_ sender: Any) {
        
        guard let email = txtFieldEmail.text, !email.isEmpty else {
            //Show Alert
            return
        }
        
        guard let userNAme = txtFieldUserName.text, !userNAme.isEmpty else {
            return
        }
        //"nagaraju.iosdeveloper@gmail.com"/ "TestVendor218031"
        let parameters = ["Email":email, "UserName":userNAme]
        self.makeForgotPaswordCall(parameters: parameters)
    }
}
//MARK: Api Calling...
extension ForgotViewController {
    func makeForgotPaswordCall(parameters: [String: Any]) {
        SwiftLoader.show(animated: true)
        NetworkLayer.shared.postRequest(url:APIs.FORGOT_PASSWORD, parameters: parameters) { response in
            print("response ======> \(response)")
            print("FORGOT PASSWORD URL IS \(APIs.FORGOT_PASSWORD)and parameter is \(parameters)")
            var responseData = response as!NSArray
            var ResponseDic = responseData[0] as! NSDictionary
            if(ResponseDic["Status"] as! Int == 2){
                
                let alert = UIAlertController(title: "Wrong", message: ResponseDic["Message"] as! String, preferredStyle: UIAlertController.Style.alert)

                        // add an action (button)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                }))
                // show the alert
                SwiftLoader.hide()
                        self.present(alert, animated: true, completion: nil)
                
            }
            if(ResponseDic["Status"] as! Int == 1){
                // create the alert
                SwiftLoader.hide()
                let alert = UIAlertController(title: "Sending", message: ResponseDic["Message"] as! String, preferredStyle: UIAlertController.Style.alert)

                        // add an action (button)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                    let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController
                        vc!.modalPresentationStyle = .fullScreen
                    self.present(vc!, animated: true, completion: nil)
                  }))

                        // show the alert
                        self.present(alert, animated: true, completion: nil)
            }
        } failure: { error in
            print("error ======> \(error.localizedDescription)")
        }
    }
}
