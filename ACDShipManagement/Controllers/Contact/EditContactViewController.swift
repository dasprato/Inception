//
//  SelectContactViewController.swift
//  ACDShipManagement
//
//  Created by Prato Das on 2018-03-30.
//  Copyright © 2018 Prato Das. All rights reserved.
//

//import UIKit
//import Firebase
//class EditContactViewController: UIViewController {
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        fetchContacts()
//        view.backgroundColor = .gray
//    }
//
//
//    func fetchContacts() {
//        let db = Firestore.firestore()
//        db.collection("Contacts").getDocuments() { (querySnapshot, err) in
//            if let err = err {
//                print("Error getting documents: \(err)")
//            } else {
//                for document in querySnapshot!.documents {
//                    print("\(document.documentID)")
//                }
//            }
//        }
//    }
//
//
//
//
//
//}



import UIKit
import Firebase
import NotificationBannerSwift

class EditContactViewController: UIViewController {
    
    
    var arrayOfContacts: [Contact]? {
        didSet {
//            self.contactsCollectionView.reloadData()
        }
    }

    
    var contact: Contact? {
        didSet {
            
            print(contact)
            
            
            contactImageView.image = UIImage(data: (contact?.imageData)!)
            contactNameTextField.text = contact?.name
            contactEmailTextField.text  = contact?.email
            contactPhoneTextField.text = contact?.phone
            //            self.contactsCollectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(statusManager), name: .flagsChanged, object: Network.reachability)
        setupBarButtons()
        setupTextFieldsAndButtons()
    }
    
    func setupBarButtons() {
                view.backgroundColor = .darkGray
        
        let barButton = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(handleEdit))
        barButton.tintColor = .white
        self.navigationItem.setRightBarButton(barButton, animated: true)
    }
    
    @objc func handleEdit() {
        
    }
    func setupTextFieldsAndButtons() {
        view.addSubview(contactImageViewBackground)
        view.addSubview(contactImageView)
        view.addSubview(contactNameTextField)
        view.addSubview(contactPhoneTextField)
        view.addSubview(contactEmailTextField)
        view.addSubview(updateButton)
        view.addSubview(deleteButton)
        
        NSLayoutConstraint.activate([contactImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8), contactImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor), contactImageView.widthAnchor.constraint(equalToConstant: 80), contactImageView.heightAnchor.constraint(equalToConstant: 80)])
        
        NSLayoutConstraint.activate([contactImageViewBackground.topAnchor.constraint(equalTo: contactImageView.topAnchor), contactImageViewBackground.centerXAnchor.constraint(equalTo: view.centerXAnchor), contactImageViewBackground.widthAnchor.constraint(equalToConstant: 80), contactImageViewBackground.heightAnchor.constraint(equalToConstant: 80)])
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onProfileImageTapped))
        contactImageView.addGestureRecognizer(tapGesture)
        
        NSLayoutConstraint.activate([contactNameTextField.topAnchor.constraint(equalTo: contactImageView.bottomAnchor, constant: 8), contactNameTextField.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -16), contactNameTextField.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 16), contactNameTextField.heightAnchor.constraint(equalToConstant: 40)])
        
        NSLayoutConstraint.activate([contactPhoneTextField.topAnchor.constraint(equalTo: contactNameTextField.bottomAnchor, constant: 8), contactPhoneTextField.rightAnchor.constraint(equalTo: contactNameTextField.rightAnchor), contactPhoneTextField.leftAnchor.constraint(equalTo: contactNameTextField.leftAnchor), contactPhoneTextField.heightAnchor.constraint(equalToConstant: 40)])
        
        
        NSLayoutConstraint.activate([contactEmailTextField.topAnchor.constraint(equalTo: contactPhoneTextField.bottomAnchor, constant: 8), contactEmailTextField.rightAnchor.constraint(equalTo: contactNameTextField.rightAnchor), contactEmailTextField.leftAnchor.constraint(equalTo: contactNameTextField.leftAnchor), contactEmailTextField.heightAnchor.constraint(equalToConstant: 40)])
        
        
        NSLayoutConstraint.activate([updateButton.topAnchor.constraint(equalTo: contactEmailTextField.bottomAnchor, constant: 8), updateButton.rightAnchor.constraint(equalTo: contactNameTextField.rightAnchor), updateButton.leftAnchor.constraint(equalTo: contactNameTextField.leftAnchor), updateButton.heightAnchor.constraint(equalToConstant: 40)])
        
        NSLayoutConstraint.activate([deleteButton.topAnchor.constraint(equalTo: updateButton.bottomAnchor, constant: 8), deleteButton.rightAnchor.constraint(equalTo: contactNameTextField.rightAnchor), deleteButton.leftAnchor.constraint(equalTo: contactNameTextField.leftAnchor), deleteButton.heightAnchor.constraint(equalToConstant: 40)])
        
        
        updateButton.addSubview(saveProgressView)
        NSLayoutConstraint.activate([
            saveProgressView.bottomAnchor.constraint(equalTo: updateButton.bottomAnchor), saveProgressView.rightAnchor.constraint(equalTo: updateButton.rightAnchor, constant: -10), saveProgressView.leftAnchor.constraint(equalTo: updateButton.leftAnchor, constant: 10), saveProgressView.heightAnchor.constraint(equalToConstant: 5)])
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

    
    var updateButton: CustomUIButton = {
        let cb = CustomUIButton(type: .system)
        cb.setTitle("Update", for: .normal)
        cb.addTarget(self, action: #selector(handleUpdate), for: .touchUpInside)
        cb.backgroundColor = .blue
        cb.layer.cornerRadius = 10.0
        cb.clipsToBounds = true
        return cb
    }()
    
    var deleteButton: CustomUIButton = {
        let cb = CustomUIButton(type: .system)
        cb.setTitle("Delete", for: .normal)
        cb.addTarget(self, action: #selector(handleDelete), for: .touchUpInside)
        cb.backgroundColor = .red
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
        updateButton.addShadow()
        deleteButton.addShadow()
    }
}


extension EditContactViewController {
    
    @objc func handleDelete() {
        guard let contactId = contact?.contactId else { return }
        
        
        
        // Check if fields are emtpy
        print("Attempting to save contact to firebase")
        if contactNameTextField.text == "" || contactEmailTextField.text == "" || contactPhoneTextField.text == "" {
            print("ERROR")
            return
        }
        saveProgressView.alpha = 1
        makeViewDisabled()
        
        Firestore.firestore().collection("Contacts").document(contactId).delete { (err) in
            if let err = err {
                print ("Error removing document")
                

            } else {
                print ("Document removed successfully")
                
                let banner = StatusBarNotificationBanner(title: "Deleted", style: .success)
                banner.show()
                banner.duration = 0.5
                self.contactImageView.image = UIImage(named: "contact")
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    func makeViewDisabled() {
        contactImageView.isUserInteractionEnabled = false
        contactNameTextField.isUserInteractionEnabled = false
        contactEmailTextField.isUserInteractionEnabled = false
        contactPhoneTextField.isUserInteractionEnabled = false
        updateButton.isUserInteractionEnabled = false
        deleteButton.isUserInteractionEnabled = false
    }
    @objc func handleUpdate() {
        
        // Check if fields are emtpy
        print("Attempting to save contact to firebase")
        if contactNameTextField.text == "" || contactEmailTextField.text == "" || contactPhoneTextField.text == "" {
            print("ERROR")
            return
        }
        saveProgressView.alpha = 1
        makeViewDisabled()
        
        let name = contactNameTextField.text
        let email = contactEmailTextField.text
        let phone = contactPhoneTextField.text
        let image = contactImageView.image
        
            
            // First just setting a name
            guard let contactId = contact?.contactId else { return }
            var imageData = Data()
        if image != nil {
            imageData = UIImageJPEGRepresentation(image!, 0)!
            
        }
            
            let db = Firestore.firestore()
            let contactDictionary: [String: Any?] = ["name": name, "email": email, "phone": phone, "imageData": imageData]
            db.collection("Contacts").document(contactId).setData(contactDictionary)
            let banner = StatusBarNotificationBanner(title: "Updated", style: .success)
            banner.show()
            banner.duration = 0.5
            updateButton.isUserInteractionEnabled = true
            contactImageView.isUserInteractionEnabled = true
            contactNameTextField.isUserInteractionEnabled = true
            contactEmailTextField.isUserInteractionEnabled = true
            contactPhoneTextField.isUserInteractionEnabled = true
            updateButton.isUserInteractionEnabled = true
            deleteButton.isUserInteractionEnabled = true
        
    }
}

extension EditContactViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @objc func onProfileImageTapped() {
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


