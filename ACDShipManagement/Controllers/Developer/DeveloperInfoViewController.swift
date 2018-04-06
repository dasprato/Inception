//
//  DeveloperInfoViewController.swift
//  ACDShipManagement
//
//  Created by Prato Das on 2018-03-18.
//  Copyright © 2018 Prato Das. All rights reserved.
//

import UIKit

class DeveloperInfoViewController: InteractiveViewController {
    
    var developerName: String?
    var developerImage: UIImage?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setupBarButtons()
        setupDeveloperImageViewAndNameLabel()
        
    }
    
    
    
    
    func setupBarButtons() {
        view.addSubview(closeButton)
        NSLayoutConstraint.activate([closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor), closeButton.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 16), closeButton.heightAnchor.constraint(equalToConstant: 40), closeButton.widthAnchor.constraint(equalToConstant: 40)])
    }
    
    func setupDeveloperImageViewAndNameLabel() {
        view.addSubview(developerImageView)
        NSLayoutConstraint.activate([developerImageView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor), developerImageView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor), developerImageView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.8), developerImageView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.8)])
        
        view.addSubview(developerNameView)
        
        NSLayoutConstraint.activate([developerNameView.centerXAnchor.constraint(equalTo: developerImageView.centerXAnchor), developerNameView.topAnchor.constraint(equalTo: developerImageView.bottomAnchor, constant: 8)])
        
        developerNameView.text = developerName
        developerImageView.image = developerImage
    }
    
    override func viewDidLayoutSubviews() {
        developerImageView.layer.cornerRadius = developerImageView.layer.frame.height / 2
        
    }
    
    var closeButton: UIButton = {
        let cb = UIButton(type: .system)
        cb.setImage(UIImage(named: "arrow")?.withRenderingMode(.alwaysTemplate), for: .normal)
        cb.translatesAutoresizingMaskIntoConstraints = false
        cb.addTarget(self, action: #selector(closeView(_:)), for: .touchUpInside)
        cb.tintColor = .black
        cb.contentMode = .scaleAspectFit
        return cb
    }()

    
    
    private var developerImageView: UIImageView = {
        let div = UIImageView()
        div.translatesAutoresizingMaskIntoConstraints = false
        div.clipsToBounds = true
        return div
    }()
    
    private var developerNameView: UILabel = {
        let dnv = UILabel()
        dnv.translatesAutoresizingMaskIntoConstraints = false
        dnv.font = UIFont.boldSystemFont(ofSize: dnv.font.pointSize * 2)
        dnv.adjustsFontSizeToFitWidth = true
        dnv.textAlignment = .center
        
    
        return dnv
    }()
}

