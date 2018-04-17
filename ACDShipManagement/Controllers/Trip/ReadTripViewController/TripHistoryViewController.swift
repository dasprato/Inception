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
import MapKit

import AddressBookUI
import Contacts
import CoreLocation

class TripHistoryViewController: UIViewController {

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
    

    override func viewWillAppear(_ animated: Bool) {
        arrayOfLocations?.removeAll()
        fetchLocationLog()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        arrayOfLocations = [Location]()

        fetchLocationLog()
        self.navigationItem.title = trip.tripStatus!
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
            navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        
        

//
        let rightBarButton = UIBarButtonItem(title: "Scroll To Bottom", style: .plain, target: self, action: #selector(scroll))
        self.navigationItem.setRightBarButton(rightBarButton, animated: true)
        
        setupCollectionView()
//        checkAndAdjustContraints()
    }

    @objc func scroll() {
            self.tripsCollectionView.scrollToItem(at: IndexPath(row: arrayOfLocations!.count - 1, section: 0), at: .bottom, animated: true)
    }
    
    func serverToLocal(date:String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        let localDate = dateFormatter.date(from: date)
        
        return localDate
    }
    
    

    
    func setupCollectionView() {
        view.addSubview(tripsCollectionView)
        [
            tripsCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tripsCollectionView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            tripsCollectionView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            tripsCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ].forEach { (constraint) in
                constraint.isActive = true
        }
        
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
        ccv.showsVerticalScrollIndicator = false
        return ccv
    }()
    
    
    
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        
    }
    
    

    
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
                    
                    guard let lat = difference.document.data()["lat"] as? Double else { return }
                    guard let long = difference.document.data()["long"] as? Double else { return }
                    let dateAndTime = Date(timeIntervalSince1970: Double(difference.document.documentID)!)
                    
                    let myTimeInterval = TimeInterval(difference.document.documentID)
                    let time = NSDate(timeIntervalSince1970: TimeInterval(myTimeInterval!))
                    var addressToAppend = ""
                    
                    self.geocode(latitude: lat, longitude: long) { placemark, error in
                        guard let placemark = placemark, error == nil else { return }
                        // you should always update your UI in the main thread
                        DispatchQueue.main.async {
                            var address1 = ""
                            var address2 = ""
                            var city = ""
                            var state = ""
                            var country = ""
                            address1 = placemark.subThoroughfare!
                            address2 = placemark.thoroughfare!
                            city = placemark.locality!
                            state = placemark.administrativeArea!
                            country = placemark.country!
                            
                            addressToAppend = "\(address2) \(address1) \(city) \(state) \(country)"
                            self.arrayOfLocations!.append(Location(latitude: lat, longitude: long, dateAndTime:  time as Date!, timeStamp: difference.document.documentID, address: addressToAppend))
                        }
                    }

                    

                    
                }
                
                if (difference.type == .modified) {
                    for i in 0..<self.arrayOfLocations!.count {
                        if self.arrayOfLocations![i].timeStamp == difference.document.documentID {
                            guard let lat = difference.document.data()["lat"] as? Double else { return }
                            guard let long = difference.document.data()["long"] as? Double else { return }
                            let dateAndTime = Date(timeIntervalSince1970: Double(difference.document.documentID)!)
                            
                            let myTimeInterval = TimeInterval(difference.document.documentID)
                            let time = NSDate(timeIntervalSince1970: TimeInterval(myTimeInterval!))
                            
                            var addressToAppend = ""
                            
                            self.geocode(latitude: lat, longitude: long) { placemark, error in
                                guard let placemark = placemark, error == nil else { return }
                                // you should always update your UI in the main thread
                                DispatchQueue.main.async {
                                    //  update UI here
                                    var address1 = ""
                                    var address2 = ""
                                    var city = ""
                                    var state = ""
                                    var country = ""
                                    address1 = placemark.subThoroughfare!
                                    address2 = placemark.thoroughfare!
                                    city = placemark.locality!
                                    state = placemark.administrativeArea!
                                    country = placemark.country!
                                    
                                    addressToAppend = "\(address2) \(address1) \(city) \(state) \(country)"
                                    self.arrayOfLocations![i] = Location(latitude: lat, longitude: long, dateAndTime: time as Date!, timeStamp: difference.document.documentID, address: addressToAppend)
                                }
                                
                            }
                            

                            return
                        }
                    }
                }
                if (difference.type == .removed) {
                    // TODO: Find an efficient solution

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
    
    func geocode(latitude: Double, longitude: Double, completion: @escaping (CLPlacemark?, Error?) -> ())  {
        CLGeocoder().reverseGeocodeLocation(CLLocation(latitude: latitude, longitude: longitude)) { completion($0?.first, $1) }
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
            toLabel.text = String(describing: location.longitude!) + " = " + location.address
            vesselNameLabel.text = DateFormatter.localizedString(from: location.dateAndTime, dateStyle: .medium, timeStyle: .medium)
        }
    }
    
    
    override init(frame: CGRect) {
        self.location = Location(latitude: 0.0, longitude: 0.0, dateAndTime: Date(), timeStamp: "", address: "")
        super.init(frame: frame)
        contentView.addSubview(vesselNameLabel)
        contentView.addSubview(fromLabel)
        contentView.addSubview(toLabel)
        
        NSLayoutConstraint.activate([vesselNameLabel.topAnchor.constraint(equalTo: topAnchor), vesselNameLabel.leftAnchor.constraint(equalTo: leftAnchor)])
        NSLayoutConstraint.activate([fromLabel.topAnchor.constraint(equalTo: vesselNameLabel.bottomAnchor), fromLabel.leftAnchor.constraint(equalTo: leftAnchor)])
        NSLayoutConstraint.activate([toLabel.topAnchor.constraint(equalTo: vesselNameLabel.bottomAnchor), toLabel.leftAnchor.constraint(equalTo: fromLabel.rightAnchor)])
    }
    
    
    // Text fields
    private var fromLabel: UILabel = {
        let cntf = UILabel()
        cntf.textColor = .gray
        cntf.font = UIFont.boldSystemFont(ofSize: cntf.font.pointSize + 2)
        cntf.translatesAutoresizingMaskIntoConstraints = false
        return cntf
    }()
    
    
    private var toLabel: UILabel = {
        let cntf = UILabel()
        cntf.textColor = .gray
        cntf.font = UIFont.boldSystemFont(ofSize: cntf.font.pointSize + 2)
        cntf.translatesAutoresizingMaskIntoConstraints = false
        
        return cntf
    }()
    
    private var vesselNameLabel: UILabel = {
        let cntf = UILabel()
        cntf.textColor = .darkGray
        cntf.backgroundColor = UIColor.white.withAlphaComponent(0.6)
        cntf.layer.cornerRadius = 10.0
        cntf.font = UIFont.boldSystemFont(ofSize: cntf.font.pointSize + 2)
        cntf.translatesAutoresizingMaskIntoConstraints = false
        return cntf
    }()


    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}



