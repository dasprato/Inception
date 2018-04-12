//
//  ViewController.swift
//  ACDShipManagement
//
//  Created by Prato Das on 2018-02-05.
//  Copyright © 2018 Prato Das. All rights reserved.
//

import UIKit
import Firebase
import QRCode

class ReadShipViewController: UIViewController {
    
    
    var arrayOfShips: [Ship]? {
        didSet {
            self.shipsCollectionView.reloadData()
        }
    }
    
    let contactsCollectionViewCellId = "contactsCollectionViewCellId"
    override func viewDidLoad() {
        super.viewDidLoad()
        arrayOfShips = [Ship]()
        fetchShips()
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
        view.addSubview(shipsCollectionView)
        [
            shipsCollectionView.topAnchor.constraint(equalTo: view.topAnchor),
            shipsCollectionView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            shipsCollectionView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            shipsCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ].forEach { (constraint) in
                constraint.isActive = true
        }
        
        shipsCollectionView.delegate = self
        shipsCollectionView.dataSource = self
        
        shipsCollectionView.register(ReadShipCollectionViewCell.self, forCellWithReuseIdentifier: contactsCollectionViewCellId)
    }
    
    var shipsCollectionView: UICollectionView = {
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
    
    func fetchShips() {
        let db = Firestore.firestore()
        db.collection("Ships").addSnapshotListener { (snapshot, error) in
            guard let _ = snapshot?.documents else {
                print("Error fetching documents: \(error!)")
                return
            }
            snapshot?.documentChanges.forEach({ (difference) in
                if (difference.type == .added) {
                    
                    guard let representativeEmail = difference.document.data()["representativeEmail"] as? String else { return }
                    guard let representativeName = difference.document.data()["representativeName"] as? String else { return }
                    guard let representativePhone = difference.document.data()["representativePhone"] as? String else { return }
                    guard let vesselCapacity = difference.document.data()["vesselCapacity"] as? String else { return }
                    
                    guard let currentStatus = difference.document.data()["currentStatus"] as? String else { return }
                    guard let vesselName = difference.document.data()["vesselName"] as? String else { return }
                    self.arrayOfShips?.append(Ship(representativeEmail: representativeEmail, representativeName: representativeName, representativePhone: representativePhone, vesselCapacity: vesselCapacity, vesselName: vesselName, shipId: difference.document.documentID, currentStatus: currentStatus))
                }
                
                if (difference.type == .modified) {
                    for i in 0..<self.arrayOfShips!.count {
                        if self.arrayOfShips![i].shipId == difference.document.documentID {
                            self.arrayOfShips![i] = (Ship(representativeEmail: difference.document.data()["representativeEmail"]! as? String, representativeName: difference.document.data()["representativeName"]! as? String, representativePhone: difference.document.data()["representativePhone"]! as? String, vesselCapacity: difference.document.data()["vesselCapacity"]! as? String, vesselName: difference.document.data()["vesselName"]! as? String, shipId: difference.document.documentID, currentStatus: difference.document.data()["currentStatus"]! as? String))
                            return
                        }
                    }
                }
                if (difference.type == .removed) {
                    // TODO: Find an efficient solution
                    print("Removed contact: \(difference.document.documentID)")
                    for i in 0..<self.arrayOfShips!.count {
                        if self.arrayOfShips![i].shipId == difference.document.documentID {
                            self.arrayOfShips?.remove(at: i)
                            return
                        }
                    }
                }
            })
        }
    }
}


extension ReadShipViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let numberOfContacts = self.arrayOfShips?.count {
            return numberOfContacts
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = QRCodeViewController()
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overCurrentContext
        vc.id = "Ship Id: " + self.arrayOfShips![indexPath.row].shipId!
        present(vc, animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = shipsCollectionView.dequeueReusableCell(withReuseIdentifier: contactsCollectionViewCellId, for: indexPath) as! ReadShipCollectionViewCell
        cell.ship = self.arrayOfShips![indexPath.row]
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width - 32, height: 64)
    }
}


class ReadShipCollectionViewCell: UICollectionViewCell {
    var ship: Ship {
        didSet {
            vesselNameTextField.text = ship.vesselName
            vesselCapacityTextField.text = ship.vesselCapacity
            vesselRepresentativeNameTextField.text = ship.representativeName
            currentStatusTextField.text = ship.currentStatus
            if ship.currentStatus == "Available" {
                statusViewCircle.backgroundColor = .green
            } else if ship.currentStatus == "Not Available" {
                statusViewCircle.backgroundColor = .red
            }
            let qrCode = QRCode("Ship Id: " + ship.shipId!)
            QRCodeImageView.image = qrCode?.image
        }
    }
    override init(frame: CGRect) {
        self.ship = Ship(representativeEmail: "", representativeName: "", representativePhone: "", vesselCapacity: "", vesselName: "", shipId: "", currentStatus: "")
        super.init(frame: frame)
        
        contentView.addSubview(contactImageViewBackground)
        contentView.addSubview(contactImageView)
        contentView.addSubview(vesselRepresentativeNameTextField)
        contentView.addSubview(vesselCapacityTextField)
        contentView.addSubview(vesselNameTextField)
        contentView.addSubview(QRCodeImageViewBackground)
        contentView.addSubview(QRCodeImageView)
        contentView.addSubview(statusViewCircle)
        contentView.addSubview(currentStatusTextField)
        
        NSLayoutConstraint.activate([contactImageView.topAnchor.constraint(equalTo: topAnchor), contactImageView.bottomAnchor.constraint(equalTo: bottomAnchor), contactImageView.leftAnchor.constraint(equalTo: leftAnchor), contactImageView.widthAnchor.constraint(equalTo: heightAnchor)])
        
        NSLayoutConstraint.activate([contactImageViewBackground.topAnchor.constraint(equalTo: topAnchor), contactImageViewBackground.bottomAnchor.constraint(equalTo: bottomAnchor), contactImageViewBackground.leftAnchor.constraint(equalTo: leftAnchor), contactImageViewBackground.widthAnchor.constraint(equalTo: heightAnchor)])
        contactImageViewBackground.addShadow()
        
        
        NSLayoutConstraint.activate([vesselNameTextField.topAnchor.constraint(equalTo: contactImageView.topAnchor), vesselNameTextField.leftAnchor.constraint(equalTo: contactImageView.rightAnchor, constant: 8)])
        
        NSLayoutConstraint.activate([vesselRepresentativeNameTextField.topAnchor.constraint(equalTo: vesselNameTextField.bottomAnchor), vesselRepresentativeNameTextField.leftAnchor.constraint(equalTo: vesselNameTextField.leftAnchor)])
        
        NSLayoutConstraint.activate([vesselCapacityTextField.topAnchor.constraint(equalTo: vesselRepresentativeNameTextField.bottomAnchor), vesselCapacityTextField.leftAnchor.constraint(equalTo: vesselNameTextField.leftAnchor)])
        
        
        NSLayoutConstraint.activate([currentStatusTextField.topAnchor.constraint(equalTo: vesselRepresentativeNameTextField.bottomAnchor), currentStatusTextField.leftAnchor.constraint(equalTo: statusViewCircle.rightAnchor, constant: 8)])
        
        NSLayoutConstraint.activate([statusViewCircle.centerYAnchor.constraint(equalTo: vesselCapacityTextField.centerYAnchor), statusViewCircle.leftAnchor.constraint(equalTo: vesselCapacityTextField.rightAnchor, constant: 8), statusViewCircle.heightAnchor.constraint(equalToConstant: 10), statusViewCircle.widthAnchor.constraint(equalToConstant: 10)])
        
        
        NSLayoutConstraint.activate([QRCodeImageViewBackground.topAnchor.constraint(equalTo: topAnchor), QRCodeImageViewBackground.bottomAnchor.constraint(equalTo: bottomAnchor), QRCodeImageViewBackground.rightAnchor.constraint(equalTo: rightAnchor), QRCodeImageViewBackground.widthAnchor.constraint(equalTo: heightAnchor)])
        
        NSLayoutConstraint.activate([QRCodeImageView.topAnchor.constraint(equalTo: topAnchor), QRCodeImageView.bottomAnchor.constraint(equalTo: bottomAnchor), QRCodeImageView.rightAnchor.constraint(equalTo: rightAnchor), QRCodeImageView.widthAnchor.constraint(equalTo: heightAnchor)])
        QRCodeImageViewBackground.addShadow()
    }
    
    
    // Text fields
    private var vesselNameTextField: UILabel = {
        let cntf = UILabel()
        cntf.translatesAutoresizingMaskIntoConstraints = false
        cntf.textColor = .white
        cntf.font = UIFont.boldSystemFont(ofSize: cntf.font.pointSize + 2)
        return cntf
    }()
    
    
    private var vesselRepresentativeNameTextField: UILabel = {
        let cntf = UILabel()
        cntf.translatesAutoresizingMaskIntoConstraints = false
        cntf.textColor = .white
        return cntf
    }()
    
    
    private var currentStatusTextField: UILabel = {
        let cntf = UILabel()
        cntf.translatesAutoresizingMaskIntoConstraints = false
        cntf.textColor = .white
        return cntf
    }()
    
    private var vesselCapacityTextField: UILabel = {
        let cntf = UILabel()
        cntf.translatesAutoresizingMaskIntoConstraints = false
        cntf.textColor = .white
        return cntf
    }()
    
    
    private var statusViewCircle: UIView = {
        let cntf = UIView()
        cntf.translatesAutoresizingMaskIntoConstraints = false
        cntf.layer.cornerRadius = 5.0
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



