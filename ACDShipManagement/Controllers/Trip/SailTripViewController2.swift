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
        
        view.addSubview(interactiveBackgroundMap)
        NSLayoutConstraint.activate([interactiveBackgroundMap.leftAnchor.constraint(equalTo: view.leftAnchor), interactiveBackgroundMap.rightAnchor.constraint(equalTo: view.rightAnchor), interactiveBackgroundMap.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor), interactiveBackgroundMap.bottomAnchor.constraint(equalTo: view.bottomAnchor)])
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
        
    }
    
    
    var interactiveBackgroundMap: MGLMapView = {
        let styleURL = URL(string: "mapbox://styles/dasprato/cjfr0k7z85le32sp1bembn1f6")
        let mt = MGLMapView()
        mt.styleURL =  MGLStyle.lightStyleURL()
        mt.translatesAutoresizingMaskIntoConstraints = false
        mt.clipsToBounds = true
        mt.isZoomEnabled = true
        mt.isScrollEnabled = true
        mt.showsUserLocation = true
        mt.isPitchEnabled = false
        mt.isUserInteractionEnabled = true
        return mt
    }()
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        
        interactiveBackgroundMap.setCenter(locValue, animated: true)
        let locationCoorindate = CLLocationCoordinate2DMake(locValue.latitude, locValue.longitude)
        print(locationCoorindate)
    }

}
