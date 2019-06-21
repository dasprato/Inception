//
//  ReadContactViewController.swift
//  ACDShipManagement
//
//  Created by Prato Das on 2018-03-31.
//  Copyright © 2018 Prato Das. All rights reserved.
//

import UIKit
import Firebase
import QRCode

class ReadContactViewController: UIViewController {

    
    var arrayOfContacts: [Contact]? {
        didSet {
            self.contactsCollectionView.reloadData()
        }
    }
    
    let contactsCollectionViewCellId = "contactsCollectionViewCellId"
    override func viewDidLoad() {
        super.viewDidLoad()
        arrayOfContacts = [Contact]()
        fetchContacts()
        setupCollectionView()
//        setupBar()
        setupBarWithBaiscStyling(self)
        

        
        
        searchBar.placeholder = "Search"
        navigationItem.titleView = searchBar
        searchBar.becomeFirstResponder()

    }

    
    func setupCollectionView() {
        view.addSubview(contactsCollectionView)
        [
            contactsCollectionView.topAnchor.constraint(equalTo: view.topAnchor),
            contactsCollectionView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            contactsCollectionView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            contactsCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ].forEach { (constraint) in
                constraint.isActive = true
        }
        
        contactsCollectionView.delegate = self
        contactsCollectionView.dataSource = self
        
        contactsCollectionView.register(ReadContactCollectionViewCell.self, forCellWithReuseIdentifier: contactsCollectionViewCellId)
    }
    
    var contactsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 8
        layout.minimumInteritemSpacing = 0
        layout.sectionHeadersPinToVisibleBounds = true
        let ccv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        ccv.translatesAutoresizingMaskIntoConstraints = false
        ccv.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        ccv.keyboardDismissMode = .interactive
        ccv.tag = 0
        ccv.isScrollEnabled = true
        ccv.bounces = true
        ccv.alwaysBounceVertical = true
        ccv.backgroundColor = .clear
        return ccv
    }()
    
    var searchBar: UISearchBar = {
        let sb = UISearchBar(frame: CGRect.zero)
        sb.translatesAutoresizingMaskIntoConstraints = false
        sb.barStyle = .black
        let textFieldInsideSearchBar = sb.value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBar?.textColor = .white
        sb.keyboardAppearance = .dark
        
        sb.placeholder = "Search"
        return sb
    }()
    
    func fetchContacts() {
        let db = Firestore.firestore()
        db.collection("Contacts").addSnapshotListener { (snapshot, error) in
            guard let _ = snapshot?.documents else {
                print("Error fetching documents: \(error!)")
                return
            }
            snapshot?.documentChanges.forEach({ (difference) in
                if (difference.type == .added) {
                    
                    guard let name = difference.document.data()["name"] as? String else { return }
                    guard let imageData = difference.document.data()["imageData"] as? Data else { return }
                    guard let phone = difference.document.data()["phone"] as? String else { return }
                    guard let email = difference.document.data()["email"] as? String else { return }
                    
                    self.arrayOfContacts?.append(Contact(email: email, imageData: imageData, name: name, phone: phone, contactId: difference.document.documentID))
                }
                
                if (difference.type == .modified) {
                    for i in 0..<self.arrayOfContacts!.count {
                        if self.arrayOfContacts![i].contactId == difference.document.documentID {
                            self.arrayOfContacts![i] = Contact(email: difference.document.data()["email"]! as? String, imageData: difference.document.data()["imageData"]! as? Data, name: (difference.document.data()["name"]! as! String), phone: difference.document.data()["phone"]! as? String, contactId: difference.document.documentID)
                        
                            return
                        }
                    }
                }
                if (difference.type == .removed) {
                    // TODO: Find an efficient solution
                    for i in 0..<self.arrayOfContacts!.count {
                        if self.arrayOfContacts![i].contactId == difference.document.documentID {
                            self.arrayOfContacts?.remove(at: i)
                            return
                        }
                    }
                }
            })
        }
    }
}


extension ReadContactViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let numberOfContacts = self.arrayOfContacts?.count {
            return numberOfContacts
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let vc = QRCodeViewController()
//        vc.modalTransitionStyle = .crossDissolve
//        vc.modalPresentationStyle = .overCurrentContext
//        vc.id = "Contact Id: " + self.arrayOfContacts![indexPath.row].contactId!
//        present(vc, animated: true, completion: nil)
//
        
        searchBar.resignFirstResponder()
        
        
        let vc = EditContactViewController()
//        vc.contact = self
        vc.contact = arrayOfContacts![indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
        
//        let vc = QRCodeViewController()
//        vc.modalTransitionStyle = .crossDissolve
//        vc.modalPresentationStyle = .overCurrentContext
//        vc.id = "Ship Id: " + self.arrayOfShips![indexPath.row].shipId!
//        present(vc, animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = contactsCollectionView.dequeueReusableCell(withReuseIdentifier: contactsCollectionViewCellId, for: indexPath) as! ReadContactCollectionViewCell
        cell.contact = self.arrayOfContacts![indexPath.row]
        return cell
    }
    

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width - 32, height: 64)
    }
}

class ReadContactCollectionViewCell: UICollectionViewCell {
    var contact: Contact {
        didSet {
            contactNameTextField.text = contact.name
            contactEmailTextField.text = contact.email
            contactPhoneTextField.text = contact.phone
            contactImageView.image = UIImage(data: contact.imageData ?? Data())
            let qrCode = QRCode("Contact Id: " + contact.contactId!)
            QRCodeImageView.image = qrCode?.image
            
            
        }
    }
    override init(frame: CGRect) {
        self.contact = Contact(email: "", imageData: Data(), name: "", phone: "", contactId: "")
        super.init(frame: frame)

        contentView.addSubview(contactImageViewBackground)
        contentView.addSubview(contactImageView)
        contentView.addSubview(contactPhoneTextField)
        contentView.addSubview(contactEmailTextField)
        contentView.addSubview(contactNameTextField)
        contentView.addSubview(QRCodeImageViewBackground)
        contentView.addSubview(QRCodeImageView)
        
        NSLayoutConstraint.activate([contactImageView.topAnchor.constraint(equalTo: topAnchor), contactImageView.bottomAnchor.constraint(equalTo: bottomAnchor), contactImageView.leftAnchor.constraint(equalTo: leftAnchor), contactImageView.widthAnchor.constraint(equalTo: heightAnchor)])
        
        NSLayoutConstraint.activate([contactImageViewBackground.topAnchor.constraint(equalTo: topAnchor), contactImageViewBackground.bottomAnchor.constraint(equalTo: bottomAnchor), contactImageViewBackground.leftAnchor.constraint(equalTo: leftAnchor), contactImageViewBackground.widthAnchor.constraint(equalTo: heightAnchor)])
        contactImageViewBackground.addShadow()
        
        
        NSLayoutConstraint.activate([contactNameTextField.topAnchor.constraint(equalTo: contactImageView.topAnchor), contactNameTextField.leftAnchor.constraint(equalTo: contactImageView.rightAnchor, constant: 8)])
        
        NSLayoutConstraint.activate([contactPhoneTextField.topAnchor.constraint(equalTo: contactNameTextField.bottomAnchor), contactPhoneTextField.leftAnchor.constraint(equalTo: contactNameTextField.leftAnchor)])
        
        NSLayoutConstraint.activate([contactEmailTextField.topAnchor.constraint(equalTo: contactPhoneTextField.bottomAnchor), contactEmailTextField.leftAnchor.constraint(equalTo: contactNameTextField.leftAnchor)])
        
        
        NSLayoutConstraint.activate([QRCodeImageViewBackground.topAnchor.constraint(equalTo: topAnchor), QRCodeImageViewBackground.bottomAnchor.constraint(equalTo: bottomAnchor), QRCodeImageViewBackground.rightAnchor.constraint(equalTo: rightAnchor), QRCodeImageViewBackground.widthAnchor.constraint(equalTo: heightAnchor)])
        
        NSLayoutConstraint.activate([QRCodeImageView.topAnchor.constraint(equalTo: topAnchor), QRCodeImageView.bottomAnchor.constraint(equalTo: bottomAnchor), QRCodeImageView.rightAnchor.constraint(equalTo: rightAnchor), QRCodeImageView.widthAnchor.constraint(equalTo: heightAnchor)])
        QRCodeImageViewBackground.addShadow()
    }
    
    
    // Text fields
    private var contactNameTextField: UILabel = {
        let cntf = UILabel()
        cntf.translatesAutoresizingMaskIntoConstraints = false
        cntf.textColor = .white
        cntf.font = UIFont.boldSystemFont(ofSize: cntf.font.pointSize + 2)
        return cntf
    }()
    
    
    private var contactPhoneTextField: UILabel = {
        let cntf = UILabel()
        cntf.translatesAutoresizingMaskIntoConstraints = false
        cntf.textColor = .white
        return cntf
    }()
    
    private var contactEmailTextField: UILabel = {
        let cntf = UILabel()
        cntf.translatesAutoresizingMaskIntoConstraints = false
        cntf.textColor = .white
        return cntf
    }()
    
    // Contact image
    
    private var contactImageView: UIImageView = {
        let civ = UIImageView()
        civ.image = UIImage(named: "contact")
        civ.translatesAutoresizingMaskIntoConstraints = false
        civ.clipsToBounds = true
        civ.backgroundColor = .white
        civ.isUserInteractionEnabled = true
        civ.contentMode = .scaleAspectFill
        civ.layer.cornerRadius = 10.0
        return civ
    }()
    
    
    private var contactImageViewBackground: UIView = {
        let civb = UIView()
        civb.translatesAutoresizingMaskIntoConstraints = false
        civb.isUserInteractionEnabled = false
        civb.backgroundColor = .white
        civb.layer.cornerRadius = 10.0
        return civb
    }()
    
    
    // QRCode image
    
    var QRCodeImageView: UIImageView = {
        let civ = UIImageView()
        civ.image = UIImage(named: "contact")
        civ.translatesAutoresizingMaskIntoConstraints = false
        civ.clipsToBounds = true
        civ.backgroundColor = .white
        civ.isUserInteractionEnabled = true
        civ.contentMode = .scaleAspectFit
        civ.layer.cornerRadius = 5.0
        return civ
    }()
    
    
    private var QRCodeImageViewBackground: UIView = {
        let civb = UIView()
        civb.translatesAutoresizingMaskIntoConstraints = false
        civb.isUserInteractionEnabled = false
        civb.backgroundColor = .white
        civb.layer.cornerRadius = 5.0
        return civb
    }()
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
