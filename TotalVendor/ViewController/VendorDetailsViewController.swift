//
//  VendorDetailViewController.swift
//  TotalVendor
//
//  Created by SMIT 005 on 14/12/21.
//

import UIKit
import Alamofire
//import SteppableSlider
import iOSDropDown
class VendorDetailViewController: UIViewController {
    @IBOutlet weak var birthCountryTF: DropDown!
    @IBOutlet weak var profileImgView: UIImageView!
    
    @IBOutlet weak var firstNameTF: UITextField!
    @IBOutlet weak var lastNameTF: UITextField!
    @IBOutlet weak var middleNameTF: UITextField!
    
    @IBOutlet weak var dateOfBirthTF: UITextField!
    @IBOutlet weak var mailingZipCodeTF: UITextField!
    @IBOutlet weak var stateTF: UITextField!
    @IBOutlet weak var MailingCityTf: UITextField!
    @IBOutlet weak var mailingStreetAddressTF: UITextField!
    @IBOutlet weak var mailingAptTF: UITextField!
    @IBOutlet weak var zipCodeTF: UITextField!
    
    @IBOutlet weak var mailingStateTF: UITextField!
    @IBOutlet weak var cityTF: UITextField!
    @IBOutlet weak var ApartmentTF: UITextField!
    @IBOutlet weak var onsiteHourTF: UITextField!
    @IBOutlet weak var streetAddressTF: UITextField!
    @IBOutlet weak var phoneNumberTF: UITextField!
    @IBOutlet weak var typeTF: UITextField!
    @IBOutlet weak var workPhoneTF: UITextField!
    @IBOutlet weak var mainPhoneTF: UITextField!
    @IBOutlet weak var badgeNumberTF: UITextField!
    @IBOutlet weak var nickNameTF: UITextField!
    @IBOutlet weak var vendorNameTF: UITextField!
    @IBOutlet weak var fullNameTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var zipCodeView: UIView!
    @IBOutlet weak var stateView: UIView!
    @IBOutlet weak var cityOuterView: UIView!
    @IBOutlet weak var aptView: UIView!
    @IBOutlet weak var vendorDetailTV: UITableView!
    @IBOutlet weak var onsiteHourView: UIView!
    @IBOutlet weak var streetAddress: UIView!
    @IBOutlet weak var phoneNumberView: UIView!
    @IBOutlet weak var typeCellView: UIView!
    @IBOutlet weak var workPhoneView: UIView!
    @IBOutlet weak var mainPhoneView: UIView!
    @IBOutlet weak var badgeNumberView: UIView!
    @IBOutlet weak var vendorNameView: UIView!
    @IBOutlet weak var genderTF: DropDown!
    @IBOutlet weak var nickNameView: UIView!
    @IBOutlet weak var socialSecurityNumberTF: UITextField!
    @IBOutlet weak var stepIndicatorView: StepIndicatorView!
    @IBOutlet weak var companyLogo: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var fullNameouterView: UIView!
    @IBOutlet weak var emailOuterView: UIView!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var mailingStressView: UIView!
    @IBOutlet weak var mailingAptView: UIView!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var mailingZipCodeView: UIView!
    @IBOutlet weak var stateBillingView: UIView!
    @IBOutlet weak var mailingCityView: UIView!
    @IBOutlet weak var genderMainView: UIView!
    @IBOutlet weak var birthCountryView: UIView!
    @IBOutlet weak var dateOfBirthView: UIView!
    @IBOutlet weak var titlePageView: UILabel!
    @IBOutlet weak var socialSecurityNumberView: UIView!
    @IBOutlet weak var additionalInfoMainView: UIView!
    @IBOutlet weak var languageMainView: UIView!
    @IBOutlet weak var profileImageView: UIView!
    @IBOutlet weak var specialityMainView: UIView!
    @IBOutlet weak var emailNotificationMainView: UIView!
    var Live_BASE_URL = "https://lsp.totallanguage.com/"
    
    @IBOutlet weak var vendorNameLbl: UILabel!
    var stepValue = 0
    var apiVendorDetailResponseModel:ApiVendorDetailResponseModel?
    override func viewDidLoad() {
        super.viewDidLoad()
        let imageDataa = (userDefaults.value(forKey: UserDeafultsString.instance.CompanyLogo) ?? "")
        let finalDataa = "\(Live_BASE_URL)\(imageDataa)"
        print("FINAL DATA IS \(finalDataa)")
        if imageDataa as! String != "" {
            self.companyLogo.sd_setImage(with: URL(string: finalDataa), completed: nil)
        }else {
            self.companyLogo.image = UIImage(named: "logo")         
        }

        userNameLabel.text = UserDefaults.standard.value(forKey: UserDeafultsString.instance.CompanyName) as? String ?? ""
        
        
        print("IMAGE DATA IS \(userDefaults.value(forKey: UserDeafultsString.instance.USER_IMAGEDATA) ?? "")")
        let imageData = (userDefaults.value(forKey: UserDeafultsString.instance.USER_IMAGEDATA) ?? "")
        let finalData = "\(Live_BASE_URL)\(imageData)"
        print("FINAL DATA IS \(finalData)")
        if imageData as! String != "" {
            self.profileImgView.sd_setImage(with: URL(string: finalData), completed: nil)
        }else {
            self.profileImgView.image = UIImage(systemName: "person.fill")
            self.profileImgView.tintColor  = .white
  
        }
        
        
        
        self.vendorDetailTV.isHidden = false
        self.languageMainView.isHidden = true
        self.additionalInfoMainView.isHidden = true
        self.specialityMainView.isHidden = true
        self.emailNotificationMainView.isHidden = true
        
        // Do any additional setup after loading the view.
        
        updateUI()
        updateBottomView()
        apiGetVendorDetail()
    }
    
    @IBAction func actionDashboard(_ sender: UIButton) {
        
    }
    @IBAction func actionBack(_ sender: UIButton) {
        if self.stepValue == 0 {
            
        }else {
            self.stepValue = self.stepValue - 1
        }
        stepIndicatorView.currentStep = stepValue
        updateBottomView()
    }
    @IBAction func actionBackBtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func selectDateOFBirthAction(_ sender: Any) {
    }
    @IBAction func actionSave(_ sender: UIButton) {
        
    }
    @IBAction func actionNext(_ sender: UIButton) {
        if self.stepValue < 5 {
            self.stepValue = self.stepValue + 1
        }else {
            
        }
        
        stepIndicatorView.currentStep = stepValue
        updateBottomView()
    }
    func apiGetVendorDetail(){
        SwiftLoader.show(animated: true)
        self.apiVendorDetailResponseModel = nil
        let userId = UserDefaults.standard.value(forKey: UserDeafultsString.instance.UserID) ?? "0"
        let companyID = UserDefaults.standard.value(forKey: UserDeafultsString.instance.CompanyID) ?? "0"
      
        let urlString = "https://lsp.totallanguage.com/VendorManagement/Vendor/GetFormData?methodType=VendorDetails&CompanyID=\(userId)&aprFlag=2&recNumber=0"
        print("url to get apiGetVendorDetail  \(urlString)")
                AF.request(urlString, method: .get , parameters: nil, encoding: JSONEncoding.default, headers: nil)
                    .validate()
                    .responseData(completionHandler: { [self] (response) in
                        SwiftLoader.hide()
                        switch(response.result){
                        
                        case .success(_):
                            print("Respose Success apiGetVendorDetail Data ")
                            guard let daata = response.data else { return }
                            do {
                                let jsonDecoder = JSONDecoder()
                                self.apiVendorDetailResponseModel = try jsonDecoder.decode(ApiVendorDetailResponseModel.self, from: daata)
                               print("Success apiGetVendorDetail Model \(self.apiVendorDetailResponseModel)")
                                
                                updateDetailInfoView()
                                
                            } catch{
                                
                                print("error block apiGetVendorDetail Data  " ,error)
                            }
                        case .failure(_):
                            print("Respose Failure apiGetVendorDetail")
                           
                        }
                })
     }
    func updateDetailInfoView(){
        let vendorData = self.apiVendorDetailResponseModel?.vendorDetail?.first
        let vendorAddressData = self.apiVendorDetailResponseModel?.address?.first
        self.emailTF.text = vendorData?.email ?? ""
        self.firstNameTF.text = vendorData?.contactFirstName ?? ""
        self.middleNameTF.text = vendorData?.middleName ?? ""
        self.lastNameTF.text = vendorData?.contactLastName ?? ""
        self.nickNameTF.text = vendorData?.nickName ?? ""
        self.vendorNameTF.text = vendorData?.vendorFullName ?? ""
        self.vendorNameLbl.text = vendorData?.vendorFullName ?? ""
        self.badgeNumberTF.text = vendorData?.badgeNumber ?? ""
        self.mainPhoneTF.text = vendorData?.mainPhone ?? ""
        self.workPhoneTF.text = vendorData?.workPhone ?? ""
        self.phoneNumberTF.text = vendorData?.phone ?? ""
        self.streetAddressTF.text = vendorAddressData?.streetAddress ?? ""
        self.ApartmentTF.text = vendorAddressData?.aptNumber ?? ""
        self.cityTF.text = vendorAddressData?.city ?? ""
        self.zipCodeTF.text = vendorAddressData?.zipCode ?? ""
        self.mailingStreetAddressTF.text = vendorAddressData?.mailingStreetAddress ?? ""
        self.mailingAptTF.text = vendorAddressData?.mailingAptNumber ?? ""
        self.MailingCityTf.text = vendorAddressData?.mailingCity ?? ""
        self.mailingZipCodeTF.text = vendorAddressData?.mailingZipCode ?? ""
    }
    func updateBottomView(){
        print("step Value",stepValue)
        
        switch (stepValue) {
        case 0:
            self.vendorDetailTV.isHidden = false
            self.languageMainView.isHidden = true
            self.additionalInfoMainView.isHidden = true
            self.specialityMainView.isHidden = true
            self.emailNotificationMainView.isHidden = true
            self.titlePageView.text = "DETAILS"
            self.backBtn.visibility = .gone
            self.nextBtn.visibility = .visible
            break
        case 1:
            self.vendorDetailTV.isHidden = true
            self.languageMainView.isHidden = true
            self.additionalInfoMainView.isHidden = false
            self.specialityMainView.isHidden = true
            self.emailNotificationMainView.isHidden = true
            self.titlePageView.text = "ADDITIONAL INFO"
            self.backBtn.visibility = .visible
            self.nextBtn.visibility = .visible
            break
        case 2:
            self.vendorDetailTV.isHidden = true
            self.languageMainView.isHidden = true
            self.additionalInfoMainView.isHidden = true
            self.specialityMainView.isHidden = false
            self.emailNotificationMainView.isHidden = true
            self.titlePageView.text = "SPECIALITY"
            self.backBtn.visibility = .visible
            self.nextBtn.visibility = .visible
            break
        case 3:
            self.vendorDetailTV.isHidden = true
            self.languageMainView.isHidden = false
            self.additionalInfoMainView.isHidden = true
            self.specialityMainView.isHidden = true
            self.emailNotificationMainView.isHidden = true
            self.titlePageView.text = "LANGUAGE"
            self.backBtn.visibility = .visible
            self.nextBtn.visibility = .visible
            break
        case 4:
            self.vendorDetailTV.isHidden = true
            self.languageMainView.isHidden = true
            self.additionalInfoMainView.isHidden = true
            self.specialityMainView.isHidden = true
            self.emailNotificationMainView.isHidden = false
            self.titlePageView.text = "EMAIL NOTIFICATION CONFIGURATION"
            self.backBtn.visibility = .visible
            self.nextBtn.visibility = .gone
            break
        default:
            print("defaultCase")
            self.vendorDetailTV.isHidden = false
            self.languageMainView.isHidden = true
            self.additionalInfoMainView.isHidden = true
            self.specialityMainView.isHidden = true
            self.emailNotificationMainView.isHidden = true
            self.titlePageView.text = "Detail"
            self.backBtn.visibility = .visible
            self.nextBtn.visibility = .visible
        }
    
    }
    func updateUI(){
        self.firstNameTF.borderColor = UIColor.lightGray
        self.middleNameTF.borderColor = UIColor.lightGray
        self.lastNameTF.borderColor = UIColor.lightGray
        self.firstNameTF.layer.borderWidth=0.6
        self.firstNameTF.layer.cornerRadius=6.0
        self.middleNameTF.layer.borderWidth=0.6
        self.middleNameTF.layer.cornerRadius=6.0
        self.lastNameTF.layer.borderWidth=0.6
        self.lastNameTF.layer.cornerRadius=6.0
        self.fullNameouterView.layer.borderColor = UIColor.lightGray.cgColor
        self.zipCodeView.layer.borderColor = UIColor.lightGray.cgColor
        self.stateView.layer.borderColor = UIColor.lightGray.cgColor
        self.cityOuterView.layer.borderColor = UIColor.lightGray.cgColor
        self.aptView.layer.borderColor = UIColor.lightGray.cgColor
        self.onsiteHourView.layer.borderColor = UIColor.lightGray.cgColor
        self.streetAddress.layer.borderColor = UIColor.lightGray.cgColor
        self.phoneNumberView.layer.borderColor = UIColor.lightGray.cgColor
        self.typeCellView.layer.borderColor = UIColor.lightGray.cgColor
        self.workPhoneView.layer.borderColor = UIColor.lightGray.cgColor
        self.mainPhoneView.layer.borderColor = UIColor.lightGray.cgColor
        self.badgeNumberView.layer.borderColor = UIColor.lightGray.cgColor
        self.vendorNameView.layer.borderColor = UIColor.lightGray.cgColor
        self.nickNameView.layer.borderColor = UIColor.lightGray.cgColor
        self.stepIndicatorView.layer.borderColor = UIColor.lightGray.cgColor
        self.fullNameouterView.layer.borderColor = UIColor.lightGray.cgColor
        self.emailOuterView.layer.borderColor = UIColor.lightGray.cgColor
        self.mailingStressView.layer.borderColor = UIColor.lightGray.cgColor
        self.mailingAptView.layer.borderColor = UIColor.lightGray.cgColor
        self.mailingCityView.layer.borderColor = UIColor.lightGray.cgColor
        self.stateBillingView.layer.borderColor = UIColor.lightGray.cgColor
        self.mailingZipCodeView.layer.borderColor = UIColor.lightGray.cgColor
    }

}



//
//  RPicker.swift
//  TotalVendor
//
//  Created by SMIT 005 on 16/12/21.
//

import UIKit

@objc enum RDatePickerStyle: Int {
    //Only for iOS 14 and above
    case Wheel, Inline, Compact
}

enum RPickerType {
    case date, option
}

@objc open class RPicker: NSObject {
    
    private static let sharedInstance = RPicker()
    private var isPresented = false
    
    /**
     Show UIDatePicker with various constraints.
     
     - Parameters:
     - title: Title visible to user above UIDatePicker.
     - cancelText: By default button is hidden. Set text to show cancel button.
     - doneText: Set done button title customization. A default title "Done" is used.
     - datePickerMode: default is Date.
     - selectedDate: default is current date.
     - minDate: default is nil.
     - maxDate: default is nil.
     - style: default is wheel.

     - returns: closure with selected date.
     */
    
    @objc class func selectDate(title: String? = nil,
                          cancelText: String? = nil,
                          doneText: String = "Done",
                          datePickerMode: UIDatePicker.Mode = .date,
                          selectedDate: Date = Date(),
                          minDate: Date? = nil,
                          maxDate: Date? = nil,
                          style: RDatePickerStyle = .Wheel,
                          didSelectDate : ((_ date: Date)->())?) {
        
        guard let vc = controller(title: title, cancelText: cancelText, doneText: doneText, datePickerMode: datePickerMode, selectedDate: selectedDate, minDate: minDate, maxDate: maxDate, type: .date, style: style) else { return }
        
        vc.onDateSelected = { (selectedData) in
            didSelectDate?(selectedData)
        }
    }
    
    /**
    Show UIDatePicker with various constraints.
    
    - Parameters:
    - title: Title visible to user above UIDatePicker.
    - cancelText: By default button is hidden. Set text to show cancel button.
    - doneText: Set done button title customization. A default title "Done" is used.
    - dataArray: Array of string items.
    - selectedIndex: default is nil. If set then picker will show selected index

    - returns: closure with selected text and index.
    */
    
    class func selectOption(title: String? = nil,
                            cancelText: String? = nil,
                            doneText: String = "Done",
                            dataArray: Array<String>?,
                            selectedIndex: Int? = nil,
                            didSelectValue : ((_ value: String, _ atIndex: Int)->())?)  {
        
        guard let arr = dataArray, let vc = controller(title: title, cancelText: cancelText, doneText: doneText, dataArray: arr, selectedIndex: selectedIndex, type: .option) else { return }
        
        vc.onOptionSelected = { (selectedValue, selectedIndex) in
            didSelectValue?(selectedValue, selectedIndex)
        }
    }
    
    /**
    Show UIDatePicker with various constraints.
    
    - Parameters:
    - title: Title visible to user above UIDatePicker.
    - cancelText: By default button is hidden. Set text to show cancel button.
    - doneText: Set done button title customization. A default title "Done" is used.
    - dataArray: Array of string items.
    - selectedIndex: default is nil. If set then picker will show selected index

    - returns: closure with selected text and index.
    */
    //--> For exposing to Objective C. Same as swift
    @objc class func pickOption(title: String? = nil,
                            cancelText: String? = nil,
                            doneText: String = "Done",
                            dataArray: Array<String>?,
                            selectedIndex: NSNumber? = nil,
                            didSelectValue : ((_ value: String, _ atIndex: Int)->())?)  {
        
        var selIndex: Int?
        if let index = selectedIndex {
         selIndex = Int(truncating: index)
        }
        
        guard let arr = dataArray, let vc = controller(title: title, cancelText: cancelText, doneText: doneText, dataArray: arr, selectedIndex: selIndex, type: .option) else { return }
        
        vc.onOptionSelected = { (selectedValue, selectedIndex) in
            didSelectValue?(selectedValue, selectedIndex)
        }
    }
    
    private class func controller(title: String? = nil,
                          cancelText: String? = nil,
                          doneText: String = "Done",
                          datePickerMode: UIDatePicker.Mode = .date,
                          selectedDate: Date = Date(),
                          minDate: Date? = nil,
                          maxDate: Date? = nil,
                          dataArray:Array<String> = [],
                          selectedIndex: Int? = nil,
                          type: RPickerType = .date,
                          style: RDatePickerStyle = .Wheel) -> RPickerController? {
        
        
        if let cc = UIWindow.currentController {
            if RPicker.sharedInstance.isPresented == false {
                RPicker.sharedInstance.isPresented = true
                
                let vc = RPickerController(title: title, cancelText: cancelText, doneText: doneText, datePickerMode: datePickerMode, selectedDate: selectedDate, minDate: minDate, maxDate: maxDate, dataArray: dataArray, selectedIndex: selectedIndex, type: type, style: style)
                
                vc.modalPresentationStyle = .overCurrentContext
                vc.modalTransitionStyle = .crossDissolve
                cc.present(vc, animated: true, completion: nil)
                
                vc.onWillDismiss = {
                    NotificationCenter.default.post(name: Notification.Name("RpickerDismiss"), object: nil)
                    RPicker.sharedInstance.isPresented = false
                }
                
                return vc
            }
        }
        
        return nil
    }
}

private extension UIView {
    
    func pinConstraints(_ byView: UIView, left: CGFloat? = nil, right: CGFloat? = nil, top: CGFloat? = nil, bottom: CGFloat? = nil, height: CGFloat? = nil, width: CGFloat? = nil) {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if let l = left { leftAnchor.constraint(equalTo: byView.leftAnchor, constant: l).isActive = true }
        if let r = right { rightAnchor.constraint(equalTo: byView.rightAnchor, constant: r).isActive = true }
        if let t = top { topAnchor.constraint(equalTo: byView.topAnchor, constant: t).isActive = true }
        if let b = bottom { bottomAnchor.constraint(equalTo: byView.bottomAnchor, constant: b).isActive = true }
        if let h = height { heightAnchor.constraint(equalToConstant: h).isActive = true }
        if let w = width { widthAnchor.constraint(equalToConstant: w).isActive = true }
    }
    
    func surroundConstraints(_ byView: UIView, left: CGFloat = 0, right: CGFloat = 0, top: CGFloat = 0, bottom: CGFloat = 0) {
        pinConstraints(byView, left: left, right: right, top: top, bottom: bottom)
    }
}

class RPickerController: UIViewController {
    
    //MARK:- Public closuers
    var onDateSelected : ((_ date: Date) -> Void)?
    var onOptionSelected : ((_ value: String, _ atIndex: Int) -> Void)?
    var onWillDismiss : (() -> Void)?

    //MARK:- Public variables
    var selectedIndex: Int?
    var selectedDate = Date()
    var maxDate: Date?
    var minDate: Date?
    var titleText: String?
    var cancelText: String?
    var doneText: String = "Done"
    var datePickerMode: UIDatePicker.Mode = .date
    var datePickerStyle: RDatePickerStyle = .Wheel //Only for iOS 14 and above

    var pickerType: RPickerType = .date
    var dataArray: Array<String> = []
    
    //MARK:- Private variables
    private let barViewHeight: CGFloat = 34
    private let pickerHeight: CGFloat = 150
    private let buttonWidth: CGFloat = 84
    private let lineHeight: CGFloat = 0.5
    private let buttonColor = UIColor(red: 72/255, green: 152/255, blue: 240/255, alpha: 1)
    private let lineColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1)
    
    //MARK:- Init
    init(title: String? = nil,
         cancelText: String? = nil,
         doneText: String = "Done",
         datePickerMode: UIDatePicker.Mode = .date,
         selectedDate: Date = Date(),
         minDate: Date? = nil,
         maxDate: Date? = nil,
         dataArray:Array<String> = [],
         selectedIndex: Int? = nil,
         type: RPickerType = .date,
         style: RDatePickerStyle = .Wheel) {
        
        self.titleText = title
        self.cancelText = cancelText
        self.doneText = doneText
        self.datePickerMode = datePickerMode
        self.selectedDate = selectedDate
        self.minDate = minDate
        self.maxDate = maxDate
        self.dataArray = dataArray
        self.selectedIndex = selectedIndex
        self.pickerType = type
        self.datePickerStyle = style

        super.init(nibName: nil, bundle: nil)
        
        initialSetup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        // Trait collection has already changed
    }
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        // Trait collection will change. Use this one so you know what the state is changing to.
      if #available(iOS 12.0, *) {
         if newCollection.userInterfaceStyle != traitCollection.userInterfaceStyle {
            if newCollection.userInterfaceStyle == .dark {
               setUpThemeMode(isDark: true)
            } else {
                setUpThemeMode(isDark: false)
            }
         }
      } else {
         // Fallback on earlier versions
        setUpThemeMode(isDark: false)
      }
    }
    
    //MARK:- Private functions
    private func initialSetup() {
        
        view.backgroundColor = UIColor.clear
        let bgView = transView
        view.addSubview(bgView)
        bgView.surroundConstraints(view)
        
        //Stack View
        stackView.addArrangedSubview(lineLabel)
        stackView.addArrangedSubview(toolBarView)
        stackView.addArrangedSubview(lineLabel)
                
        var height = barViewHeight + (2*lineHeight)

        if pickerType == .date {
            stackView.addArrangedSubview(datePicker)
            if #available(iOS 14.0, *) {
                if datePickerStyle == .Wheel {
                    height = height + pickerHeight
                } else if datePickerStyle == .Compact {
                    height = height + pickerHeight
                } else {
                    if datePicker.datePickerMode == .dateAndTime {
                        height = height + 428
                    } else if datePicker.datePickerMode == .date {
                        height = height + 386
                    } else {
                        height = height + pickerHeight
                    }
                }
            } else {
                //restrict to use wheel mode
                datePickerStyle = .Wheel
                height = height + pickerHeight
            }
        
        } else {
            stackView.addArrangedSubview(optionPicker)
            height = height + pickerHeight
        }
        
        self.view.addSubview(stackView)
                
        stackView.pinConstraints(view, left: 0, right: 0, bottom: 0, height: height)
        //stackView.pinConstraints(view, left: 0, right: 0, top: 0, bottom: 0)
        
      if #available(iOS 12.0, *) {
         if traitCollection.userInterfaceStyle == .dark {
            setUpThemeMode(isDark: true)
         } else {
            setUpThemeMode(isDark: false)
         }
      } else {
         // Fallback on earlier versions
        setUpThemeMode(isDark: false)
      }
    }
    
    private func setUpThemeMode(isDark: Bool) {

        if isDark {
            titleLabel.textColor = UIColor.white
            stackView.backgroundColor = UIColor.black
            transView.backgroundColor = UIColor(white: 1, alpha: 0.3)
            if pickerType == .date {
                datePicker.backgroundColor = UIColor.black
            } else {
                optionPicker.backgroundColor = UIColor.black
            }
            toolBarView.backgroundColor = UIColor.black

        } else {
            titleLabel.textColor = UIColor.white
            doneButton.titleLabel?.textColor = UIColor.white
            stackView.backgroundColor = UIColor.white
            transView.backgroundColor = UIColor(white: 0.1, alpha: 0.3)
            if pickerType == .date {
                datePicker.backgroundColor = UIColor.white
            } else {
                optionPicker.backgroundColor = UIColor.blue
            }
            toolBarView.backgroundColor = UIColor(hexString: "33A5FF")
        }
    }
    
    private func dismissVC() {
        onWillDismiss?()
        dismiss(animated: true, completion: nil)
    }
    
    @objc func handleTap() { dismissVC() }
    
    //MARK:- Private properties

    private lazy var transView: UIView = {
        let vw = UIView()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleTap))
        vw.addGestureRecognizer(tapGesture)
        vw.isUserInteractionEnabled = true
        return vw
    }()
    
    private lazy var stackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = NSLayoutConstraint.Axis.vertical
        sv.distribution = UIStackView.Distribution.fill
        sv.alignment = UIStackView.Alignment.center
        sv.spacing = 0.0
        return sv
    }()
    
    private lazy var datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.pinConstraints(view, width: view.frame.width)
        picker.minimumDate = minDate
        picker.maximumDate = maxDate
        picker.date = selectedDate
        picker.datePickerMode = datePickerMode

        if #available(iOS 14, *) {
            if datePickerStyle == .Wheel {
                picker.preferredDatePickerStyle = .wheels
            } else if datePickerStyle == .Compact {
                picker.preferredDatePickerStyle = .compact
            } else {
                picker.preferredDatePickerStyle = .inline
            }
        }

        return picker
    }()
    
    private lazy var optionPicker: UIPickerView = {
        
        let picker = UIPickerView()
        picker.dataSource = self
        picker.delegate = self
        picker.pinConstraints(view, width: view.frame.width)
        
        if let selectedIndex = selectedIndex {
            if (selectedIndex < dataArray.count) {
                picker.selectRow(selectedIndex, inComponent: 0, animated: false)
            }
        }
        
        return picker
    }()
    
    private lazy var toolBarView: UIView = {
        
        let barView = UIView()
        barView.pinConstraints(view, height: barViewHeight, width: view.frame.width)
        
        //add done button
        let doneButton = self.doneButton
        let cancelButton = self.cancelButton
        
        barView.addSubview(doneButton)
        barView.addSubview(cancelButton)
        
        cancelButton.pinConstraints(barView, left: 0, top: 0, bottom: 0, width: buttonWidth)
        doneButton.pinConstraints(barView, right: 0, top: 0, bottom: 0, width: buttonWidth)
        
        if let text = titleText {
            let titleLabel = self.titleLabel
            titleLabel.text = text
            barView.addSubview(titleLabel)
            titleLabel.surroundConstraints(barView, left: buttonWidth, right: -buttonWidth)
        }
        doneButton.setTitleColor(UIColor.white, for: .normal)
       
        doneButton.setTitle(doneText, for: .normal)
        
        if let text = cancelText {
            cancelButton.setTitleColor(UIColor.white, for: .normal)
            cancelButton.setTitle(text, for: .normal)
        } else {
            cancelButton.isHidden = true
        }
        
        return barView
    }()
    
    private lazy var lineLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = lineColor
        label.pinConstraints(view, height: lineHeight, width: view.frame.width)
        return label
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont(name: "HelveticaNeue-Medium", size: 14)
        label.numberOfLines = 2
        return label
    }()
    
    private lazy var doneButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(buttonColor, for: .normal)
        button.titleLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: 16)
        button.titleLabel?.textColor = UIColor.white
        button.addTarget(self, action: #selector(onDoneButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(buttonColor, for: .normal)
        button.titleLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: 16)
        button.addTarget(self, action: #selector(onCancelButton), for: .touchUpInside)
        return button
    }()
    
    @objc func onDoneButton(sender : UIButton) {
        
        if pickerType == .date {
            onDateSelected?(datePicker.date)
        } else {
            let selectedValueIndex = self.optionPicker.selectedRow(inComponent: 0)
            onOptionSelected?(dataArray[selectedValueIndex], selectedValueIndex)
        }
        
        dismissVC()
    }
    
    @objc func onCancelButton(sender : UIButton) { dismissVC() }
}

//MARK:- UIPickerViewDataSource, UIPickerViewDelegate

extension RPickerController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int { return 1 }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int { return dataArray.count }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        var pickerLabel = view as? UILabel
        
        if (pickerLabel == nil) {
            pickerLabel = UILabel()
            pickerLabel?.font = UIFont(name: "OpenSans-Semibold", size: 16)
            pickerLabel?.textAlignment = NSTextAlignment.center
        }
        
        pickerLabel?.text = dataArray[row]
        
        return pickerLabel!
    }
}

// MARK:- Private Extensions

private extension UIApplication {
    static var keyWindow: UIWindow? {
        if #available(iOS 13.0, *) {
         return UIApplication.shared.windows.filter {$0.isKeyWindow}.first
         } else {
            return UIApplication.shared.delegate?.window ?? nil
         }
    }
}

private extension UIWindow {
    
    static var currentController: UIViewController? {
        return UIApplication.keyWindow?.currentController
    }
    
    var currentController: UIViewController? {
        if let vc = self.rootViewController {
            return topViewController(controller: vc)
        }
        return nil
    }
    
    func topViewController(controller: UIViewController? = UIApplication.keyWindow?.rootViewController) -> UIViewController? {
        if let nc = controller as? UINavigationController {
            if nc.viewControllers.count > 0 {
                return topViewController(controller: nc.viewControllers.last!)
            } else {
                return nc
            }
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
}

