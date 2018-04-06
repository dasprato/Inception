//
//  AccountViewController.swift
//  ACDShipManagement
//
//  Created by Prato Das on 2018-01-27.
//  Copyright © 2018 Prato Das. All rights reserved.
//

import UIKit

class AccountViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationController?.navigationBar.barTintColor = .gray
        self.navigationController?.navigationBar.topItem?.title = "Account"
        view.backgroundColor = .white
        
    }


}
