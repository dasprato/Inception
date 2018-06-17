//
//  AccountViewController.swift
//  ACDShipManagement
//
//  Created by Prato Das on 2018-01-27.
//  Copyright © 2018 Prato Das. All rights reserved.
//

import UIKit
import Firebase

class AccountViewController: UIViewController {

    
    let colors = ColorForAccount()
    var backgroundLayer = CAGradientLayer()
    
    
    func refresh() {
        view.backgroundColor = UIColor.clear
        backgroundLayer = colors.gl
        view.layer.insertSublayer(backgroundLayer, at: 0)
    }
    
    
    override func viewDidLayoutSubviews() {
        self.backgroundLayer.frame = view.frame
        logout.addShadow()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        refresh()
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationController?.navigationBar.barTintColor = .gray
        self.navigationController?.navigationBar.topItem?.title = "Account"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationBar.isHidden = true
        
        
        view.addSubview(logout)
        
        NSLayoutConstraint.activate([logout.centerXAnchor.constraint(equalTo: view.centerXAnchor), logout.centerYAnchor.constraint(equalTo: view.centerYAnchor), logout.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -16), logout.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 16), logout.heightAnchor.constraint(equalToConstant: 32)])
        
    }

    var logout: CustomUIButton = {
        let lgt = CustomUIButton(type: .system)
        lgt.translatesAutoresizingMaskIntoConstraints = false
        lgt.backgroundColor = .green
        lgt.setTitle("Logout", for: .normal)
        lgt.setTitleColor(.white, for: .normal)
        lgt.addTarget(self, action: #selector(handleLogout), for: .touchUpInside)
        lgt.layer.cornerRadius = 5.0
        return lgt
    }()
    
    @objc func handleLogout() {
        do {
            try Auth.auth().signOut()
        } catch let logoutError {
            print(logoutError)
        }
        let viewControllerToPresent = LoginController()
        
        self.present(UINavigationController(rootViewController: viewControllerToPresent), animated: true, completion: nil)
    }
    
    class ColorForAccount {
        var gl:CAGradientLayer!
        
        init() {
            let colorTop = UIColor.blue.cgColor
            let colorBottom = UIColor.gray.cgColor
            self.gl = CAGradientLayer()
            self.gl.colors = [colorTop, colorBottom]
            self.gl.locations = [0.0, 0.5]
        }
    }
}
