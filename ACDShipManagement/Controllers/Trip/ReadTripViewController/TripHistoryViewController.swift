//
//  TripCompletedViewController.swift
//  ACDShipManagement
//
//  Created by Prato Das on 2018-04-13.
//  Copyright © 2018 Prato Das. All rights reserved.
//

import UIKit
import QRCode
import Firebase



class TripHistoryViewController: UIViewController {
    var imageAnchorsPortraitConstraints = [NSLayoutConstraint]()
    var textFieldAnchorsPortraitConstraints = [NSLayoutConstraint]()
    var imageAnchorsLandscapeConstraints = [NSLayoutConstraint]()
    var textFieldAnchorsLandscapeConstraints = [NSLayoutConstraint]()
    var arrayOfLocations = [Location]()
    let tripLocationLogCellId = "tripLocationLogCellId"
    var trip: Trip! {
        didSet {
            
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
//        view.addSubview(image)

        fetchLocationLog()
        fetchStatusLog()
        self.navigationItem.title = ConnectionBetweenVC.trip.tripStatus!
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
            navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.black]

//
//        imageAnchorsPortraitConstraints = [image.topAnchor.constraint(equalTo: view.topAnchor), image.bottomAnchor.constraint(equalTo: view.bottomAnchor), image.rightAnchor.constraint(equalTo: view.rightAnchor), image.leftAnchor.constraint(equalTo: view.leftAnchor)]
//
//
//
//        imageAnchorsLandscapeConstraints = [image.topAnchor.constraint(equalTo: view.topAnchor), image.bottomAnchor.constraint(equalTo: view.bottomAnchor), image.rightAnchor.constraint(equalTo: view.rightAnchor), image.leftAnchor.constraint(equalTo: view.leftAnchor)]
        
        
        setupCollectionView()
//        checkAndAdjustContraints()
    }

    
    func checkAndAdjustContraints() {
            NSLayoutConstraint.activate(textFieldAnchorsLandscapeConstraints)
            NSLayoutConstraint.activate(imageAnchorsLandscapeConstraints)
    }
    
    func setupCollectionView() {
        view.addSubview(tripsCollectionView)
        NSLayoutConstraint.activate([
            tripsCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tripsCollectionView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            tripsCollectionView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            tripsCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
        
        tripsCollectionView.delegate = self
        tripsCollectionView.dataSource = self
        
        tripsCollectionView.register(LocationCell.self, forCellWithReuseIdentifier: tripLocationLogCellId)
        
        
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
        ccv.backgroundColor = .blue
        return ccv
    }()
    
    
    
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        checkAndAdjustContraints()
    }
    
    
    var image: UIImageView = {
        let img = UIImageView()
        img.translatesAutoresizingMaskIntoConstraints = false
        img.image = UIImage(named: "ship6")?.withRenderingMode(.alwaysOriginal)
        img.contentMode = .scaleAspectFill
        img.clipsToBounds = true
        return img
    }()
    
    func fetchLocationLog() {
        let db = Firestore.firestore()
       
        print("Trips/" + trip.tripId! + "/LocationLog")
        db.collection("Trips/" + trip.tripId! + "/LocationLog").addSnapshotListener { (snapshot, error) in
            guard let _ = snapshot?.documents else {
                print("Error fetching documents: \(error!)")
                return
            }
            snapshot?.documentChanges.forEach({ (difference) in
                if (difference.type == .added) {
                    
                    guard let lat = difference.document.data()["lat"] as? String else { return }
                    guard let long = difference.document.data()["long"] as? String else { return }
                    let dateAndTime = difference.document.documentID

                    self.arrayOfLocations.append(Location(latitude: lat, longitude: long, dateAndTime: dateAndTime))
                    print("LocationAdded")
                }
                
                if (difference.type == .modified) {
                    for i in 0..<self.arrayOfLocations.count {
                        if self.arrayOfLocations[i].dateAndTime == difference.document.documentID {
                            guard let lat = difference.document.data()["lat"] as? String else { return }
                            guard let long = difference.document.data()["long"] as? String else { return }
                            let dateAndTime = difference.document.documentID
                            self.arrayOfLocations[i] = Location(latitude: lat, longitude: long, dateAndTime: dateAndTime)
                            return
                        }
                    }
                }
                if (difference.type == .removed) {
                    // TODO: Find an efficient solution
                    print("Removed contact: \(difference.document.documentID)")
                    for i in 0..<self.arrayOfLocations.count {
                        if self.arrayOfLocations[i].dateAndTime == difference.document.documentID {
                            self.arrayOfLocations.remove(at: i)
                            return
                        }
                    }
                }
            })
        }
    }
    
    func fetchStatusLog(){
        
    }
    


}

extension TripHistoryViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.arrayOfLocations.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = tripsCollectionView.dequeueReusableCell(withReuseIdentifier: tripLocationLogCellId, for: indexPath) as! LocationCell
        cell.location = self.arrayOfLocations[indexPath.row]
        cell.backgroundColor = .red
        return cell
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width - 32, height: 64)
    }
}


class LocationCell: UICollectionViewCell {
    var location: Location {
        didSet {
            fromLabel.text = location.longitude + " || "
            toLabel.text = location.latitude
            vesselNameLabel.text = String(describing: Date(timeIntervalSince1970: Double(location.dateAndTime)!))
        }
    }
    
    
    override init(frame: CGRect) {
        self.location = Location(latitude: "", longitude: "", dateAndTime: "")
        //        self.ship = Ship(representativeEmail: "", representativeName: "", representativePhone: "", vesselCapacity: "", vesselName: "", shipId: "", currentStatus: "")
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
        cntf.textColor = .black
        cntf.font = UIFont.boldSystemFont(ofSize: cntf.font.pointSize + 2)
        return cntf
    }()
    
    
    private var toLabel: UILabel = {
        let cntf = UILabel()
        cntf.translatesAutoresizingMaskIntoConstraints = false
        cntf.textColor = .black
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
        cntf.textColor = .black
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


