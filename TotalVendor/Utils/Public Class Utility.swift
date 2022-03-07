//
//  Public Class Utility.swift
//  TotalVendor
//
//  Created by Shivansh SMIT on 22/02/22.
//

import Foundation
import UIKit

extension UIViewController{
    
    func openDialogBox(){
        var dialogMessage = UIAlertController(title: "Coming Soon", message: "This will get updated soon.", preferredStyle: .alert)
        // Present alert to user
        dialogMessage.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(dialogMessage, animated: true, completion: nil)
    }
}
