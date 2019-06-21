//
//  MenuViewController.swift
//  ACDShipManagement
//
//  Created by Prato Das on 2018-02-02.
//  Copyright © 2018 Prato Das. All rights reserved.
//

import UIKit


class MenuViewController: UIViewController {

var arrayOfMenus = [Menu]()
    
let interactor = Interactor()

var currentCellIndex: Int!
let mainCollectionViewCellId = "mainCollectionViewCellId"

    override func viewDidLoad() {
        super.viewDidLoad()
        arrayOfMenus.append(Menu(titleForCell: "Trip", operations: "crs"))
        arrayOfMenus.append(Menu(titleForCell: "Ship", operations: "cr"))
        arrayOfMenus.append(Menu(titleForCell: "Company", operations: "cr"))
        arrayOfMenus.append(Menu(titleForCell: "Contact", operations: "cr"))
        arrayOfMenus.append(Menu(titleForCell: "QR Code", operations: "r"))
//        arrayOfMenus.append(Menu(titleForCell: "Developer", operations: ""))
        
        setupMainCollectionView()
        
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationController?.navigationBar.barTintColor = .gray
        self.navigationController?.navigationBar.addShadow()
        view.backgroundColor = .darkGray
        self.navigationItem.title = "Menu"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(statusManager), name: .flagsChanged, object: Network.reachability)
        updateUserInterface()
        setupObservers()
    }

    
    
    func setupMainCollectionView() {
        
        menuCollectionView.delegate = self
        menuCollectionView.dataSource = self
        menuCollectionView.register(MenuCollectionViewCell.self, forCellWithReuseIdentifier: mainCollectionViewCellId)
        
        view.addSubview(menuCollectionView)
        NSLayoutConstraint.activate([menuCollectionView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor), menuCollectionView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor), menuCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor), menuCollectionView.topAnchor.constraint(equalTo: view.topAnchor)])
        
    }
    
    
    @objc func createTrip() {
        present(UINavigationController(rootViewController: CreateTripViewController1()), animated: true, completion: nil)
    }
    
    @objc func readTrip() {
        
        present(UINavigationController(rootViewController: ReadTripViewController()), animated: true, completion: nil)
    }
    
    @objc func sailTrip() {
        present(UINavigationController(rootViewController: SailTripViewController1()), animated: true, completion: nil)
    }
    
    @objc func createShip() {
        present(UINavigationController(rootViewController: CreateShipViewController()), animated: true, completion: nil)
    }
    
    @objc func readShip() {
         present(UINavigationController(rootViewController: ReadShipViewController()), animated: true, completion: nil)
    }

    
    @objc func createCompany() {
        present(UINavigationController(rootViewController: CreateCompanyViewController()), animated: true, completion: nil)
    }
    
    @objc func readCompany() {
        present(UINavigationController(rootViewController: ReadCompanyViewController()), animated: true, completion: nil)
    }
    

    @objc func createContact() {
        present(UINavigationController(rootViewController: CreateContactViewController()), animated: true, completion: nil)
    }
    
    @objc func readContact() {
        present(UINavigationController(rootViewController: ReadContactViewController()), animated: true, completion: nil)
    }
    

    
    override func viewWillAppear(_ animated: Bool) {
        print("willAppear")
        NotificationCenter.default.post(name: NSNotification.Name.init("Menu Appeared"), object: self, userInfo: nil)
    }
    func setupObservers() {

        NotificationCenter.default.addObserver(self, selector: #selector(createShip), name: NSNotification.Name.init("create Ship"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(readShip), name: NSNotification.Name.init("read Ship"), object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(updateShip), name: NSNotification.Name.init("update Ship"), object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(deleteShip), name: NSNotification.Name.init("delete Ship"), object: nil)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(createCompany), name: NSNotification.Name.init("create Company"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(readCompany), name: NSNotification.Name.init("read Company"), object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(updateCompany), name: NSNotification.Name.init("update Company"), object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(deleteCompany), name: NSNotification.Name.init("delete Company"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(createTrip), name: NSNotification.Name.init("create Trip"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(readTrip), name: NSNotification.Name.init("read Trip"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(sailTrip), name: NSNotification.Name.init("sail Trip"), object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(deleteTrip), name: NSNotification.Name.init("delete Trip"), object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(sailTrip), name: NSNotification.Name.init("sail Trip"), object: nil)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(createContact), name: NSNotification.Name.init("create Contact"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(readContact), name: NSNotification.Name.init("read Contact"), object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(updateContact), name: NSNotification.Name.init("update Contact"), object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(deleteContact), name: NSNotification.Name.init("delete Contact"), object: nil)
        
        
//        NotificationCenter.default.addObserver(self, selector: #selector(readQRCode), name: NSNotification.Name.init("read QR Code"), object: nil)
        
//
//        NotificationCenter.default.addObserver(self, selector: #selector(openShubranilInfo), name: NSNotification.Name.init("shubranil"), object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(openSumitInfo), name: NSNotification.Name.init("sumit"), object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(openPratoInfo), name: NSNotification.Name.init("prato"), object: nil)
    }
    

    private var menuCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 8
        layout.minimumInteritemSpacing = 0
        let rcv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        rcv.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 0, right: 0)
        rcv.backgroundColor = .clear
        rcv.translatesAutoresizingMaskIntoConstraints = false
        rcv.clipsToBounds = true
        rcv.keyboardDismissMode = .interactive
        rcv.tag = 1
        rcv.showsVerticalScrollIndicator = false
        rcv.alwaysBounceVertical = true
        return rcv
    }()
}


extension MenuViewController: UICollectionViewDelegate, UICollectionViewDataSource   {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayOfMenus.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: mainCollectionViewCellId, for: indexPath) as! MenuCollectionViewCell
        cell.isPortraint = true
        if !collectionView.isDragging || !collectionView.isDecelerating {
            UIView.animate(withDuration: 0.5, animations: {
                cell.backgroundColor = UIColor(red: 150/255, green: 150/255, blue: 150/255, alpha: (CGFloat(arc4random_uniform(255)))/255)
            })
            
        }
        cell.titleForCellText = arrayOfMenus[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.currentCellIndex = indexPath.row
    }
}


extension MenuViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.width), height: 48)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        self.menuCollectionView.collectionViewLayout.invalidateLayout()
    }
}
    
    
    

