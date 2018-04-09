//
//  SailTripViewController1.swift
//  ACDShipManagement
//
//  Created by Prato Das on 2018-04-03.
//  Copyright © 2018 Prato Das. All rights reserved.
//

import UIKit
import Firebase
import QRCode

class SailTripViewController1: UIViewController {
    
    var arrayOfShipNames: [String] = [String]()
    var arrayOfTrips: [Trip]? {
        didSet {
            self.tripsCollectionView.reloadData()
        }
    }
    
    let contactsCollectionViewCellId = "contactsCollectionViewCellId"
    override func viewDidLoad() {
        super.viewDidLoad()
        arrayOfTrips = [Trip]()
        fetchTrips()
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
        view.addSubview(tripsCollectionView)
        [
            tripsCollectionView.topAnchor.constraint(equalTo: view.topAnchor),
            tripsCollectionView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            tripsCollectionView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            tripsCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ].forEach { (constraint) in
                constraint.isActive = true
        }
        
        tripsCollectionView.delegate = self
        tripsCollectionView.dataSource = self
        
        tripsCollectionView.register(SailTripCollectionViewCell.self, forCellWithReuseIdentifier: contactsCollectionViewCellId)
    }
    
    var tripsCollectionView: UICollectionView = {
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
    
    func fetchTrips() {
        let db = Firestore.firestore()
        db.collection("Trips").addSnapshotListener { (snapshot, error) in
            guard let _ = snapshot?.documents else {
                print("Error fetching documents: \(error!)")
                return
            }
            snapshot?.documentChanges.forEach({ (difference) in
                if (difference.type == .added) {
                    guard let amount = difference.document.data()["amount"] as? String else { return }
                    guard let cargo = difference.document.data()["cargo"] as? String else { return }
                    guard let from = difference.document.data()["from"] as? String else { return }
                    guard let to = difference.document.data()["to"] as? String else { return }
                    guard let initialised = difference.document.data()["initialised"] as? String else { return }

                    guard let vesselReferencePath = difference.document.data()["vesselReferencePath"] as? String else { return }
                    guard let tripStatus = difference.document.data()["tripStatus"] as? String else { return }
                    guard let fromDate = difference.document.data()["fromDate"] as? String else { return }
                    guard let toDate = difference.document.data()["toDate"] as? String else { return }
                    
                    var vesselName = ""
                    let docRef = db.collection("Ships").document(vesselReferencePath)
                    docRef.getDocument { (document, error) in
                        if let document = document {
                            vesselName = document.data()!["vesselName"] as! String
                            
                            self.arrayOfTrips?.append(Trip(amount: amount, cargo: cargo, from: from, to: to, initiliased: tripStatus, tripStatus: tripStatus, vesselReferencePath: vesselReferencePath, tripId: difference.document.documentID, fromDate: fromDate, toDate: toDate, vesselName: vesselName))
                        } else {
                            print("Document does not exist")
                        }
                    }
                }
                
                if (difference.type == .modified) {
                    for i in 0..<self.arrayOfTrips!.count {
                        if self.arrayOfTrips![i].tripId == difference.document.documentID {
                            guard let amount = difference.document.data()["amount"] as? String else { return }
                            guard let cargo = difference.document.data()["cargo"] as? String else { return }
                            guard let from = difference.document.data()["from"] as? String else { return }
                            guard let to = difference.document.data()["to"] as? String else { return }
                            guard let initialised = difference.document.data()["initialised"] as? String else { return }
                            guard let vesselReferencePath = difference.document.data()["vesselReferencePath"] as? String else { return }
                            guard let tripStatus = difference.document.data()["tripStatus"] as? String else { return }
                            guard let fromDate = difference.document.data()["fromDate"] as? String else { return }
                            guard let toDate = difference.document.data()["toDate"] as? String else { return }
                            
                            
                            var vesselName = ""
                            let docRef = db.collection("Ships").document(vesselReferencePath)
                            docRef.getDocument { (document, error) in
                                if let document = document {
                                    vesselName = document.data()!["vesselName"] as! String
                                   self.arrayOfTrips![i] = Trip(amount: amount, cargo: cargo, from: from, to: to, initiliased: tripStatus, tripStatus: tripStatus, vesselReferencePath: vesselReferencePath, tripId: difference.document.documentID, fromDate: fromDate, toDate: toDate, vesselName: vesselName)
                                } else {
                                    print("Document does not exist")
                                }
                            }
                            return
                        }
                    }
                }
                if (difference.type == .removed) {
                    // TODO: Find an efficient solution
                    print("Removed contact: \(difference.document.documentID)")
                    for i in 0..<self.arrayOfTrips!.count {
                        if self.arrayOfTrips![i].tripId == difference.document.documentID {
                            self.arrayOfTrips?.remove(at: i)
                            return
                        }
                    }
                }
            })
        }
    }
}


extension SailTripViewController1: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let numberOfContacts = self.arrayOfTrips?.count {
            return numberOfContacts
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = UINavigationController(rootViewController: SailTripViewController2())
        ConnectionBetweenVC.tripID = "Trip Id: " + self.arrayOfTrips![indexPath.row].tripId!
        ConnectionBetweenVC.trip = self.arrayOfTrips![indexPath.row]
        present(vc, animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = tripsCollectionView.dequeueReusableCell(withReuseIdentifier: contactsCollectionViewCellId, for: indexPath) as! SailTripCollectionViewCell
        cell.trip = self.arrayOfTrips![indexPath.row]
        
        return cell
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width - 32, height: 64)
    }
}



class SailTripCollectionViewCell: UICollectionViewCell {
    var trip: Trip {
        didSet {
            fromLabel.text = trip.from! + " ⛵️ "
            toLabel.text = trip.to!
            fromDateLabel.text = trip.fromDate! + "  📆  "
            toDateLabel.text = trip.toDate
            vesselNameLabel.text = trip.vesselName
            if trip.tripStatus == "Initialised" {
                statusViewCircle.backgroundColor = .blue
            } else if trip.tripStatus == "In Trip" {
                statusViewCircle.backgroundColor = .green
            }
            let qrCode = QRCode("Trip Id: " + trip.tripId!)
            QRCodeImageView.image = qrCode?.image
        }
    }
    
    var shipName: String {
        didSet {
            vesselNameLabel.text = shipName
        }
    }
    override init(frame: CGRect) {
        self.trip = Trip(amount: "", cargo: "", from: "", to: "", initiliased: "", tripStatus: "", vesselReferencePath: "", tripId: "", fromDate: "", toDate: "", vesselName: "")
        self.shipName = ""
        super.init(frame: frame)
        
        contentView.addSubview(vesselNameLabel)
        contentView.addSubview(fromLabel)
        contentView.addSubview(toLabel)
        contentView.addSubview(fromDateLabel)
        contentView.addSubview(toDateLabel)
        contentView.addSubview(QRCodeImageViewBackground)
        contentView.addSubview(QRCodeImageView)
        
        
        NSLayoutConstraint.activate([vesselNameLabel.topAnchor.constraint(equalTo: topAnchor), vesselNameLabel.leftAnchor.constraint(equalTo: leftAnchor)])
        NSLayoutConstraint.activate([fromLabel.topAnchor.constraint(equalTo: vesselNameLabel.bottomAnchor), fromLabel.leftAnchor.constraint(equalTo: leftAnchor)])
        NSLayoutConstraint.activate([toLabel.topAnchor.constraint(equalTo: vesselNameLabel.bottomAnchor), toLabel.leftAnchor.constraint(equalTo: fromLabel.rightAnchor)])
        
        NSLayoutConstraint.activate([fromDateLabel.topAnchor.constraint(equalTo: fromLabel.bottomAnchor), fromDateLabel.leftAnchor.constraint(equalTo: fromLabel.leftAnchor)])
        NSLayoutConstraint.activate([toDateLabel.topAnchor.constraint(equalTo: toLabel.bottomAnchor), toDateLabel.leftAnchor.constraint(equalTo: fromDateLabel.rightAnchor)])
        
        
        
        NSLayoutConstraint.activate([QRCodeImageViewBackground.topAnchor.constraint(equalTo: topAnchor), QRCodeImageViewBackground.bottomAnchor.constraint(equalTo: bottomAnchor), QRCodeImageViewBackground.rightAnchor.constraint(equalTo: rightAnchor), QRCodeImageViewBackground.widthAnchor.constraint(equalTo: heightAnchor)])
        
        NSLayoutConstraint.activate([QRCodeImageView.topAnchor.constraint(equalTo: topAnchor), QRCodeImageView.bottomAnchor.constraint(equalTo: bottomAnchor), QRCodeImageView.rightAnchor.constraint(equalTo: rightAnchor), QRCodeImageView.widthAnchor.constraint(equalTo: heightAnchor)])
        
        
        QRCodeImageViewBackground.addShadow()
        
    }
    
    
    // Text fields
    private var fromLabel: UILabel = {
        let cntf = UILabel()
        cntf.translatesAutoresizingMaskIntoConstraints = false
        cntf.textColor = .white
        cntf.font = UIFont.boldSystemFont(ofSize: cntf.font.pointSize + 2)
        return cntf
    }()
    
    
    private var toLabel: UILabel = {
        let cntf = UILabel()
        cntf.translatesAutoresizingMaskIntoConstraints = false
        cntf.textColor = .white
        cntf.font = UIFont.boldSystemFont(ofSize: cntf.font.pointSize + 2)
        return cntf
    }()
    
    
    private var fromDateLabel: UILabel = {
        let cntf = UILabel()
        cntf.translatesAutoresizingMaskIntoConstraints = false
        cntf.textColor = .white
        return cntf
    }()
    
    private var toDateLabel: UILabel = {
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
    
    private var statusLabel: UILabel = {
        let cntf = UILabel()
        cntf.translatesAutoresizingMaskIntoConstraints = false
        cntf.textColor = .white
        return cntf
    }()
    
    private var vesselNameLabel: UILabel = {
        let cntf = UILabel()
        cntf.translatesAutoresizingMaskIntoConstraints = false
        cntf.textColor = .white
        cntf.font = UIFont.boldSystemFont(ofSize: cntf.font.pointSize + 2)
        return cntf
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

