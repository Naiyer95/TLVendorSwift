//
//  DashBoardViewController.swift
//  TotalVendor
//
//  Created by Darrin Brooks on 18/08/21.
//

import UIKit

class VideoCallViewController1: UIViewController,UITableViewDataSource,UITableViewDelegate {
    @IBOutlet weak var Tableview: UITableView!
        
    var CellDataArray = ["Chat","ChangeView","PinVideo","MeetingInfo"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
                Tableview.delegate = self
                        Tableview.dataSource = self
                        Tableview.separatorStyle = .singleLine
                
        

        // Do any additional setup after loading the view.
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           return 4
       }
       func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
           return 60
       }
       
       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           
           let cell = tableView.dequeueReusableCell(withIdentifier: "VideoCallcell", for: indexPath) as! VideoCallCell
           
           cell.backgroundColor = .systemGray
           cell.videoCellImageNameLabel.text = "\(CellDataArray[indexPath.row])"
           
           return cell
           
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
