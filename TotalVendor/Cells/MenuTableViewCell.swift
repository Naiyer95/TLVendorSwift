//
//  MenuTableViewCell.swift
//  TotalVendor
//
//  Created by Darrin Brooks on 12/08/21.
//

import UIKit

class MenuTableViewCell: UITableViewCell {
    
    var nameLabel = UILabel()
    var CellImage = UIImageView()
    var ExpandImage = UIImageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        
        
        CellImage.frame = CGRect(x: 10, y: 5, width: 35, height: 35)
        CellImage.layer.cornerRadius = 10
        CellImage.layer.masksToBounds = true
        CellImage.layer.borderWidth = 1
        CellImage.layer.borderColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        CellImage.contentMode = .scaleAspectFill

        
        contentView.addSubview(CellImage)
        nameLabel.frame = CGRect(x: 60, y: 5, width: 200, height: 35)
        nameLabel.textColor = .white
        nameLabel.font = UIFont(name:"blod", size: 25)
        contentView.addSubview(nameLabel)
        
        ExpandImage.frame = CGRect(x:77, y: 5, width: 35, height: 35)
        ExpandImage.layer.cornerRadius = 10
        ExpandImage.layer.masksToBounds = true
        ExpandImage.contentMode = .scaleAspectFill
        contentView.addSubview(ExpandImage)
        
        
        
        
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @objc func callButtonClicked()  {
        print("Call Button Clicked")
    }
    
}

