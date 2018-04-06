//
//  ViewController1.swift
//  ACDShipManagement
//
//  Created by Prato Das on 2018-02-05.
//  Copyright © 2018 Prato Das. All rights reserved.
//

import UIKit
import Firebase
import NotificationBannerSwift

class CreateShipViewController: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationController?.navigationBar.barTintColor = .gray
        self.navigationController?.navigationBar.addShadow()
        view.backgroundColor = .darkGray
        
        setupBarButtons()
        setupTextFieldsAndButtons()
    }
    
    func setupBarButtons() {
        view.backgroundColor = .darkGray
        

        let barButtonClose = UIBarButtonItem(image: UIImage(named: "arrow")?.withRenderingMode(.alwaysTemplate), style: .plain, target: self, action: #selector(closeView(_:)))
        barButtonClose.tintColor = .white
        self.navigationItem.setLeftBarButton(barButtonClose, animated: true)
        
        
    }
    
    
    func setupTextFieldsAndButtons() {
        view.addSubview(vesselNameTextField)
        view.addSubview(vesselCapacityTextField)
        view.addSubview(representativeNameTextField)
        view.addSubview(representativePhoneTextField)
        view.addSubview(representativeEmailTextField)
        view.addSubview(saveButton)
        NSLayoutConstraint.activate([vesselNameTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8), vesselNameTextField.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -16), vesselNameTextField.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 16), vesselNameTextField.heightAnchor.constraint(equalToConstant: 40)])
        
        NSLayoutConstraint.activate([vesselCapacityTextField.topAnchor.constraint(equalTo: vesselNameTextField.bottomAnchor, constant: 8), vesselCapacityTextField.rightAnchor.constraint(equalTo: vesselNameTextField.rightAnchor), vesselCapacityTextField.leftAnchor.constraint(equalTo: vesselNameTextField.leftAnchor), vesselCapacityTextField.heightAnchor.constraint(equalToConstant: 40)])
        
        
        NSLayoutConstraint.activate([representativeNameTextField.topAnchor.constraint(equalTo: vesselCapacityTextField.bottomAnchor, constant: 8), representativeNameTextField.rightAnchor.constraint(equalTo: vesselNameTextField.rightAnchor), representativeNameTextField.leftAnchor.constraint(equalTo: vesselNameTextField.leftAnchor), representativeNameTextField.heightAnchor.constraint(equalToConstant: 40)])
        
        NSLayoutConstraint.activate([representativePhoneTextField.topAnchor.constraint(equalTo: representativeNameTextField.bottomAnchor, constant: 8), representativePhoneTextField.rightAnchor.constraint(equalTo: vesselNameTextField.rightAnchor), representativePhoneTextField.leftAnchor.constraint(equalTo: vesselNameTextField.leftAnchor), representativePhoneTextField.heightAnchor.constraint(equalToConstant: 40)])
        
        
        NSLayoutConstraint.activate([representativeEmailTextField.topAnchor.constraint(equalTo: representativePhoneTextField.bottomAnchor, constant: 8), representativeEmailTextField.rightAnchor.constraint(equalTo: vesselNameTextField.rightAnchor), representativeEmailTextField.leftAnchor.constraint(equalTo: vesselNameTextField.leftAnchor), representativeEmailTextField.heightAnchor.constraint(equalToConstant: 40)])
        
        
        NSLayoutConstraint.activate([saveButton.topAnchor.constraint(equalTo: representativeEmailTextField.bottomAnchor, constant: 8), saveButton.rightAnchor.constraint(equalTo: vesselNameTextField.rightAnchor), saveButton.leftAnchor.constraint(equalTo: vesselNameTextField.leftAnchor), saveButton.heightAnchor.constraint(equalToConstant: 40)])
        
        
        
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
    
    var saveButton: CustomUIButton = {
        let cb = CustomUIButton(type: .system)
        cb.setTitle("Save", for: .normal)
        cb.addTarget(self, action: #selector(save), for: .touchUpInside)
        cb.backgroundColor = .green
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
        saveButton.addShadow()
    }
}


extension CreateShipViewController {
    @objc func save() {
        print("Attempting to save contact to firebase")
        if vesselNameTextField.text == "" || vesselCapacityTextField.text == "" || representativeNameTextField.text == "" || representativePhoneTextField.text == "" || representativeEmailTextField.text == ""   {
            print("ERROR")
            return
        }
        
        
        vesselNameTextField.isUserInteractionEnabled = false
        vesselCapacityTextField.isUserInteractionEnabled = false
        representativeNameTextField.isUserInteractionEnabled = false
        representativePhoneTextField.isUserInteractionEnabled = false
        representativeEmailTextField.isUserInteractionEnabled = false
        saveButton.isUserInteractionEnabled = false
        
        let vesselName = vesselNameTextField.text
        let vesselCapacity = vesselCapacityTextField.text
        let representativeName = representativeNameTextField.text
        let representativePhone = representativePhoneTextField.text
        let representativeEmail = representativeEmailTextField.text
        let vesselId = UUID().uuidString + UUID().uuidString + UUID().uuidString + UUID().uuidString + UUID().uuidString + UUID().uuidString + UUID().uuidString + UUID().uuidString +
            UUID().uuidString + UUID().uuidString + UUID().uuidString + UUID().uuidString + UUID().uuidString + UUID().uuidString + UUID().uuidString + UUID().uuidString + UUID().uuidString + UUID().uuidString + UUID().uuidString + UUID().uuidString
        let db = Firestore.firestore()
        let vesselDictionary: [String: Any?] = ["vesselName": vesselName, "vesselCapacity": vesselCapacity, "representativeName": representativeName, "representativePhone": representativePhone, "representativeEmail": representativeEmail, "currentStatus": "Available"]
        db.collection("Ships").document(vesselId).setData(vesselDictionary)
        
        vesselNameTextField.text = ""
        vesselCapacityTextField.text = ""
        representativeNameTextField.text = ""
        representativePhoneTextField.text = ""
        representativeEmailTextField.text = ""
        vesselNameTextField.isUserInteractionEnabled = true
        vesselCapacityTextField.isUserInteractionEnabled = true
        representativeNameTextField.isUserInteractionEnabled = true
        representativePhoneTextField.isUserInteractionEnabled = true
        representativeEmailTextField.isUserInteractionEnabled = true
        saveButton.isUserInteractionEnabled = true


        vesselNameTextField.becomeFirstResponder()
        let banner = StatusBarNotificationBanner(title: "Saved", style: .success)
        banner.show()
        banner.duration = 0.5
    }
}


