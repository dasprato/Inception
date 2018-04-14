//
//  TripCompletedViewController.swift
//  ACDShipManagement
//
//  Created by Prato Das on 2018-04-13.
//  Copyright © 2018 Prato Das. All rights reserved.
//

import UIKit

class TripHistoryViewController: UIViewController {
    var imageAnchorsPortraitConstraints = [NSLayoutConstraint]()
    var textFieldAnchorsPortraitConstraints = [NSLayoutConstraint]()
    var imageAnchorsLandscapeConstraints = [NSLayoutConstraint]()
    var textFieldAnchorsLandscapeConstraints = [NSLayoutConstraint]()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(image)
//        view.addSubview(tripCompletedTextField)
        
        self.navigationItem.title = ConnectionBetweenVC.trip.tripStatus!
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
            navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        
        
        imageAnchorsPortraitConstraints = [image.topAnchor.constraint(equalTo: view.topAnchor), image.bottomAnchor.constraint(equalTo: view.bottomAnchor), image.rightAnchor.constraint(equalTo: view.rightAnchor), image.leftAnchor.constraint(equalTo: view.leftAnchor)]
        

//        textFieldAnchorsPortraitConstraints = [tripCompletedTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor), tripCompletedTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor), tripCompletedTextField.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -16), tripCompletedTextField.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 16)]
        
        
        imageAnchorsLandscapeConstraints = [image.topAnchor.constraint(equalTo: view.topAnchor), image.bottomAnchor.constraint(equalTo: view.bottomAnchor), image.rightAnchor.constraint(equalTo: view.rightAnchor), image.leftAnchor.constraint(equalTo: view.leftAnchor)]
        
        
//        textFieldAnchorsLandscapeConstraints = [tripCompletedTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor), tripCompletedTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor), tripCompletedTextField.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -16), tripCompletedTextField.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 16)]
        
        checkAndAdjustContraints()
        
    }
    
    func checkAndAdjustContraints() {
        
            NSLayoutConstraint.activate(textFieldAnchorsLandscapeConstraints)
            NSLayoutConstraint.activate(imageAnchorsLandscapeConstraints)

        

    }
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
    


}
