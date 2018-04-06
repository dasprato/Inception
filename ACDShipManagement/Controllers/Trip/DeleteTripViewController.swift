//
//  DeleteTripViewController.swift
//  ACDShipManagement
//
//  Created by Prato Das on 2018-02-05.
//  Copyright © 2018 Prato Das. All rights reserved.
//

import UIKit

class DeleteTripViewController: InteractiveViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationController?.navigationBar.barTintColor = .gray
        self.navigationItem.title = "Delete Trip"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        setupBarButtons()
    }
    
    
    func setupBarButtons() {
        view.backgroundColor = .darkGray
        view.addSubview(closeButton)
        NSLayoutConstraint.activate([closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor), closeButton.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 16), closeButton.heightAnchor.constraint(equalToConstant: 40), closeButton.widthAnchor.constraint(equalToConstant: 40)])
    }
    
    var closeButton: UIButton = {
        let cb = UIButton(type: .system)
        cb.setImage(UIImage(named: "arrow")?.withRenderingMode(.alwaysTemplate), for: .normal)
        cb.translatesAutoresizingMaskIntoConstraints = false
        cb.addTarget(self, action: #selector(closeView(_:)), for: .touchUpInside)
        cb.tintColor = .white
        cb.contentMode = .scaleAspectFit
        return cb
    }()
    


}
