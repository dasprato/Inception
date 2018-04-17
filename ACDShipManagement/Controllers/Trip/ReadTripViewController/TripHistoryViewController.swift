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
    var arrayOfLocations: [Location]? {
        didSet {
            self.tripsCollectionView.reloadData()

        }
    }
    let tripLocationLogCellId = "tripLocationLogCellId"
    var trip: Trip! {
        didSet {
            
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        arrayOfLocations = [Location]()

        fetchLocationLog()
        fetchStatusLog()
        self.navigationItem.title = trip.tripStatus!
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
            navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        
        

        view.addSubview(image)
        NSLayoutConstraint.activate([image.topAnchor.constraint(equalTo: view.topAnchor), image.bottomAnchor.constraint(equalTo: view.bottomAnchor), image.rightAnchor.constraint(equalTo: view.rightAnchor), image.leftAnchor.constraint(equalTo: view.leftAnchor)])
//
        let rightBarButton = UIBarButtonItem(title: "Scroll To Bottom", style: .plain, target: self, action: #selector(scroll))
        self.navigationItem.setRightBarButton(rightBarButton, animated: true)
        
        setupCollectionView()
//        checkAndAdjustContraints()
    }

    @objc func scroll() {
            self.tripsCollectionView.scrollToItem(at: IndexPath(row: arrayOfLocations!.count - 1, section: 0), at: .bottom, animated: true)
    }
    
    func checkAndAdjustContraints() {
            NSLayoutConstraint.activate(textFieldAnchorsLandscapeConstraints)
            NSLayoutConstraint.activate(imageAnchorsLandscapeConstraints)
    }
    
    func setupCollectionView() {
        view.addSubview(tripsCollectionView)
        tripsCollectionView.translatesAutoresizingMaskIntoConstraints = false 
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
        ccv.backgroundColor = .clear
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
                    
                    guard let lat = difference.document.data()["lat"] as? Float else { return }
                    guard let long = difference.document.data()["long"] as? Float else { return }
                    let dateAndTime = Date(timeIntervalSince1970: Double(difference.document.documentID)!)
                    
                    self.arrayOfLocations!.append(Location(latitude: lat, longitude: long, dateAndTime: dateAndTime, timeStamp: difference.document.documentID))
                    print("LocationAdded")
                }
                
                if (difference.type == .modified) {
                    for i in 0..<self.arrayOfLocations!.count {
                        if self.arrayOfLocations![i].timeStamp == difference.document.documentID {
                            guard let lat = difference.document.data()["lat"] as? Float else { return }
                            guard let long = difference.document.data()["long"] as? Float else { return }
                            let dateAndTime = Date(timeIntervalSince1970: Double(difference.document.documentID)!)
                            self.arrayOfLocations![i] = Location(latitude: lat, longitude: long, dateAndTime: dateAndTime, timeStamp: difference.document.documentID)
                            return
                        }
                    }
                }
                if (difference.type == .removed) {
                    // TODO: Find an efficient solution
                    print("Removed contact: \(difference.document.documentID)")
                    for i in 0..<self.arrayOfLocations!.count {
                        if self.arrayOfLocations![i].timeStamp == difference.document.documentID {
                            self.arrayOfLocations!.remove(at: i)
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
        if let _ = arrayOfLocations {
            return arrayOfLocations!.count
        } else {
            return 0
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = tripsCollectionView.dequeueReusableCell(withReuseIdentifier: tripLocationLogCellId, for: indexPath) as! LocationCell
        cell.location = self.arrayOfLocations![indexPath.row]
        

        return cell
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width - 32, height: 40)
    }
}


class LocationCell: UICollectionViewCell {
    var location: Location {
        didSet {
            
            fromLabel.text =  String(describing: location.latitude!) + ", "
            toLabel.text = String(describing: location.longitude!)
            vesselNameLabel.text = String(describing: location.dateAndTime!)
        }
    }
    
    
    override init(frame: CGRect) {
        self.location = Location(latitude: 0.0, longitude: 0.0, dateAndTime: Date(), timeStamp: "")
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(vesselNameLabel)
        contentView.addSubview(fromLabel)
        contentView.addSubview(toLabel)
        contentView.addSubview(fromDateLabel)
        contentView.addSubview(toDateLabel)
        
        NSLayoutConstraint.activate([vesselNameLabel.topAnchor.constraint(equalTo: topAnchor), vesselNameLabel.leftAnchor.constraint(equalTo: leftAnchor)])
        NSLayoutConstraint.activate([fromLabel.topAnchor.constraint(equalTo: vesselNameLabel.bottomAnchor), fromLabel.leftAnchor.constraint(equalTo: leftAnchor)])
        NSLayoutConstraint.activate([toLabel.topAnchor.constraint(equalTo: vesselNameLabel.bottomAnchor), toLabel.leftAnchor.constraint(equalTo: fromLabel.rightAnchor)])
        
        NSLayoutConstraint.activate([fromDateLabel.topAnchor.constraint(equalTo: fromLabel.bottomAnchor), fromDateLabel.leftAnchor.constraint(equalTo: fromLabel.leftAnchor)])
        NSLayoutConstraint.activate([toDateLabel.topAnchor.constraint(equalTo: toLabel.bottomAnchor), toDateLabel.leftAnchor.constraint(equalTo: fromDateLabel.rightAnchor)])
    }
    
    
    // Text fields
    private var fromLabel: UILabel = {
        let cntf = UILabel()
        cntf.translatesAutoresizingMaskIntoConstraints = false
        cntf.textColor = .gray
        cntf.font = UIFont.boldSystemFont(ofSize: cntf.font.pointSize + 2)
        return cntf
    }()
    
    
    private var toLabel: UILabel = {
        let cntf = UILabel()
        cntf.translatesAutoresizingMaskIntoConstraints = false
        cntf.textColor = .gray
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
        cntf.textColor = .darkGray
        cntf.backgroundColor = UIColor.white.withAlphaComponent(0.6)
        cntf.layer.cornerRadius = 10.0
        cntf.font = UIFont.boldSystemFont(ofSize: cntf.font.pointSize + 2)
        return cntf
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


