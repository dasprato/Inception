//
//  SailTripViewController2.swift
//  ACDShipManagement
//
//  Created by Prato Das on 2018-04-03.
//  Copyright © 2018 Prato Das. All rights reserved.
//

import UIKit
import NotificationBannerSwift
import Firebase
import MapKit
import CoreLocation
import AddressBookUI
import Mapbox
import MapboxNavigation
import QRCode


class SailTripViewController2: UIViewController, CLLocationManagerDelegate {

    let locationManager = CLLocationManager()
    var currentLong = CLLocationDegrees()
    var currentLat = CLLocationDegrees()
    
    var loadingButtonLandscapeConstraints = [NSLayoutConstraint]()
    var loadingButtonPortraitConstraints = [NSLayoutConstraint]()
    var unloadingButtonLandscapeConstraints = [NSLayoutConstraint]()
    var unloadingButtonPortraitConstraints = [NSLayoutConstraint]()
    var loadingWaitingButtonLandscapeConstraints = [NSLayoutConstraint]()
    var loadingWaitingButtonPortraitConstraints = [NSLayoutConstraint]()
    var unloadingWaitingButtonLandscapeConstraints = [NSLayoutConstraint]()
    var unloadingWaitingButtonPortraitConstraints = [NSLayoutConstraint]()
    var otherButtonLandscapeConstraints = [NSLayoutConstraint]()
    var otherButtonPortraitConstraints = [NSLayoutConstraint]()
    var completeButtonPortraitConstraints = [NSLayoutConstraint]()
    var completeButtonLandscapeConstrainsts = [NSLayoutConstraint]()

    
    

    // Timer to log data into Database
    var ourTimer = Timer()
    let barButtonClose = UIBarButtonItem(image: UIImage(named: "arrow")?.withRenderingMode(.alwaysTemplate), style: .plain, target: self, action: #selector(closeView(_:)))
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.darkGray]
        self.navigationController?.navigationBar.barTintColor = .darkGray
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        setupBarButtonItems()
        //        let modelName = UIDevice.current.modelName
        
        
        
        // Ask for Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
            locationManager.startUpdatingLocation()
        }
        
        
        view.addSubview(interactiveBackgroundMap)
        NSLayoutConstraint.activate([interactiveBackgroundMap.leftAnchor.constraint(equalTo: view.leftAnchor), interactiveBackgroundMap.rightAnchor.constraint(equalTo: view.rightAnchor), interactiveBackgroundMap.topAnchor.constraint(equalTo: view.topAnchor), interactiveBackgroundMap.bottomAnchor.constraint(equalTo: view.bottomAnchor)])
        interactiveBackgroundMap.setZoomLevel(17, animated: true)
        
        
        
        setupActionButtons()
        
        performLogicOnButtonTitle()
        
        let date = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        print(hour)
        if hour > 6 && hour < 18 {
            interactiveBackgroundMap.styleURL = MGLStyle.lightStyleURL()
            barButtonClose.tintColor = .darkGray
            navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.darkGray]

        } else {
            interactiveBackgroundMap.styleURL = MGLStyle.darkStyleURL()
            barButtonClose.tintColor = .white
            navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        }
        
        
        ourTimer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(sendLocationToDatabase), userInfo: nil, repeats: true)
    }
    
    
    fileprivate func setupBarButtonItems() {
        
        
        self.navigationItem.setLeftBarButton(barButtonClose, animated: true)
        
        let qrCode = QRCode("Trip Id: " + ConnectionBetweenVC.trip.tripId!)
        QRCodeImageView.image = qrCode?.image
        
        NSLayoutConstraint.activate([QRCodeImageView.widthAnchor.constraint(equalTo: QRCodeImageView.heightAnchor)])
        let barQRCode = UIBarButtonItem(customView: QRCodeImageView)
        self.navigationItem.setRightBarButton(barQRCode, animated: true)
    }
    
    fileprivate func setupActionButtons() {
        view.addSubview(actionButton)
        NSLayoutConstraint.activate([actionButton.leftAnchor.constraint(equalTo: view.leftAnchor), actionButton.rightAnchor.constraint(equalTo: view.rightAnchor), actionButton.heightAnchor.constraint(equalToConstant: 60), actionButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)])
        
        
        view.addSubview(loadingButton)
        view.addSubview(unloadingButton)
        view.addSubview(loadingWaitingButton)
        view.addSubview(unloadingWaitingButton)
        view.addSubview(otherButton)
        view.addSubview(completeTripButton)
        loadingButton.layer.cornerRadius = 25
        unloadingButton.layer.cornerRadius = 25
        loadingWaitingButton.layer.cornerRadius = 25
        unloadingWaitingButton.layer.cornerRadius = 25
        otherButton.layer.cornerRadius = 25
        completeTripButton.layer.cornerRadius = 25
        
        
        loadingButtonPortraitConstraints = [loadingButton.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 16), loadingButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor), loadingButton.widthAnchor.constraint(equalToConstant: 50), loadingButton.heightAnchor.constraint(equalToConstant: 50)]
        unloadingButtonPortraitConstraints = [unloadingButton.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 16), unloadingButton.topAnchor.constraint(equalTo: loadingButton.bottomAnchor, constant: 8), unloadingButton.widthAnchor.constraint(equalToConstant: 50), unloadingButton.heightAnchor.constraint(equalToConstant: 50)]
        loadingWaitingButtonPortraitConstraints = [loadingWaitingButton.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 16), loadingWaitingButton.topAnchor.constraint(equalTo: unloadingButton.bottomAnchor, constant: 8), loadingWaitingButton.widthAnchor.constraint(equalToConstant: 50), loadingWaitingButton.heightAnchor.constraint(equalToConstant: 50)]
        unloadingWaitingButtonPortraitConstraints = [unloadingWaitingButton.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 16), unloadingWaitingButton.topAnchor.constraint(equalTo: loadingWaitingButton.bottomAnchor, constant: 8), unloadingWaitingButton.widthAnchor.constraint(equalToConstant: 50), unloadingWaitingButton.heightAnchor.constraint(equalToConstant: 50)]
        otherButtonPortraitConstraints = [otherButton.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 16), otherButton.topAnchor.constraint(equalTo: unloadingWaitingButton.bottomAnchor, constant: 8), otherButton.widthAnchor.constraint(equalToConstant: 50), otherButton.heightAnchor.constraint(equalToConstant: 50)]
        completeButtonPortraitConstraints = [completeTripButton.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 16), completeTripButton.topAnchor.constraint(equalTo: otherButton.bottomAnchor, constant: 8), completeTripButton.widthAnchor.constraint(equalToConstant: 50), completeTripButton.heightAnchor.constraint(equalToConstant: 50)]
        loadingButtonLandscapeConstraints = [loadingButton.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 21), loadingButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor), loadingButton.widthAnchor.constraint(equalToConstant: 50), loadingButton.heightAnchor.constraint(equalToConstant: 50)]
        unloadingButtonLandscapeConstraints = [unloadingButton.leftAnchor.constraint(equalTo: loadingButton.rightAnchor, constant: 8), unloadingButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor), unloadingButton.widthAnchor.constraint(equalToConstant: 50), unloadingButton.heightAnchor.constraint(equalToConstant: 50)]
        loadingWaitingButtonLandscapeConstraints = [loadingWaitingButton.leftAnchor.constraint(equalTo: unloadingButton.rightAnchor, constant: 8), loadingWaitingButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor), loadingWaitingButton.widthAnchor.constraint(equalToConstant: 50), loadingWaitingButton.heightAnchor.constraint(equalToConstant: 50)]
        unloadingWaitingButtonLandscapeConstraints = [unloadingWaitingButton.leftAnchor.constraint(equalTo: loadingWaitingButton.rightAnchor, constant: 8), unloadingWaitingButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor), unloadingWaitingButton.widthAnchor.constraint(equalToConstant: 50), unloadingWaitingButton.heightAnchor.constraint(equalToConstant: 50)]
        otherButtonLandscapeConstraints = [otherButton.leftAnchor.constraint(equalTo: unloadingWaitingButton.rightAnchor, constant: 8), otherButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor), otherButton.widthAnchor.constraint(equalToConstant: 50), otherButton.heightAnchor.constraint(equalToConstant: 50)]
        completeButtonLandscapeConstrainsts = [completeTripButton.leftAnchor.constraint(equalTo: otherButton.rightAnchor, constant: 8), completeTripButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor), completeTripButton.widthAnchor.constraint(equalToConstant: 50), completeTripButton.heightAnchor.constraint(equalToConstant: 50)]
        checkAndAdjustButtonContraints()
    }
    
    
    
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        checkAndAdjustButtonContraints()
    }
    
    
    fileprivate func checkAndAdjustButtonContraints() {
        if UIDevice.current.orientation.isLandscape {
            NSLayoutConstraint.deactivate(loadingButtonPortraitConstraints)
            NSLayoutConstraint.deactivate(unloadingButtonPortraitConstraints)
            NSLayoutConstraint.deactivate(loadingWaitingButtonPortraitConstraints)
            NSLayoutConstraint.deactivate(unloadingWaitingButtonPortraitConstraints)
            NSLayoutConstraint.deactivate(otherButtonPortraitConstraints)
            NSLayoutConstraint.deactivate(completeButtonPortraitConstraints)
            
            NSLayoutConstraint.activate(loadingButtonLandscapeConstraints)
            NSLayoutConstraint.activate(unloadingButtonLandscapeConstraints)
            NSLayoutConstraint.activate(loadingWaitingButtonLandscapeConstraints)
            NSLayoutConstraint.activate(unloadingWaitingButtonLandscapeConstraints)
            NSLayoutConstraint.activate(otherButtonLandscapeConstraints)
            NSLayoutConstraint.activate(completeButtonLandscapeConstrainsts)
            print("Landscape")
        }
        else {
            NSLayoutConstraint.activate(loadingButtonPortraitConstraints)
            NSLayoutConstraint.activate(unloadingButtonPortraitConstraints)
            NSLayoutConstraint.activate(loadingWaitingButtonPortraitConstraints)
            NSLayoutConstraint.activate(unloadingWaitingButtonPortraitConstraints)
            NSLayoutConstraint.activate(otherButtonPortraitConstraints)
            NSLayoutConstraint.activate(completeButtonPortraitConstraints)
            
            NSLayoutConstraint.deactivate(loadingButtonLandscapeConstraints)
            NSLayoutConstraint.deactivate(unloadingButtonLandscapeConstraints)
            NSLayoutConstraint.deactivate(loadingWaitingButtonLandscapeConstraints)
            NSLayoutConstraint.deactivate(unloadingWaitingButtonLandscapeConstraints)
            NSLayoutConstraint.deactivate(otherButtonLandscapeConstraints)
             NSLayoutConstraint.deactivate(completeButtonLandscapeConstrainsts)
            print("Portrait")
        }
    }

    
    @objc func sendLocationToDatabase() {
        if ConnectionBetweenVC.trip.tripStatus == "TripPaused" || ConnectionBetweenVC.trip.tripStatus == "Sailing" {
            let timeStamp = "\(String(describing: Date().timeIntervalSince1970))"
            let db = Firestore.firestore()
            db.collection("Trips").document(ConnectionBetweenVC.trip.tripId!).collection("LocationLog").document(timeStamp).setData(["lat": currentLat, "long": currentLong])
        }
        
        let date = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        print(hour)
        if hour > 6 && hour < 18 {
            interactiveBackgroundMap.styleURL = MGLStyle.lightStyleURL()
            barButtonClose.tintColor = .darkGray
            navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.darkGray]
            
        } else {
            interactiveBackgroundMap.styleURL = MGLStyle.darkStyleURL()
            barButtonClose.tintColor = .white
            navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        ourTimer.invalidate()
    }
    
    
    override func viewDidLayoutSubviews() {
        actionButton.addShadow()
        loadingButton.addShadow()
        unloadingButton.addShadow()
        loadingWaitingButton.addShadow()
        unloadingWaitingButton.addShadow()
        otherButton.addShadow()
    }
    func performLogicOnButtonTitle() {
        if ConnectionBetweenVC.trip.tripStatus == "Initialised" {
            actionButton.setTitle("Sail Trip", for: .normal)
        }
        if ConnectionBetweenVC.trip.tripStatus == "Sailing" {
            actionButton.setTitle("Pause Trip", for: .normal)
        }
        if ConnectionBetweenVC.trip.tripStatus == "TripPaused" {
            actionButton.setTitle("Sail Trip", for: .normal)
        }
    }
    
    var interactiveBackgroundMap: MGLMapView = {
        let mt = MGLMapView()
        mt.translatesAutoresizingMaskIntoConstraints = false
        mt.clipsToBounds = true
        mt.isZoomEnabled = true
        mt.isScrollEnabled = true
        mt.showsUserLocation = true
        mt.isPitchEnabled = false
        mt.isUserInteractionEnabled = true
        mt.isUserInteractionEnabled = false
        return mt
    }()
    
    var QRCodeImageView: UIImageView = {
        let civ = UIImageView()
        civ.image = UIImage(named: "contact")
        civ.translatesAutoresizingMaskIntoConstraints = false
        civ.clipsToBounds = true
        civ.backgroundColor = .white
        civ.isUserInteractionEnabled = true
        civ.contentMode = .scaleAspectFit
        civ.backgroundColor = .clear
        return civ
    }()
    
    var actionButton: CustomUIButton = {
        let civ = CustomUIButton(type: .system)
        civ.backgroundColor = .orange
        civ.addTarget(self, action: #selector(onActionButtonTapped), for: .touchUpInside)
        return civ
    }()

    var loadingButton: CustomUIButton = {
        let civ = CustomUIButton(type: .system)
        civ.backgroundColor = .orange
        civ.addTarget(self, action: #selector(onLoadingTapped), for: .touchUpInside)
        civ.setTitle("L", for: .normal)
        return civ
    }()
    
    var unloadingButton: CustomUIButton = {
        let civ = CustomUIButton(type: .system)
        civ.backgroundColor = .orange
        civ.addTarget(self, action: #selector(onUnloadingTapped), for: .touchUpInside)
        civ.setTitle("U", for: .normal)
        return civ
    }()
    
    var loadingWaitingButton: CustomUIButton = {
        let civ = CustomUIButton(type: .system)
        civ.backgroundColor = .orange
        civ.addTarget(self, action: #selector(onLoadingWaitingTapped), for: .touchUpInside)
        civ.setTitle("LW", for: .normal)
        return civ
    }()
    
    var unloadingWaitingButton: CustomUIButton = {
        let civ = CustomUIButton(type: .system)
        civ.backgroundColor = .orange
        civ.addTarget(self, action: #selector(onUnloadingWaitingTapped), for: .touchUpInside)
        civ.setTitle("UW", for: .normal)
        return civ
    }()
    
    var otherButton: CustomUIButton = {
        let civ = CustomUIButton(type: .system)
        civ.backgroundColor = .orange
        civ.addTarget(self, action: #selector(onOtherButton), for: .touchUpInside)
        civ.setTitle("O", for: .normal)
        return civ
    }()
    
    var completeTripButton: CustomUIButton = {
        let civ = CustomUIButton(type: .system)
        civ.backgroundColor = .orange
        civ.addTarget(self, action: #selector(onCompleteButtonTapped), for: .touchUpInside)
        civ.setTitle("C", for: .normal)
        return civ
    }()
    
    
    @objc func onCompleteButtonTapped() {
        let timeStamp = "\(String(describing: Date().timeIntervalSince1970))"
        let db = Firestore.firestore()
        let tripStatusDictionary: [String: Any?] = ["Completed": timeStamp]
        db.collection("Trips").document(ConnectionBetweenVC.trip.tripId!).collection("TripStatusLog").document(timeStamp).setData(tripStatusDictionary)
    }
    @objc func onLoadingTapped() {
        let timeStamp = "\(String(describing: Date().timeIntervalSince1970))"
        let db = Firestore.firestore()
        let tripStatusDictionary: [String: Any?] = ["Loading": timeStamp]
        db.collection("Trips").document(ConnectionBetweenVC.trip.tripId!).collection("TripStatusLog").document(timeStamp).setData(tripStatusDictionary)
    }
    
    @objc func onUnloadingTapped() {
        let timeStamp = "\(String(describing: Date().timeIntervalSince1970))"
        let db = Firestore.firestore()
        let tripStatusDictionary: [String: Any?] = ["Unloading": timeStamp]
        db.collection("Trips").document(ConnectionBetweenVC.trip.tripId!).collection("TripStatusLog").document(timeStamp).setData(tripStatusDictionary)
    }
    
    @objc func onLoadingWaitingTapped() {
        let timeStamp = "\(String(describing: Date().timeIntervalSince1970))"
        let db = Firestore.firestore()
        let tripStatusDictionary: [String: Any?] = ["LoadingWaiting": timeStamp]
        db.collection("Trips").document(ConnectionBetweenVC.trip.tripId!).collection("TripStatusLog").document(timeStamp).setData(tripStatusDictionary)
    }
    
    @objc func onUnloadingWaitingTapped() {
        let timeStamp = "\(String(describing: Date().timeIntervalSince1970))"
        let db = Firestore.firestore()
        let tripStatusDictionary: [String: Any?] = ["UnloadingWaiting": timeStamp]
        db.collection("Trips").document(ConnectionBetweenVC.trip.tripId!).collection("TripStatusLog").document(timeStamp).setData(tripStatusDictionary)
    }
    
    @objc func onOtherButton() {
        let timeStamp = "\(String(describing: Date().timeIntervalSince1970))"
        let db = Firestore.firestore()
        let tripStatusDictionary: [String: Any?] = ["Other": timeStamp]
        db.collection("Trips").document(ConnectionBetweenVC.trip.tripId!).collection("TripStatusLog").document(timeStamp).setData(tripStatusDictionary)
    }
    
    
}

extension SailTripViewController2 {
    
    
    
    @objc func onActionButtonTapped() {
        
        
        
        ConnectionBetweenVC.ship = Ship(representativeEmail: ConnectionBetweenVC.ship.representativeEmail!, representativeName: ConnectionBetweenVC.ship.representativeName!, representativePhone: ConnectionBetweenVC.ship.representativePhone!, vesselCapacity: ConnectionBetweenVC.ship.vesselCapacity!, vesselName: ConnectionBetweenVC.ship.vesselName!, shipId: ConnectionBetweenVC.ship.shipId!, currentStatus: "Not Available")
            updateShipStatusNotAvailable()
        
        if ConnectionBetweenVC.trip.tripStatus == "Initialised" {
            // Initial hit
            print("Take actions for Initialised")
            
            ConnectionBetweenVC.trip = Trip(amount: ConnectionBetweenVC.trip.amount!, cargo: ConnectionBetweenVC.trip.cargo!, from: ConnectionBetweenVC.trip.from!, to: ConnectionBetweenVC.trip.to!, tripStatus: "Sailing", vesselReferencePath: ConnectionBetweenVC.trip.vesselReferencePath!, tripId: ConnectionBetweenVC.trip.tripId!, fromDate: ConnectionBetweenVC.trip.fromDate!, toDate: ConnectionBetweenVC.trip.toDate!, vesselName: ConnectionBetweenVC.trip.vesselName!)
            performLogicOnButtonTitle()
            updateTripStatus()

        }
        else if ConnectionBetweenVC.trip.tripStatus == "Sailing" {
            // Start and Between trip hits
            print("Take actions for Sailing")
            
            ConnectionBetweenVC.trip = Trip(amount: ConnectionBetweenVC.trip.amount!, cargo: ConnectionBetweenVC.trip.cargo!, from: ConnectionBetweenVC.trip.from!, to: ConnectionBetweenVC.trip.to!, tripStatus: "TripPaused", vesselReferencePath: ConnectionBetweenVC.trip.vesselReferencePath!, tripId: ConnectionBetweenVC.trip.tripId!, fromDate: ConnectionBetweenVC.trip.fromDate!, toDate: ConnectionBetweenVC.trip.toDate!, vesselName: ConnectionBetweenVC.trip.vesselName!)
            performLogicOnButtonTitle()
            updateTripStatus()
        }
        else if ConnectionBetweenVC.trip.tripStatus == "TripPaused" {
            print("Take actions for TripPaused")
            // Between trip hits
            ConnectionBetweenVC.trip = Trip(amount: ConnectionBetweenVC.trip.amount!, cargo: ConnectionBetweenVC.trip.cargo!, from: ConnectionBetweenVC.trip.from!, to: ConnectionBetweenVC.trip.to!, tripStatus: "Sailing", vesselReferencePath: ConnectionBetweenVC.trip.vesselReferencePath!, tripId: ConnectionBetweenVC.trip.tripId!, fromDate: ConnectionBetweenVC.trip.fromDate!, toDate: ConnectionBetweenVC.trip.toDate!, vesselName: ConnectionBetweenVC.trip.vesselName!)
            performLogicOnButtonTitle()
            updateTripStatus()
        }
    }
    
    func updateTripStatus() {
        let db = Firestore.firestore()
        let tripDictionary: [String: Any?] = ["from": ConnectionBetweenVC.trip.from!, "to": ConnectionBetweenVC.trip.to!, "cargo": ConnectionBetweenVC.trip.cargo!, "amount": ConnectionBetweenVC.trip.amount!, "vesselReferencePath": ConnectionBetweenVC.trip.vesselReferencePath!, "fromDate": ConnectionBetweenVC.trip.fromDate!, "toDate": ConnectionBetweenVC.trip.toDate!, "tripStatus": ConnectionBetweenVC.trip.tripStatus!]
        db.collection("Trips").document(ConnectionBetweenVC.trip.tripId!).setData(tripDictionary)
        
    }

    
    func updateShipStatusNotAvailable() {
        
        let db = Firestore.firestore()
        let vesselDictionary: [String: Any?] = ["vesselName": ConnectionBetweenVC.ship.vesselName!, "vesselCapacity": ConnectionBetweenVC.ship.vesselCapacity!, "representativeName": ConnectionBetweenVC.ship.representativeName!, "representativePhone": ConnectionBetweenVC.ship.representativePhone!, "representativeEmail": ConnectionBetweenVC.ship.representativeName!, "currentStatus": ConnectionBetweenVC.ship.currentStatus!]
        db.collection("Ships").document(ConnectionBetweenVC.ship.shipId!).setData(vesselDictionary)
    }

    

    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // This runs only when device location is updated
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        //        let locationCoorindate = CLLocationCoordinate2DMake(locValue.latitude, locValue.longitude)
        interactiveBackgroundMap.setCenter(locValue, animated: true)
        currentLong = locValue.longitude
        currentLat = locValue.latitude
        if ConnectionBetweenVC.trip.tripStatus! == "Initialised" {
            self.navigationItem.title = "Initialised: (" + String(locValue.latitude) + ", " + String(locValue.longitude) + ")"
        }
            
        else if ConnectionBetweenVC.trip.tripStatus! == "Sailing" {
            self.navigationItem.title = "Sailing: (" + String(locValue.latitude) + ", " + String(locValue.longitude) + ")"
        }
            
        else if ConnectionBetweenVC.trip.tripStatus! == "TripPaused" {
            self.navigationItem.title = "Trip Paused: (" + String(locValue.latitude) + ", " + String(locValue.longitude) + ")"
    
        }
    }
    
}
