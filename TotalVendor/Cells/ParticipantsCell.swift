//
//  ParticipantsCell.swift
//  TotalVendor
//
//  Created by Darrin Brooks on 12/08/21.
//

import UIKit

class ParticipantsCell: UITableViewCell {
    @IBOutlet weak var participantImage: UIImageView!
    @IBOutlet weak var participantsNameLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        participantImage.layer.cornerRadius = participantImage.frame.size.height/2
        participantImage.layer.masksToBounds = true
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
