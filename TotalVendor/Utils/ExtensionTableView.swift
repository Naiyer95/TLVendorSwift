//
//  ExtensionTableView.swift
//  TotalVendor
//
//  Created by Shivansh SMIT on 09/02/22.
//

import Foundation
import UIKit

extension UITableView {
    func scrollToBottomRow() {
        DispatchQueue.main.async {
            guard self.numberOfSections > 0 else { return }
            
            // Make an attempt to use the bottom-most section with at least one row
            var section = max(self.numberOfSections - 1, 0)
            var row = max(self.numberOfRows(inSection: section) - 1, 0)
            var indexPath = IndexPath(row: row, section: section)
            
            // Ensure the index path is valid, otherwise use the section above (sections can
            // contain 0 rows which leads to an invalid index path)
            while !self.indexPathIsValid(indexPath) {
                section = max(section - 1, 0)
                row = max(self.numberOfRows(inSection: section) - 1, 0)
                indexPath = IndexPath(row: row, section: section)
                
                // If we're down to the last section, attempt to use the first row
                if indexPath.section == 0 {
                    indexPath = IndexPath(row: 0, section: 0)
                    break
                }
            }
            
            // In the case that [0, 0] is valid (perhaps no data source?), ensure we don't encounter an
            // exception here
            guard self.indexPathIsValid(indexPath) else { return }
            
            self.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }
    
    func indexPathIsValid(_ indexPath: IndexPath) -> Bool {
        let section = indexPath.section
        let row = indexPath.row
        return section < self.numberOfSections && row < self.numberOfRows(inSection: section)
    }
    
//    func scrollToBottom(animated: Bool) {
//        let y = contentSize.height - frame.size.height
//        if y < 0 { return }
//        setContentOffset(CGPoint(x: 0, y: y), animated: animated)
//    }
    func setEmptyView(title: String, message: String) {
    let emptyView = UIView(frame: CGRect(x: self.center.x, y: self.center.y, width: self.bounds.size.width, height: self.bounds.size.height))
    let titleLabel = UILabel()
    let messageLabel = UILabel()
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    messageLabel.translatesAutoresizingMaskIntoConstraints = false
    titleLabel.textColor = UIColor.black//black
    titleLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 18)
    messageLabel.textColor = UIColor.lightGray
    messageLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 17)
    emptyView.addSubview(titleLabel)
    emptyView.addSubview(messageLabel)
    titleLabel.centerYAnchor.constraint(equalTo: emptyView.centerYAnchor).isActive = true
    titleLabel.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor).isActive = true
    messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20).isActive = true
    messageLabel.leftAnchor.constraint(equalTo: emptyView.leftAnchor, constant: 20).isActive = true
    messageLabel.rightAnchor.constraint(equalTo: emptyView.rightAnchor, constant: -20).isActive = true
    titleLabel.text = title
    messageLabel.text = message
    messageLabel.numberOfLines = 0
    messageLabel.textAlignment = .center
    // The only tricky part is here:
    self.backgroundView = emptyView
    self.separatorStyle = .none
    }
    func restore() {
    self.backgroundView = nil
    self.separatorStyle = .singleLine
    }
}
