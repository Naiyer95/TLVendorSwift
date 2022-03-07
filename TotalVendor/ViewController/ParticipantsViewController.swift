//
//  ParticipantsViewController.swift
//  TotalVendor
//
//  Created by Darrin Brooks on 12/08/21.
//

import UIKit

class ParticipantsViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    @IBOutlet weak var Tableview: UITableView!
    @IBOutlet weak var participantsLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        Tableview.delegate = self
        Tableview.dataSource = self
        Tableview.separatorStyle = .none
        Tableview.backgroundColor = .clear
        view.backgroundColor = .clear

        // Do any additional setup after loading the view.
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ParticipantsCell", for: indexPath) as! ParticipantsCell
        cell.backgroundColor = .gray
        
        
        
        return cell
        
    }
    
    @IBAction func CloseBtnAction(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
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
