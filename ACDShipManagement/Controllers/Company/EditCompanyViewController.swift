//
//  EditCompanyViewController.swift
//  ACDShipManagement
//
//  Created by Prato Das on 2019-06-21.
//  Copyright © 2019 Prato Das. All rights reserved.
//

import UIKit
import Firebase
import NotificationBannerSwift

class EditCompanyViewController: UIViewController {
    
    var company: Company? {
        didSet {
            companyNameTextField.text = company?.companyName
            companyAddressTextField.text = company?.companyAddress
            representativeNameTextField.text  = company?.representativeName
            representativePhoneTextField.text = company?.representativePhone
            representativeEmailTextField.text = company?.representativeEmail
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBarButtons()
        setupTextFieldsAndButtons()
    }
    
    func setupTextFieldsAndButtons() {
        view.addSubview(companyNameTextField)
        view.addSubview(companyAddressTextField)
        view.addSubview(representativeNameTextField)
        view.addSubview(representativePhoneTextField)
        view.addSubview(representativeEmailTextField)
        view.addSubview(updateButton)
        view.addSubview(deleteButton)
        NSLayoutConstraint.activate([companyNameTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8), companyNameTextField.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -16), companyNameTextField.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 16), companyNameTextField.heightAnchor.constraint(equalToConstant: 40)])
        
        NSLayoutConstraint.activate([companyAddressTextField.topAnchor.constraint(equalTo: companyNameTextField.bottomAnchor, constant: 8), companyAddressTextField.rightAnchor.constraint(equalTo: companyNameTextField.rightAnchor), companyAddressTextField.leftAnchor.constraint(equalTo: companyNameTextField.leftAnchor), companyAddressTextField.heightAnchor.constraint(equalToConstant: 40)])
        
        
        NSLayoutConstraint.activate([representativeNameTextField.topAnchor.constraint(equalTo: companyAddressTextField.bottomAnchor, constant: 8), representativeNameTextField.rightAnchor.constraint(equalTo: companyNameTextField.rightAnchor), representativeNameTextField.leftAnchor.constraint(equalTo: companyNameTextField.leftAnchor), representativeNameTextField.heightAnchor.constraint(equalToConstant: 40)])
        
        NSLayoutConstraint.activate([representativePhoneTextField.topAnchor.constraint(equalTo: representativeNameTextField.bottomAnchor, constant: 8), representativePhoneTextField.rightAnchor.constraint(equalTo: companyNameTextField.rightAnchor), representativePhoneTextField.leftAnchor.constraint(equalTo: companyNameTextField.leftAnchor), representativePhoneTextField.heightAnchor.constraint(equalToConstant: 40)])
        
        NSLayoutConstraint.activate([representativeEmailTextField.topAnchor.constraint(equalTo: representativePhoneTextField.bottomAnchor, constant: 8), representativeEmailTextField.rightAnchor.constraint(equalTo: companyNameTextField.rightAnchor), representativeEmailTextField.leftAnchor.constraint(equalTo: companyNameTextField.leftAnchor), representativeEmailTextField.heightAnchor.constraint(equalToConstant: 40)])
        
        
        NSLayoutConstraint.activate([updateButton.topAnchor.constraint(equalTo: representativeEmailTextField.bottomAnchor, constant: 8), updateButton.rightAnchor.constraint(equalTo: companyNameTextField.rightAnchor), updateButton.leftAnchor.constraint(equalTo: companyNameTextField.leftAnchor), updateButton.heightAnchor.constraint(equalToConstant: 40)])
        
        
        NSLayoutConstraint.activate([deleteButton.topAnchor.constraint(equalTo: updateButton.bottomAnchor, constant: 8), deleteButton.rightAnchor.constraint(equalTo: companyNameTextField.rightAnchor), deleteButton.leftAnchor.constraint(equalTo: companyNameTextField.leftAnchor), deleteButton.heightAnchor.constraint(equalToConstant: 40)])
        
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
    
    var updateButton: CustomUIButton = {
        let cb = CustomUIButton(type: .system)
        cb.setTitle("Update", for: .normal)
        cb.addTarget(self, action: #selector(handleUpdate), for: .touchUpInside)
        cb.backgroundColor = .blue
        cb.layer.cornerRadius = 10.0
        return cb
    }()
    
    
    var deleteButton: CustomUIButton = {
        let cb = CustomUIButton(type: .system)
        cb.setTitle("Delete", for: .normal)
        cb.addTarget(self, action: #selector(handleDelete), for: .touchUpInside)
        cb.backgroundColor = .red
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
        updateButton.addShadow()
        deleteButton.addShadow()
    }
}


extension EditCompanyViewController {
    
    
    @objc func handleEdit() {
        
    }
    
    func setupBarButtons() {
        view.backgroundColor = .darkGray
        let barButton = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(handleEdit))
        barButton.tintColor = .white
        self.navigationItem.setRightBarButton(barButton, animated: true)
    }
    
    
    func makeViewDisabled () {
        self.companyNameTextField.isUserInteractionEnabled = false
        self.companyAddressTextField.isUserInteractionEnabled = false
        self.representativeNameTextField.isUserInteractionEnabled = false
        self.representativePhoneTextField.isUserInteractionEnabled = false
        self.representativeEmailTextField.isUserInteractionEnabled = false
        self.updateButton.isUserInteractionEnabled = false
        self.deleteButton.isUserInteractionEnabled = false
    }
    
    @objc func handleUpdate() {
        
        guard let companyId = company?.companyId else { return }
        
        print("Attempting to save contact to firebase")
        if companyNameTextField.text == "" || companyAddressTextField.text == "" || representativeNameTextField.text == "" || representativePhoneTextField.text == "" || representativeEmailTextField.text == ""   {
            print("ERROR")
            return
        }
        
        makeViewDisabled()
        let companyName = companyNameTextField.text
        let companyAddress = companyAddressTextField.text
        let representativeName = representativeNameTextField.text
        let representativePhone = representativePhoneTextField.text
        let representativeEmail = representativeEmailTextField.text
        let db = Firestore.firestore()
        let companyDictionary: [String: Any?] = ["companyName": companyName, "companyAddress": companyAddress, "representativeName": representativeName, "representativePhone": representativePhone, "representativeEmail": representativeEmail]
        db.collection("Companies").document(companyId).setData(companyDictionary)
        self.companyNameTextField.isUserInteractionEnabled = true
        self.companyAddressTextField.isUserInteractionEnabled = true
        self.representativeNameTextField.isUserInteractionEnabled = true
        self.representativePhoneTextField.isUserInteractionEnabled = true
        self.representativeEmailTextField.isUserInteractionEnabled = true
        self.updateButton.isUserInteractionEnabled = true
        self.deleteButton.isUserInteractionEnabled = true
        let banner = StatusBarNotificationBanner(title: "Updated", style: .success)
        banner.show()
        banner.duration = 0.5
    }
    
    @objc func handleDelete() {
        guard let companyId = company?.companyId else { return }
        print("Attempting to save contact to firebase")
        makeViewDisabled()
        Firestore.firestore().collection("Companies").document(companyId).delete { (err) in
            if err != nil {
                print ("Error removing document")
            } else {
                print ("Document removed successfully")
                let banner = StatusBarNotificationBanner(title: "Deleted", style: .success)
                banner.show()
                banner.duration = 0.5
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
}



