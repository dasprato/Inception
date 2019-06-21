//
//  SelectContactViewController.swift
//  ACDShipManagement
//
//  Created by Prato Das on 2018-03-30.
//  Copyright © 2018 Prato Das. All rights reserved.
//

import UIKit
import Firebase
class EditContactViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchContacts()
        view.backgroundColor = .gray
    }
    
    
    func fetchContacts() {
        let db = Firestore.firestore()
        db.collection("Contacts").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    print("\(document.documentID)")
                }
            }
        }
    }
    
    
    
    
    
}
