//
//  UploadDocCVCell.swift
//  TotalVendor
//
//  Created by Darrin Brooks on 08/03/22.
//

import Foundation
import UIKit
class UploadDocumentsCVC:UICollectionViewCell{
    
    @IBOutlet weak var documentImgView:UIImageView!
    
    
    func configFileType(type:String,imageURL:String){
switch type {
        case "txt",".txt":
            documentImgView.image = UIImage(systemName: "doc.text.fill")
            documentImgView.tintColor = .black
        case "pdf",".pdf":
            documentImgView.image = UIImage(named:"pdfIcon")
        case "zip",".zip":
            documentImgView.image = UIImage(systemName:"doc.zipper")
            documentImgView.tintColor = .black
        case "rar",".rar":
            documentImgView.image = UIImage(systemName:"doc.zipper")
            documentImgView.tintColor = .black
        case "doc",".doc":
            documentImgView.image = UIImage(systemName:"doc.fill")
            documentImgView.tintColor = .black
        case "docx",".docx":
            documentImgView.image = UIImage(systemName:"doc.fill")
            documentImgView.tintColor = .black
        case "ppt",".ppt":
            documentImgView.image = UIImage(systemName:"doc.on.doc.fill")
            documentImgView.tintColor = .black
        case "pptx",".pptx":
            documentImgView.image = UIImage(systemName:"doc.on.doc.fill")
            documentImgView.tintColor = .black
        case "xls",".xls":
            documentImgView.image = UIImage(systemName:"xls")
            documentImgView.tintColor = .black
        case "xlsx",".xlsx":
            documentImgView.image = UIImage(systemName:"xls")
            documentImgView.tintColor = .black
        case "png",".png":
            documentImgView.sd_setImage(with: URL(string: imageURL), completed: nil)
        case "jpeg",".jpeg":
            documentImgView.sd_setImage(with: URL(string: imageURL), completed: nil)
        case "gif",".gif":
            documentImgView.sd_setImage(with: URL(string: imageURL), completed: nil)
        case "xml",".xml":
            documentImgView.image = UIImage(systemName:"safari.fill")
            documentImgView.tintColor = .black
        case "html",".html":
            documentImgView.image = UIImage(systemName:"safari.fill")
            documentImgView.tintColor = .black
        default:
            documentImgView.image = UIImage(systemName:"doc.circle.fill")
            documentImgView.tintColor = .black
        }
        
        
        
    }
    
    
    
}
