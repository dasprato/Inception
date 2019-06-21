//
//  ShipViewController.swift
//  ACDShipManagement
//
//  Created by Prato Das on 2018-01-25.
//  Copyright © 2018 Prato Das. All rights reserved.
//
import UIKit
import Mapbox
import MapKit
import MapboxCoreNavigation
import MapboxNavigation
import MapboxDirections
import Firebase

class ShipViewController: UIViewController {
    
    var arrayOfShips: [Ship] = [Ship]()  {
        didSet {
            print(arrayOfShips)
        }
    }
    
    
    
    var directionsRoute: Route?
    var firstTimeFlag = true
    
    let locationManager = CLLocationManager()
    
    fileprivate func plotShipsOnMap() {
        // Create four new point annotations with specified coordinates and titles.
        //        interactiveBackgroundMap.removeAnnotations(interactiveBackgroundMap.annotations)
//        addPoint(withTitle: "MV SS Helencha 7", andLocationCooridinate: CLLocationCoordinate2D(latitude: 23.597159, longitude: 90.573151))
//        addPoint(withTitle: "MV SS Helencha 2", andLocationCooridinate: CLLocationCoordinate2D(latitude: 23.597159, longitude: 89))
//        addPoint(withTitle: "MV SS Helencha 1", andLocationCooridinate:  CLLocationCoordinate2D(latitude: 21.676898, longitude: 91.778931))
//        addPoint(withTitle: "MV Al Jihad", andLocationCooridinate: CLLocationCoordinate2D(latitude: 20.95284782222657, longitude: 91.69104026967057))
//        addPoint(withTitle: "MV Banglar Drishti", andLocationCooridinate: CLLocationCoordinate2D(latitude: 21.893741, longitude: 87.955689))
    }
    
    func addPoint(withTitle title: String, andLocationCooridinate coordinate: CLLocationCoordinate2D) {
        let point = MyCustomPointAnnotation()
        point.title = title
        point.coordinate = coordinate
        interactiveBackgroundMap.addAnnotation(point)
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
                    guard let currentStatus = difference.document.data()["currentStatus"] as? String else { return }
                    guard let vesselName = difference.document.data()["vesselName"] as? String else { return }
                    self.arrayOfShips.append(Ship(representativeEmail: representativeEmail, representativeName: representativeName, representativePhone: representativePhone, vesselCapacity: vesselCapacity, vesselName: vesselName, shipId: difference.document.documentID, currentStatus: currentStatus))
                    print(vesselName)
                    
                    let latitude = arc4random_uniform(90)
                    let longitude = arc4random_uniform(180)
                    
                    self.addPoint(withTitle: vesselName, andLocationCooridinate: CLLocationCoordinate2D(latitude: CLLocationDegrees(latitude), longitude: CLLocationDegrees(longitude)))
                }
                
                if (difference.type == .modified) {
                    for i in 0..<self.arrayOfShips.count {
                        if self.arrayOfShips[i].shipId == difference.document.documentID {
                            self.arrayOfShips[i] = (Ship(representativeEmail: difference.document.data()["representativeEmail"]! as? String, representativeName: difference.document.data()["representativeName"]! as? String, representativePhone: difference.document.data()["representativePhone"]! as? String, vesselCapacity: difference.document.data()["vesselCapacity"]! as? String, vesselName: difference.document.data()["vesselName"]! as? String, shipId: difference.document.documentID, currentStatus: difference.document.data()["currentStatus"]! as? String))
                            return
                        }
                    }
                }
                if (difference.type == .removed) {
                    // TODO: Find an efficient solution
                    print("Removed contact: \(difference.document.documentID)")
                    for i in 0..<self.arrayOfShips.count {
                        if self.arrayOfShips[i].shipId == difference.document.documentID {
                            self.arrayOfShips.remove(at: i)
                            return
                        }
                    }
                }
            })
        }
    }
    
    
    @objc func updateShipsOnMap() {
        for i in 0..<interactiveBackgroundMap.annotations!.count {
            if let annotation = self.interactiveBackgroundMap.annotations![i] as? MyCustomPointAnnotation {
                annotation.coordinate = CLLocationCoordinate2D(latitude: annotation.coordinate.latitude - 0.001, longitude: annotation.coordinate.longitude - 0.001)
            }
            
            //            interactiveBackgroundMap.annotations!.remove(at: i)
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationController?.navigationBar.barTintColor = .gray
        self.navigationController?.navigationBar.topItem?.title = "Ship"
        navigationController?.hidesBarsOnSwipe = true
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationBar.isHidden = true
        
        // Ask for Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            //            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        
        interactiveBackgroundMap.delegate = self
        
        view.addSubview(interactiveBackgroundMap)
        NSLayoutConstraint.activate([interactiveBackgroundMap.centerXAnchor.constraint(equalTo: view.centerXAnchor), interactiveBackgroundMap.centerXAnchor.constraint(equalTo: view.centerXAnchor), interactiveBackgroundMap.heightAnchor.constraint(equalTo: view.heightAnchor), interactiveBackgroundMap.widthAnchor.constraint(equalTo: view.widthAnchor)])
        
        
        interactiveBackgroundMap.delegate = self
        
        // Method to plot ships on the graph
        plotShipsOnMap()
        
        
        Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateShipsOnMap), userInfo: nil, repeats: true)
        
        fetchShips()
    }
    
    
    
    
    
    
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .slide
    }
    
    
    var interactiveBackgroundMap: NavigationMapView = {
        let mt = NavigationMapView()
        mt.styleURL = MGLStyle.darkStyleURL()
        mt.translatesAutoresizingMaskIntoConstraints = false
        mt.clipsToBounds = true
        mt.isZoomEnabled = true
        mt.isScrollEnabled = true
        mt.showsUserLocation = true
        mt.isPitchEnabled = false
        mt.isUserInteractionEnabled = true
        return mt
    }()
    
    
    
    
    
    
    // This delegate method is where you tell the map to load a view for a specific annotation based on the willUseImage property of the custom subclass.
    func mapView(_ mapView: MGLMapView, viewFor annotation: MGLAnnotation) -> MGLAnnotationView? {
        
        if let castAnnotation = annotation as? MyCustomPointAnnotation {
            if (castAnnotation.willUseImage) {
                return nil;
            }
        }
        
        // Assign a reuse identifier to be used by both of the annotation views, taking advantage of their similarities.
        let reuseIdentifier = "reusableDotView"
        
        // For better performance, always try to reuse existing annotations.
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier)
        
        
        let shipNameLabel: UILabel = {
            let tl = UILabel()
            tl.translatesAutoresizingMaskIntoConstraints = false
            tl.text = "Ship"
            tl.textColor = UIColor.blue
            return tl
        }()
        
        // If there’s no reusable annotation view available, initialize a new one.
        if annotationView == nil {
            
            annotationView = MGLAnnotationView(reuseIdentifier: reuseIdentifier)
            annotationView?.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
            annotationView!.backgroundColor = UIColor.clear
            
            let detailsLabel:UILabel = UILabel()
            detailsLabel.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
            detailsLabel.textAlignment = .center
            detailsLabel.text = "🚢"
            //                detailsLabel.textColor = UIColor(red:175/255 ,green:255/255, blue:255/255 , alpha:0.75)
            detailsLabel.textColor = UIColor.white
            detailsLabel.font = UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)
            
            let strokeTextAttributes = [NSAttributedStringKey.strokeColor : UIColor.black, NSAttributedStringKey.strokeWidth : -5.0,] as [NSAttributedStringKey : Any]
            
            detailsLabel.attributedText = NSAttributedString(string: "🚢", attributes: strokeTextAttributes)
            detailsLabel.backgroundColor = UIColor.clear
            detailsLabel.clipsToBounds = true
            detailsLabel.layer.cornerRadius = 5.0
            detailsLabel.layer.borderWidth = 2.0
            detailsLabel.layer.borderColor = UIColor.clear.cgColor
            annotationView?.addSubview(detailsLabel)
        }
        
        return annotationView
    }
    
    // This delegate method is where you tell the map to load an image for a specific annotation based on the willUseImage property of the custom subclass.
    func mapView(_ mapView: MGLMapView, imageFor annotation: MGLAnnotation) -> MGLAnnotationImage? {
        
        if let castAnnotation = annotation as? MyCustomPointAnnotation {
            if (!castAnnotation.willUseImage) {
                return nil
            }
        }
        
        // For better performance, always try to reuse existing annotations.
        var annotationImage = mapView.dequeueReusableAnnotationImage(withIdentifier: "camera")
        
        // If there is no reusable annotation image available, initialize a new one.
        if(annotationImage == nil) {
            annotationImage = MGLAnnotationImage(image: UIImage(named: "shipclipart")!, reuseIdentifier: "camera")
        }
        
        return annotationImage
    }
    
    func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        // Always allow callouts to popup when annotations are tapped.
        return true
    }
    
    
}

extension ShipViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        interactiveBackgroundMap.setZoomLevel(6, animated: false)
        let locationCoorindate = CLLocationCoordinate2DMake(locValue.latitude, locValue.longitude)
        interactiveBackgroundMap.setCenter(locValue, animated: true)
        print(locValue.latitude)
        print(locValue.longitude)
        
        
        let locationId = String(describing: Date().timeIntervalSince1970)
        let db = Firestore.firestore()
        let locationDictionary: [String: Any?] = ["latitude": locValue.latitude, "longitude": locValue.longitude]
        db.collection("MyLocations").document(locationId).setData(locationDictionary)
    }
}

extension ShipViewController: MGLMapViewDelegate {
    // Present the navigation view controller when the callout is selected
    func mapView(_ mapView: MGLMapView, tapOnCalloutFor annotation: MGLAnnotation) {
        
        let navigationViewController = NavigationViewController(for: directionsRoute!, styles: [CustomStyle()])
        self.present(navigationViewController, animated: true, completion: nil)
    }
}

class CustomStyle: NightStyle {
    required init() {
        super.init()
        mapStyleURL = MGLStyle.darkStyleURL()
        styleType = .dayStyle
    }
    override func apply() {
        super.apply()
    }
}




// MGLPointAnnotation subclass
class MyCustomPointAnnotation: MGLPointAnnotation {
    var willUseImage: Bool = false
}
