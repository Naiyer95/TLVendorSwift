//
//  TableViewCell.swift
//  TotalVendor
//
//  Created by Darrin Brooks on 12/08/21.
//

import UIKit

class VideoCallCell: UITableViewCell {
    @IBOutlet weak var videoCellImage: UIImageView!
    @IBOutlet weak var videoCellImageNameLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
