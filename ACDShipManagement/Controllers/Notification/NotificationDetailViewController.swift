//
//  NotificationDetailViewController.swift
//  ACDShipManagement
//
//  Created by Prato Das on 2018-02-01.
//  Copyright © 2018 Prato Das. All rights reserved.
//

import UIKit
import Mapbox

protocol NotificationDetailViewControllerDidClose {
    func didClose()
}

protocol NotificationDetailViewControllerDidShow {
    func didShow()
}

class NotificationDetailViewController: UIViewController {
    var firstTimeFlag: Bool = true
    
    var arrayOfMapContraintsForVerticalOrientation: [NSLayoutConstraint]?
    var arrayOfMapContraintsForHorizontalOrientation: [NSLayoutConstraint]?
    var delegate: NotificationDetailViewControllerDidClose?
            let locationManager = CLLocationManager()
    override func viewDidLoad() {
        super.viewDidLoad()


        let popButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(close))
        navigationItem.setLeftBarButtonItems([popButton], animated: true)
        
        
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationController?.navigationBar.barTintColor = .gray
        self.navigationController?.navigationBar.topItem?.title = "Notification Detail"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        view.addSubview(containerView)
        

        arrayOfMapContraintsForHorizontalOrientation = [containerView.widthAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.7), containerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.7), containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor), containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor)]
        
        arrayOfMapContraintsForVerticalOrientation = [containerView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8), containerView.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8), containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor), containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor)]
        if UIDevice.current.orientation.isLandscape {
            NSLayoutConstraint.activate(arrayOfMapContraintsForHorizontalOrientation!)
            NSLayoutConstraint.deactivate(arrayOfMapContraintsForVerticalOrientation!)
        } else {
            NSLayoutConstraint.deactivate(arrayOfMapContraintsForHorizontalOrientation!)
            NSLayoutConstraint.activate(arrayOfMapContraintsForVerticalOrientation!)
//            print("Portrait")
        }
        
        

        containerView.addSubview(interactiveBackgroundMap)
        
        NSLayoutConstraint.activate([interactiveBackgroundMap.topAnchor.constraint(equalTo: containerView.topAnchor), interactiveBackgroundMap.bottomAnchor.constraint(equalTo: containerView.bottomAnchor), interactiveBackgroundMap.rightAnchor.constraint(equalTo: containerView.rightAnchor), interactiveBackgroundMap.leftAnchor.constraint(equalTo: containerView.leftAnchor)])
        
        
        interactiveBackgroundMap.addSubview(closeButton)
        NSLayoutConstraint.activate([closeButton.bottomAnchor.constraint(equalTo: interactiveBackgroundMap.bottomAnchor), closeButton.rightAnchor.constraint(equalTo: interactiveBackgroundMap.rightAnchor), closeButton.leftAnchor.constraint(equalTo: interactiveBackgroundMap.leftAnchor), closeButton.heightAnchor.constraint(equalToConstant: 40)])
        
        interactiveBackgroundMap.showsUserLocation = true
        interactiveBackgroundMap.allowsRotating = false
        interactiveBackgroundMap.showsHeading = true
        interactiveBackgroundMap.showsTraffic = true

        // Ask for Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        
        setupObservers()
    }

    
    @objc func close() {

        dismiss(animated: true, completion: nil)
        delegate?.didClose()
    }
    
    var closeButton: CustomUIButton = {
        let cb = CustomUIButton()
        cb.setTitle("Close", for: .normal)
        cb.addTarget(self, action: #selector(close), for: .touchUpInside)
        return cb
    }()
    
    
    var interactiveBackgroundMap: MGLMapView = {
        let mt = MGLMapView()
        mt.styleURL = MGLStyle.darkStyleURL()
        mt.translatesAutoresizingMaskIntoConstraints = false
        mt.isZoomEnabled = true
        mt.isScrollEnabled = true
        mt.isUserInteractionEnabled = true
        mt.layer.cornerRadius = 10.0
        mt.clipsToBounds = true
        return mt
    }()
    
    var containerView: UIView = {
        let cv = UIView()
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.clipsToBounds = true
        cv.layer.cornerRadius = 10.0
        cv.backgroundColor = .clear
        return cv
    }()

    func setupObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(removePopViewController), name: NSNotification.Name.init("didSelectADifferentTab"), object: nil)
    }

    
    @objc func removePopViewController() {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        if UIDevice.current.orientation.isLandscape {
            NSLayoutConstraint.activate(arrayOfMapContraintsForHorizontalOrientation!)
            NSLayoutConstraint.deactivate(arrayOfMapContraintsForVerticalOrientation!)
        } else {
            NSLayoutConstraint.deactivate(arrayOfMapContraintsForHorizontalOrientation!)
            NSLayoutConstraint.activate(arrayOfMapContraintsForVerticalOrientation!)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOffset = CGSize(width: 0, height: 0)
        containerView.layer.shadowOpacity = 1.0
        containerView.layer.masksToBounds = false
        containerView.layer.shadowPath = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: containerView.frame.width, height: containerView.frame.height), cornerRadius: containerView.layer.cornerRadius).cgPath
    }
    



}


extension NotificationDetailViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        var locValue:CLLocationCoordinate2D = manager.location!.coordinate
        if firstTimeFlag {
            interactiveBackgroundMap.setZoomLevel(10, animated: false)
            firstTimeFlag = false
        }
        var locationCoorindate = CLLocationCoordinate2DMake(locValue.latitude, locValue.longitude)
        interactiveBackgroundMap.setCenter(locValue, animated: true)
        
        interactiveBackgroundMap.isPitchEnabled = false
    }
    
}

extension NotificationViewController {

}
