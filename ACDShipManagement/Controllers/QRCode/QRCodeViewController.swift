//
//  QRCodeViewController.swift
//  ACDShipManagement
//
//  Created by Prato Das on 2018-04-01.
//  Copyright © 2018 Prato Das. All rights reserved.
//

import UIKit
import Mapbox
import QRCode


class QRCodeViewController: UIViewController {
    
    var id: String? {
        didSet {
            let qrCode = QRCode(id!)
            QRCodeViewController.qrCodeImageView.image = qrCode?.image
        }
    }

    var qrCodePortraitContraintsArray = [NSLayoutConstraint]()
    var qrCodeLandscapetContraintsArray = [NSLayoutConstraint]()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationController?.navigationBar.barTintColor = .gray
        view.addSubview(QRCodeViewController.qrCodeImageView)
        
        NSLayoutConstraint.activate([QRCodeViewController.qrCodeImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor), QRCodeViewController.qrCodeImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor)])
        
        qrCodePortraitContraintsArray = [QRCodeViewController.qrCodeImageView.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7), QRCodeViewController.qrCodeImageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7)]
        qrCodeLandscapetContraintsArray = [QRCodeViewController.qrCodeImageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.7), QRCodeViewController.qrCodeImageView.widthAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.7)]

        checkAndAdjustContraintst()
        
        view.addSubview(closeButton)
        view.addSubview(shareButton)
        
        NSLayoutConstraint.activate([closeButton.topAnchor.constraint(equalTo: QRCodeViewController.qrCodeImageView.bottomAnchor), closeButton.rightAnchor.constraint(equalTo: QRCodeViewController.qrCodeImageView.rightAnchor), closeButton.widthAnchor.constraint(equalTo: QRCodeViewController.qrCodeImageView.widthAnchor, multiplier: 0.5), closeButton.heightAnchor.constraint(equalToConstant: 40)])
        
        NSLayoutConstraint.activate([shareButton.topAnchor.constraint(equalTo: QRCodeViewController.qrCodeImageView.bottomAnchor), shareButton.widthAnchor.constraint(equalTo: QRCodeViewController.qrCodeImageView.widthAnchor, multiplier: 0.5), shareButton.leftAnchor.constraint(equalTo: QRCodeViewController.qrCodeImageView.leftAnchor), shareButton.heightAnchor.constraint(equalToConstant: 40)])
    }
    

    var shareButton: CustomUIButton = {
        var cb = CustomUIButton(type: .system)
        cb.setTitle("Share", for: .normal)
        cb.backgroundColor = .blue
        cb.addTarget(self, action: #selector(openShareController), for: .touchUpInside)
        return cb
    }()
    
    var closeButton: CustomUIButton = {
        let cb = CustomUIButton(type: .system)
        cb.setTitle("Close", for: .normal)
        cb.addTarget(self, action: #selector(closeView(_:)), for: .touchUpInside)
        return cb
    }()
    
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        checkAndAdjustContraintst()
    }
    

    fileprivate func checkAndAdjustContraintst() {
        if UIDevice.current.orientation.isLandscape {
            NSLayoutConstraint.activate(qrCodeLandscapetContraintsArray)
            NSLayoutConstraint.deactivate(qrCodePortraitContraintsArray)
        }
        else {
            NSLayoutConstraint.activate(qrCodePortraitContraintsArray)
            NSLayoutConstraint.deactivate(qrCodeLandscapetContraintsArray)
        }
    }

    static var qrCodeImageView: UIImageView = {
        let civ = UIImageView()
        civ.image = UIImage(named: "contact")
        civ.translatesAutoresizingMaskIntoConstraints = false
        civ.clipsToBounds = true
        civ.backgroundColor = .white
        civ.isUserInteractionEnabled = true
        civ.contentMode = .scaleAspectFit
        return civ
    }()
    
    var containerView: UIView = {
        let cv = UIView()
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.clipsToBounds = true
        cv.backgroundColor = .white
        return cv
    }()
    
    func setupObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(removePopViewController), name: NSNotification.Name.init("didSelectADifferentTab"), object: nil)
    }
    
    
    @objc func removePopViewController() {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        QRCodeViewController.qrCodeImageView.addShadow()
        closeButton.addShadow()
        shareButton.addShadow()
    }
}
