//
//  CreateTripViewController2.swift
//  ACDShipManagement
//
//  Created by Prato Das on 2018-04-02.
//  Copyright © 2018 Prato Das. All rights reserved.
//

import UIKit
import Mapbox
import Firebase
import NotificationBannerSwift


protocol CreateTripViewController2DidClose {
    func didClose()
}

class CreateTripViewController2: UIViewController {
    var ship: Ship? {
        didSet {
        }
    }
    
    var fromDate: Date?
    var toDate: Date?
    var qrCodePortraintContrainstsArray = [NSLayoutConstraint]()
    var qrCodeLandscapetContrainstsArray = [NSLayoutConstraint]()
    var delegate: CreateTripViewController2DidClose?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationController?.navigationBar.barTintColor = .gray

        view.addSubview(containerView)
        
        NSLayoutConstraint.activate([containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor), containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor)])
        
        qrCodePortraintContrainstsArray = [containerView.heightAnchor.constraint(equalToConstant: 140), containerView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9)]
        qrCodeLandscapetContrainstsArray = [containerView.heightAnchor.constraint(equalToConstant: 140), containerView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9)]
        
        checkAndAdjustContraintst()
        
        view.addSubview(createTripButton)
        NSLayoutConstraint.activate([createTripButton.centerYAnchor.constraint(equalTo: containerView.topAnchor), createTripButton.centerXAnchor.constraint(equalTo: containerView.rightAnchor), createTripButton.widthAnchor.constraint(equalToConstant: 40), createTripButton.heightAnchor.constraint(equalToConstant: 40)])
        
        containerView.addSubview(fromTextField)
        containerView.addSubview(toTextField)
        containerView.addSubview(cargoTextField)
        containerView.addSubview(cargoAmountTextField)
        containerView.addSubview(fromDateTextField)
        containerView.addSubview(toDateTextField)
        
        NSLayoutConstraint.activate([fromTextField.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 4), fromTextField.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.5, constant: -8), fromTextField.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 4), fromTextField.heightAnchor.constraint(equalToConstant: 40)])
        
        NSLayoutConstraint.activate([toTextField.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.5, constant: -8), toTextField.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -4), toTextField.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 4), toTextField.heightAnchor.constraint(equalToConstant: 40)])

        NSLayoutConstraint.activate([cargoTextField.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 4), cargoTextField.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.5, constant: -8), cargoTextField.topAnchor.constraint(equalTo: toTextField.bottomAnchor, constant: 4), cargoTextField.heightAnchor.constraint(equalToConstant: 40)])

        NSLayoutConstraint.activate([cargoAmountTextField.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.5, constant: -8), cargoAmountTextField.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -4), cargoAmountTextField.topAnchor.constraint(equalTo: toTextField.bottomAnchor, constant: 4), cargoAmountTextField.heightAnchor.constraint(equalToConstant: 40)])
        
        NSLayoutConstraint.activate([fromDateTextField.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 4), fromDateTextField.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.5, constant: -8), fromDateTextField.topAnchor.constraint(equalTo: cargoAmountTextField.bottomAnchor, constant: 4), fromDateTextField.heightAnchor.constraint(equalToConstant: 40)])
        
        
        NSLayoutConstraint.activate([toDateTextField.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -4), toDateTextField.topAnchor.constraint(equalTo: cargoAmountTextField.bottomAnchor, constant: 4), toDateTextField.heightAnchor.constraint(equalToConstant: 40), toDateTextField.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.5, constant: -8)])

        let closeTap = UITapGestureRecognizer(target: self, action: #selector(closeAndAlertPreviousViewController))
        view.addGestureRecognizer(closeTap)
        
        fromTextField.becomeFirstResponder()
        
        
        setupDateFieldKeyboards()
        
    }
    
    
    func setupDateFieldKeyboards() {
        let fromDatePicker = UIDatePicker()
        fromDatePicker.minimumDate = Date()
        fromDatePicker.backgroundColor = .darkGray
        fromDatePicker.setValue(UIColor.white, forKeyPath: "textColor")
        fromDatePicker.datePickerMode = .date
        fromDatePicker.addTarget(self, action: #selector(fomDatePickerValueChanged(_:)), for: .allEvents)

        fromDateTextField.inputView = fromDatePicker
        
        
        let toDatePicker = UIDatePicker()
        toDatePicker.minimumDate = Date()
        toDatePicker.backgroundColor = .darkGray
        toDatePicker.setValue(UIColor.white, forKeyPath: "textColor")
        toDatePicker.datePickerMode = .date
        toDatePicker.addTarget(self, action: #selector(toDatePickerValueChanged(_:)), for: .allEvents)
        toDateTextField.inputView = toDatePicker
    }
    
    @objc func toDatePickerValueChanged(_ sender: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateStyle = DateFormatter.Style.medium
        formatter.timeStyle = .none
        toDate = sender.date
        toDateTextField.text = formatter.string(from: sender.date)
        
    }
    
    @objc func fomDatePickerValueChanged(_ sender: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateStyle = DateFormatter.Style.medium
        formatter.timeStyle = .none
        fromDate = sender.date
        fromDateTextField.text = formatter.string(from: sender.date)
    }
    
    @objc func closeAndAlertPreviousViewController() {
        delegate?.didClose()
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func openCalenderVC() {
        print("Trying to open calender")
    }
    
    fileprivate func checkAndAdjustContraintst() {
        if UIDevice.current.orientation.isLandscape {
            NSLayoutConstraint.activate(qrCodeLandscapetContrainstsArray)
            NSLayoutConstraint.deactivate(qrCodePortraintContrainstsArray)
            print("Landscape")
        }
        else {
            NSLayoutConstraint.activate(qrCodePortraintContrainstsArray)
            NSLayoutConstraint.deactivate(qrCodeLandscapetContrainstsArray)
            print("Portrait")
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        checkAndAdjustContraintst()
    }

    // Text fields
    var fromTextField: CustomUITextField = {
        let cntf = CustomUITextField()
        cntf.placeholder = "From"
        cntf.backgroundColor = .gray
        return cntf
    }()
    
    
    var toTextField: CustomUITextField = {
        let cntf = CustomUITextField()
        cntf.placeholder = "To"
        cntf.backgroundColor = .gray
        return cntf
    }()
    
    var cargoTextField: CustomUITextField = {
        let cntf = CustomUITextField()
        cntf.placeholder = "Cargo"
        cntf.backgroundColor = .gray
        return cntf
    }()
    
    
    var cargoAmountTextField: CustomUITextField = {
        let cntf = CustomUITextField()
        cntf.placeholder = "Ton"
        cntf.backgroundColor = .gray
        cntf.keyboardType = .decimalPad
        return cntf
    }()

    
    var fromDateTextField: CustomUITextField = {
        let cntf = CustomUITextField()
        cntf.placeholder = "From Date"
        cntf.backgroundColor = .gray
        cntf.allowsEditingTextAttributes = false
        return cntf
    }()
    
    var toDateTextField: CustomUITextField = {
        let cntf = CustomUITextField()
        cntf.placeholder = "To Date"
        cntf.backgroundColor = .gray
        cntf.allowsEditingTextAttributes = false
        return cntf
    }()

    var createTripButton: CustomUIButton = {
        let cb = CustomUIButton()
        cb.setImage(UIImage(named: "greenCheck")?.withRenderingMode(.alwaysOriginal), for: .normal)
        cb.addTarget(self, action: #selector(save), for: .touchUpInside)
        cb.backgroundColor = .clear
        return cb
    }()

    var containerView: UIView = {
        let cv = UIView()
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.clipsToBounds = true
        cv.backgroundColor = .darkGray
        cv.layer.cornerRadius = 10.0
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
        containerView.addShadow()
        createTripButton.addShadow()
        fromTextField.addShadow()
        toTextField.addShadow()
        cargoTextField.addShadow()
        cargoAmountTextField.addShadow()
        fromDateTextField.addShadow()
        toDateTextField.addShadow()
    }
}

extension CreateTripViewController2 {
    @objc func save() {
        if fromTextField.text == "" || toTextField.text == "" || cargoTextField.text == "" || cargoAmountTextField.text == "" || fromDateTextField.text == "" || toDateTextField.text == "" {
            print("ERROR")
            return
        }
        
        
        guard let checkToDate = toDate else { return }
        guard let checkFromDate = fromDate else { return }
       

        if checkFromDate.compare(checkToDate).rawValue == 1 {
            print("ERROR")
            return
        }
        
        print("The check returned")
        print()

        
        let from = fromTextField.text
        let to = toTextField.text
        let cargo = cargoTextField.text
        let amount = cargoAmountTextField.text
        let fromDateForDatabase = fromDateTextField.text
        let toDateForDatabase = toDateTextField.text
        
        let timeStamp = "\(String(describing: Date().timeIntervalSince1970))"

        let tripId = UUID().uuidString + UUID().uuidString + UUID().uuidString + UUID().uuidString + UUID().uuidString + UUID().uuidString + UUID().uuidString + UUID().uuidString +
            UUID().uuidString + UUID().uuidString + UUID().uuidString + UUID().uuidString + UUID().uuidString + UUID().uuidString + UUID().uuidString + UUID().uuidString + UUID().uuidString + UUID().uuidString + UUID().uuidString + UUID().uuidString
        let db = Firestore.firestore()
        let tripDictionary: [String: Any?] = ["from": from, "to": to, "cargo": cargo, "amount": amount, "vesselReferencePath": (ship?.shipId)!, "fromDate": fromDateForDatabase, "toDate": toDateForDatabase, "initialised": timeStamp, "tripStatus": "Intialised"]
        db.collection("Trips").document(tripId).setData(tripDictionary)
        
        let basicTripDictionary: [String: Any?] = ["tripReferencePath": tripId]
db.collection("Ships").document((ship?.shipId)!).collection("Trips").document(tripId).setData(basicTripDictionary)
        
        closeAndAlertPreviousViewController()
        let banner = StatusBarNotificationBanner(title: "Trip Initialised", style: .info)
        banner.show()
        banner.duration = 0.5
    }
}
