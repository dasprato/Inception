//
//  CreateContactViewController.swift
//  ACDShipManagement
//
//  Created by Prato Das on 2018-03-27.
//  Copyright © 2018 Prato Das. All rights reserved.
//

import UIKit
import Firebase
import NotificationBannerSwift

class CreateContactViewController: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(statusManager), name: .flagsChanged, object: Network.reachability)
    
        setupBarButtons()
        setupTextFieldsAndButtons()
        
    }
    
    func setupBarButtons() {
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationController?.navigationBar.barTintColor = .gray
        self.navigationController?.navigationBar.addShadow()
        view.backgroundColor = .darkGray
        
        
        let barButtonClose = UIBarButtonItem(image: UIImage(named: "arrow")?.withRenderingMode(.alwaysTemplate), style: .plain, target: self, action: #selector(closeView(_:)))
        barButtonClose.tintColor = .white
        self.navigationItem.setLeftBarButton(barButtonClose, animated: true)
    }
    
    
    func setupTextFieldsAndButtons() {
        view.addSubview(contactImageViewBackground)
        view.addSubview(contactImageView)
        view.addSubview(contactNameTextField)
        view.addSubview(contactPhoneTextField)
        view.addSubview(contactEmailTextField)
        view.addSubview(saveButton)
    
        NSLayoutConstraint.activate([contactImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8), contactImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor), contactImageView.widthAnchor.constraint(equalToConstant: 80), contactImageView.heightAnchor.constraint(equalToConstant: 80)])
        
        NSLayoutConstraint.activate([contactImageViewBackground.topAnchor.constraint(equalTo: contactImageView.topAnchor), contactImageViewBackground.centerXAnchor.constraint(equalTo: view.centerXAnchor), contactImageViewBackground.widthAnchor.constraint(equalToConstant: 80), contactImageViewBackground.heightAnchor.constraint(equalToConstant: 80)])
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onProfileImageTapped))
        contactImageView.addGestureRecognizer(tapGesture)
        
        NSLayoutConstraint.activate([contactNameTextField.topAnchor.constraint(equalTo: contactImageView.bottomAnchor, constant: 8), contactNameTextField.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -16), contactNameTextField.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 16), contactNameTextField.heightAnchor.constraint(equalToConstant: 40)])
        
        NSLayoutConstraint.activate([contactPhoneTextField.topAnchor.constraint(equalTo: contactNameTextField.bottomAnchor, constant: 8), contactPhoneTextField.rightAnchor.constraint(equalTo: contactNameTextField.rightAnchor), contactPhoneTextField.leftAnchor.constraint(equalTo: contactNameTextField.leftAnchor), contactPhoneTextField.heightAnchor.constraint(equalToConstant: 40)])
        
        
        NSLayoutConstraint.activate([contactEmailTextField.topAnchor.constraint(equalTo: contactPhoneTextField.bottomAnchor, constant: 8), contactEmailTextField.rightAnchor.constraint(equalTo: contactNameTextField.rightAnchor), contactEmailTextField.leftAnchor.constraint(equalTo: contactNameTextField.leftAnchor), contactEmailTextField.heightAnchor.constraint(equalToConstant: 40)])

        
        NSLayoutConstraint.activate([saveButton.topAnchor.constraint(equalTo: contactEmailTextField.bottomAnchor, constant: 8), saveButton.rightAnchor.constraint(equalTo: contactNameTextField.rightAnchor), saveButton.leftAnchor.constraint(equalTo: contactNameTextField.leftAnchor), saveButton.heightAnchor.constraint(equalToConstant: 40)])
        
        
        saveButton.addSubview(saveProgressView)
        NSLayoutConstraint.activate([
            saveProgressView.bottomAnchor.constraint(equalTo: saveButton.bottomAnchor), saveProgressView.rightAnchor.constraint(equalTo: saveButton.rightAnchor, constant: -10), saveProgressView.leftAnchor.constraint(equalTo: saveButton.leftAnchor, constant: 10), saveProgressView.heightAnchor.constraint(equalToConstant: 5)])
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
    var contactNameTextField: CustomUITextField = {
        let cntf = CustomUITextField()
        cntf.placeholder = "Name"
        return cntf
    }()
    
    
    var contactPhoneTextField: CustomUITextField = {
        let cntf = CustomUITextField()
        cntf.placeholder = "Phone"
        cntf.keyboardType = .decimalPad
        return cntf
    }()
    
    var contactEmailTextField: CustomUITextField = {
        let cntf = CustomUITextField()
        cntf.placeholder = "Email"
        cntf.keyboardType = .emailAddress
        return cntf
    }()
    
    // Contact image
    
    var contactImageView: UIImageView = {
        let civ = UIImageView()
        civ.image = UIImage(named: "contact")
        civ.translatesAutoresizingMaskIntoConstraints = false
        civ.clipsToBounds = true
        civ.backgroundColor = .white
        civ.isUserInteractionEnabled = true
        civ.contentMode = .scaleAspectFill
        return civ
    }()
    
    
    var contactImageViewBackground: UIView = {
        let civb = UIView()
        civb.translatesAutoresizingMaskIntoConstraints = false
        civb.isUserInteractionEnabled = false
        civb.backgroundColor = .white
        civb.layer.cornerRadius = 10.0
        return civb
    }()
    
    // Save button
    
    var saveButton: CustomUIButton = {
        let cb = CustomUIButton(type: .system)
        cb.setTitle("Save", for: .normal)
        cb.addTarget(self, action: #selector(save), for: .touchUpInside)
        cb.backgroundColor = .green
        cb.layer.cornerRadius = 10.0
        cb.clipsToBounds = true
        return cb
    }()
    
    
    var saveProgressView: UIProgressView = {
        let pv = UIProgressView()
        pv.translatesAutoresizingMaskIntoConstraints = false
        pv.trackTintColor = UIColor.clear
        pv.tintColor = .white
        return pv
    }()
    // Function called to dismiss the view controller
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        contactImageView.layer.cornerRadius = 10.0
        contactNameTextField.addShadow()
        contactPhoneTextField.addShadow()
        contactEmailTextField.addShadow()
        contactImageViewBackground.layer.cornerRadius = 10.0
        contactImageViewBackground.addShadow()
        saveButton.addShadow()
    }
}


extension CreateContactViewController {
    @objc func save() {
        if contactNameTextField.text == "" || contactEmailTextField.text == "" || contactPhoneTextField.text == "" {
            return
        }
        saveProgressView.alpha = 1
        contactImageView.isUserInteractionEnabled = false
        contactNameTextField.isUserInteractionEnabled = false
        contactEmailTextField.isUserInteractionEnabled = false
        contactPhoneTextField.isUserInteractionEnabled = false
        saveButton.isUserInteractionEnabled = false
        
        let name = contactNameTextField.text
        let email = contactEmailTextField.text
        let phone = contactPhoneTextField.text
        let image = contactImageView.image

        if image != nil {
            
            // First just setting a name
            let contactId = UUID().uuidString
            var imageData = Data()
            if image != UIImage(named: "contact") {
                imageData = UIImageJPEGRepresentation(image!, 0)!
            }

            print("Image being saved:")
            print(imageData)
            let db = Firestore.firestore()
            let contactDictionary: [String: Any?] = ["name": name, "email": email, "phone": phone, "imageData": imageData]
            db.collection("Contacts").document(contactId).setData(contactDictionary)
            let banner = StatusBarNotificationBanner(title: "Saved", style: .success)
            banner.show()
            banner.duration = 0.5
            contactImageView.image = UIImage(named: "contact")
            contactNameTextField.text = ""
            contactEmailTextField.text = ""
            contactPhoneTextField.text = ""
            saveButton.isUserInteractionEnabled = true
            contactImageView.isUserInteractionEnabled = true
            contactNameTextField.isUserInteractionEnabled = true
            contactEmailTextField.isUserInteractionEnabled = true
            contactPhoneTextField.isUserInteractionEnabled = true
            saveButton.isUserInteractionEnabled = true
            contactNameTextField.becomeFirstResponder()
        }
    }
}

extension CreateContactViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @objc func onProfileImageTapped() {
        print("Trying to present")
        let picker = UIImagePickerController()
        
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        var selectedImageFromPicker: UIImage?
        
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            selectedImageFromPicker = editedImage
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            selectedImageFromPicker = originalImage
        }
        
        if let selectedImage = selectedImageFromPicker {
            contactImageView.image = selectedImage
            
        }
        dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
}

