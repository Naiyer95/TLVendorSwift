//
//  ServiceVerificationURLViewController.swift
//  TotalVendor
//
//  Created by SMIT 005 on 04/01/22.
//

import UIKit
import WebKit
import Alamofire
class ServiceVerificationURLViewController: UIViewController, WKNavigationDelegate {
    
    @IBOutlet weak var serviceFormDownloadOutlet: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    var serviceURL = ""
    var isFromRegular = true
    var fromUploadedDocuments=false
    var fileName = ""
    var isfromfcm = false
    
    @IBOutlet weak var serviceWebView: WKWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        serviceWebView.navigationDelegate = self
        if fromUploadedDocuments{
            self.titleLabel.text = "Document Viewer"
        }else {
            self.titleLabel.text = "Service Verification Form"
        }
        serviceFormDownloadOutlet.isHidden = true
       
        
        self.configUI()
        serviceWebView.allowsBackForwardNavigationGestures = true
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("DID FINISH DELEGATE")
        SwiftLoader.hide()
    }
    
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        SwiftLoader.show(animated: true)
          
        }

        func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
            SwiftLoader.hide()
           
            self.view.makeToast("Unable to load document")
        }

        func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
            print(#function)
        }
        func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
            print(#function)
        }
    
    func configUI(){
        
        DispatchQueue.main.async {
            
            let url = URL(string: self.serviceURL)!
            var urlReq = URLRequest(url: url)
            urlReq.cachePolicy = .returnCacheDataElseLoad
            self.serviceWebView.load(urlReq)
        }
      }
 
    
    @IBAction func actionBackbtn(_ sender: UIButton) {
        if isfromfcm {
            self.dismiss(animated: true)
        }
        else if isFromRegular{
            self.navigationController?.popViewController(animated: true)
        }
        else
        {
            self.dismiss(animated: true)
        }
    }
    
    
    @IBAction func actionDownload(_ sender: UIButton) {
//        downloadServiceVerificationForm()
//        downloadFileFromURL(urlString: self.serviceURL)
//
//        let url = URL(string: self.serviceURL)
//        self.DownlondFromUrl(fileName: self.fileName, downloadFileURL: self.serviceURL)
        self.openDialogBox()
//        let url = URL(string: self.serviceURL)
//        FileDownloader.loadFileAsync(url: url!,fileName: self.fileName) { (path, error) in
//            print("File downloaded to : \(path!)")
//        }
    }
    
    func downloadServiceVerificationForm()
    {

                    // then lets create your document folder url
                    let documentsDirectoryURL =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        
let downloadURL  = URL(string: serviceURL)
                    // lets create your destination file url
        let destinationUrl = documentsDirectoryURL.appendingPathComponent(downloadURL!.lastPathComponent)
                    print(destinationUrl)

                    // to check if it exists before downloading it
                    if FileManager.default.fileExists(atPath: destinationUrl.path) {
                       // print("The file already exists at path")
                        DispatchQueue.main.async {
                            let excelSheet = UIActivityViewController(activityItems: [destinationUrl as Any], applicationActivities: nil)
                            self.present(excelSheet,animated: true,completion: nil)
                        }
                        
                        // if the file doesn't exist
                    } else {

                        // you can use NSURLSession.sharedSession to download the data asynchronously
                        URLSession.shared.downloadTask(with: downloadURL!) { location, response, error in
                            guard let location = location, error == nil else { return }
                            do {
                                // after downloading your file you need to move it to your destination url
                                try FileManager.default.moveItem(at: location, to: destinationUrl)
                                //self.view.makeToast("File Saved.")
                                DispatchQueue.main.async {
                                    let excelSheet = UIActivityViewController(activityItems: [destinationUrl as Any], applicationActivities: nil)
                                    self.present(excelSheet,animated: true,completion: nil)
                                    print("File moved to documents folder")
                                }
                                
                            } catch {
                                print(error)
                            }
                        }.resume()
                    }
                }
}


extension ServiceVerificationURLViewController{
    
    func DownlondFromUrl(fileName:String,downloadFileURL:String){
       // Create destination URL
        let documentsUrl:URL =  (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first as URL?)!
    let destinationFileUrl = documentsUrl.appendingPathComponent(fileName)

    //Create URL to the source file you want to download
    let fileURL = URL(string: downloadFileURL)

    let sessionConfig = URLSessionConfiguration.default
    let session = URLSession(configuration: sessionConfig)

    let request = URLRequest(url:fileURL!)

    let task = session.downloadTask(with: request) { (tempLocalUrl, response, error) in
        if let tempLocalUrl = tempLocalUrl, error == nil {
            // Success
            if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                print("Successfully downloaded. Status code: \(statusCode)")
            }

            do {
                try FileManager.default.copyItem(at: tempLocalUrl, to: destinationFileUrl)
            } catch (let writeError) {
                print("Error creating a file \(destinationFileUrl) : \(writeError)")
            }

        } else {
            print("Error took place while downloading a file. Error description: %@", error?.localizedDescription);
        }
    }
    task.resume()
    }
}


extension ServiceVerificationURLViewController{
    
    func download(url: URL, toFile file: URL, completion: @escaping (Error?) -> Void) {
        // Download the remote URL to a file
        let task = URLSession.shared.downloadTask(with: url) {
            (tempURL, response, error) in
            // Early exit on error
            guard let tempURL = tempURL else {
                completion(error)
                return
            }

            do {
                // Remove any existing document at file
                if FileManager.default.fileExists(atPath: file.path) {
                    try FileManager.default.removeItem(at: file)
                }

                // Copy the tempURL to file
                try FileManager.default.copyItem(
                    at: tempURL,
                    to: file
                )

                completion(nil)
            }

            // Handle potential file system errors
            catch let fileError {
                completion(error)
            }
        }

        // Start the download
        task.resume()
    }
    
    
    
    func downloadFileFromURL(urlString:String){
        // file location to save download file
            let destination: DownloadRequest.Destination = { _, _ in
                var documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
           
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd-MM-yyyy h-mm-ss"
                // Convert Date to String
                dateFormatter.locale = Locale(identifier: "en_US_POSIX")
                let abc = dateFormatter.string(from: Date())
                documentsURL.appendPathComponent("\(self.fileName)")
                print("DOCUMENT DOWNLOAD URL IS \(documentsURL)")
                return (documentsURL, [.removePreviousFile])
            }
            
            // Alamofire to download file
            AF.download(urlString, to: destination).responseData { response in
               
                switch response.result {
                case .success:
                    // write something here
                    if response.fileURL != nil {
//                        showAlertMessage(titleStr: APPNAME, messageStr: "File Saved in Documents!")
                        self.view.makeToast("File Saved in Documents!")
                        print("File Saved in Documents!")
                        
                    }
                case .failure:
                    self.view.makeToast("Failed to save document")
                    print("FAILURE IS \(response.error.debugDescription)")
//                    showAlertMessage(titleStr: APPNAME, messageStr: response.result.error.debugDescription)
                }
            }
    }
    
}


