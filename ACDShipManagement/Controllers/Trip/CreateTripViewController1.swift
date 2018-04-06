//
//  CreateTripViewController.swift
//  ACDShipManagement
//
//  Created by Prato Das on 2018-02-05.
//  Copyright © 2018 Prato Das. All rights reserved.
//

import UIKit
import Firebase
import QRCode

class CreateTripViewController1: UIViewController, CreateTripViewController2DidClose {
    
    
    func didClose() {
        print("Function called")
        UIView.animate(withDuration: 0.3) {
            self.view.alpha = 1
        }
    }
    

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
        self.navigationController?.navigationBar.topItem?.title = ""
        self.navigationController?.title = ""
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
    
    override func viewWillAppear(_ animated: Bool) {

    }
    
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
                    guard let vesselName = difference.document.data()["vesselName"] as? String else { return }
                    guard let currentStatus = difference.document.data()["currentStatus"] as? String else { return }
                    self.arrayOfShips?.append(Ship(representativeEmail: representativeEmail, representativeName: representativeName, representativePhone: representativePhone, vesselCapacity: vesselCapacity, vesselName: vesselName, shipId: difference.document.documentID, currentStatus: currentStatus))
                }
                
                if (difference.type == .modified) {
                    for i in 0..<self.arrayOfShips!.count {
                        if self.arrayOfShips![i].shipId == difference.document.documentID {
                            self.arrayOfShips![i] = (Ship(representativeEmail: difference.document.data()["representativeEmail"]! as? String, representativeName: difference.document.data()["representativeName"]! as? String, representativePhone: difference.document.data()["representativePhone"]! as? String, vesselCapacity: difference.document.data()["vesselCapacity"]! as? String, vesselName: difference.document.data()["vesselName"]! as? String, shipId: difference.document.documentID, currentStatus: difference.document.data()["difference"]! as? String))
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


// Scheduling and Sequencing

extension CreateTripViewController1: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let numberOfContacts = self.arrayOfShips?.count {
            return numberOfContacts
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        UIView.animate(withDuration: 0.3) {
            self.view.alpha = 0.2
        }
        
        let vc = CreateTripViewController2()
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overCurrentContext
        vc.ship = self.arrayOfShips![indexPath.row]
        vc.delegate = self
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

