//
//  CreateCompanyViewController.swift
//  ACDShipManagement
//
//  Created by Prato Das on 2018-02-05.
//  Copyright © 2018 Prato Das. All rights reserved.
//

import UIKit
import Firebase
import NotificationBannerSwift

class CreateCompanyViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setupBar()
        setupBarButtons()
        setupTextFieldsAndButtons()
    }
    
    func setupBar() {
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationController?.navigationBar.barTintColor = .gray
        self.navigationController?.navigationBar.addShadow()
        view.backgroundColor = .darkGray
    }

    func setupBarButtons() {
        view.backgroundColor = .darkGray

        let barButtonClose = UIBarButtonItem(image: UIImage(named: "arrow")?.withRenderingMode(.alwaysTemplate), style: .plain, target: self, action: #selector(closeView(_:)))
        barButtonClose.tintColor = .white
        self.navigationItem.setLeftBarButton(barButtonClose, animated: true)
    }
    
    
    func setupTextFieldsAndButtons() {
        view.addSubview(companyNameTextField)
        view.addSubview(companyAddressTextField)
        view.addSubview(representativeNameTextField)
        view.addSubview(representativePhoneTextField)
        view.addSubview(representativeEmailTextField)
        view.addSubview(saveButton)
        NSLayoutConstraint.activate([companyNameTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8), companyNameTextField.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -16), companyNameTextField.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 16), companyNameTextField.heightAnchor.constraint(equalToConstant: 40)])

        NSLayoutConstraint.activate([companyAddressTextField.topAnchor.constraint(equalTo: companyNameTextField.bottomAnchor, constant: 8), companyAddressTextField.rightAnchor.constraint(equalTo: companyNameTextField.rightAnchor), companyAddressTextField.leftAnchor.constraint(equalTo: companyNameTextField.leftAnchor), companyAddressTextField.heightAnchor.constraint(equalToConstant: 40)])
        
        
        NSLayoutConstraint.activate([representativeNameTextField.topAnchor.constraint(equalTo: companyAddressTextField.bottomAnchor, constant: 8), representativeNameTextField.rightAnchor.constraint(equalTo: companyNameTextField.rightAnchor), representativeNameTextField.leftAnchor.constraint(equalTo: companyNameTextField.leftAnchor), representativeNameTextField.heightAnchor.constraint(equalToConstant: 40)])

        NSLayoutConstraint.activate([representativePhoneTextField.topAnchor.constraint(equalTo: representativeNameTextField.bottomAnchor, constant: 8), representativePhoneTextField.rightAnchor.constraint(equalTo: companyNameTextField.rightAnchor), representativePhoneTextField.leftAnchor.constraint(equalTo: companyNameTextField.leftAnchor), representativePhoneTextField.heightAnchor.constraint(equalToConstant: 40)])

        NSLayoutConstraint.activate([representativeEmailTextField.topAnchor.constraint(equalTo: representativePhoneTextField.bottomAnchor, constant: 8), representativeEmailTextField.rightAnchor.constraint(equalTo: companyNameTextField.rightAnchor), representativeEmailTextField.leftAnchor.constraint(equalTo: companyNameTextField.leftAnchor), representativeEmailTextField.heightAnchor.constraint(equalToConstant: 40)])
        
        
        NSLayoutConstraint.activate([saveButton.topAnchor.constraint(equalTo: representativeEmailTextField.bottomAnchor, constant: 8), saveButton.rightAnchor.constraint(equalTo: companyNameTextField.rightAnchor), saveButton.leftAnchor.constraint(equalTo: companyNameTextField.leftAnchor), saveButton.heightAnchor.constraint(equalToConstant: 40)])
        
        
        
    }
    
    
    // Close button to dismiss the menu
    var closeButton: UIButton = {
        let cb = UIButton(type: .system)
        cb.setImage(UIImage(named: "arrow")?.withRenderingMode(.alwaysTemplate), for: .normal)
        cb.translatesAutoresizingMaskIntoConstraints = false
        cb.addTarget(self, action: #selector(closeView(_:)), for: .touchUpInside)
        cb.tintColor = .white
        cb.contentMode = .scaleAspectFit
        return cb
    }()
    
    // Text fields
    var companyNameTextField: CustomUITextField = {
        let cntf = CustomUITextField()
        cntf.placeholder = "Company Name"
        return cntf
    }()
    
    
    var representativeNameTextField: CustomUITextField = {
        let cntf = CustomUITextField()
        cntf.placeholder = "Representative Name"
        return cntf
    }()
    
    var representativePhoneTextField: CustomUITextField = {
        let cntf = CustomUITextField()
        cntf.placeholder = "Representative Phone"
        cntf.keyboardType = .phonePad
        return cntf
    }()
    
    var representativeEmailTextField: CustomUITextField = {
        let cntf = CustomUITextField()
        cntf.placeholder = "Representative Email"
        cntf.keyboardType = .emailAddress
        return cntf
    }()
    
    var companyAddressTextField: CustomUITextField = {
        let cntf = CustomUITextField()
        cntf.placeholder = "Company Address"
        return cntf
    }()
    
    // Save button
    
    var saveButton: CustomUIButton = {
        let cb = CustomUIButton(type: .system)
        cb.setTitle("Save", for: .normal)
        cb.addTarget(self, action: #selector(handleSave), for: .touchUpInside)
        cb.backgroundColor = .green
        cb.layer.cornerRadius = 10.0
        
        return cb
    }()
    // Function called to dismiss the view controller

    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        companyNameTextField.addShadow()
        companyAddressTextField.addShadow()
        representativeNameTextField.addShadow()
        representativeEmailTextField.addShadow()
        representativePhoneTextField.addShadow()
        saveButton.addShadow()
    }
}


extension CreateCompanyViewController {
    @objc func handleSave() {
        print("Attempting to save contact to firebase")
        if companyNameTextField.text == "" || companyAddressTextField.text == "" || representativeNameTextField.text == "" || representativePhoneTextField.text == "" || representativeEmailTextField.text == ""   {
            print("ERROR")
            return
        }
        self.companyNameTextField.isUserInteractionEnabled = false
        self.companyAddressTextField.isUserInteractionEnabled = false
        self.representativeNameTextField.isUserInteractionEnabled = false
        self.representativePhoneTextField.isUserInteractionEnabled = false
        self.representativeEmailTextField.isUserInteractionEnabled = false
        self.saveButton.isUserInteractionEnabled = false
        
        let companyName = companyNameTextField.text
        let companyAddress = companyAddressTextField.text
        let representativeName = representativeNameTextField.text
        let representativePhone = representativePhoneTextField.text
        let representativeEmail = representativeEmailTextField.text
        let companyId = UUID().uuidString
        let db = Firestore.firestore()
        let companyDictionary: [String: Any?] = ["companyName": companyName, "companyAddress": companyAddress, "representativeName": representativeName, "representativePhone": representativePhone, "representativeEmail": representativeEmail]
        db.collection("Companies").document(companyId).setData(companyDictionary)
        self.companyNameTextField.text = ""
        self.companyAddressTextField.text = ""
        self.representativeNameTextField.text = ""
        self.representativePhoneTextField.text = ""
        self.representativeEmailTextField.text = ""
        self.companyNameTextField.isUserInteractionEnabled = true
        self.companyAddressTextField.isUserInteractionEnabled = true
        self.representativeNameTextField.isUserInteractionEnabled = true
        self.representativePhoneTextField.isUserInteractionEnabled = true
        self.representativeEmailTextField.isUserInteractionEnabled = true
        self.saveButton.isUserInteractionEnabled = true
        self.companyNameTextField.becomeFirstResponder()
        let banner = StatusBarNotificationBanner(title: "Saved", style: .success)
        banner.show()
        banner.duration = 0.5
    }
}



