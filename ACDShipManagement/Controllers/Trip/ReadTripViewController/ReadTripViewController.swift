//
//  ReadTripViewController.swift
//  ACDShipManagement
//
//  Created by Prato Das on 2018-04-13.
//  Copyright © 2018 Prato Das. All rights reserved.
//

import UIKit
import QRCode
import Firebase

class ReadTripViewController: InteractiveViewController {
    
    var arrayOfShipNames: [Ship] = [Ship]()
    var arrayOfTrips: [Trip]? {
        didSet {
            self.tripsCollectionView.reloadData()
        }
    }
    let colors = Colors()
    var backgroundLayer = CAGradientLayer()
    
    func refresh() {
        view.backgroundColor = UIColor.clear
        backgroundLayer = colors.gl
        view.layer.insertSublayer(backgroundLayer, at: 0)
    }

    
    override func viewDidLayoutSubviews() {
        self.backgroundLayer.frame = view.frame
    }

    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.prefersLargeTitles = false
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
        self.navigationController?.title = ""
        self.navigationController?.navigationBar.topItem?.title = ""
        view.backgroundColor = .darkGray
        
        self.navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.darkGray]
        self.navigationController?.navigationBar.barTintColor = .darkGray
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        let barButtonClose = UIBarButtonItem(image: UIImage(named: "arrow")?.withRenderingMode(.alwaysTemplate), style: .plain, target: self, action: #selector(closeView(_:)))
        barButtonClose.tintColor = .white
        self.navigationItem.setLeftBarButton(barButtonClose, animated: true)
        
        searchBar.placeholder = "Search"
        navigationItem.titleView = searchBar
        
        searchBar.becomeFirstResponder()
        refresh()
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
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        refresh()
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
                    
                    guard let vesselReferencePath = difference.document.data()["vesselReferencePath"] as? String else { return }
                    guard let tripStatus = difference.document.data()["tripStatus"] as? String else { return }
                    guard let fromDate = difference.document.data()["fromDate"] as? String else { return }
                    guard let toDate = difference.document.data()["toDate"] as? String else { return }
                    
                    var vesselName = ""
                    var representativeEmail = ""
                    var representativeName = ""
                    var representativePhone = ""
                    var vesselCapacity = ""
                    var shipId = ""
                    var currentStatus = ""
                    let docRef = db.collection("Ships").document(vesselReferencePath)
                    docRef.getDocument { (document, error) in
                        if let document = document {
                            vesselName = document.data()!["vesselName"] as! String
                            representativeEmail = document.data()!["representativeEmail"] as! String
                            representativeName = document.data()!["representativeName"] as! String
                            representativePhone = document.data()!["representativePhone"] as! String
                            vesselCapacity = document.data()!["vesselCapacity"] as! String
                            currentStatus = document.data()!["currentStatus"] as! String
                            shipId = document.documentID
                            
                            self.arrayOfShipNames.append(Ship(representativeEmail: representativeEmail, representativeName: representativeName, representativePhone: representativePhone, vesselCapacity: vesselCapacity, vesselName: vesselName, shipId: shipId, currentStatus: currentStatus))
                            self.arrayOfTrips?.append(Trip(amount: amount, cargo: cargo, from: from, to: to, tripStatus: tripStatus, vesselReferencePath: vesselReferencePath, tripId: difference.document.documentID, fromDate: fromDate, toDate: toDate, vesselName: vesselName))
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
                            guard let vesselReferencePath = difference.document.data()["vesselReferencePath"] as? String else { return }
                            guard let tripStatus = difference.document.data()["tripStatus"] as? String else { return }
                            guard let fromDate = difference.document.data()["fromDate"] as? String else { return }
                            guard let toDate = difference.document.data()["toDate"] as? String else { return }
                            
                            
                            var vesselName = ""
                            var representativeEmail = ""
                            var representativeName = ""
                            var representativePhone = ""
                            var vesselCapacity = ""
                            var shipId = ""
                            var currentStatus = ""
                            let docRef = db.collection("Ships").document(vesselReferencePath)
                            docRef.getDocument { (document, error) in
                                if let document = document {
                                    vesselName = document.data()!["vesselName"] as! String
                                    representativeEmail = document.data()!["representativeEmail"] as! String
                                    representativeName = document.data()!["representativeName"] as! String
                                    representativePhone = document.data()!["representativePhone"] as! String
                                    vesselCapacity = document.data()!["vesselCapacity"] as! String
                                    currentStatus = document.data()!["currentStatus"] as! String
                                    shipId = document.documentID
                                    
                                    self.arrayOfShipNames[i] = Ship(representativeEmail: representativeEmail, representativeName: representativeName, representativePhone: representativePhone, vesselCapacity: vesselCapacity, vesselName: vesselName, shipId: shipId, currentStatus: currentStatus)
                                    self.arrayOfTrips![i] = Trip(amount: amount, cargo: cargo, from: from, to: to, tripStatus: tripStatus, vesselReferencePath: vesselReferencePath, tripId: difference.document.documentID, fromDate: fromDate, toDate: toDate, vesselName: vesselName)
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
                            self.arrayOfShipNames.remove(at: i)
                            return
                        }
                    }
                }
            })
        }
    }
}


extension ReadTripViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let numberOfContacts = self.arrayOfTrips?.count {
            return numberOfContacts
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            let vc = TripHistoryViewController()
            vc.trip = self.arrayOfTrips![indexPath.row]
//            ConnectionBetweenVC.ship = self.arrayOfShipNames[indexPath.row]
            self.navigationController?.pushViewController(vc, animated: true)
    

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


class Colors {
    var gl:CAGradientLayer!
    
    init() {
        let colorTop = UIColor.darkGray.cgColor
        let colorBottom = UIColor.gray.cgColor
        
        self.gl = CAGradientLayer()
        self.gl.colors = [colorTop, colorBottom]
        self.gl.locations = [0.0, 0.4]
    }
}
