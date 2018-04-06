//
//  NotificationViewController.swift
//  ACDShipManagement
//
//  Created by Prato Das on 2018-01-27.
//  Copyright © 2018 Prato Das. All rights reserved.
//

import UIKit

class NotificationViewController: UIViewController {
    var itemToScrollTo: Int?
    let notificationCollectionViewCellId = "notificationCollectionViewCellId"
    var arrayOfNumbers: [Int] = {
        var aon = [Int]()
        for i in 0..<30 {
            aon.append(i)
        }
        return aon
    }()
    
    var viewIsShown = false
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.topItem?.title = "Notification"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationController?.navigationBar.barTintColor = .gray
        self.navigationController?.navigationBar.addShadow()
        view.backgroundColor = .darkGray

        view.addSubview(notificationCollectionView)
        notificationCollectionView.delegate = self
        notificationCollectionView.dataSource = self
        notificationCollectionView.register(NotificationCollectionViewCell.self, forCellWithReuseIdentifier: notificationCollectionViewCellId)
        
        [
            notificationCollectionView.topAnchor.constraint(equalTo: view.topAnchor),
            notificationCollectionView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            notificationCollectionView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            notificationCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
            ].forEach { (constraint) in
                constraint.isActive = true
        }
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        handleOrientationChange()
    }
    
    var notificationCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 8
        layout.minimumInteritemSpacing = 0
        layout.sectionHeadersPinToVisibleBounds = true
        let rcv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        rcv.translatesAutoresizingMaskIntoConstraints = false
        rcv.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        rcv.keyboardDismissMode = .interactive
        rcv.tag = 0
        rcv.isScrollEnabled = true
        rcv.bounces = true
        rcv.alwaysBounceVertical = true
        rcv.backgroundColor = .clear
        return rcv
    }()
    

    fileprivate func handleOrientationChange() {
        if UIDevice.current.orientation.isLandscape {
        
            if let item = self.itemToScrollTo {
                self.notificationCollectionView.scrollToItem(at: IndexPath(row: item, section: 0), at: .top, animated: true)
            }
            
        } else {

            if let item = self.itemToScrollTo {
            self.notificationCollectionView.scrollToItem(at: IndexPath(row: item, section: 0), at: .top, animated: true)
            }
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        handleOrientationChange()
    }
    
}

extension NotificationViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayOfNumbers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: notificationCollectionViewCellId, for: indexPath) as! NotificationCollectionViewCell
        cell.dayNumberView.text = String(describing: arrayOfNumbers[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width - 32, height: 64)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        showNotificationDetailViewControllerModally()
    }
    
    @objc func showNotificationDetailViewControllerModally() {
        let vc = NotificationDetailViewController()
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overCurrentContext
        vc.delegate = self
        self.present(vc, animated: true, completion: nil)
        UIView.animate(withDuration: 0.3, animations: {
        })

    }
    
    //called when the cell is about to be displayed
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {

    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if collectionView.visibleCells.count == 0 { return }
        

        
    }
    

    
    
    
}

extension NotificationViewController: NotificationDetailViewControllerDidClose {
    func didClose() {
        
        UIView.animate(withDuration: 0.3, animations: {
//            self.shadowView.backgroundColor = UIColor.black.withAlphaComponent(0)
        }) { (_) in
//            self.shadowView.isHidden = true
        }
    }
}

