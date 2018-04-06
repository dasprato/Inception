//
//  ReadCompanyViewController.swift
//  ACDShipManagement
//
//  Created by Prato Das on 2018-02-05.
//  Copyright © 2018 Prato Das. All rights reserved.
//

import UIKit
import Firebase
import QRCode

class ReadCompanyViewController: UIViewController {
    
    
    var arrayOfCompanies: [Company]? {
        didSet {
            self.companiesCollectionView.reloadData()
        }
    }
    
    let contactsCollectionViewCellId = "contactsCollectionViewCellId"
    override func viewDidLoad() {
        super.viewDidLoad()
        arrayOfCompanies = [Company]()
        fetchCompanies()
        setupCollectionView()
        
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationController?.navigationBar.barTintColor = .gray
        self.navigationController?.navigationBar.addShadow()
        view.backgroundColor = .darkGray
        
        let barButtonClose = UIBarButtonItem(image: UIImage(named: "arrow")?.withRenderingMode(.alwaysTemplate), style: .plain, target: self, action: #selector(closeView(_:)))
        barButtonClose.tintColor = .white
        self.navigationItem.setLeftBarButton(barButtonClose, animated: true)
        
        
        searchBar.placeholder = "Search"
        navigationItem.titleView = searchBar
        searchBar.becomeFirstResponder()
    }
    
    func setupCollectionView() {
        view.addSubview(companiesCollectionView)
        [
            companiesCollectionView.topAnchor.constraint(equalTo: view.topAnchor),
            companiesCollectionView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            companiesCollectionView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            companiesCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ].forEach { (constraint) in
                constraint.isActive = true
        }
        
        companiesCollectionView.delegate = self
        companiesCollectionView.dataSource = self
        
        companiesCollectionView.register(ReadCompanyCollectionViewCell.self, forCellWithReuseIdentifier: contactsCollectionViewCellId)
    }
    
    var companiesCollectionView: UICollectionView = {
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
    
    func fetchCompanies() {
        let db = Firestore.firestore()
        db.collection("Companies").addSnapshotListener { (snapshot, error) in
            guard let _ = snapshot?.documents else {
                print("Error fetching documents: \(error!)")
                return
            }
            snapshot?.documentChanges.forEach({ (difference) in
                if (difference.type == .added) {
                    guard let companyAddress = difference.document.data()["companyAddress"] as? String else { return }
                    guard let companyName = difference.document.data()["companyName"] as? String else { return }
                    guard let representativeEmail = difference.document.data()["representativeEmail"] as? String else { return }
                    guard let representativeName = difference.document.data()["representativeName"] as? String else { return }
                    guard let representativePhone = difference.document.data()["representativePhone"] as? String else { return }
                    
                    self.arrayOfCompanies?.append(Company(companyAddress: companyAddress, companyName: companyName, representativeEmail: representativeEmail, representativeName: representativeName, representativePhone: representativePhone, companyId: difference.document.documentID))
                }
                
                if (difference.type == .modified) {
                    for i in 0..<self.arrayOfCompanies!.count {
                        if self.arrayOfCompanies![i].companyId == difference.document.documentID {
                            self.arrayOfCompanies![i] = (Company(companyAddress: difference.document.data()["companyAddress"]! as? String, companyName: difference.document.data()["companyName"]! as? String, representativeEmail: difference.document.data()["representativeEmail"]! as? String, representativeName: difference.document.data()["representativeName"]! as? String, representativePhone: difference.document.data()["representativePhone"]! as? String, companyId: difference.document.documentID))
                            return
                        }
                    }
                }
                if (difference.type == .removed) {
                    // TODO: Find an efficient solution
                    print("Removed contact: \(difference.document.documentID)")
                    for i in 0..<self.arrayOfCompanies!.count {
                        if self.arrayOfCompanies![i].companyId == difference.document.documentID {
                            self.arrayOfCompanies?.remove(at: i)
                            return
                        }
                    }
                }
            })
        }
    }
}


extension ReadCompanyViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let numberOfContacts = self.arrayOfCompanies?.count {
            return numberOfContacts
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = QRCodeViewController()
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overCurrentContext
        vc.id = "Company Id: " + self.arrayOfCompanies![indexPath.row].companyId!
        present(vc, animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = companiesCollectionView.dequeueReusableCell(withReuseIdentifier: contactsCollectionViewCellId, for: indexPath) as! ReadCompanyCollectionViewCell
        cell.company = self.arrayOfCompanies![indexPath.row]
        
        return cell
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width - 32, height: 64)
    }
}

class ReadCompanyCollectionViewCell: UICollectionViewCell {
    var company: Company {
        didSet {
            companyNameTextField.text = company.companyName
            companyRepresentativeNameTextField.text = company.representativeName
            companyRepresentativePhoneTextField.text = company.representativePhone
            let qrCode = QRCode("Company Id: " + company.companyId!)
            QRCodeImageView.image = qrCode?.image
        }
    }
    override init(frame: CGRect) {
        self.company = Company(companyAddress: "", companyName: "", representativeEmail: "", representativeName: "", representativePhone: "", companyId: "")
        super.init(frame: frame)
        
        contentView.addSubview(contactImageViewBackground)
        contentView.addSubview(contactImageView)
        contentView.addSubview(companyRepresentativeNameTextField)
        contentView.addSubview(companyRepresentativePhoneTextField)
        contentView.addSubview(companyNameTextField)
        contentView.addSubview(QRCodeImageViewBackground)
        contentView.addSubview(QRCodeImageView)
        
        NSLayoutConstraint.activate([contactImageView.topAnchor.constraint(equalTo: topAnchor), contactImageView.bottomAnchor.constraint(equalTo: bottomAnchor), contactImageView.leftAnchor.constraint(equalTo: leftAnchor), contactImageView.widthAnchor.constraint(equalTo: heightAnchor)])
        
        NSLayoutConstraint.activate([contactImageViewBackground.topAnchor.constraint(equalTo: topAnchor), contactImageViewBackground.bottomAnchor.constraint(equalTo: bottomAnchor), contactImageViewBackground.leftAnchor.constraint(equalTo: leftAnchor), contactImageViewBackground.widthAnchor.constraint(equalTo: heightAnchor)])
        contactImageViewBackground.addShadow()
        
        
        NSLayoutConstraint.activate([companyNameTextField.topAnchor.constraint(equalTo: contactImageView.topAnchor), companyNameTextField.leftAnchor.constraint(equalTo: contactImageView.rightAnchor, constant: 8)])
        
        NSLayoutConstraint.activate([companyRepresentativeNameTextField.topAnchor.constraint(equalTo: companyNameTextField.bottomAnchor), companyRepresentativeNameTextField.leftAnchor.constraint(equalTo: companyNameTextField.leftAnchor)])
        
        NSLayoutConstraint.activate([companyRepresentativePhoneTextField.topAnchor.constraint(equalTo: companyRepresentativeNameTextField.bottomAnchor), companyRepresentativePhoneTextField.leftAnchor.constraint(equalTo: companyNameTextField.leftAnchor)])
        
        
        NSLayoutConstraint.activate([QRCodeImageViewBackground.topAnchor.constraint(equalTo: topAnchor), QRCodeImageViewBackground.bottomAnchor.constraint(equalTo: bottomAnchor), QRCodeImageViewBackground.rightAnchor.constraint(equalTo: rightAnchor), QRCodeImageViewBackground.widthAnchor.constraint(equalTo: heightAnchor)])
        
        NSLayoutConstraint.activate([QRCodeImageView.topAnchor.constraint(equalTo: topAnchor), QRCodeImageView.bottomAnchor.constraint(equalTo: bottomAnchor), QRCodeImageView.rightAnchor.constraint(equalTo: rightAnchor), QRCodeImageView.widthAnchor.constraint(equalTo: heightAnchor)])
        QRCodeImageViewBackground.addShadow()
    }
    
    
    // Text fields
    private var companyNameTextField: UILabel = {
        let cntf = UILabel()
        cntf.translatesAutoresizingMaskIntoConstraints = false
        cntf.textColor = .white
        cntf.font = UIFont.boldSystemFont(ofSize: cntf.font.pointSize + 2)
        return cntf
    }()
    
    
    private var companyRepresentativeNameTextField: UILabel = {
        let cntf = UILabel()
        cntf.translatesAutoresizingMaskIntoConstraints = false
        cntf.textColor = .white
        return cntf
    }()
    
    private var companyRepresentativePhoneTextField: UILabel = {
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

