//
//  ViewController.swift
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

class ShipTrackViewController: UIViewController, MGLMapViewDelegate, CLLocationManagerDelegate {
    
    var directionsRoute: Route?
    var firstTimeFlag = true
    
    let locationManager = CLLocationManager()
    
    fileprivate func plotShipsOnMap() {
        // Create four new point annotations with specified coordinates and titles.
        let pointA = MyCustomPointAnnotation()
        pointA.coordinate = CLLocationCoordinate2D(latitude: 13.5317, longitude: 89)
        pointA.title = "MV SS Helencha 7"
        
        
        let pointB = MyCustomPointAnnotation()
        pointB.coordinate = CLLocationCoordinate2D(latitude: 23.597159, longitude: 90.573151)
        pointB.title = "MV SS Helencha 2"
        
        
        let pointC = MyCustomPointAnnotation()
        pointC.title = "MV SS Helencha 1"
        pointC.coordinate = CLLocationCoordinate2D(latitude: 21.676898, longitude: 91.778931)
        
        let pointD = MyCustomPointAnnotation()
        pointD.title = "MV Al Jihad"
        pointD.coordinate = CLLocationCoordinate2D(latitude: 20.95284782222657, longitude: 91.69104026967057)
        
        let pointE = MyCustomPointAnnotation()
        pointE.title = "MV Banglar Drishti"
        pointE.coordinate = CLLocationCoordinate2D(latitude: 21.893741, longitude: 87.955689)
        
        // Fill an array with four point annotations.
        let myPlaces = [pointA, pointB, pointC, pointD, pointE]
        
        // Add all annotations to the map all at once, instead of individually.
        interactiveBackgroundMap.addAnnotations(myPlaces)
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
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        
        interactiveBackgroundMap.delegate = self

        view.addSubview(interactiveBackgroundMap)
        NSLayoutConstraint.activate([interactiveBackgroundMap.centerXAnchor.constraint(equalTo: view.centerXAnchor), interactiveBackgroundMap.centerXAnchor.constraint(equalTo: view.centerXAnchor), interactiveBackgroundMap.heightAnchor.constraint(equalTo: view.heightAnchor), interactiveBackgroundMap.widthAnchor.constraint(equalTo: view.widthAnchor)])
        

        
        // Add a gesture recognizer to the map view
        let setDestination = UILongPressGestureRecognizer(target: self, action: #selector(didLongPress(_:)))
        interactiveBackgroundMap.addGestureRecognizer(setDestination)
        
        interactiveBackgroundMap.delegate = self

        // Method to plot ships on the graph
        plotShipsOnMap()
    }
    
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
    
    // Calculate route to be used for navigation
    func calculateRoute(from origin: CLLocationCoordinate2D,
                        to destination: CLLocationCoordinate2D,
                        completion: @escaping (Route?, Error?) -> ()) {
        
        // Coordinate accuracy is the maximum distance away from the waypoint that the route may still be considered viable, measured in meters. Negative values indicate that a indefinite number of meters away from the route and still be considered viable.
        let origin = Waypoint(coordinate: origin, coordinateAccuracy: -1, name: "Start")
        let destination = Waypoint(coordinate: destination, coordinateAccuracy: -1, name: "Finish")
        
        // Specify that the route is intended for automobiles avoiding traffic
        let options = NavigationRouteOptions(waypoints: [origin, destination], profileIdentifier: .automobileAvoidingTraffic)
        
        // Generate the route object and draw it on the map
        _ = Directions.shared.calculate(options) { [unowned self] (waypoints, routes, error) in
            self.directionsRoute = routes?.first
            // Draw the route on the map after creating it
            self.drawRoute(route: self.directionsRoute!)
        }
    }
    
    // Present the navigation view controller when the callout is selected
    func mapView(_ mapView: MGLMapView, tapOnCalloutFor annotation: MGLAnnotation) {
        
        let navigationViewController = NavigationViewController(for: directionsRoute!, styles: [CustomStyle()])
        self.present(navigationViewController, animated: true, completion: nil)
    }
    

    func drawRoute(route: Route) {
        guard route.coordinateCount > 0 else { return }
        // Convert the route’s coordinates into a polyline
        var routeCoordinates = route.coordinates!
        let polyline = MGLPolylineFeature(coordinates: &routeCoordinates, count: route.coordinateCount)
        
        // If there's already a route line on the map, reset its shape to the new route
        if let source = interactiveBackgroundMap.style?.source(withIdentifier: "route-source") as? MGLShapeSource {
            source.shape = polyline
        } else {
            let source = MGLShapeSource(identifier: "route-source", features: [polyline], options: nil)
            
            // Customize the route line color and width
            let lineStyle = MGLLineStyleLayer(identifier: "route-style", source: source)
            lineStyle.lineColor = MGLStyleValue(rawValue: #colorLiteral(red: 0.1897518039, green: 0.3010634184, blue: 0.7994888425, alpha: 1))
            lineStyle.lineWidth = MGLStyleValue(rawValue: 3)
            
            // Add the source and style layer of the route line to the map
            interactiveBackgroundMap.style?.addSource(source)
            interactiveBackgroundMap.style?.addLayer(lineStyle)
        }
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
    @objc func didLongPress(_ sender: UILongPressGestureRecognizer) {
        guard sender.state == .began else { return }
        
        // Converts point where user did a long press to map coordinates
        let point = sender.location(in: interactiveBackgroundMap)
        let coordinate = interactiveBackgroundMap.convert(point, toCoordinateFrom: interactiveBackgroundMap)
        
        // Create a basic point annotation and add it to the map
        let annotation = MGLPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = "Start navigation"
        interactiveBackgroundMap.addAnnotation(annotation)
        
        // Calculate the route from the user's location to the set destination
        calculateRoute(from: (interactiveBackgroundMap.userLocation!.coordinate), to: annotation.coordinate) { (route, error) in
            if error != nil {
                print("Error calculating route")
            }
        }
    }
    
    
    

    
    
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
        
        
        let textLabel: UILabel = {
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

