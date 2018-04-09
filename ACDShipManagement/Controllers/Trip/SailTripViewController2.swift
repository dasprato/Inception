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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.tintColor = .white
        self.navigationController?.navigationBar.barTintColor = .darkGray
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        let barButtonClose = UIBarButtonItem(image: UIImage(named: "arrow")?.withRenderingMode(.alwaysTemplate), style: .plain, target: self, action: #selector(closeView(_:)))
        barButtonClose.tintColor = .white
        
        self.navigationItem.setLeftBarButton(barButtonClose, animated: true)
        
        let qrCode = QRCode(ConnectionBetweenVC.tripID)
        QRCodeImageView.image = qrCode?.image
        
        NSLayoutConstraint.activate([QRCodeImageView.widthAnchor.constraint(equalTo: QRCodeImageView.heightAnchor)])
        let barQRCode = UIBarButtonItem(customView: QRCodeImageView)
        self.navigationItem.setRightBarButton(barQRCode, animated: true)

        
        view.addSubview(interactiveBackgroundMap)
        NSLayoutConstraint.activate([interactiveBackgroundMap.leftAnchor.constraint(equalTo: view.leftAnchor), interactiveBackgroundMap.rightAnchor.constraint(equalTo: view.rightAnchor), interactiveBackgroundMap.topAnchor.constraint(equalTo: view.topAnchor), interactiveBackgroundMap.bottomAnchor.constraint(equalTo: view.bottomAnchor)])
        
        
        view.addSubview(actionButton)
        
        let modelName = UIDevice.current.modelName
        
        if modelName ==  "iPhone X" {
            NSLayoutConstraint.activate([actionButton.leftAnchor.constraint(equalTo: view.leftAnchor), actionButton.rightAnchor.constraint(equalTo: view.rightAnchor), actionButton.heightAnchor.constraint(equalToConstant: 60), actionButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)])
        } else {
                NSLayoutConstraint.activate([actionButton.leftAnchor.constraint(equalTo: view.leftAnchor), actionButton.rightAnchor.constraint(equalTo: view.rightAnchor), actionButton.heightAnchor.constraint(equalToConstant: 60), actionButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)])
        }
        
        
        interactiveBackgroundMap.setZoomLevel(17, animated: true)
        
        // Ask for Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
            locationManager.startUpdatingLocation()
        }
        
        
        performLogicOnButtonTitle()
        
    }
    
    
    override func viewDidLayoutSubviews() {
        actionButton.addShadow()
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
        let styleURL = URL(string: "mapbox://styles/dasprato/cjfr0k7z85le32sp1bembn1f6")
        let mt = MGLMapView()
        mt.styleURL =  MGLStyle.darkStyleURL()
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
    
    @objc func onActionButtonTapped() {
        if ConnectionBetweenVC.trip.tripStatus == "Initialised" {
            // Initial hit
            print("Take actions for Initialised")

            ConnectionBetweenVC.trip = Trip(amount: ConnectionBetweenVC.trip.amount!, cargo: ConnectionBetweenVC.trip.cargo!, from: ConnectionBetweenVC.trip.from!, to: ConnectionBetweenVC.trip.fromDate!, initiliased: ConnectionBetweenVC.trip.initiliased!, tripStatus: "Sailing", vesselReferencePath: ConnectionBetweenVC.trip.vesselReferencePath!, tripId: ConnectionBetweenVC.trip.tripId!, fromDate: ConnectionBetweenVC.trip.fromDate!, toDate: ConnectionBetweenVC.trip.toDate!, vesselName: ConnectionBetweenVC.trip.vesselName!)
            performLogicOnButtonTitle()
            
        }
        else if ConnectionBetweenVC.trip.tripStatus == "Sailing" {
            // Start and Between trip hits
            print("Take actions for Sailing")
            
            ConnectionBetweenVC.trip = Trip(amount: ConnectionBetweenVC.trip.amount!, cargo: ConnectionBetweenVC.trip.cargo!, from: ConnectionBetweenVC.trip.from!, to: ConnectionBetweenVC.trip.fromDate!, initiliased: ConnectionBetweenVC.trip.initiliased!, tripStatus: "TripPaused", vesselReferencePath: ConnectionBetweenVC.trip.vesselReferencePath!, tripId: ConnectionBetweenVC.trip.tripId!, fromDate: ConnectionBetweenVC.trip.fromDate!, toDate: ConnectionBetweenVC.trip.toDate!, vesselName: ConnectionBetweenVC.trip.vesselName!)
            performLogicOnButtonTitle()

        }
        else if ConnectionBetweenVC.trip.tripStatus == "TripPaused" {
            // Between trip hits
            ConnectionBetweenVC.trip = Trip(amount: ConnectionBetweenVC.trip.amount!, cargo: ConnectionBetweenVC.trip.cargo!, from: ConnectionBetweenVC.trip.from!, to: ConnectionBetweenVC.trip.fromDate!, initiliased: ConnectionBetweenVC.trip.initiliased!, tripStatus: "Sailing", vesselReferencePath: ConnectionBetweenVC.trip.vesselReferencePath!, tripId: ConnectionBetweenVC.trip.tripId!, fromDate: ConnectionBetweenVC.trip.fromDate!, toDate: ConnectionBetweenVC.trip.toDate!, vesselName: ConnectionBetweenVC.trip.vesselName!)
            performLogicOnButtonTitle()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // This runs only when device location is updated
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        if ConnectionBetweenVC.trip.tripStatus! == "Initialised" {
            interactiveBackgroundMap.setCenter(locValue, animated: true)
            let locationCoorindate = CLLocationCoordinate2DMake(locValue.latitude, locValue.longitude)
            self.navigationItem.title = "Initialised: (" + String(locValue.latitude) + ", " + String(locValue.longitude) + ")"
        }

        else if ConnectionBetweenVC.trip.tripStatus! == "Sailing" {
            let timeStamp = "\(String(describing: Date().timeIntervalSince1970))"
            let db = Firestore.firestore()
            db.collection("Trips").document(ConnectionBetweenVC.trip.tripId!).collection("LocationLog").document(timeStamp).setData(["lat": locValue.latitude, "long": locValue.longitude])
            self.navigationItem.title = "Sailing: (" + String(locValue.latitude) + ", " + String(locValue.longitude) + ")"
        }
        
        else if ConnectionBetweenVC.trip.tripStatus! == "TripPaused" {
            let timeStamp = "\(String(describing: Date().timeIntervalSince1970))"
            let db = Firestore.firestore()
            db.collection("Trips").document(ConnectionBetweenVC.trip.tripId!).collection("LocationLog").document(timeStamp).setData(["lat": locValue.latitude, "long": locValue.longitude])
            self.navigationItem.title = "Trip Paused: (" + String(locValue.latitude) + ", " + String(locValue.longitude) + ")"
        }
        
    }

}
