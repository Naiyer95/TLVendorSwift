//
//  SignUpVC.swift
//  TotalVendor
//
//  Created by Darrin Brooks on 28/03/22.
//

import UIKit
import WebKit

class SignUpVC: UIViewController, WKNavigationDelegate {

    @IBOutlet weak var signUPWebview: WKWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
        // Do any additional setup after loading the view.
    }
    func configUI(){
        
        DispatchQueue.main.async {
            
            let url = URL(string: signUPUrl)!
            var urlReq = URLRequest(url: url)
            urlReq.cachePolicy = .returnCacheDataElseLoad
            self.signUPWebview.load(urlReq)
        }
      }

    @IBAction func btnbackTapped(_ sender: Any) {
        dismiss(animated: true)
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("DID FINISH DELEGATE")
        SwiftLoader.hide()
    }
    
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        SwiftLoader.show(animated: true)
            print("didStartProvisionalNavigation")
        }

        func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
            SwiftLoader.hide()
            print("ERROR IN LOADING WEB VIEW IS \(error.localizedDescription)")
            self.view.makeToast("Unable to load document")
        }

        func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
            print(#function)
        }
        func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
            print(#function)
        }
    
  

}
