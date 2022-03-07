//
//  OnsiteInterpretationViewController.swift
//  TotalVendor
//
//  Created by Darrin Brooks on 12/08/21.
//

import UIKit
import SideMenu
class OnsiteInterpretationViewController: UIViewController {
    var menu : SideMenuNavigationController!
    override func viewDidLoad() {
        super.viewDidLoad()
        menu = SideMenuNavigationController(rootViewController: SideMenuViewController())
        menu.leftSide = true
        menu.setNavigationBarHidden(true, animated: true)
        // Do any additional setup after loading the view.
    }
    @IBAction func SideMenuBtnAction(_ sender: Any) {
        present(menu, animated: true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
