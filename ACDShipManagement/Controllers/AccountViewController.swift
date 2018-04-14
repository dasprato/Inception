//
//  AccountViewController.swift
//  ACDShipManagement
//
//  Created by Prato Das on 2018-01-27.
//  Copyright © 2018 Prato Das. All rights reserved.
//

import UIKit

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
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        refresh()
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationController?.navigationBar.barTintColor = .gray
        self.navigationController?.navigationBar.topItem?.title = "Ship"
        navigationController?.hidesBarsOnSwipe = true
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationBar.isHidden = true
        
        
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
