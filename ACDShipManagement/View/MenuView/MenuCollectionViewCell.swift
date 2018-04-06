//
//  MenuCollectionViewCell.swift
//  ACDShipManagement
//
//  Created by Prato Das on 2018-02-02.
//  Copyright © 2018 Prato Das. All rights reserved.
//

import UIKit

class MenuCollectionViewCell: UICollectionViewCell {
    
    
    let subMenuCollectionViewCellId = "subMenuCollectionViewCellId"
    let menuTitleCollectionViewCellId = "menuTitleCollectionViewCellId"
    var isLandscape = false
    var isPortraint = false
    var isSubMenuVisible = false
    var arrayOfButtons: [String] = [String]()
    
    var titleForCellText: Menu? {
        didSet {
            
            guard let _ = titleForCellText else { return }

            if titleForCellText?.titleForCell == "Developer" {
                arrayOfButtons.removeAll()
                arrayOfButtons.append("prato")
                arrayOfButtons.append("sumit")
                arrayOfButtons.append("shubranil")
            }
                
            if titleForCellText?.titleForCell != "Developer" {
            for index in (titleForCellText?.operations?.characters.indices)! {
                    if titleForCellText!.operations![index] == "c" { arrayOfButtons.append("create") }
                    else if titleForCellText!.operations![index] == "r" { arrayOfButtons.append("read") }
                    else if titleForCellText!.operations![index] == "u" { arrayOfButtons.append("update") }
                    else if titleForCellText!.operations![index] == "d" { arrayOfButtons.append("delete") }
                    else if titleForCellText!.operations![index] == "s" { arrayOfButtons.append("sail") }
                }
            }
            
        }
    }
    

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupHorizontalCollectionView()
        clipsToBounds = true
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(horizontalCollectionView)
        
        NSLayoutConstraint.activate([contentView.leftAnchor.constraint(equalTo: leftAnchor), contentView.rightAnchor.constraint(equalTo: rightAnchor), contentView.topAnchor.constraint(equalTo: topAnchor), contentView.bottomAnchor.constraint(equalTo: bottomAnchor)])
        NSLayoutConstraint.activate([horizontalCollectionView.leftAnchor.constraint(equalTo: contentView.leftAnchor), horizontalCollectionView.rightAnchor.constraint(equalTo: contentView.rightAnchor), horizontalCollectionView.topAnchor.constraint(equalTo: contentView.topAnchor), horizontalCollectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)])
        
            NotificationCenter.default.addObserver(self, selector: #selector(changeMenuOrientationToPortrait), name: NSNotification.Name.init("ChangedMenuOrientationToPortrait"), object: nil)
        
                    NotificationCenter.default.addObserver(self, selector: #selector(changeMenuOrientationToLandscape), name: NSNotification.Name.init("ChangedMenuOrientationToLandscape"), object: nil)
        
        
        setupObservers()
        
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(scrollHorizontalCollectionViewUsingLogic)))
    }
    
    
    
    
    
    @objc func changeMenuOrientationToPortrait() {
//        horizontalCollectionView.reloadData()
//        layoutSublayers(of: contentView.layer)
        contentView.layoutMarginsDidChange()
        horizontalCollectionView.layoutMarginsDidChange()
//        horizontalCollectionView.reloadData()
//        horizontalCollectionView.scrollToItem(at: IndexPath(row: 1, section: 0), at: .centeredHorizontally, animated: false)
    }
    
    
    @objc func changeMenuOrientationToLandscape() {
//        horizontalCollectionView.reloadData()
        contentView.layoutMarginsDidChange()
        horizontalCollectionView.layoutMarginsDidChange()
//        horizontalCollectionView.reloadData()
//        horizontalCollectionView.scrollToItem(at: IndexPath(row: 1, section: 0), at: .centeredHorizontally, animated: false)

        
        
    }
    
    @objc func scrollHorizontalCollectionViewUsingLogic() {
        if !isSubMenuVisible { horizontalCollectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .left, animated: true); isSubMenuVisible = !isSubMenuVisible }
        else if isSubMenuVisible { horizontalCollectionView.scrollToItem(at: IndexPath(row: 1, section: 0), at: .left, animated: true); isSubMenuVisible = !isSubMenuVisible }
    }
    func setupObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(scrollCollectionViewToAppropriatePosition), name: NSNotification.Name.init("theMenuHasAppeared"), object: nil)
    }
    
    @objc func scrollCollectionViewToAppropriatePosition() {
        horizontalCollectionView.scrollToItem(at: IndexPath(row: 1, section: 0), at: .left, animated: true)
        self.isSubMenuVisible = false
    }
    func setupHorizontalCollectionView() {
        horizontalCollectionView.delegate = self
        horizontalCollectionView.dataSource = self
        horizontalCollectionView.register(SubMenuCollectionViewCell.self, forCellWithReuseIdentifier: subMenuCollectionViewCellId)
        horizontalCollectionView.register(MenuTitleCollectionViewCell.self, forCellWithReuseIdentifier: menuTitleCollectionViewCellId)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var titleForCell: UILabel = {
        let tfc = UILabel()
        tfc.translatesAutoresizingMaskIntoConstraints = false
        tfc.textColor = .white
        tfc.font = UIFont.boldSystemFont(ofSize: tfc.font.pointSize * 2)
        tfc.adjustsFontSizeToFitWidth = true
        tfc.textAlignment = .left
        return tfc
    }()
    
    
    private var horizontalCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        let mcv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        mcv.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        mcv.backgroundColor = .clear
        mcv.translatesAutoresizingMaskIntoConstraints = false
        mcv.clipsToBounds = true
        mcv.keyboardDismissMode = .interactive
        mcv.tag = 1
        mcv.showsVerticalScrollIndicator = false
        mcv.isPagingEnabled = true
        mcv.showsHorizontalScrollIndicator = false
        mcv.bounces = false
        return mcv
        
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        horizontalCollectionView.scrollToItem(at: IndexPath(row: 1, section: 0), at: .centeredHorizontally, animated: true)
        isSubMenuVisible = false
    }
    
}


extension MenuCollectionViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.row {
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: menuTitleCollectionViewCellId, for: indexPath) as! MenuTitleCollectionViewCell
            cell.titleForCellText = titleForCellText
            cell.backgroundColor = .clear

            return cell
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: subMenuCollectionViewCellId, for: indexPath) as! SubMenuCollectionViewCell
             cell.titleForCellText = titleForCellText
            cell.arrayOfButtons = self.arrayOfButtons
            cell.backgroundColor = .clear
            return cell
            
            
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: subMenuCollectionViewCellId, for: indexPath) as! SubMenuCollectionViewCell
            cell.backgroundColor = .darkGray
            return cell
        }
    }
    

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //Trying to set menu size
            if indexPath.row == 1 { return CGSize(width: collectionView.frame.width - 5, height: collectionView.frame.height) }
            else { return CGSize(width: collectionView.frame.height * CGFloat(arrayOfButtons.count), height: collectionView.frame.height) }
    }
    
}

