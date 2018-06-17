//
//  MenuViewControllerExtensions.swift
//  ACDShipManagement
//
//  Created by Prato Das on 2018-06-07.
//  Copyright © 2018 Prato Das. All rights reserved.
//

import UIKit


// extension for oppenning the other view controllers
extension MenuViewController {
    @objc func createShip() {
        self.present(UINavigationController(rootViewController: CreateShipViewController()), animated: true, completion: nil)
    }
    @objc func readShip() {
        self.present(UINavigationController(rootViewController: ReadShipViewController()), animated: true, completion: nil)
    }
    @objc func updateShip() {
        UpdateShipViewController().showInteractive()
    }
    
    @objc func deleteShip() {
        DeleteShipViewController().showInteractive()
    }
    
    
    @objc func createCompany() {
        self.present(UINavigationController(rootViewController: CreateCompanyViewController()), animated: true, completion: nil)
    }
    @objc func readCompany() {
        self.present(UINavigationController(rootViewController: ReadCompanyViewController()), animated: true, completion: nil)
    }
    @objc func updateCompany() {
        UpdateCompanyViewController().showInteractive()
    }
    
    @objc func deleteCompany() {
        DeleteCompanyViewController().showInteractive()
    }
    
    @objc func createTrip() {
        let vc = CreateTripViewController1()
        vc.modalTransitionStyle = .crossDissolve
        self.present(UINavigationController(rootViewController: vc), animated: true, completion: nil)
    }
    
    @objc func sailTrip() {
        let vc = SailTripViewController1()
        vc.modalTransitionStyle = .crossDissolve
        self.present(UINavigationController(rootViewController: vc), animated: true, completion: nil)
    }
    
    @objc func readTrip() {
        let vc = ReadTripViewController()
        vc.modalTransitionStyle = .crossDissolve
        self.present(UINavigationController(rootViewController: vc), animated: true, completion: nil)
    }
    @objc func updateTrip() {
        UpdateTripViewController().showInteractive()
    }
    
    @objc func deleteTrip() {
        DeleteTripViewController().showInteractive()
    }
    
    @objc func createContact() {
        
        self.present(UINavigationController(rootViewController: CreateContactViewController()), animated: true, completion: nil)
        
    }
    @objc func readQRCode() {
        self.present(UINavigationController(rootViewController: QRCodeReaderViewController()), animated: true, completion: nil)
    }
    @objc func readContact() {
        self.present(UINavigationController(rootViewController: ReadContactViewController()), animated: true, completion: nil)
    }
    
    @objc func openPratoInfo() {
        let developerInfoViewController = DeveloperInfoViewController()
        developerInfoViewController.developerName = "Prato Das"
        developerInfoViewController.developerImage = UIImage(named: "prato")
        developerInfoViewController.showInteractive()
    }
    
    @objc func openShubranilInfo() {
        let developerInfoViewController = DeveloperInfoViewController()
        developerInfoViewController.developerName = "Shubranil Sengupta"
        developerInfoViewController.developerImage = UIImage(named: "shubranil")
        developerInfoViewController.showInteractive()
    }
    
    @objc func openSumitInfo() {
        let developerInfoViewController = DeveloperInfoViewController()
        developerInfoViewController.developerName = "Sumit Somani"
        developerInfoViewController.developerImage = UIImage(named: "sumit")
        developerInfoViewController.showInteractive()
    }
}



