//
//  SubMenuCollectionViewCell.swift
//  ACDShipManagement
//
//  Created by Prato Das on 2018-02-02.
//  Copyright © 2018 Prato Das. All rights reserved.
//

import UIKit

class SubMenuCollectionViewCell: UICollectionViewCell {
    let quickActionCollectionViewCellId = "quickActionCollectionViewCellId"
    
    var titleForCellText: Menu? {
        
        didSet {
            
//            print(titleForCellText?.operations)
            self.horizontalCollectionView.reloadData()
        }
    }
    
    var arrayOfButtons: [String] = [String]()
    override init(frame: CGRect) {
        super.init(frame: frame)
        clipsToBounds = true
        translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(horizontalCollectionView)
        
        NSLayoutConstraint.activate([contentView.leftAnchor.constraint(equalTo: leftAnchor), contentView.rightAnchor.constraint(equalTo: rightAnchor), contentView.topAnchor.constraint(equalTo: topAnchor), contentView.bottomAnchor.constraint(equalTo: bottomAnchor)])
        
        contentView.addSubview(whiteBackgroundView)
        
        contentView.addSubview(supportWhiteBackgroundView)
        contentView.addSubview(horizontalCollectionView)
        

        NSLayoutConstraint.activate([horizontalCollectionView.topAnchor.constraint(equalTo: contentView.topAnchor), horizontalCollectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor), horizontalCollectionView.rightAnchor.constraint(equalTo: contentView.rightAnchor), horizontalCollectionView.leftAnchor.constraint(equalTo: contentView.leftAnchor)])
        
        
                NSLayoutConstraint.activate([supportWhiteBackgroundView.topAnchor.constraint(equalTo: horizontalCollectionView.topAnchor), supportWhiteBackgroundView.bottomAnchor.constraint(equalTo: horizontalCollectionView.bottomAnchor), supportWhiteBackgroundView.rightAnchor.constraint(equalTo: horizontalCollectionView.rightAnchor), supportWhiteBackgroundView.leftAnchor.constraint(equalTo: horizontalCollectionView.leftAnchor)])
        
        
        
        
                NSLayoutConstraint.activate([whiteBackgroundView.topAnchor.constraint(equalTo: horizontalCollectionView.topAnchor), whiteBackgroundView.bottomAnchor.constraint(equalTo: horizontalCollectionView.bottomAnchor), whiteBackgroundView.rightAnchor.constraint(equalTo: horizontalCollectionView.rightAnchor, constant: -20), whiteBackgroundView.leftAnchor.constraint(equalTo: horizontalCollectionView.leftAnchor)])
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(changeMenuOrientationToPortrait), name: NSNotification.Name.init("ChangedMenuOrientationToPortrait"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(changeMenuOrientationToLandscape), name: NSNotification.Name.init("ChangedMenuOrientationToLandscape"), object: nil)
        
        
        setupHorizontalCollectionView()
    }
    
    
    @objc func changeMenuOrientationToPortrait() {
        //        horizontalCollectionView.reloadData()
        //        layoutSublayers(of: contentView.layer)
        contentView.layoutMarginsDidChange()
        horizontalCollectionView.layoutMarginsDidChange()
        supportWhiteBackgroundView.layoutMarginsDidChange()
        whiteBackgroundView.layoutMarginsDidChange()
    }
    
    
    @objc func changeMenuOrientationToLandscape() {
        //        horizontalCollectionView.reloadData()
        contentView.layoutMarginsDidChange()
        horizontalCollectionView.layoutMarginsDidChange()
        supportWhiteBackgroundView.layoutMarginsDidChange()
        whiteBackgroundView.layoutMarginsDidChange()
        
        
    }
    
    
    func setupHorizontalCollectionView() {
        horizontalCollectionView.delegate = self
        horizontalCollectionView.dataSource = self
        horizontalCollectionView.register(QuickActionCollectionViewCell.self, forCellWithReuseIdentifier: quickActionCollectionViewCellId)
    }
    
    private var horizontalCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        let mcv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        mcv.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        mcv.translatesAutoresizingMaskIntoConstraints = false
        mcv.clipsToBounds = true
        mcv.backgroundColor = .clear
        mcv.keyboardDismissMode = .interactive
        mcv.tag = 1
        mcv.showsVerticalScrollIndicator = false
        mcv.showsHorizontalScrollIndicator = false
        mcv.isScrollEnabled = false
        return mcv
    }()
    
    
    
    private var whiteBackgroundView: UIView = {
        let bv = UIView()
        bv.translatesAutoresizingMaskIntoConstraints = false
        bv.backgroundColor = .darkGray
        return bv
    }()
    
    private var supportWhiteBackgroundView: UIView = {
        let bv = UIView()
        bv.translatesAutoresizingMaskIntoConstraints = false
        bv.backgroundColor = .darkGray
        bv.layer.cornerRadius = 10.0
        return bv
    }()
    
    
    
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    @objc func pressedACell(sender: UIButton) {
        // Send out notification to the Notification Center to open other View Controllers from MenuViewController
        
        switch sender.titleLabel!.text! {
        case "create Ship":
            NotificationCenter.default.post(name: NSNotification.Name.init("create Ship"), object: self, userInfo: nil)
        case "read Ship":
            NotificationCenter.default.post(name: NSNotification.Name.init("read Ship"), object: self, userInfo: nil)
        case "update Ship":
            NotificationCenter.default.post(name: NSNotification.Name.init("update Ship"), object: self, userInfo: nil)
        case "delete Ship":
            NotificationCenter.default.post(name: NSNotification.Name.init("delete Ship"), object: self, userInfo: nil)
            
            
        case "create Company":
            NotificationCenter.default.post(name: NSNotification.Name.init("create Company"), object: self, userInfo: nil)
        case "read Company":
            NotificationCenter.default.post(name: NSNotification.Name.init("read Company"), object: self, userInfo: nil)
        case "update Company":
            NotificationCenter.default.post(name: NSNotification.Name.init("update Company"), object: self, userInfo: nil)
        case "delete Company":
            NotificationCenter.default.post(name: NSNotification.Name.init("delete Company"), object: self, userInfo: nil)
            
            
        case "create Trip":
            NotificationCenter.default.post(name: NSNotification.Name.init("create Trip"), object: self, userInfo: nil)
        case "read Trip":
            NotificationCenter.default.post(name: NSNotification.Name.init("read Trip"), object: self, userInfo: nil)
        case "update Trip":
            NotificationCenter.default.post(name: NSNotification.Name.init("update Trip"), object: self, userInfo: nil)
        case "delete Trip":
            NotificationCenter.default.post(name: NSNotification.Name.init("delete Trip"), object: self, userInfo: nil)
        case "sail Trip":
            NotificationCenter.default.post(name: NSNotification.Name.init("sail Trip"), object: self, userInfo: nil)
            
        
        case "create Contact":
            NotificationCenter.default.post(name: NSNotification.Name.init("create Contact"), object: self, userInfo: nil)
        case "read Contact":
            NotificationCenter.default.post(name: NSNotification.Name.init("read Contact"), object: self, userInfo: nil)
        case "update Contact":
            NotificationCenter.default.post(name: NSNotification.Name.init("update Contact"), object: self, userInfo: nil)
        case "delete Contact":
            NotificationCenter.default.post(name: NSNotification.Name.init("delete Contact"), object: self, userInfo: nil)
            
            
        case "read QR Code":
            NotificationCenter.default.post(name: NSNotification.Name.init("read QR Code"), object: self, userInfo: nil)
            
        case "shubranil":
            NotificationCenter.default.post(name: NSNotification.Name.init("shubranil"), object: self, userInfo: nil)
        case "sumit":
            NotificationCenter.default.post(name: NSNotification.Name.init("sumit"), object: self, userInfo: nil)
        case "prato":
            NotificationCenter.default.post(name: NSNotification.Name.init("prato"), object: self, userInfo: nil)
        default:
            break
        }
        
    }
    
}

extension SubMenuCollectionViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: quickActionCollectionViewCellId, for: indexPath) as! QuickActionCollectionViewCell
        if self.titleForCellText?.titleForCell != "Developer" {
            let image = UIImage(named: arrayOfButtons[indexPath.row])
            cell.cellButton.setImage(image?.withRenderingMode(.alwaysTemplate), for: .normal)
            cell.cellButton.addTarget(self, action: #selector(pressedACell), for: .touchUpInside)
            cell.cellButton.titleLabel?.text = arrayOfButtons[indexPath.row] + " " + (titleForCellText?.titleForCell)!
            cell.cellButton.tintColor = .white
        }
        else {
            let image = UIImage(named: arrayOfButtons[indexPath.row])
            cell.cellButton.titleLabel?.text = arrayOfButtons[indexPath.row]
            cell.cellButton.setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)
            cell.cellButton.addTarget(self, action: #selector(pressedACell), for: .touchUpInside)
            cell.cellButton.layer.cornerRadius = 10.0
            cell.cellButton.clipsToBounds = true
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width / CGFloat(arrayOfButtons.count), height: collectionView.frame.width / CGFloat(arrayOfButtons.count))
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayOfButtons.count
    }
}
