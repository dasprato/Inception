//
//  EditShipViewController.swift
//  ACDShipManagement
//
//  Created by Prato Das on 2019-06-21.
//  Copyright © 2019 Prato Das. All rights reserved.
//

import UIKit
import Firebase
import NotificationBannerSwift

class EditShipViewController: UIViewController {
    
    var ship: Ship? {
        didSet {
            vesselNameTextField.text = ship?.vesselName
            vesselCapacityTextField.text = ship?.vesselCapacity
            representativeNameTextField.text = ship?.representativeName
            representativePhoneTextField.text = ship?.representativePhone
            representativeEmailTextField.text = ship?.representativeEmail
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBarButtons()
        setupTextFieldsAndButtons()
    }
    
    func setupBarButtons() {
        view.backgroundColor = .darkGray
        let barButton = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(handleEdit))
        barButton.tintColor = .white
        self.navigationItem.setRightBarButton(barButton, animated: true)
    }
    
    
    func setupTextFieldsAndButtons() {
        view.addSubview(vesselNameTextField)
        view.addSubview(vesselCapacityTextField)
        view.addSubview(representativeNameTextField)
        view.addSubview(representativePhoneTextField)
        view.addSubview(representativeEmailTextField)
        view.addSubview(updateButton)
        view.addSubview(deleteButton)
        
        NSLayoutConstraint.activate([vesselNameTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8), vesselNameTextField.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -16), vesselNameTextField.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 16), vesselNameTextField.heightAnchor.constraint(equalToConstant: 40)])
        
        NSLayoutConstraint.activate([vesselCapacityTextField.topAnchor.constraint(equalTo: vesselNameTextField.bottomAnchor, constant: 8), vesselCapacityTextField.rightAnchor.constraint(equalTo: vesselNameTextField.rightAnchor), vesselCapacityTextField.leftAnchor.constraint(equalTo: vesselNameTextField.leftAnchor), vesselCapacityTextField.heightAnchor.constraint(equalToConstant: 40)])
        
        
        NSLayoutConstraint.activate([representativeNameTextField.topAnchor.constraint(equalTo: vesselCapacityTextField.bottomAnchor, constant: 8), representativeNameTextField.rightAnchor.constraint(equalTo: vesselNameTextField.rightAnchor), representativeNameTextField.leftAnchor.constraint(equalTo: vesselNameTextField.leftAnchor), representativeNameTextField.heightAnchor.constraint(equalToConstant: 40)])
        
        NSLayoutConstraint.activate([representativePhoneTextField.topAnchor.constraint(equalTo: representativeNameTextField.bottomAnchor, constant: 8), representativePhoneTextField.rightAnchor.constraint(equalTo: vesselNameTextField.rightAnchor), representativePhoneTextField.leftAnchor.constraint(equalTo: vesselNameTextField.leftAnchor), representativePhoneTextField.heightAnchor.constraint(equalToConstant: 40)])
        
        
        NSLayoutConstraint.activate([representativeEmailTextField.topAnchor.constraint(equalTo: representativePhoneTextField.bottomAnchor, constant: 8), representativeEmailTextField.rightAnchor.constraint(equalTo: vesselNameTextField.rightAnchor), representativeEmailTextField.leftAnchor.constraint(equalTo: vesselNameTextField.leftAnchor), representativeEmailTextField.heightAnchor.constraint(equalToConstant: 40)])
        
        
        NSLayoutConstraint.activate([updateButton.topAnchor.constraint(equalTo: representativeEmailTextField.bottomAnchor, constant: 8), updateButton.rightAnchor.constraint(equalTo: vesselNameTextField.rightAnchor), updateButton.leftAnchor.constraint(equalTo: vesselNameTextField.leftAnchor), updateButton.heightAnchor.constraint(equalToConstant: 40)])
        
        NSLayoutConstraint.activate([deleteButton.topAnchor.constraint(equalTo: updateButton.bottomAnchor, constant: 8), deleteButton.rightAnchor.constraint(equalTo: vesselNameTextField.rightAnchor), deleteButton.leftAnchor.constraint(equalTo: vesselNameTextField.leftAnchor), deleteButton.heightAnchor.constraint(equalToConstant: 40)])
        
    }
    
    // Text fields
    var vesselNameTextField: CustomUITextField = {
        let cntf = CustomUITextField()
        cntf.placeholder = "Vessel Name"
        return cntf
    }()
    
    var vesselCapacityTextField: CustomUITextField = {
        let cntf = CustomUITextField()
        cntf.placeholder = "Vessel Capacity"
        cntf.keyboardType = .decimalPad
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
        vesselNameTextField.addShadow()
        vesselCapacityTextField.addShadow()
        representativeNameTextField.addShadow()
        representativePhoneTextField.addShadow()
        representativeEmailTextField.addShadow()
        updateButton.addShadow()
        deleteButton.addShadow()
    }
}


extension EditShipViewController {
    
    @objc func handleEdit() {
        
    }
    
    @objc func handleDelete() {
        guard let vesselId = ship?.shipId else { return }
        print("Attempting to save contact to firebase")
        makeViewDisabled()
        Firestore.firestore().collection("Ships").document(vesselId).delete { (err) in
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
    
    
    func makeViewDisabled () {
        vesselNameTextField.isUserInteractionEnabled = false
        vesselCapacityTextField.isUserInteractionEnabled = false
        representativeNameTextField.isUserInteractionEnabled = false
        representativePhoneTextField.isUserInteractionEnabled = false
        representativeEmailTextField.isUserInteractionEnabled = false
        updateButton.isUserInteractionEnabled = false
        deleteButton.isUserInteractionEnabled = false
    }
    @objc func handleUpdate() {
        guard let vesselId = ship?.shipId else { return }
        print("Attempting to save contact to firebase")
        if vesselNameTextField.text == "" || vesselCapacityTextField.text == "" || representativeNameTextField.text == "" || representativePhoneTextField.text == "" || representativeEmailTextField.text == ""   {
            print("ERROR")
            return
        }
        
        

        
        let vesselName = vesselNameTextField.text
        let vesselCapacity = vesselCapacityTextField.text
        let representativeName = representativeNameTextField.text
        let representativePhone = representativePhoneTextField.text
        let representativeEmail = representativeEmailTextField.text
        let db = Firestore.firestore()
        let vesselDictionary: [String: Any?] = ["vesselName": vesselName, "vesselCapacity": vesselCapacity, "representativeName": representativeName, "representativePhone": representativePhone, "representativeEmail": representativeEmail, "currentStatus": "Available"]
        db.collection("Ships").document(vesselId).setData(vesselDictionary)
        
        vesselNameTextField.isUserInteractionEnabled = true
        vesselCapacityTextField.isUserInteractionEnabled = true
        representativeNameTextField.isUserInteractionEnabled = true
        representativePhoneTextField.isUserInteractionEnabled = true
        representativeEmailTextField.isUserInteractionEnabled = true
        updateButton.isUserInteractionEnabled = true
        let banner = StatusBarNotificationBanner(title: "Updated", style: .success)
        banner.show()
        banner.duration = 0.5
    }
}
