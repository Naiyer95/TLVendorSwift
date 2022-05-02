//
//  VendorQRCodeScannerVC.swift
//  TotalVendor
//
//  Created by Darrin Brooks on 21/04/22.
//

import UIKit
import AVFoundation
import MercariQRScanner

class VendorQRCodeScannerVC: UIViewController {

    @IBOutlet weak var qrScannerView: QRScannerView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupQRScanner()
//                let qrScannerView = QRScannerView(frame: view.bounds)
//
//                       // Customize focusImage, focusImagePadding, animationDuration
//                       qrScannerView.focusImage = UIImage(named: "flashlight.off.fill")
//                       qrScannerView.focusImagePadding = 8.0
//                       qrScannerView.animationDuration = 0.5
//
//                       qrScannerView.configure(delegate: self)
//                       view.addSubview(qrScannerView)
//                       qrScannerView.startRunning()
    }
    
    @IBAction func btnCancelTapped(_ sender: Any) {
        navigationController?.popToViewController(ofClass: CalendarViewController.self)
    }
    private func setupQRScanner() {
            switch AVCaptureDevice.authorizationStatus(for: .video) {
            case .authorized:
                setupQRScannerView()
            case .notDetermined:
                AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                    if granted {
                        DispatchQueue.main.async { [weak self] in
                            self?.setupQRScannerView()
                        }
                    }
                }
            default:
                showAlert()
            }
        }

    @IBAction func btnFlashLightTapped(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        qrScannerView.setTorchActive(isOn: sender.isSelected)
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        qrScannerView.stopRunning()
    }
    private func setupQRScannerView() {
        qrScannerView.configure(delegate: self, input: .init(isBlurEffectEnabled: true))
        qrScannerView.startRunning()
    }

        private func showAlert() {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
                let alert = UIAlertController(title: "Error", message: "Camera is required to use in this application", preferredStyle: .alert)
                alert.addAction(.init(title: "OK", style: .default))
                self?.present(alert, animated: true)
            }
        }
    func AlerMethod(msz: String, err: Bool){
        let alrt = UIAlertController(title: "Appoinment", message: msz, preferredStyle: .alert)
        alrt.addAction(UIAlertAction(title: "Okay", style: .default, handler: { alert in
            if err == false {
                self.navigationController?.popToViewController(ofClass: CalendarViewController.self)
            }
            else {
                self.setupQRScanner()
            }
            
        }))
        present(alrt, animated: true)
    }
    }



    extension VendorQRCodeScannerVC: QRScannerViewDelegate {
        func qrScannerView(_ qrScannerView: QRScannerView, didFailure error: QRScannerError) {
            print("err:------", error)
            AlerMethod(msz: "Checked-in failed please try again", err: true)
            self.dismiss(animated: true)
        }

        func qrScannerView(_ qrScannerView: QRScannerView, didSuccess code: String) {
            AlerMethod(msz: "Checked-in successfully", err: false)
            print("code:----------->",code)
            
           
          
        }
    }
extension UINavigationController {
  func popToViewController(ofClass: AnyClass, animated: Bool = true) {
    if let vc = viewControllers.last(where: { $0.isKind(of: ofClass) }) {
      popToViewController(vc, animated: animated)
    }
  }
}
