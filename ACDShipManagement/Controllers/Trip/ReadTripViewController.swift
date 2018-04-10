//
//  ReadTripCollectionViewController.swift
//  ACDShipManagement
//
//  Created by Prato Das on 2018-02-05.
//  Copyright © 2018 Prato Das. All rights reserved.
//

import UIKit
import Firebase
import QRCode

class ReadTripViewController: UIViewController {


    var arrayOfTrips: [Trip]? {
        didSet {
            self.tripsCollectionView.reloadData()
        }
    }

    let contactsCollectionViewCellId = "contactsCollectionViewCellId"
    override func viewDidLoad() {
        super.viewDidLoad()
        arrayOfTrips = [Trip]()
        fetchTrips()
        setupCollectionView()

        self.navigationController?.navigationBar.tintColor = .white
        self.navigationController?.navigationBar.barTintColor = .gray
        self.navigationController?.navigationBar.addShadow()
        view.backgroundColor = .darkGray

        let barButtonClose = UIBarButtonItem(image: UIImage(named: "arrow")?.withRenderingMode(.alwaysTemplate), style: .plain, target: self, action: #selector(closeView(_:)))
        barButtonClose.tintColor = .white
        self.navigationItem.setLeftBarButton(barButtonClose, animated: true)


        searchBar.placeholder = "Search"
        navigationItem.titleView = searchBar

        searchBar.becomeFirstResponder()
    }

    func setupCollectionView() {
        view.addSubview(tripsCollectionView)
        [
            tripsCollectionView.topAnchor.constraint(equalTo: view.topAnchor),
            tripsCollectionView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            tripsCollectionView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            tripsCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ].forEach { (constraint) in
                constraint.isActive = true
        }

        tripsCollectionView.delegate = self
        tripsCollectionView.dataSource = self

        tripsCollectionView.register(ReadTripCollectionViewCell.self, forCellWithReuseIdentifier: contactsCollectionViewCellId)
    }

    var tripsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 8
        layout.minimumInteritemSpacing = 0
        layout.sectionHeadersPinToVisibleBounds = true
        let ccv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        ccv.translatesAutoresizingMaskIntoConstraints = false
        ccv.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        ccv.keyboardDismissMode = .interactive
        ccv.tag = 0
        ccv.isScrollEnabled = true
        ccv.bounces = true
        ccv.alwaysBounceVertical = true
        ccv.backgroundColor = .clear
        return ccv
    }()

    var searchBar: UISearchBar = {
        let sb = UISearchBar(frame: CGRect.zero)
        sb.translatesAutoresizingMaskIntoConstraints = false
        sb.barStyle = .black
        let textFieldInsideSearchBar = sb.value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBar?.textColor = .white
        sb.keyboardAppearance = .dark

        sb.placeholder = "Search"
        return sb
    }()

    func fetchTrips() {
        let db = Firestore.firestore()
        db.collection("Ships").addSnapshotListener { (snapshot, error) in
            guard let _ = snapshot?.documents else {
                print("Error fetching documents: \(error!)")
                return
            }
            snapshot?.documentChanges.forEach({ (difference) in
                if (difference.type == .added) {
    
                    guard let amount = difference.document.data()["amount"] as? String else { return }
                    guard let cargo = difference.document.data()["cargo"] as? String else { return }
                    guard let from = difference.document.data()["from"] as? String else { return }
                    guard let to = difference.document.data()["to"] as? String else { return }
                    guard let initiliased = difference.document.data()["initiliased"] as? String else { return }
                    guard let vesselReferencePath = difference.document.data()["vesselReferencePath"] as? String else { return }
                    guard let tripStatus = difference.document.data()["tripStatus"] as? String else { return }
                    guard let fromDate = difference.document.data()["fromDate"] as? String else { return }
                    guard let toDate = difference.document.data()["toDate"] as? String else { return }
                    self.arrayOfTrips?.append(Trip(amount: amount, cargo: cargo, from: from, to: to, tripStatus: tripStatus, vesselReferencePath: vesselReferencePath, tripId: difference.document.documentID, fromDate: fromDate, toDate: toDate, vesselName: ""))
                }

                if (difference.type == .modified) {
                    for i in 0..<self.arrayOfTrips!.count {
                        if self.arrayOfTrips![i].tripId == difference.document.documentID {
//                            self.arrayOfTrips![i] = (Ship(representativeEmail: difference.document.data()["representativeEmail"]! as? String, representativeName: difference.document.data()["representativeName"]! as? String, representativePhone: difference.document.data()["representativePhone"]! as? String, vesselCapacity: difference.document.data()["vesselCapacity"]! as? String, vesselName: difference.document.data()["vesselName"]! as? String, shipId: difference.document.documentID, currentStatus: difference.document.data()["currentStatus"]! as? String))
                            return
                        }
                    }
                }
                if (difference.type == .removed) {
                    // TODO: Find an efficient solution
                    print("Removed contact: \(difference.document.documentID)")
                    for i in 0..<self.arrayOfTrips!.count {
                        if self.arrayOfTrips![i].tripId == difference.document.documentID {
//                            self.arrayOfTrips?.remove(at: i)
                            return
                        }
                    }
                }
            })
        }
    }
}


extension ReadTripViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let numberOfContacts = self.arrayOfTrips?.count {
            return numberOfContacts
        } else {
            return 0
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = QRCodeViewController()
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overCurrentContext
        vc.id = "Trip Id: " + self.arrayOfTrips![indexPath.row].tripId!
        present(vc, animated: true, completion: nil)
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = tripsCollectionView.dequeueReusableCell(withReuseIdentifier: contactsCollectionViewCellId, for: indexPath) as! ReadTripCollectionViewCell
        cell.trip = self.arrayOfTrips![indexPath.row]

        return cell
    }



    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width - 32, height: 64)
    }
}


class ReadTripCollectionViewCell: UICollectionViewCell {
    var trip: Trip {
        didSet {
            fromLabel.text = trip.from
            toLabel.text = trip.to
            fromDateLabel.text = trip.fromDate
            toDateLabel.text = trip.toDate
            
            if trip.tripStatus == "Initialised" {
                statusViewCircle.backgroundColor = .blue
            } else if trip.tripStatus == "In Trip" {
                statusViewCircle.backgroundColor = .green
            }
            let qrCode = QRCode("Trip Id: " + trip.tripId!)
            QRCodeImageView.image = qrCode?.image
        }
    }
    override init(frame: CGRect) {
        self.trip = Trip(amount: "", cargo: "", from: "", to: "", tripStatus: "", vesselReferencePath: "", tripId: "", fromDate: "", toDate: "", vesselName: "")
        super.init(frame: frame)


        contentView.addSubview(fromLabel)
        contentView.addSubview(toLabel)
        contentView.addSubview(fromDateLabel)
        contentView.addSubview(toDateLabel)
        contentView.addSubview(QRCodeImageViewBackground)
        contentView.addSubview(QRCodeImageView)

        NSLayoutConstraint.activate([fromLabel.centerYAnchor.constraint(equalTo: centerYAnchor), fromLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 8)])
        NSLayoutConstraint.activate([toLabel.centerYAnchor.constraint(equalTo: centerYAnchor), toLabel.leftAnchor.constraint(equalTo: fromLabel.rightAnchor, constant: 8)])
        
        NSLayoutConstraint.activate([fromDateLabel.topAnchor.constraint(equalTo: fromLabel.bottomAnchor), fromDateLabel.centerXAnchor.constraint(equalTo: fromLabel.centerXAnchor)])
        NSLayoutConstraint.activate([toDateLabel.topAnchor.constraint(equalTo: toLabel.bottomAnchor), toDateLabel.centerXAnchor.constraint(equalTo: toLabel.centerXAnchor)])



        NSLayoutConstraint.activate([QRCodeImageViewBackground.topAnchor.constraint(equalTo: topAnchor), QRCodeImageViewBackground.bottomAnchor.constraint(equalTo: bottomAnchor), QRCodeImageViewBackground.rightAnchor.constraint(equalTo: rightAnchor), QRCodeImageViewBackground.widthAnchor.constraint(equalTo: heightAnchor)])

        NSLayoutConstraint.activate([QRCodeImageView.topAnchor.constraint(equalTo: topAnchor), QRCodeImageView.bottomAnchor.constraint(equalTo: bottomAnchor), QRCodeImageView.rightAnchor.constraint(equalTo: rightAnchor), QRCodeImageView.widthAnchor.constraint(equalTo: heightAnchor)])
        
        
        QRCodeImageViewBackground.addShadow()
        
    }


    // Text fields
    private var fromLabel: UILabel = {
        let cntf = UILabel()
        cntf.translatesAutoresizingMaskIntoConstraints = false
        cntf.textColor = .white
        cntf.font = UIFont.boldSystemFont(ofSize: cntf.font.pointSize + 2)
        return cntf
    }()


    private var toLabel: UILabel = {
        let cntf = UILabel()
        cntf.translatesAutoresizingMaskIntoConstraints = false
        cntf.textColor = .white
        cntf.font = UIFont.boldSystemFont(ofSize: cntf.font.pointSize + 2)
        return cntf
    }()


    private var fromDateLabel: UILabel = {
        let cntf = UILabel()
        cntf.translatesAutoresizingMaskIntoConstraints = false
        cntf.textColor = .white
        return cntf
    }()

    private var toDateLabel: UILabel = {
        let cntf = UILabel()
        cntf.translatesAutoresizingMaskIntoConstraints = false
        cntf.textColor = .white
        return cntf
    }()


    private var statusViewCircle: UIView = {
        let cntf = UIView()
        cntf.translatesAutoresizingMaskIntoConstraints = false
        cntf.layer.cornerRadius = 5.0
        return cntf
    }()
    
    private var statusLabel: UILabel = {
        let cntf = UILabel()
        cntf.translatesAutoresizingMaskIntoConstraints = false
        cntf.textColor = .white
        return cntf
    }()
    
    private var vesselNameLabel: UILabel = {
        let cntf = UILabel()
        cntf.translatesAutoresizingMaskIntoConstraints = false
        cntf.textColor = .white
        return cntf
    }()
    

    // QRCode image

    var QRCodeImageView: UIImageView = {
        let civ = UIImageView()
        civ.image = UIImage(named: "contact")
        civ.translatesAutoresizingMaskIntoConstraints = false
        civ.clipsToBounds = true
        civ.backgroundColor = .white
        civ.isUserInteractionEnabled = true
        civ.contentMode = .scaleAspectFit
        civ.layer.cornerRadius = 5.0
        return civ
    }()


    private var QRCodeImageViewBackground: UIView = {
        let civb = UIView()
        civb.translatesAutoresizingMaskIntoConstraints = false
        civb.isUserInteractionEnabled = false
        civb.backgroundColor = .white
        civb.layer.cornerRadius = 5.0
        return civb
    }()


    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}




