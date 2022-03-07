//
//  ChatScreenViewController.swift
//  TotalVendor
//
//  Created by Shivansh SMIT on 28/01/22.
//

import UIKit

class ReceivedMessageTVC:UITableViewCell{
    
}


class ReceivedMessageImageTVC:UITableViewCell{
    
}

class ReceivedMessageOtherAttatchmentTVC:UITableViewCell{
    
}


class SenderMessageTVC:UITableViewCell{
    
}


class SenderMessageImageTVC:UITableViewCell{
    
}

class SenderMessageOtherAttatchmentTVC:UITableViewCell{
    
}

class ChatScreenViewController: UIViewController {
    @IBOutlet weak var chatMessagesTV: UITableView!
    
    var cellTypeArray = ["sText","sImage","sAttachment","rText","rImage","rAttachment","sText","sImage","sAttachment","rText","rImage","rAttachment","sText","sImage","sAttachment","rText","rImage","rAttachment","sText","sImage","sAttachment","rText","rImage","rAttachment","sText","sImage","sAttachment","rText","rImage","rAttachment"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
        chatMessagesTV.delegate=self
        chatMessagesTV.dataSource=self
        
    }

}
extension ChatScreenViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 25
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = chatMessagesTV.dequeueReusableCell(withIdentifier: "ReceivedMessageTVC", for: indexPath) as! ReceivedMessageTVC
//        ReceivedMessageImageTVC
        let cell1 = chatMessagesTV.dequeueReusableCell(withIdentifier: "ReceivedMessageImageTVC", for: indexPath) as! ReceivedMessageImageTVC
        let cell2 = chatMessagesTV.dequeueReusableCell(withIdentifier: "ReceivedMessageOtherAttatchmentTVC", for: indexPath) as! ReceivedMessageOtherAttatchmentTVC
        let cell4 = chatMessagesTV.dequeueReusableCell(withIdentifier: "SenderMessageTVC", for: indexPath) as! SenderMessageTVC
//        ReceivedMessageImageTVC
        let cell5 = chatMessagesTV.dequeueReusableCell(withIdentifier: "SenderMessageImageTVC", for: indexPath) as! SenderMessageImageTVC
        let cell6 = chatMessagesTV.dequeueReusableCell(withIdentifier: "SenderMessageOtherAttatchmentTVC", for: indexPath) as! SenderMessageOtherAttatchmentTVC
//        "sText","sImage","sAttachment","rText","rImage","rAttachment"
        
        switch cellTypeArray[indexPath.row] {
        case "sText":
            return cell
        case "sImage":
            return cell1
        case "sAttachment":
            return cell2
        case "rText":
            return cell4
        case "rImage":
            return cell5
        case "rAttachment":
            return cell6
        default:
            return UITableViewCell()
        }
    }
    
    
}
