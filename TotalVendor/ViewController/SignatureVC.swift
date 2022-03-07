//
//  SignatureVC.swift
//  TotalVendor
//
//  Created by Shivansh SMIT on 27/02/22.
//

import UIKit
import AASignatureView
import Screenshots

class SignatureVC: UIViewController {

    @IBOutlet weak var doneBtnOutlet: UIButton!
    
    @IBOutlet weak var signatureImgView: AASignatureView!
    @IBOutlet weak var signatureMainView: UIView!
    var selectedImage = UIImage()
    
    @IBOutlet weak var screenshotView: UIView!
    @IBOutlet weak var finalSignImage: UIImageView!
    var delegate:BringSelectedImage?
    @IBOutlet weak var selectedImg: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.doneBtnOutlet.isHidden = true
        self.signatureMainView.isHidden=false
        self.signatureImgView.isHidden=false
        self.selectedImg.image = selectedImage
        
    }

    
    @IBAction func backBtnTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func resetBtnTapped(_ sender: Any) {
        signatureImgView.clear()
        
    }
    @IBAction func saveBtnTapped(_ sender: Any) {
        if let image = signatureImgView.signature {
        // captured image of signature view
            finalSignImage.image = image
            self.doneBtnOutlet.isHidden=false
            self.finalSignImage.isHidden = false
            self.selectedImg.isHidden = false
            self.signatureMainView.isHidden = true
            
        }

    }
    
    @IBAction func doneBtnTapped(_ sender: Any) {
        
       // let abc = self.selectedImage.mergeWith(topImage: self.finalSignImage.image!)
       // let abc = mergeTwoImage(leftImg: selectedImage, rightImg: finalSignImage.image!)
        let abc = screenshotView.screenshot



        
        self.selectedImg.image = abc
        
        self.delegate?.selectImage(selectedImage: abc!)
       self.dismiss(animated: true)
        
    }
    func mergeTwoImage(leftImg:UIImage,rightImg:UIImage) -> UIImage?{
            
            let size = CGSize(width: leftImg.size.width, height: leftImg.size.height)
            UIGraphicsBeginImageContext(size)
            
            let area1 = CGRect(x: 0, y: 0, width: size.width, height: size.height)
            let area2 = CGRect(x: 0, y: size.height - 50, width: 60, height: 50)
            
            
            leftImg.draw(in: area1)
            rightImg.draw(in: area2, blendMode: .normal, alpha: 1)
            
            let finalImage = UIGraphicsGetImageFromCurrentImageContext()
            
            UIGraphicsEndImageContext()
            return finalImage
        }
}


extension UIImage {
    func mergeWith(topImage: UIImage, bottom:UIImage) -> UIImage {
    let bottomImage = self

    UIGraphicsBeginImageContext(size)
    let areaSize = CGRect(x: 0, y: 0, width: 80, height: 50)
    bottomImage.draw(in: areaSize)

    topImage.draw(in: areaSize, blendMode: .normal, alpha: 1.0)

    let mergedImage = UIGraphicsGetImageFromCurrentImageContext()!
    UIGraphicsEndImageContext()
    return mergedImage
  }
}

