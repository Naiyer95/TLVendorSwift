//
//  InitialViewController.swift
//  TotalVendor
//
//  Created by Darrin Brooks on 12/08/21.
//

import UIKit

class InitialViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func SignInBtnAction(_ sender: Any) {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController
                        vc!.modalPresentationStyle = .fullScreen
        self.present(vc!, animated: true, completion: nil)
       
    }
    @IBAction func SignUpBtnAction(_ sender: Any) {
        guard let url = URL(string: signUPUrl) else { return }
        UIApplication.shared.open(url)
//        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SignUpVC") as! SignUpVC
//        vc.modalPresentationStyle = .fullScreen
//self.present(vc, animated: true, completion: nil)
    }


}
