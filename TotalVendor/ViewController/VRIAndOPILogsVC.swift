//
//  VRIAndOPILogsVC.swift
//  TotalVendor
//
//  Created by Shivansh SMIT on 10/12/21.
//

import UIKit

class VRIAndOPILogsVC: UIViewController {

    @IBOutlet weak var sourceLanguageTF: UITextField!
    @IBOutlet weak var targetLangugageTF: UITextField!
    @IBOutlet weak var startDateTF:UITextField!
    @IBOutlet weak var endDateTF:UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.createRightViewImageTF(tfName: startDateTF, imageName: "calendar")
        self.createRightViewImageTF(tfName: endDateTF, imageName: "calendar")
        self.createRightViewImageTF(tfName: sourceLanguageTF, imageName: "arrowtriangle.down.fill")
        self.createRightViewImageTF(tfName: targetLangugageTF, imageName: "arrowtriangle.down.fill")
    }
    
    
    
    
    func createRightViewImageTF(tfName:UITextField!,imageName:String){
            let arrow = UIImageView(image: UIImage(systemName: imageName    ))
            if let size = arrow.image?.size {
                arrow.frame = CGRect(x: 0.0, y: 0.0, width: size.width + 10.0, height: size.height)
            }
            arrow.contentMode = UIView.ContentMode.scaleAspectFit
            tfName.rightView = arrow
            tfName.rightViewMode = UITextField.ViewMode.always
    }


}



