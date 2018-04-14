//
//  TripCompletedViewController.swift
//  ACDShipManagement
//
//  Created by Prato Das on 2018-04-13.
//  Copyright © 2018 Prato Das. All rights reserved.
//

import UIKit

class TripCompletedViewController: InteractiveViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(image)
        NSLayoutConstraint.activate([
            image.topAnchor.constraint(equalTo: view.topAnchor), image.bottomAnchor.constraint(equalTo: view.bottomAnchor), image.rightAnchor.constraint(equalTo: view.rightAnchor), image.leftAnchor.constraint(equalTo: view.leftAnchor)
            ])
        
        view.addSubview(noConnectionLabel)
        NSLayoutConstraint.activate([
            noConnectionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor), noConnectionLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor), noConnectionLabel.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -16), noConnectionLabel.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 16)
            ])
        
    }
    var image: UIImageView = {
        let img = UIImageView()
        img.translatesAutoresizingMaskIntoConstraints = false
        img.image = UIImage(named: "ship6")?.withRenderingMode(.alwaysOriginal)
        img.contentMode = .scaleAspectFill
        return img
    }()
    
    var noConnectionLabel: CustomUITextField = {
        let ncl = CustomUITextField()
        ncl.text = "TRIP COMPLETED! 🙂"
        ncl.textAlignment = .center
        ncl.textColor = .white
        ncl.font = UIFont.boldSystemFont(ofSize: (ncl.font?.pointSize)! * 2)
        ncl.backgroundColor = UIColor.gray.withAlphaComponent(0.6)
        ncl.isEnabled = false
        ncl.adjustsFontSizeToFitWidth = true
        return ncl
    }()

}
