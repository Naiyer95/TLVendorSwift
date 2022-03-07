////
////  NibView.swift
////  TotalVendor
////
////  Created by Shivansh SMIT on 10/11/21.
////
//
//import Foundation
//class NibView: UIView {
//    override init(frame: CGRect) {
//     super.init(frame: frame)
//     setup()
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//      super.init(coder: aDecoder)
//      setup()
//    }
//    
//    func loadView() -> UIView {
//        return loadViewFromNib()
//    }
//    
//    func setup() {
//        let contentView = loadView()
//        contentView.frame = bounds
//        
//        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//        
//        addSubview(contentView)
//    }
//    
//    func loadViewFromNib() -> UIView! {
//      let bundle = Bundle(for: type(of: self))
//      let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
//      let view = nib.instantiate(withOwner: self, options: nil).first as? UIView
//      
//      return view
//    }
//}
